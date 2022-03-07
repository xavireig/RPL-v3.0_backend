class Auction < ApplicationRecord
  #
  # associations
  #

  belongs_to :virtual_footballer
  belongs_to :virtual_round
  has_many :bids, dependent: :destroy
  has_one :transfer_activity, as: :transfer

  def winning_bid
    amounts = bids.pluck(:amount)
    max_amount = amounts.index(amounts.max) == amounts.rindex(amounts.max) && amounts.max
    if max_amount
      max_bid = bids.where(amount: max_amount).first
      max_bid
    else
      max_bid = bids.max_by { |b| b&.amount }
      multiple_max_bids = bids.find_all { |b| b.amount == max_bid.amount }
      lowest_standing(multiple_max_bids)
    end
  end

    def runner_up_bid
    amounts = bids.pluck(:amount)
    unless amounts.index(amounts.max) == amounts.rindex(amounts.max) && amounts.max
      max_bid = bids.max_by { |b| b&.amount }
      multiple_max_bids = bids.find_all { |b| b.amount == max_bid.amount }
      return (multiple_max_bids - [lowest_standing(multiple_max_bids)]).first
    end
    runner_up_amount = amounts.index(amounts.max(2)[1]) == amounts.rindex(amounts.max(2)[1]) && amounts.max(2)[1]
    if runner_up_amount
      runner_up_bid = bids.where(amount: runner_up_amount).first
      runner_up_bid
    else
      runner_up_bid = bids.max_by(2) { |b| b&.amount }.last
      multiple_runner_up_bids = bids.find_all { |b| b.amount == runner_up_bid.amount }
      lowest_standing(multiple_runner_up_bids)
    end
  end

  private

  def lowest_standing(bids) #returns the bid of the club with the lowest point
    return bids.first if bids.size.eql?(1)

    bids.min do |a, b|
      a_standing = a.bidder_virtual_club
      b_standing = b.bidder_virtual_club
      if a_standing.total_pts != b_standing.total_pts
        a_standing.total_pts <=> b_standing.total_pts
      else
        a_standing.total_score <=> b_standing.total_score
      end
    end
  end
end

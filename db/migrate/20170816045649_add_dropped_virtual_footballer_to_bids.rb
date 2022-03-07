class AddDroppedVirtualFootballerToBids < ActiveRecord::Migration[5.1]
  def change
    add_column :bids, :dropped_virtual_footballer_id, :integer, foreign_key: true
  end
end

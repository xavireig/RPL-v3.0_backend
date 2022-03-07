class AddColumnRoundIdToFixtures < ActiveRecord::Migration[5.0]
  def change
    add_column :fixtures, :round_id, :integer
  end
end

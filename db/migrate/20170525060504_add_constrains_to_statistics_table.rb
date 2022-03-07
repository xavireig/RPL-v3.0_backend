class AddConstrainsToStatisticsTable < ActiveRecord::Migration[5.0]
  def change
    add_index :statistics, %i[footballer_id fixture_id], unique: true
  end
end

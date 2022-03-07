class AddConstrainsToVirtualFootballers < ActiveRecord::Migration[5.0]
  def change
    add_index :virtual_footballers, %i[league_id footballer_id], unique: true
  end
end

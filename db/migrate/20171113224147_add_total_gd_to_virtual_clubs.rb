class AddTotalGdToVirtualClubs < ActiveRecord::Migration[5.1]
  def change
    add_column :virtual_clubs, :total_gd, :integer, default: 0
  end
end

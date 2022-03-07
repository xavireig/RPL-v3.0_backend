class AddDetailsToVirtualClubs < ActiveRecord::Migration[5.1]
  def change
    add_column :virtual_clubs, :rank, :integer, default: 0
    add_column :virtual_clubs, :total_pts, :integer, default: 0
    add_column :virtual_clubs, :form, :string, array: true, default: []
    add_column :virtual_clubs, :total_win, :integer, default: 0
    add_column :virtual_clubs, :total_loss, :integer, default: 0
    add_column :virtual_clubs, :total_draw, :integer, default: 0
    add_column :virtual_clubs, :total_score, :integer, default: 0
  end
end

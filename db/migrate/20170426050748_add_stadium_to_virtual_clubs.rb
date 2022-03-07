class AddStadiumToVirtualClubs < ActiveRecord::Migration[5.0]
  def change
    add_column :virtual_clubs, :stadium, :string
  end
end

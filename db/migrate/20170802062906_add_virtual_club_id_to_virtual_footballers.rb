class AddVirtualClubIdToVirtualFootballers < ActiveRecord::Migration[5.1]
  def up
    add_column :virtual_footballers, :virtual_club_id, :integer, null: true
  end

  def down
    remove_column :virtual_footballers, :virtual_club_id
  end
end

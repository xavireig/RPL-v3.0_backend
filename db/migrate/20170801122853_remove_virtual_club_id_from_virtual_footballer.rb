class RemoveVirtualClubIdFromVirtualFootballer < ActiveRecord::Migration[5.1]
  def up
    remove_column :virtual_footballers, :virtual_club_id
  end

  def down
    add_column :virtual_footballers, :virtual_club_id, :integer, null: true
  end
end

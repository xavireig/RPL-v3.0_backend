class AddConstraintsToDraftHistory < ActiveRecord::Migration[5.0]
  def change
    add_index :draft_histories, %i[virtual_club_id virtual_footballer_id],
      unique: true, name: 'index_v_footballers_on_virtual_club_id'
  end
end

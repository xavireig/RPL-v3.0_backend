class RemoveNotNullConstrainAndAddColumnToClubs < ActiveRecord::Migration[5.0]
  def change
    change_column :clubs, :city, :string, null: true
    change_column :clubs, :abbreviation, :string, null: true

    # add new column
    add_column :clubs, :official_club_name, :string
  end
end

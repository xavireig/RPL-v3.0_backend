class MakeClubsColumnStreetNullable < ActiveRecord::Migration[5.0]
  def change
    change_column :clubs, :street, :string, null: true
  end
end

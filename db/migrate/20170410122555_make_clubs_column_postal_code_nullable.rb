class MakeClubsColumnPostalCodeNullable < ActiveRecord::Migration[5.0]
  def change
    change_column :clubs, :postal_code, :string, null: true
  end
end

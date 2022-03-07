class MakeClubsColumnWebAddressNullable < ActiveRecord::Migration[5.0]
  def change
    change_column :clubs, :web_address, :string, null: true
  end
end

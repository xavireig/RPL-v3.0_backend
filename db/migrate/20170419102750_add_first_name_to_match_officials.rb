class AddFirstNameToMatchOfficials < ActiveRecord::Migration[5.0]
  def change
    add_column :match_officials, :first_name, :string
    change_column :match_officials, :last_name, :string, null: true
  end
end

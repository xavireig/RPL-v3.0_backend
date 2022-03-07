class RemoveNullConstrainsFromMatchOfficials < ActiveRecord::Migration[5.0]
  def change
    change_column :match_officials, :country, :string, null: true
  end
end

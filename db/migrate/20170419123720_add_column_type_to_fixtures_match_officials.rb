class AddColumnTypeToFixturesMatchOfficials < ActiveRecord::Migration[5.0]
  def change
    add_column :fixtures_match_officials, :o_type, :string
  end
end

class AddColumnPostponedToFixtures < ActiveRecord::Migration[5.0]
  def change
    add_column :fixtures, :postponed, :string
  end
end

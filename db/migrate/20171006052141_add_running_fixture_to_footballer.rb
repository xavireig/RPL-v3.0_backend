class AddRunningFixtureToFootballer < ActiveRecord::Migration[5.1]
  def change
    add_column :footballers, :running_fixture_id, :integer, index: true
  end
end

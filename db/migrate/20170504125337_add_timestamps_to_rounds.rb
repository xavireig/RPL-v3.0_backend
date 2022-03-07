class AddTimestampsToRounds < ActiveRecord::Migration[5.0]
  def change
    add_column :rounds, :created_at, :datetime
    add_column :rounds, :updated_at, :datetime
  end
end

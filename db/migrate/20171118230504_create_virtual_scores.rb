class CreateVirtualScores < ActiveRecord::Migration[5.1]
  def change
    create_table :virtual_scores do |t|
      t.belongs_to :virtual_fixture, foreign_key: true, null: false, index: true
      t.float :home_score
      t.float :away_score

      t.timestamps
    end
  end
end

class CreateVirtualEngagements < ActiveRecord::Migration[5.0]
  def change
    create_table :virtual_engagements do |t|
      t.belongs_to :game_week, foreign_key: true, null: false
      t.belongs_to :virtual_footballer, foreign_key: true, null: false
      t.boolean  :in_line_up, default: false
      t.timestamps
    end
  end
end

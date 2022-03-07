# frozen_string_literal: true

class CreateEngagements < ActiveRecord::Migration[5.0]
  def change
    create_table :engagements do |t|
      t.belongs_to :footballer, foreign_key: true, null: false
      t.belongs_to :club, foreign_key: true, null: false
      t.belongs_to :season, foreign_key: true, null: false
      t.datetime :join_date, null: false
      t.datetime :leave_date
      t.string :real_position, null: false
      t.string :real_position_side, null: false
      t.integer :jersey_num, null: false
      t.timestamps
    end

    add_index :engagements, %i[footballer_id club_id season_id], unique: true
  end
end

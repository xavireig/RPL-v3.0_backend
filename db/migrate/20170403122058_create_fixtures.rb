# frozen_string_literal: true

class CreateFixtures < ActiveRecord::Migration[5.0]
  def change
    create_table :fixtures do |t|
      t.integer :u_id, null: false, index: true, unique: true
      t.integer :original_u_id, null: false, index: true, unique: true
      t.belongs_to :season, foreign_key: true, null: false
      t.datetime :last_modified, null: false
      t.integer :detail_id, null: false
      t.datetime :match_day, null: false
      t.string :match_type, null: false
      t.string :period, null: false
      t.belongs_to :venue, foreign_key: { to_table: :stadia }, null: false
      t.datetime :date, null: false, index: true
      t.belongs_to :home_club, foreign_key: { to_table: :clubs }, null: false
      t.belongs_to :away_club, foreign_key: { to_table: :clubs }, null: false
      t.timestamps
    end
  end
end

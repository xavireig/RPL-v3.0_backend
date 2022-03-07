# frozen_string_literal: true

class CreateFixturesMatchOfficials < ActiveRecord::Migration[5.0]
  def change
    create_table :fixtures_match_officials do |t|
      t.belongs_to :fixture, foreign_key: true, null: false
      t.belongs_to :match_official, foreign_key: true, null: false
      t.timestamps
    end
  end
end

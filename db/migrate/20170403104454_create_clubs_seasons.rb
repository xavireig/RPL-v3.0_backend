# frozen_string_literal: true

class CreateClubsSeasons < ActiveRecord::Migration[5.0]
  def change
    create_table :clubs_seasons do |t|
      t.belongs_to :club, foreign_key: true, null: false
      t.belongs_to :season, foreign_key: true, null: false
      t.timestamps
    end
  end
end

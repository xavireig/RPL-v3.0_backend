# frozen_string_literal: true

class CreateVirtualClubs < ActiveRecord::Migration[5.0]
  def change
    create_table :virtual_clubs do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.belongs_to :league, foreing_key: true, null: false
      t.belongs_to :crest_pattern, foreign_key: true, null: false
      t.string :name, null: false
      t.string :color1, null: false
      t.string :color2, null: false
      t.string :color3, null: false
      t.boolean :auto_pick, default: false
      t.string :motto
      t.string :abbr
      t.timestamps
    end
  end
end

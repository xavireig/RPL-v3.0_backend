# frozen_string_literal: true

class CreateCrestPatterns < ActiveRecord::Migration[5.0]
  def change
    create_table :crest_patterns do |t|
      t.string :name
      t.belongs_to :crest_shape, foreign_key: true, null: false

      t.timestamps
    end
  end
end

# frozen_string_literal: true

class CreateCrestShapes < ActiveRecord::Migration[5.0]
  def change
    create_table :crest_shapes do |t|
      t.string :name
      t.timestamps
    end
  end
end

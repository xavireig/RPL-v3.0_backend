# frozen_string_literal: true

class CreateSeasons < ActiveRecord::Migration[5.0]
  def change
    create_table :seasons do |t|
      t.integer :u_id, null: false, index: true, unique: true
      t.string :name, null: false
      t.timestamps
    end
  end
end

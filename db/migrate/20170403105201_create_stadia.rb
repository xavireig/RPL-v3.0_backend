# frozen_string_literal: true

class CreateStadia < ActiveRecord::Migration[5.0]
  def change
    create_table :stadia do |t|
      t.integer :u_id, null: false, index: true, unique: true
      t.string :original_u_id, null: false, index: true, unique: true
      t.integer :capacity, null: false
      t.string :name, null: false
      t.string :city
      t.timestamps
    end
  end
end

# frozen_string_literal: true

class CreateFootballers < ActiveRecord::Migration[5.0]
  def change
    create_table :footballers do |t|
      t.integer :u_id, null: false, index: true, unique: true
      t.string :original_u_id, null: false, index: true, unique: true
      t.string :first_name, null: false
      t.string :middle_name, null: false, default: ''
      t.string :last_name, null: false
      t.string :name, null: false
      t.string :known_name, null: false
      t.string :display_name
      t.datetime :birth_date, null: false
      t.string :birth_place, null: false
      t.string :first_nationality, null: false
      t.string :preferred_foot, null: false
      t.integer :weight, null: false
      t.integer :height, null: false
      t.string :country, null: false
      t.timestamps
    end
  end
end

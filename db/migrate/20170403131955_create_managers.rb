# frozen_string_literal: true

class CreateManagers < ActiveRecord::Migration[5.0]
  def change
    create_table :managers do |t|
      t.integer :u_id, null: false, unique: true, index: true
      t.string :original_u_id, null: false, unique: true, index: true
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :country, null: false
      t.datetime :birth_day
      t.timestamps
    end
  end
end

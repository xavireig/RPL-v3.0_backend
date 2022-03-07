# frozen_string_literal: true

class CreateClubs < ActiveRecord::Migration[5.0]
  def change
    create_table :clubs do |t|
      t.integer :u_id, null: false, index: true, unique: true
      t.string :original_u_id, null: false, index: true, unique: true
      t.string :city, null: false
      t.string :name, null: false
      t.string :short_club_name, null: false
      t.string :abbreviation, null: false
      t.string :region_name, null: false
      t.string :street, null: false
      t.string :web_address, null: false
      t.string :postal_code, null: false
      t.integer :founded, null: false
      t.timestamps
    end
  end
end

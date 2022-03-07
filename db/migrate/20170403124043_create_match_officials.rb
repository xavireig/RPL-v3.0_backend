# frozen_string_literal: true

class CreateMatchOfficials < ActiveRecord::Migration[5.0]
  def change
    create_table :match_officials do |t|
      t.integer :u_id, null: false, index: true, unique: true
      t.string :original_u_id, null: false, index: true, unique: true
      t.string :last_name, null: false
      t.string :country, null: false
      t.timestamps
    end
  end
end

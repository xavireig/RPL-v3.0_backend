# frozen_string_literal: true

class CreateManagersClubs < ActiveRecord::Migration[5.0]
  def change
    create_table :managers_clubs do |t|
      t.belongs_to :club, foreign_key: true, null: false
      t.belongs_to :manager, foreign_key: true, null: false
      t.belongs_to :season, foreign_key: true, null: false
      t.string :type, null: false
      t.datetime :join_date, null: false
      t.datetime :leave_date
      t.timestamps
    end
  end
end

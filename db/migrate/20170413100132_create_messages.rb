# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.string :subject, null: false
      t.string :body, null: false
      t.belongs_to :user, foreign_key: true, null: false
      t.belongs_to :league, foreign_key: true, null: false

      t.timestamps
    end
  end
end

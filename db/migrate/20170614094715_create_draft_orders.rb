# frozen_string_literal: true

class CreateDraftOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :draft_orders do |t|
      t.integer :current_iteration, null: false
      t.integer :current_step, null: false
      t.belongs_to :league, foreign_key: true, null: false
      t.jsonb :queue, null: false
      t.timestamps
    end
  end
end

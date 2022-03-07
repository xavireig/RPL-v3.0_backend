class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.belongs_to :league, foreign_key: true, null: false, index: true
      t.belongs_to :recipient, foreign_key: { to_table: :users }, null: false, index: true
      t.belongs_to :sender, foreign_key: { to_table: :users }, null: false, index: true
      t.string :activity_type, null: false
      t.string :object_type, null: false
      t.string :object_id, null: false, index: true
      t.text :content, null: false
      t.datetime :time_sent, null: false
      t.integer :status, default: 0

      t.timestamps
    end
  end
end

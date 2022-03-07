class CreateSubscriptionTable < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.integer :sub_type, null: false, index: true, default: 0
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.belongs_to :user, foreign_key: true, null: false
      t.timestamps
    end
  end
end

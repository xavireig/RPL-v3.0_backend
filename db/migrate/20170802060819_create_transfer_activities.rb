class CreateTransferActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :transfer_activities do |t|
      t.references :transfer, polymorphic: true
      t.timestamps
    end
  end
end

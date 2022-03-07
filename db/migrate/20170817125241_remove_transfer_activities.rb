class RemoveTransferActivities < ActiveRecord::Migration[5.1]
  def up
    drop_table :transfer_activities
  end

  def down
    create_table :transfer_activities do |t|
      t.references :transfer, polymorphic: true
      t.timestamps
    end
  end
end

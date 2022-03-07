class AddWaiverToVirtualFootballers < ActiveRecord::Migration[5.1]
  def change
    add_column :virtual_footballers, :waiver, :boolean, default: false, null: false
  end
end

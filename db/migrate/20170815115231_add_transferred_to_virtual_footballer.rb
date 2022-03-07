class AddTransferredToVirtualFootballer < ActiveRecord::Migration[5.1]
  def change
    add_column :virtual_footballers, :transferred, :boolean, default: false
  end
end

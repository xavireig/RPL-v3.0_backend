class ChangeColumnChairmanVetoDefaultValue < ActiveRecord::Migration[5.0]
  def change
    change_column :leagues,
      :chairman_veto,
      :boolean,
      default: true
  end
end

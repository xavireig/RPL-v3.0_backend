class ChangeColumnTransferBudgetDefaultValue < ActiveRecord::Migration[5.0]
  def change
    change_column :leagues,
      :transfer_budget,
      :integer,
      default: 25
  end
end

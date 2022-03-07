class ChangeColumnMinFeePerAdditionDefaultValue < ActiveRecord::Migration[5.0]
  def change
    change_column :leagues,
      :min_fee_per_addition,
      :integer,
      default: 1
  end
end

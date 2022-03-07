class ChangeColumnAutoSubsDefaultValue < ActiveRecord::Migration[5.0]
  def change
    change_column :leagues,
      :auto_sub_enabled,
      :boolean,
      default: true
  end
end

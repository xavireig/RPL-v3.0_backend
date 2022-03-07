class ChangeColumnTimePerPickDefaultValue < ActiveRecord::Migration[5.0]
  def change
    change_column :leagues,
      :time_per_pick,
      :integer,
      default: 60
  end
end

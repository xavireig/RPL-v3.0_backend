class AddTotalPointsToVirtualFootballers < ActiveRecord::Migration[5.1]
  def change
    add_column :virtual_footballers,
      :total_points, :decimal, precision: 5, scale: 1, default: 0.0
  end
end

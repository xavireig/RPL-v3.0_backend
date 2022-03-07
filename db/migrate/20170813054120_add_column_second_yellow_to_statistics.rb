class AddColumnSecondYellowToStatistics < ActiveRecord::Migration[5.1]
  def change
    add_column :statistics, :second_yellow, :integer, default: 0
  end
end

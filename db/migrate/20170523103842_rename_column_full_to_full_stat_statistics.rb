class RenameColumnFullToFullStatStatistics < ActiveRecord::Migration[5.0]
  def change
    rename_column :statistics, :full, :full_stat
  end
end

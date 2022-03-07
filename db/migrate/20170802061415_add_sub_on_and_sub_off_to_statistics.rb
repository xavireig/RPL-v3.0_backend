class AddSubOnAndSubOffToStatistics < ActiveRecord::Migration[5.0]
  def up
    add_column :statistics, :sub_on, :boolean, default: false
    add_column :statistics, :sub_off, :boolean, default: false
  end

  def down
    remove_column :statistics, :sub_on, :boolean, default: false
    remove_column :statistics, :sub_off, :boolean, default: false
  end
end

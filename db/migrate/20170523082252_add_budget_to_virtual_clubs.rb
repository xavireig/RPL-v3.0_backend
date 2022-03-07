class AddBudgetToVirtualClubs < ActiveRecord::Migration[5.0]
  def change
    add_column :virtual_clubs, :budget, :integer, default: 10
  end
end

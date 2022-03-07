class AddAutoSubOnToGameWeek < ActiveRecord::Migration[5.1]
  def change
    add_column :game_weeks, :auto_sub_on, :boolean, default: false
  end
end

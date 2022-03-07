class RemoveNullConstrainFromManages < ActiveRecord::Migration[5.0]
  def change
    change_column :engagements, :join_date, :datetime, null: true
  end
end

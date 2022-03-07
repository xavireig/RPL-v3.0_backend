class RemoveNullConstrainsFromCapacityStadium < ActiveRecord::Migration[5.0]
  def change
    change_column :stadia, :capacity, :integer, null: true
  end
end

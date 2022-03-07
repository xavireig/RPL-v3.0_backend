class AddPositionColumToFootballers < ActiveRecord::Migration[5.0]
  def change
    add_column :footballers, :position, :string
  end
end

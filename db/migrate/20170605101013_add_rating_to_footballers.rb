class AddRatingToFootballers < ActiveRecord::Migration[5.0]
  def change
    add_column :footballers, :rating, :decimal, default: 10
  end
end

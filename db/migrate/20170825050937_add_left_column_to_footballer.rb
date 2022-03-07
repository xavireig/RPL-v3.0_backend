class AddLeftColumnToFootballer < ActiveRecord::Migration[5.1]
  def change
    add_column :footballers, :left, :boolean, default: false
  end
end

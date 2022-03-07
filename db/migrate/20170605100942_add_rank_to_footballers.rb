class AddRankToFootballers < ActiveRecord::Migration[5.0]
  def change
    add_column :footballers, :rank, :integer, default: 2048
  end
end

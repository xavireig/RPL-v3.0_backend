class MakeKnownNameNullTrueForFootballers < ActiveRecord::Migration[5.0]
  def change
    change_column :footballers, :known_name, :string, null: true
  end
end

class RemoveNullConstrainFromFootballersCountry < ActiveRecord::Migration[5.0]
  def change
    change_column :footballers, :country, :string, null: true
  end
end

class RemoveNullConstrainFromFootballersFirstNationality < ActiveRecord::Migration[5.0]
  def change
    change_column :footballers, :first_nationality, :string, null: true
  end
end

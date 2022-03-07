class RemoveNullConstrainFromFootballersPreferredFoot < ActiveRecord::Migration[5.0]
  def change
    change_column :footballers, :preferred_foot, :string, null: true
  end
end

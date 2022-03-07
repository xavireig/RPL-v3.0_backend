class RemoveNullConstrainFromFootballersBirthPlace < ActiveRecord::Migration[5.0]
  def change
    change_column :footballers, :birth_place, :string, null: true
  end
end

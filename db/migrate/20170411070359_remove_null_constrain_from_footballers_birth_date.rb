class RemoveNullConstrainFromFootballersBirthDate < ActiveRecord::Migration[5.0]
  def change
    change_column :footballers, :birth_date, :datetime, null: true
  end
end

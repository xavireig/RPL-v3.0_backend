class CreateChats < ActiveRecord::Migration[5.0]
  def change
    create_table :chats do |t|
      t.text :content, null: false
      t.belongs_to :league, foreign_key: true, null: false
      t.belongs_to :virtual_club, foreign_key: true, null: false

      t.timestamps
    end
  end
end

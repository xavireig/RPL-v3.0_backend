# frozen_string_literal: true
class AddAdminIntoUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :admin, :string, default: false, null: false
  end
end

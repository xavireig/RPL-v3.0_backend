class AddDescriptionToLeagues < ActiveRecord::Migration[5.0]
  def change
    add_column :leagues, :description, :string
  end
end

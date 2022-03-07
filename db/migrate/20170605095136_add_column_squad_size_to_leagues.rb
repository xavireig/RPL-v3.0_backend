class AddColumnSquadSizeToLeagues < ActiveRecord::Migration[5.0]
  def change
    add_column :leagues, :squad_size, :integer, default: 16
  end
end

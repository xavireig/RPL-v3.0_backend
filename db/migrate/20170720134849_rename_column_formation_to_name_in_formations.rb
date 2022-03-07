class RenameColumnFormationToNameInFormations < ActiveRecord::Migration[5.0]
  def up
    rename_column :formations, :formation, :name
  end

  def down
    rename_column :formations, :name, :formation
  end
end

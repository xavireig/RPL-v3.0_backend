class RenameFormationSettingsToFormation < ActiveRecord::Migration[5.0]
  def up
    execute <<-SQL
      ALTER TABLE formation_settings
      drop constraint check_formation;
    SQL

    rename_table :formation_settings, :formations

    execute <<-SQL
      ALTER TABLE formations
      add constraint check_formation check (formation in (
          'f442',
          'f433',
          'f451',
          'f352',
          'f343',
          'f541',
          'f532'
         ));
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE formations
      drop constraint check_formation;
    SQL

    rename_table :formations, :formation_settings

    execute <<-SQL
      ALTER TABLE formation_settings
      add constraint check_formation check (formation in (
          'f442',
          'f433',
          'f451',
          'f352',
          'f343',
          'f541',
          'f532'
         ));
    SQL
  end
end

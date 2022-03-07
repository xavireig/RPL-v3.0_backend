class AddConstraintsToFormationSettings < ActiveRecord::Migration[5.0]
  def up
    execute <<-SQL
      ALTER TABLE formation_settings
      drop constraint check_formation;
    SQL

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

  def down
    execute <<-SQL
      ALTER TABLE formation_settings
      drop constraint check_formation;
    SQL
  end
end

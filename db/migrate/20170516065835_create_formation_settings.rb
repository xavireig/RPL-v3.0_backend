class CreateFormationSettings < ActiveRecord::Migration[5.0]
  def up
    create_table :formation_settings do |t|
      t.belongs_to :league, foreign_key: true, null: false
      t.string :formation, null: false
      t.boolean :allowed, default: true
      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE formation_settings
      add constraint check_formation check (formation in (
           'f442',
           'f433',
           'f451',
           'f352',
           'f343'
         ));
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE formation_settings
      drop constraint check_formation;
    SQL

    drop_table :formation_settings
  end
end

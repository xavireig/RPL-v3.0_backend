# frozen_string_literal: true

class CreatePositionSettings < ActiveRecord::Migration[5.0]
  def up
    create_table :position_settings do |t|
      t.belongs_to :league, foreign_key: true, null: false
      t.string :position, null: false
      t.integer :min, default: 0, null: false
      t.integer :max, default: 0, null: false
      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE position_settings
      add constraint check_position check (position in (
           'defender',
           'midfielder',
           'forward',
           'goalkeeper',
           'squad'
         ));
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE position_settings
      drop constraint check_position;
    SQL

    drop_table :position_settings
  end
end

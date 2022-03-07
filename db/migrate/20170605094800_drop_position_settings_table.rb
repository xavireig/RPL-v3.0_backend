class DropPositionSettingsTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :position_settings
  end
end

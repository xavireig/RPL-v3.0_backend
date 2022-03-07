class AddCustomizedScoringToLeague < ActiveRecord::Migration[5.0]
  def change
    add_column :leagues, :customized_scoring, :boolean, default: false
  end
end

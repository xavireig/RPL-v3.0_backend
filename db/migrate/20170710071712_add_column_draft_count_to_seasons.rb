class AddColumnDraftCountToSeasons < ActiveRecord::Migration[5.0]
  def change
    add_column :seasons, :draft_count, :integer, default: 0
  end
end

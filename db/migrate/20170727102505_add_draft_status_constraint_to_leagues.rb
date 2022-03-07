class AddDraftStatusConstraintToLeagues < ActiveRecord::Migration[5.0]
  def self.up
    execute <<-SQL
      ALTER TABLE leagues
      drop constraint check_draft_status;

      ALTER TABLE leagues
      add constraint check_draft_status check (draft_status in (
        'pending',
        'running',
        'completed',
        'processing'
       ));
    SQL
  end

  def self.down
    execute <<-SQL
      ALTER TABLE leagues
      drop constraint check_draft_status;

      ALTER TABLE leagues
      add constraint check_draft_status check (draft_status in (
        'pending',
        'running',
        'completed'
       ));
    SQL
  end
end

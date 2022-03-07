# frozen_string_literal: true

class CreateInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |t|
      t.belongs_to :league, foreign_key: true, null: false
      t.string :email, null: false
      t.string :status, default: 'waiting', null: false
      t.datetime :reminder_time

      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE invitations
      add constraint check_status check (status in (
           'waiting',
           'accepted',
           'rejected'
         ));
    SQL
  end
end

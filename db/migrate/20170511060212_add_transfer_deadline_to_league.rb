class AddTransferDeadlineToLeague < ActiveRecord::Migration[5.0]
  def change
    add_column :leagues, :transfer_deadline_round_number, :integer, default: 30
  end
end

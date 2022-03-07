class AddJobIdToDraftHistory < ActiveRecord::Migration[5.0]
  def change
    add_column :draft_histories, :job_id, :string
  end
end

class AddColumnLoanToNgagements < ActiveRecord::Migration[5.0]
  def change
    add_column :engagements, :loan, :boolean, default: false
  end
end

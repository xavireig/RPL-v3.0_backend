class SetDefaultValueForVirtualEngagementsStatus < ActiveRecord::Migration[5.0]
  def change
    change_column :virtual_engagements, :status, :integer, default: 0
  end
end

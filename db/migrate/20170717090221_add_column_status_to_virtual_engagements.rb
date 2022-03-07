class AddColumnStatusToVirtualEngagements < ActiveRecord::Migration[5.0]
  def self.up
    add_column :virtual_engagements, :status, :integer, default: 0
    remove_column :virtual_engagements, :in_line_up
  end

  def self.down
    remove_column :virtual_engagements, :status
    add_column :virtual_engagements, :in_line_up, :boolean
  end
end

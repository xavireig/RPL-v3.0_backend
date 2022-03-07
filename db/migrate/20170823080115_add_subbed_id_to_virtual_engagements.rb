class AddSubbedIdToVirtualEngagements < ActiveRecord::Migration[5.1]
  def change
    add_column :virtual_engagements, :subbed_id, :integer, index: true
  end
end

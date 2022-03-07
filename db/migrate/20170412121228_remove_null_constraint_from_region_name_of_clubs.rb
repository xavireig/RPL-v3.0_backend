class RemoveNullConstraintFromRegionNameOfClubs < ActiveRecord::Migration[5.0]
  def change
    change_column :clubs, :region_name, :string, null: true
  end
end

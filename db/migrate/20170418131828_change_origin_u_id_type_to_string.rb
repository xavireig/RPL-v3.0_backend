class ChangeOriginUIdTypeToString < ActiveRecord::Migration[5.0]
  def change
    change_column :fixtures, :original_u_id, :string
  end
end

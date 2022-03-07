class AddUniquenessToUIdInFixtures < ActiveRecord::Migration[5.1]
  def change
    remove_index :fixtures, :u_id
    add_index :fixtures, :u_id, unique: true
  end
end

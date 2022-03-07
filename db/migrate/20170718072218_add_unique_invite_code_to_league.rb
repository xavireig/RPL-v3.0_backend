class AddUniqueInviteCodeToLeague < ActiveRecord::Migration[5.0]
  def change
    add_index :leagues, :invite_code, unique: true
  end
end

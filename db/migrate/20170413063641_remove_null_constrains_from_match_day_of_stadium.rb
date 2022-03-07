class RemoveNullConstrainsFromMatchDayOfStadium < ActiveRecord::Migration[5.0]
  def change
    change_column :fixtures, :match_day, :datetime, null: true
  end
end

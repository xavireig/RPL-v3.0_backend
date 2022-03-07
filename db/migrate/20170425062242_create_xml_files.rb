class CreateXmlFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :xml_files do |t|
      t.string :file_uid
      t.string :file_name

      t.timestamps
    end
  end
end

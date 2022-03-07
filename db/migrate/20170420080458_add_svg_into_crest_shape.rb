# frozen_string_literal: true

class AddSvgIntoCrestShape < ActiveRecord::Migration[5.0]
  def change
    add_column :crest_shapes, :svg_uid, :string, null: false
  end
end

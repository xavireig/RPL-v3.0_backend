# frozen_string_literal: true

class AddSvgIntoCrestPatterns < ActiveRecord::Migration[5.0]
  def change
    add_column :crest_patterns, :svg_uid, :string, null: false
  end
end

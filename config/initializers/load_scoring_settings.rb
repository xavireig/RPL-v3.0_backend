# frozen_string_literal: true

SCORING_DEFAULT = YAML.safe_load(
  File.read(File.expand_path("#{Rails.root}/config/scoring_settings.yml")),
  [],
  [],
  true
)[Rails.env]

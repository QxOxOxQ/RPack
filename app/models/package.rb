# frozen_string_literal: true

class Package < ApplicationRecord
  scope :fresh, -> { where(deleted_at: nil) }
end

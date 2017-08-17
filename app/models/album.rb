# frozen_string_literal: true

class Album < ApplicationRecord
  has_and_belongs_to_many :images
end

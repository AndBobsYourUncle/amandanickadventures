# frozen_string_literal: true

class Album < ApplicationRecord
  has_many :album_images
  has_many :images, through: :album_images

  accepts_nested_attributes_for :album_images, allow_destroy: true
end

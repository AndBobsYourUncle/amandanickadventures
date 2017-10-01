# frozen_string_literal: true

class Album < ApplicationRecord
  PIXEL_THUMB_WIDTH = 20

  has_many :album_images
  has_many :images, through: :album_images

  accepts_nested_attributes_for :album_images, allow_destroy: true

  def thumb_width
    Math.sqrt(images.count).ceil * PIXEL_THUMB_WIDTH + PIXEL_THUMB_WIDTH
  end
end

# frozen_string_literal: true

require 'ruby-thumbor'

class Image < ApplicationRecord
  has_attached_file :image
  validates_attachment_content_type :image, content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif', 'application/pdf']

  has_and_belongs_to_many :albums

  before_destroy :destroy_image

  def small_thumb_url
    thumbor_url thumbor_face_crop(100, 100)
  end

  def thumb_url
    thumbor_url thumbor_face_crop(300, 300)
  end

  def medium_url
    thumbor_url thumbor_max_midth(500)
  end

  def url
    thumbor_url thumbor_image.generate
  end

  private

  def thumbor_key
    Rails.application.secrets.thumbor_key
  end

  def file_path
    return '' unless image.path

    image.path.partition('/')[2]
  end

  def thumbor_url url
    "#{ENV['THUMBOR_URL']}#{url}"
  end

  def thumbor_max_midth width
    thumbor_image.width(width).generate
  end

  def thumbor_face_crop width, height
    thumber_image_cropped.width(width).height(height).smart.generate
  end

  def thumber_image_cropped
    if custom_cropping
      Thumbor::Cascade.new(thumbor_key, file_path).crop(crop_top_left_x, crop_top_left_y, crop_bottom_right_x, crop_bottom_right_y)
    else
      Thumbor::Cascade.new(thumbor_key, file_path)
    end
  end

  def thumbor_image
    Thumbor::Cascade.new(thumbor_key, file_path)
  end

  def destroy_image
    image.destroy
  end
end

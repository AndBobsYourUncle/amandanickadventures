# frozen_string_literal: true

require 'ruby-thumbor'

class Image < ApplicationRecord
  has_attached_file :image
  validates_attachment_content_type :image, content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif', 'application/pdf']

  has_many :album_images, dependent: :destroy
  has_many :albums, through: :album_images

  before_destroy :destroy_image

  def pixel_thumb_url width: 10
    thumbor_url thumbor_face_crop(width, width)
  end

  def small_thumb_url
    thumbor_url thumbor_face_crop(100, 100)
  end

  def thumb_url
    thumbor_url thumbor_face_crop(300, 300)
  end

  def medium_url
    thumbor_url thumbor_max_width(500)
  end

  def small_height_url
    thumbor_url thumbor_max_height(100)
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
    Rails.application.routes.url_helpers.server_images_url(url.partition('/')[2], only_path: true)
  end

  def thumbor_max_width width
    thumbor_image.width(width).generate
  end

  def thumbor_max_height height
    thumbor_image.height(height).generate
  end

  def thumbor_face_crop width, height
    thumber_image_cropped.width(width).height(height).smart.generate
  end

  def thumbor_crop x1, y1, x2, y2
    thumbor_image.crop(x1, y1, x2, y2)
  end

  def thumber_image_cropped
    if custom_cropping
      thumbor_crop(crop_top_left_x, crop_top_left_y, crop_bottom_right_x, crop_bottom_right_y)
    else
      thumbor_image
    end
  end

  def thumbor_image
    Thumbor::Cascade.new(thumbor_key, file_path)
  end

  def destroy_image
    image.destroy
  end
end

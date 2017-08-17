# frozen_string_literal: true

class Image < ApplicationRecord
  has_attached_file :image, styles: {medium: '300x300#', thumb: '200x200#'}
  validates_attachment_content_type :image, content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif', 'application/pdf']

  has_and_belongs_to_many :albums

  before_destroy :destroy_image

  private

  def destroy_image
    image.destroy
  end
end

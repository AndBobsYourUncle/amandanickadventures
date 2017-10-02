# # frozen_string_literal: true

class AlbumImage < ApplicationRecord
  belongs_to :album
  belongs_to :image, dependent: :destroy

  accepts_nested_attributes_for :image

  default_scope -> {order position: :asc}
end

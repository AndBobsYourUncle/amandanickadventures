# # frozen_string_literal: true

class AlbumImage < ApplicationRecord
  belongs_to :album
  belongs_to :image, autosave: true

  accepts_nested_attributes_for :image

  default_scope -> {order position: :asc}

  delegate :name, :name=, to: :image, prefix: true, allow_nil: true
  delegate :caption, :caption=, to: :image, prefix: true, allow_nil: true
end

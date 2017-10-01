# # frozen_string_literal: true

class AlbumImage < ApplicationRecord
  belongs_to :album
  belongs_to :image

  default_scope -> {order position: :asc}
end

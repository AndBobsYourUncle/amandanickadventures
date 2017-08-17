class AddImageToImages < ActiveRecord::Migration[5.1]
  def self.up
    add_attachment :images, :image
  end

  def self.down
    remove_attachment :images, :image
  end
end

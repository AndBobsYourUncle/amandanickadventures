class DropAlbumImagesJoinTable < ActiveRecord::Migration[5.1]
  def change
    drop_join_table :albums, :images
  end
end

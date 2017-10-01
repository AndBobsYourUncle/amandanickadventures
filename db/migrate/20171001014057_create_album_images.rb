class CreateAlbumImages < ActiveRecord::Migration[5.1]
  def change
    create_table :album_images do |t|
      t.references :album
      t.references :image
      t.integer :position
    end
  end
end

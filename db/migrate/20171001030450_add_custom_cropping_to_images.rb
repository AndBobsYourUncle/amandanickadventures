class AddCustomCroppingToImages < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :custom_cropping, :boolean
    add_column :images, :crop_top_left_x, :integer
    add_column :images, :crop_top_left_y, :integer
    add_column :images, :crop_bottom_right_x, :integer
    add_column :images, :crop_bottom_right_y, :integer
  end
end

# frozen_string_literal: true

ActiveAdmin.register Image do
  menu parent: 'Albums', label: 'Images', priority: 3

  permit_params :name, :caption, :image

  batch_action :destroy do |ids|
    Image.where(id: ids).delete_all
    redirect_to admin_images_path, success: 'Images have been successfully deleted!'
  end

  index do
    selectable_column

    column '' do |image|
      link_to image_tag(image.image.url(:thumb)), admin_image_path(image)
    end

    column :name
    column :caption

    column 'Edit' do |image|
      link_to 'Edit', edit_admin_image_path(image)
    end
  end

  show do |image|
    columns do
      column do
        div do
          image_tag("#{ENV['THUMBOR_URL']}/unsafe/700x0/https:#{image.image.url}")
        end
      end
      column do
        attributes_table do
          row :name
          row :caption
          row :image_file_name
          row :image_content_type
          row :image_file_size
        end
      end
    end
  end

  filter :name
  filter :caption

  form do |f|
    actions

    inputs 'Details' do
      f.input :name, minimum_input_length: 1
      f.input :caption
      f.input :image, hint: image_tag(f.object.image.url(:thumb))
    end
  end
end

# frozen_string_literal: true

ActiveAdmin.register Image do
  permit_params :name, :caption, :image, :custom_cropping, :crop_top_left_x,
                :crop_top_left_y, :crop_bottom_right_x, :crop_bottom_right_y

  batch_action :destroy do |ids|
    Image.where(id: ids).destroy_all
    redirect_to admin_images_path, success: 'Images have been successfully deleted!'
  end

  controller do
    def edit
      session[:prev_url] = request.referer
      super
    end

    def update
      if resource.update_attributes permitted_params[:image]
        if session[:prev_url].present?
          redirect_to session[:prev_url], notice: 'Image successfully updated.'
        else
          redirect_to admin_image_path(resource), notice: 'Image successfully updated.'
        end
      else
        render :edit, notice: 'Image update wasn\'t successful.'
      end
    end
  end

  filter :albums

  index do
    selectable_column

    column '' do |image|
      link_to image_tag(image.small_thumb_url), admin_image_path(image)
    end

    column :name do  |image|
      link_to image.name, admin_image_path(image)
    end

    column :caption

    column 'Edit' do |image|
      link_to 'Edit', edit_admin_image_path(image), class: 'button'
    end
  end

  show do |image|
    columns do
      column do
        div 'Original:'
        div do
          image_tag image.medium_url
        end

        div 'Thumbnail:'
        div do
          image_tag image.thumb_url
        end

        div 'Small Thumbnail:'
        div do
          image_tag image.small_thumb_url
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

    tabs do
      tab 'Details' do
        inputs 'Details' do
          f.input :name, minimum_input_length: 1
          f.input :caption
          f.input :custom_cropping
          f.input :image, hint: image_tag(f.object.small_thumb_url)
        end
      end
      tab 'Custom Cropping' do
        inputs 'Custom Cropping' do
          cropping_elements = safe_join(
            [
              button_tag('Save Crop Values', id: 'save_crop_values'),
              hidden_field_tag('crop_top_left_x'),
              hidden_field_tag('crop_top_left_y'),
              hidden_field_tag('crop_bottom_right_x'),
              hidden_field_tag('crop_bottom_right_y'),
              image_tag(f.object.url, class: 'cropper-image', style: 'max-width: 100%;')
            ],
            ' '
          )

          f.input :crop_top_left_x
          f.input :crop_top_left_y
          f.input :crop_bottom_right_x
          f.input :crop_bottom_right_y, hint: cropping_elements
        end
      end
    end
  end
end

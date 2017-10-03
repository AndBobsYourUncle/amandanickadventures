# frozen_string_literal: true

ActiveAdmin.register Album do
  permit_params :name, album_images_attributes: %i[id image_id position image_name image_caption _destroy]

  controller do
    def create
      if resource = Album.create(permitted_params[:album])
        redirect_to edit_admin_album_path(resource), notice: 'Album successfully created.'
      else
        render :new, notice: 'Ablum creation wasn\'t successful.'
      end
    end

    def update
      album_hash = permitted_params[:album].to_h
      album_hash[:album_images_attributes].each do |_, image_hash|
        image_hash.delete(:image_name).delete(:image_caption) if image_hash[:id].blank?
      end

      if resource.update_attributes album_hash
        redirect_to edit_admin_album_path(resource), notice: 'Album successfully updated.'
      else
        render :edit, notice: 'Ablum update wasn\'t successful.'
      end
    end
  end

  member_action :upload_images, method: :post do
    uploaded_pics = params[:file]
    uploaded_pics.each do |_, image|
      AlbumImage.create(album_id: resource.id, image_attributes: {image: image})
    end
  end

  index do
    column 'Thumbnail' do |album|
      div render(partial: 'albums/thumbnail', locals: {album: album}),
          style: "cursor: pointer; display: inline-block;",
          onclick: "window.location='#{admin_album_path(album)}';"
    end

    column :name do |album|
      link_to album.name, admin_album_path(album)
    end

    column 'Edit' do |album|
      link_to 'Edit', edit_admin_album_path(album)
    end
  end

  csv do
    column :name
  end

  filter :name

  show do |image|
    columns do
      column do
        attributes_table do
          row :name
        end
      end
    end
    panel 'Images' do
      album.album_images.order(:position).in_batches(of: 6) do |imgs|
        div do
          imgs.each do |img|
            next if img.image.blank?

            div style: 'display: inline-block;' do
              link_to admin_image_path img.image do
                image_tag img.image.small_thumb_url
              end
            end
          end
        end
      end
    end
  end

  form do |f|
    actions

    inputs 'Details' do
      f.input :name, minimum_input_length: 1, hint: f.object.new_record? ? 'Before you can add images, you must enter a name and create the album.' : ''
    end

    unless f.object.new_record?
      inputs 'Multiple image upload' do
        tag.div '', id: 'dropzone_upload', class: 'dropzone'
      end

      inputs 'Images' do
        f.has_many :album_images, allow_destroy: true, sortable: :position do |t|
          position_hint = safe_join(
            [
              t.object.image ? link_to(t.template.image_tag(t.object.image.small_thumb_url), edit_admin_image_path(t.object.image)) : ''
            ],
            ' '
          )

          t.input :position, hint: position_hint
          t.input :image
          t.input :image_name
          t.input :image_caption
        end
      end
      actions
    end
  end
end

# frozen_string_literal: true

ActiveAdmin.register UserWhitelist do
  permit_params :fb_profile_photo_url

  controller do
    def create
      whitelist_hash = permitted_params[:user_whitelist]

      if whitelist_hash[:fb_profile_photo_url].present?
        whitelist_hash[:uid] = whitelist_hash[:fb_profile_photo_url].match(/(\d+)(?!.*\d{5})/)[1]

        facebook = Koala::Facebook::API.new(current_user.fb_token)
        whitelist_hash[:name] = facebook.get_object(whitelist_hash[:uid])['name']
        whitelist_hash[:profile_photo] = facebook.get_picture_data(whitelist_hash[:uid], type: 'small')['data']['url']
      end

      if UserWhitelist.create(whitelist_hash)
        redirect_to admin_user_whitelists_path, notice: 'User whitelist successfully created.'
      else
        render :new, notice: 'User whitelist creation wasn\'t successful.'
      end
    end
  end

  batch_action :destroy do |ids|
    UserWhitelist.where(id: ids).delete_all
    redirect_to admin_user_whitelists_path, success: 'User whitelist has been successfully deleted!'
  end

  index do
    selectable_column

    column '' do |blacklist|
      link_to image_tag(blacklist.profile_photo.to_s, style: 'max-width: 100px;'), admin_user_blacklist_path(blacklist)
    end

    column :name do |whitelist|
      link_to whitelist.name, admin_user_whitelist_path(whitelist)
    end

    column 'UID' do |whitelist|
      link_to whitelist.uid, admin_user_whitelist_path(whitelist)
    end

    column 'App UID' do |whitelist|
      link_to whitelist.fb_id, admin_user_whitelist_path(whitelist)
    end

    column 'Edit' do |whitelist|
      link_to 'Edit', edit_admin_user_whitelist_path(whitelist)
    end
  end

  csv do
    column :name
    column :uid
    column :fb_id
  end

  filter :name
  filter :uid
  filter :fb_id

  show do |whitelist|
    columns do
      column do
        attributes_table do
          row 'profile_picture' do
            image_tag(whitelist.profile_photo.to_s, style: 'max-width: 100px;')
          end
          row :name
          row :uid
          row :fb_id
        end
      end
    end
  end

  form do |f|
    actions

    inputs 'Details' do
      if f.object.new_record?
        f.input :fb_profile_photo_url, hint: "View the person's FB profile photo, and paste the URL from your browser here."
      else
        f.input :name, hint: image_tag(f.object.profile_photo.to_s, style: 'max-width: 100px;')
      end
    end
  end
end

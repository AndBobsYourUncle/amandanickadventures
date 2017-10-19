# frozen_string_literal: true

ActiveAdmin.register UserBlacklist do
  permit_params :fb_profile_photo_url

  controller do
    def create
      blacklist_hash = permitted_params[:user_blacklist]

      if blacklist_hash[:fb_profile_photo_url].present?
        blacklist_hash[:uid] = blacklist_hash[:fb_profile_photo_url].match(/(\d+)(?!.*\d{5})/)[1]

        facebook = Koala::Facebook::API.new(current_user.fb_token)
        blacklist_hash[:name] = facebook.get_object(blacklist_hash[:uid])['name']
        blacklist_hash[:profile_photo] = facebook.get_picture_data(blacklist_hash[:uid], type: 'small')['data']['url']
      end

      if UserBlacklist.create(blacklist_hash)
        redirect_to admin_user_blacklists_path, notice: 'User blacklist successfully created.'
      else
        render :new, notice: 'User blacklist creation wasn\'t successful.'
      end
    end
  end

  batch_action :destroy do |ids|
    UserBlacklist.where(id: ids).delete_all
    redirect_to admin_user_blacklists_path, success: 'User blacklist has been successfully deleted!'
  end

  index do
    selectable_column

    column '' do |blacklist|
      link_to image_tag(blacklist.profile_photo.to_s), admin_user_blacklist_path(blacklist)
    end

    column :name do |blacklist|
      link_to blacklist.name, admin_user_blacklist_path(blacklist)
    end

    column 'UID' do |blacklist|
      link_to blacklist.uid, admin_user_blacklist_path(blacklist)
    end

    column 'App UID' do |blacklist|
      link_to blacklist.fb_id, admin_user_blacklist_path(blacklist)
    end

    column 'Edit' do |blacklist|
      link_to 'Edit', edit_admin_user_blacklist_path(blacklist)
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

  show do |blacklist|
    columns do
      column do
        attributes_table do
          row 'profile_picture' do
            image_tag(blacklist.profile_photo.to_s, style: 'max-width: 100px;')
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
        f.input :name, hint: image_tag(f.object.profile_photo.to_s)
      end
    end
  end
end

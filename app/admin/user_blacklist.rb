# frozen_string_literal: true

ActiveAdmin.register UserBlacklist do
  permit_params :email

  controller do
    def create
      if resource = UserBlacklist.create(permitted_params[:user_blacklist])
        redirect_to admin_user_blacklists_path, notice: 'User blacklist successfully created.'
      else
        render :new, notice: 'User blacklist creation wasn\'t successful.'
      end
    end
  end

  batch_action :destroy do |ids|
    UserBlacklist.where(id: ids).delete_all
    redirect_to admin_user_blacklists_path, success: 'Images have been successfully deleted!'
  end

  index do
    selectable_column

    column :email do |whitelist|
      link_to whitelist.email, admin_user_blacklist_path(whitelist)
    end

    column 'Edit' do |whitelist|
      link_to 'Edit', edit_admin_user_blacklist_path(whitelist)
    end
  end

  csv do
    column :email
  end

  filter :email

  show do |image|
    columns do
      column do
        attributes_table do
          row :email
        end
      end
    end
  end

  form do |f|
    actions

    inputs 'Details' do
      f.input :email, minimum_input_length: 1
    end
  end
end

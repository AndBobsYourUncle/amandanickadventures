# frozen_string_literal: true

ActiveAdmin.register Album do
  menu parent: 'Albums', label: 'Albums', priority: 3

  permit_params :name

  index do
    column 'Edit' do |job|
      link_to 'Edit', edit_admin_album_path(job)
    end

    column :name
  end

  csv do
    column :name
  end

  filter :name

  form do |f|
    actions

    inputs 'Details' do
      f.input :name, minimum_input_length: 1
    end
  end
end

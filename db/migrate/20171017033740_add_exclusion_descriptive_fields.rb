class AddExclusionDescriptiveFields < ActiveRecord::Migration[5.1]
  def change
    add_column :user_blacklists, :name, :string
    add_column :user_blacklists, :profile_photo, :string
    add_column :user_whitelists, :name, :string
    add_column :user_whitelists, :profile_photo, :string
  end
end

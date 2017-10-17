class ChangeExclusionsToId < ActiveRecord::Migration[5.1]
  def change
    add_column :user_blacklists, :uid, :integer, limit: 8
    add_column :user_blacklists, :fb_id, :integer, limit: 8
    remove_column :user_blacklists, :email, :string

    add_column :user_whitelists, :uid, :integer, limit: 8
    add_column :user_whitelists, :fb_id, :integer, limit: 8
    remove_column :user_whitelists, :email, :string
  end
end

class CreateUserBlacklists < ActiveRecord::Migration[5.1]
  def change
    create_table :user_blacklists do |t|
      t.string :email
    end
  end
end

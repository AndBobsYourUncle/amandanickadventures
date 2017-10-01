class CreateUserWhitelists < ActiveRecord::Migration[5.1]
  def change
    create_table :user_whitelists do |t|
      t.string :email
    end
  end
end

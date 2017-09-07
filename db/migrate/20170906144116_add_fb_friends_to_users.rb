class AddFbFriendsToUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :friends_count, :integer, default: 0
    add_column :users, :friends, :json, default: {}
  end

  def down
    remove_column :users, :friends, :json, default: {}
    remove_column :users, :friends_count, :integer, default: 0
  end
end

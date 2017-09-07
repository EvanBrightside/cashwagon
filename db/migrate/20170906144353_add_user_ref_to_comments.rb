class AddUserRefToComments < ActiveRecord::Migration[5.1]
  def up
    add_reference :comments, :user, foreign_key: true
  end

  def down
  	remove_reference :comments, :user, foreign_key: true
  end
end

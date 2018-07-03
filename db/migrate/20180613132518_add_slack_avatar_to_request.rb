class AddSlackAvatarToRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :slack_avatar, :string
  end
end

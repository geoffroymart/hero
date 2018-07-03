class AddSlackUserIdToRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :slack_user_id, :string
  end
end

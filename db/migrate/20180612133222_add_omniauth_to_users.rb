class AddOmniauthToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :slack_user_id, :string
    add_column :users, :slack_team_id, :string
  end
end

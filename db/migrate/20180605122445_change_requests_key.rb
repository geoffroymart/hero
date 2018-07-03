class ChangeRequestsKey < ActiveRecord::Migration[5.2]
  def change
    remove_column :requests, :user_id
    add_column :requests, :email, :string
    change_column_default :requests, :status, from: '', to: 'pending'
  end
end

class AddDisableKeyToRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :disable, :boolean, default: false
  end
end

class AddDisableToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :disable, :boolean, default: false
  end
end

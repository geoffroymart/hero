class UpdateProfile < ActiveRecord::Migration[5.2]
  def change
    remove_column :profiles, :disable, :boolean
    remove_column :profiles, :role, :string
    add_column :profiles, :first_name, :string
    add_column :profiles, :last_name, :string
  end
end

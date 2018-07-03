class AddTypeToAttachments < ActiveRecord::Migration[5.2]
  def change
    add_column :attachments, :attachment_type, :integer
  end
end

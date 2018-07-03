class ChangeNamePhotoInAttachments < ActiveRecord::Migration[5.2]
  def change
    rename_column :attachments, :file, :photo
  end
end

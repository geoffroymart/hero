class RemoveAttachmentTypeKey < ActiveRecord::Migration[5.2]
  def change
    remove_column :attachments, :attachment_type, :string
  end
end

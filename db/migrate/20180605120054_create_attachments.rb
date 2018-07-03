class CreateAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :attachments do |t|
      t.references :request, foreign_key: true, type: :uuid
      t.string :file
      t.string :attachment_type

      t.timestamps
    end
  end
end

class CreateRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :requests, id: :uuid do |t|
      t.string :title
      t.text :description
      t.text :personal_note
      t.text :end_comment
      t.string :status
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

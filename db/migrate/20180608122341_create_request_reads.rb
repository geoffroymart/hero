class CreateRequestReads < ActiveRecord::Migration[5.2]
  def change
    create_table :request_reads do |t|
      t.references :request, type: :uuid, null: false, index: true

      t.timestamps
    end
  end
end

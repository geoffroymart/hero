class Attachment < ApplicationRecord
  mount_uploader :photo, PhotoUploader
  belongs_to :request
  validates :photo, presence: true
  validates :attachment_type, presence: true

  enum attachment_type: [ :request, :comment, :personal ]
end

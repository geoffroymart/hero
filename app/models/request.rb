class Request < ApplicationRecord
  has_one :request_read
  has_many :attachments, dependent: :destroy
  accepts_nested_attributes_for :attachments

  validates :title, presence: { message: 'is needed, the shorter the better'} , length: { maximum: 50 }

  # The `on:` option sets the relevant attribute for comparing timestamps.
  #
  # The default is :updated_at, so updating a record, which was read by a
  # reader makes it unread again.
  #
  # Using :created_at, only new records will show up as unread. Updating a
  # record which was read by a reader, will NOT mark it as unread.
  #
  # Any other existing timestamp field can be used as `on:` option.
  def request_read
    super || RequestRead.create(request: self) # Astuce Hyper stylée
  end
end

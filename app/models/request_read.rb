class RequestRead < ApplicationRecord
  acts_as_readable on: :created_at

  belongs_to :request
end

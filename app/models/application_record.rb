class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include PgSearch
  pg_search_scope :search_by_title_email_and_description,
    against: [ :title, :email, :description ],
    using: {
      tsearch: { prefix: true } #
    }
end


class Link < ActiveRecord::Base
  before_create :save_clear_url


  VALID_URL_REGEX = /\A((http[s]?|ftp):\/)?\/?([^:\/\s]+)(\/|)\z/
  validates :url, presence: true, format: { with: VALID_URL_REGEX }

  private
    def save_clear_url
      path = VALID_URL_REGEX.match(self.url)
      self.url = path[3].to_s.gsub('www.','')
    end
end

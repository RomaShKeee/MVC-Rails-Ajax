class Link < ActiveRecord::Base
  before_save :save_clear_url, :validate!

  VALID_URL_REGEX = /\A((http[s]?|ftp):\/)?\/?([^:\/\s]+(\.\w{2,4}))(\/|)(...){0,20}\z/
  validates :url, presence: true, format: { with: VALID_URL_REGEX }, uniqueness: true



  private
    def save_clear_url
      path = VALID_URL_REGEX.match(self.url)
      self.url = path[3].to_s.gsub('www.','').downcase
      if item = Link.find_by_url(self.url)
        item.destroy!
      end
      return self
    end
end




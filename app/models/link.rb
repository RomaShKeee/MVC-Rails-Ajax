class Link < ActiveRecord::Base
  before_validation :save_clear_url
  VALID_URL_REGEX = /\A((http[s]?|ftp):\/)?\/?([^:\/\s]+(\.\w{2,4}))(\/|)(...){0,20}\z/
  validates :url, presence: true, format: { with: VALID_URL_REGEX }

  def parse_url(path_name)
    path = VALID_URL_REGEX.match(path_name)
    path_name = path[3].to_s.gsub('www.','').downcase if path
  end

  private
    def save_clear_url
      path = VALID_URL_REGEX.match(self.url)
      self.url = path[3].to_s.gsub('www.','').downcase if path
    end
end




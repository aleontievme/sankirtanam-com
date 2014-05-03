class Location < ActiveRecord::Base
  has_many :locations
  before_create :set_permalink

  def set_permalink
  	puts transliterate(self.name)
    self.permalink = ActiveSupport::Inflector.transliterate(self.name)
      .downcase
      .gsub(/[^0-9a-z ]/i, "")
      .gsub(" ", "-")
  end
end

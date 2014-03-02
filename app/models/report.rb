class Report < ActiveRecord::Base
  belongs_to :location
  has_many :records
end

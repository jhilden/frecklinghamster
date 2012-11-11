class Activity < ActiveRecord::Base
  # attr_accessible :title, :body

  has_many :facts
end

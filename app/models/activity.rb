class Activity < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :category
  has_many :facts
end

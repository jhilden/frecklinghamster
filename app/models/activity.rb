class Activity < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :category
  has_many :facts

  def color
    return  unless index = Freckle::PROJECT_MAPPING_ARRAY.index{|x| x[0] == id}
    FrecklingHamster::COLORS[ index ]
  end
end

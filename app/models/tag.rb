class Tag < ActiveRecord::Base
  # attr_accessible :title, :body

  has_and_belongs_to_many :facts, join_table: 'fact_tags'
end
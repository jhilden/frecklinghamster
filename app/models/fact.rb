class Fact < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :activity
  has_and_belongs_to_many :tags, join_table: 'fact_tags'

  def duration
    diff = end_time - start_time
    minutes, seconds = diff.divmod(60)
    hours, minutes = minutes.divmod(60)

    minutes = "%02d" % minutes  # add leading zeros

    [hours, minutes]
  end

  def duration_in_minutes
    ((end_time - start_time)/60).to_i
  end
end

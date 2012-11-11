class Fact < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :activity

  def duration
    diff = end_time - start_time
    minutes, seconds = diff.divmod(60)
    hours, minutes = minutes.divmod(60)

    minutes = "%02d" % minutes  # add leading zeros

    [hours, minutes]
  end
end

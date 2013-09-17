class Fact < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :activity
  has_and_belongs_to_many :tags, join_table: 'fact_tags'

  scope :exported, where(:exported_at, nil)
  scope :before_or_on, lambda {|date| where("start_time <= ?", date.end_of_day) }

  def duration
    return ["0", "00"]  unless start_time.present? && end_time.present?
    diff = end_time - start_time
    minutes, seconds = diff.divmod(60)
    hours, minutes = minutes.divmod(60)

    minutes = "%02d" % minutes  # add leading zeros

    [hours, minutes]
  end

  def duration_in_minutes
    return 0  unless end_time.present? && start_time.present?
    ((end_time - start_time)/60).to_i
  end

  def exported?
    exported_at.present?
  end

  def freckle_tags_description_string
    # http://letsfreckle.com/help/#faq_14
    tags_description = tags.select{|t| !t.name.start_with?('@') }.map(&:name).join(', ') # don't include '@cowoco' tags, etc.
    tags_description += ', ' unless tags_description.blank?
    tags_description += "!#{description}"
  end
end
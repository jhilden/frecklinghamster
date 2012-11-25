module ApplicationHelper
  def render_minutes(minutes)
    hours, minutes = minutes.divmod(60)

    minutes = "%02d" % minutes  # add leading zeros

    [hours, minutes]
  end
end

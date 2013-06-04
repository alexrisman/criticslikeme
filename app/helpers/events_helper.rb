module EventsHelper
  def translateAssTypeToVerb(kind)
    case kind
      when "Industry"
        "are in "
      when "Company"
        "work(ed) for "
      when "Location"
        "live(d) in "
      when "School"
        "went to "
      when "Language"
        "know "
      when "all"
        "may or may not be like you, but still might be "
      when "about"
        "are part of the Confr"
      else 
        "are in "
    end
  end
end

module ApplicationHelper
  def translate_time(time)
    time.strftime("%B %d, %Y %I:%M:%S%p")
  end
  
  def summarize(content, wordcount=50)
    content.split[0..(wordcount-1)].join(" ") + (content.split.size > wordcount ? "... " : "") 
  end
end

module DisplayHelper
  def get_title(title)
    base_title = "Service Pack R&D Project"
    if title.empty?
      base_title
    else
      title + " | " + base_title
    end
  end
  	
end
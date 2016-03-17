require "nokogiri"

def get_href_tag_array_from_html(content)
  page = Nokogiri::HTML(content)
  res = Array.new
  page.css("a").each do |a|

    href = a["href"]
    href = "" if href == nil
    res.push(href)
  end
  return res
end

def get_form_tag_array_from_html(content) 
  page = Nokogiri::HTML(content)
  res = Array.new
  forms = []
  page.css("form").each do |form|
    forms.push form
  end
  return forms
end


def get_xml(tag, content, attributes: [], escape_content: false)
  str = "<"
  str += tag
  str += get_attribute_list(attributes)
  str += ">"
  if escape_content
    str += escape_xml_special_characters(content)
  else
    str += content
  end
  str += "<\/"
  str += tag
  str += ">"
  return str
end

def get_attribute_list(attrib)
  str = ""
  if attrib.length > 0
    attrib.each do |p|
      if p.length == 2
        key = p.at(0)
        value = p.at(1)
        str += " " + key + "=\"" + value.to_s + "\""
      else
        puts "error in passing attribute values to get_xml"
      end
    end
  end
  return str
end

def escape_xml_special_characters(s)
  escaped_string = s
  escaped_string = escaped_string.gsub("\"", "&quot;")
  escaped_string = escaped_string.gsub("'", "&apos;")
  escaped_string = escaped_string.gsub("<", "&lt;")
  escaped_string = escaped_string.gsub("&", "&amp;")
  return escaped_string
end

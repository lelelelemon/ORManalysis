
def get_view_name_from_render_statement2(r)
  puts r
  view = nil
  ast = YARD::Parser::Ruby::RubyParser.parse(r).root
  if ast.type.to_s == "list"
    ast = ast[0]
  end
  if ast.type.to_s == "if_mod" or ast.type.to_s == "unless_mod"
    ast = ast[1]
  end
  if ast[0].source.to_s != "render"
    return "not_valid"
  end
  params = ast[1][0]
  puts params.type.to_s
  puts params.source.to_s
  if params[0].type.to_s == "string_literal"
    view =  params[0].source.to_s
  elsif params[0].type.to_s == "symbol_literal"
    view = params[0].source.to_s
  elsif params[0].type.to_s == "vcall"
    view = params[0].source.to_s
  elsif params[0].type.to_s == "var_ref"
    view = params[0].source.to_s
  else
    puts params.type.to_s
    puts params.source.to_s
    params.children.each do |assoc|
      if assoc[0].source.to_s == "partial" or 
        assoc[0].source.to_s == "template" or 
        assoc[0].source.to_s == "action" or 
        assoc[0].source.to_s == ":partial" or 
        assoc[0].source.to_s == ":template" or 
        assoc[0].source.to_s == ":action" 
        view = assoc[1].source.to_s
      end
    end
  end

  puts "raw view: " 
  if view == nil
    return "not_valid"
  end
  if view.end_with?".html.erb"
    view = view[0..-10]
  end
  view.gsub! /["':]/, ""
  k = view.rindex("/")
  if k == nil
    view = self.get_controller_name + "_" + view
  else
    view = view[0..k-1] + "_" + view[k+1..-1]
  end
  puts view
  return view
end

def get_view_name_from_render_statement(r)
  r = r.split("\n")[0]
  r = r[6..-1] if r.start_with?"return"
  r = r[17..-1] if r.start_with?"escape_javascript"
  r.strip!
  while r[0] == '(' 
    r = r[1..-1]
  end
  while r[-1] == ')'
    r = r[0..-2]
  end
  r = r[6..-1] if r.start_with?"render"
  r.strip!
  while r[0] == '(' 
    r = r[1..-1]
  end
  while r[-1] == ')'
    r = r[0..-2]
  end
  arr = r.split(",")
  view = ""
  view_exists = false
  arr[0].strip!
  if arr[0].start_with?"\"" or arr[0].start_with?"'" or arr[0].start_with?":"
    if arr[0].include?("=>")
      arr[0].gsub! /["':]/, ""
      arr[0].gsub! " ", ""
      a = arr[0].split("=>")
      if a[0] == "partial" or a[0] == "template" or a[0] == "action"
        view = a[1]
        while view[0] == '/'
          view = view[1..-1]
        end
        view_exists = true
      end
    else
      view = arr[0]
      view.gsub! /["':]/, ""
      while view[0] == '/'
        view = view[1..-1]
      end
      view_exists = true
    end
  else 
    arr.each do |a|
      a.gsub! /["'\t]/, ""
      a.gsub! " ", ""
      if a.include?("=>")
        a = a.split("=>")
      elsif a.include?":" 
        a = a.split(":")		
      else 
        a = [a]
        a[1] = ""	
      end
      if a[0] == ":partial" or a[0] == ":template" or a[0] == ":action" or 
        a[0] == "partial" or a[0] == "template" or a[0] == "action" 
        view = a[1]
        while view[0] == '/'
          view = view[1..-1]
        end
        view_exists = true
      end
    end
  end

  if view.end_with?".html.erb"
    view = view[0..-10]
  end
  k = view.rindex("/")
  if k == nil
    view = self.get_controller_name + "_" + view
  else
    view = view[0..k-1] + "_" + view[k+1..-1]
  end
  if view_exists
    return view
  else
    return "not_valid"
  end
end

def parse_render_params(line)
  line = line.to_s	
  line = line.split("\n")[0]
  line.gsub! /["' \t]/, ""
  if line.start_with?"render"
    line = line[6..-1]
  end
  if line.start_with?'{' or line.start_with?"("
    line = line[1..-1]
  end
  if line.end_with?')' or line.end_with? == '}'
    line = line[0..-2]
  end
  items = line.split(',')


  if not (items[0].include?":action" or items[0].include?":template" or items[0].include?":partial")
    return items[0]
  end

  items.each do |item|
    item.strip!
    a = item.split("=>")
    if a[0] == ':action' or a[0] == ':template' or a[0] == ':partial'
      return a[1]
    end
  end

end

def get_layout_name_from_render_statement(r)
  r = r.split("\n")[0]
  r = r[6..-1] if r.start_with?"return"
  r.strip!
  r = r[6..-1] if r.start_with?"render"
  r.strip!
  while r[0] == '(' 
    r = r[1..-1]
  end
  while r[-1] == ')'
    r = r[0..-2]
  end
  arr = r.split(",")
  layout = ""
  layout_exists = false
  arr[0].strip!
  arr.each do |a|
    a.gsub! /["'\t]/, ""
    a.gsub! " ", ""
    if a.include?("=>")
      a = a.split("=>")
    elsif a.include?":" 
      a = a.split(":")		
    else 
      a = [a]
      a[1] = ""	
    end
    if a[0] == ":layout" or a[0] == "layout"
      layout = a[1]
      while layout[0] == '/'
        layout = layout[1..-1]
      end
      layout_exists = true
    end
  end

  if layout.end_with?".html.erb"
    layout.gsub! ".html.erb", ""
  end

  if layout_exists
    return layout
  else
    return "not_valid"
  end
end





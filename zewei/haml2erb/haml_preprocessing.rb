is_comment = false
indent = ""
content = ""

encoding_options = {
  :invalid => :replace,
  :undef => :replace,
  :replace => '',
  :univseral_newline => true
}

def process_line(line)

	if line =~ /.*==.*\#{.*}.*/
    line = ""
  end
  if line =~ /.*{[^}]*{.*}[^{]*}.*/
    line.gsub! /{[^}]*{.*}[^{]*}/, "{}"
  end
  if line =~ /.*\|\| [^ ]* \? [^ ]* : "".*/
    line.gsub! /\|\| [^ ]* \? [^ ]* : ""/, ""
  end
  if line =~ /.*{class: [^ ]* \? [^ ]* : [^ ]*}.*/
    line.gsub! /{class: [^ ]* \? [^ ]* : [^ ]*}/, "{class: \"\"}"
  end
  if line.include?"font{body_font}" or line.include?"font{big_quotation_mark_font}" or line.include?"font{quote_font}"
    line.gsub! "font{body_font}", "font"
    line.gsub! "font{big_quotation_mark_font}", "font"
    line.gsub! "font{quote_font}", "font"
  end
  if line =~ /.*, :class => \(.* \? .* : [^ ]*\).*/
    line.gsub! /, :class => \(.* \? .* : [^ ]*\)/, ""
  end
  if line =~ /.*{:class => \(.* \? .* : [^ ]*\)}.*/
    line.gsub! /{:class => \(.* \? .* : [^ ]*\)}/, ""
  end
  if line =~ /.*{:class => .* \? .* : [^ ]*}.*/
    line.gsub! /{:class => .* \? .* : [^ ]*}/, ""
  end
  if line =~ /.*\|\| [^\(\)]*\).*/
    line.gsub! /\|\| [^\(\)]*\)/, ")"
  end
  if line =~ /.*\|\| [^{}]*}.*/
    line.gsub! /\|\| [^{}]*}/, "}"
  end
  if line =~ /.*\|\| [^ ]*,.*/
    line.gsub! /\|\| [^ ]*,/, ","
  end
  if line =~ /.*\#{[^}]*}.*/
    line.gsub! /\#{[^}]*}/, ""
  end
  if line =~ /.*\('container-full' if content_for\?\(:use_full_container\) && yield\(:use_full_container\)\).*/
    line.gsub! /\('container-full' if content_for\?\(:use_full_container\) && yield\(:use_full_container\)\)/, ""
  end
  if line =~ /.*\(@page.is_favourite\?\(@user\) \? [^ ]* : [^ \)]*\).*/
    line.gsub! /\(@page.is_favourite\?\(@user\) \? [^ ]* : [^ \)]*\)/, "()"
  end
  if line =~ /.*\+ \(params\[:show\] == 'unread' \? [^ \)]* : [^ \)]*\).*/
    line.gsub! /\+ \(params\[:show\] == 'unread' \? [^ \)]* : [^ \)]*\)/, ""
  end

  if line =~ /.*&& @grouped_unread_notification_counts.has_key\?\(params\[:type\]\)\).*/
    line.gsub! /&& @grouped_unread_notification_counts.has_key\?\(params\[:type\]\)\)/, ""
  end

  if line =~ /.*\+ \(params\[:type\] \? '\?type=' \+ params\[:type\] : ''\).*/
    line.gsub! /\+ \(params\[:type\] \? '\?type=' \+ params\[:type\] : ''\)/, ""
  end

  if line =~ /.*&& "active".*/
    line.gsub! /&& "active"/, ""
  end

  if line =~ /.*if \(!publisher_public && all_aspects_selected\?\(selected_aspects\)\).*/
    line.gsub! /if \(!publisher_public && all_aspects_selected\?\(selected_aspects\)\)/, ""
  end

  if line =~ /.*&& selected_aspects.include\?\(aspect\) \? "selected" : "".*/
    line.gsub! /&& selected_aspects.include\?\(aspect\) \? "selected" : ""/, ""
  end

  if line.include? " + flash_class(level)"
    line.gsub! " + flash_class(level)", ""
  end

  if line.include? " + css_class"
    line.gsub! " + css_class", ""
  end
  
  if line.include? "@selected.eql?(p.id.to_s) ? 'selected' : ''"
    line.gsub! "@selected.eql?(p.id.to_s) ? 'selected' : ''", "''"
  end

	if line =~ /.*class: fluid_layout \? "container-fluid" : "container-fluid".*/
		line.gsub! /class: fluid_layout \? "container-fluid" : "container-fluid"/, "class: \"container-fluid\""
	end

	if line.include? "content: request.base_url + request.fullpath"
		line.gsub! "content: request.base_url + request.fullpath", "content: request.base_url"
	end
	
	if line.include? "('page-with-layout-nav' if defined?(nav) && nav)"
		line.gsub! "('page-with-layout-nav' if defined?(nav) && nav)", "'page-with-layout-nav'"
	end

	if line.include? "(preview_class if defined?(preview_class))"
		line.gsub! "(preview_class if defined?(preview_class))", "preview_class"
	end
  
	if line.include? "can?(current_user, :update_issue, @issue) ? 'js-task-list-container' : ''"
		line.gsub! "can?(current_user, :update_issue, @issue) ? 'js-task-list-container' : ''", "'js-task-list-container'"
	end

	if line.include? "%button.btn.btn-danger"
		line.gsub! "%button.btn.btn-danger", "button.btn.btn-danger"
	end

	if line.include? "(dom_id(user) if user)"
		line.gsub! "(dom_id(user) if user)", "dom_id(user)"
	end

	if line.include? "class: (level.to_s == params[:visibility_level]) ? 'active' : 'light'"
		line.gsub! "class: (level.to_s == params[:visibility_level]) ? 'active' : 'light'", "class: 'light'"
	end

	if line.include? "class: (tag.name == params[:tag]) ? 'active' : 'light'"
		line.gsub! "class: (tag.name == params[:tag]) ? 'active' : 'light'", "class: 'light'"
	end

	return line

end

File.open(ARGV[0], "r").each_line do |line|

  line = line.encode(Encoding.find('ASCII'), encoding_options)

	line = process_line(line)

  if is_comment and (line.start_with?"#{indent} " or line.start_with?"#{indent}\t" or line.start_with?"\n")
    next
  else line =~ /[ \t]*.*/
    matched = /([ \t]*)(.*)/.match(line)
    indent = matched[1]
    content = matched[2]
  end
  is_comment = false
  while line.end_with?" " or line.end_with?"\t" or line.end_with?"\n"
    line = line[0..-2]
  end

  while content.end_with?" " or content.end_with?"\t" or content.end_with?"\n"
    content = content[0..-2]
  end

#  while line.start_with?" " or line.start_with?"\t" or line.start_with?"\n"
#    line = line[1..-1]
#  end
#  if line.to_s.strip.length == 0
#    next
#  end
  if content.start_with?"-#"
    is_comment = true
  end

  if content.end_with?", |"
    content = content[0..-3]
    line = indent + content
  elsif content.end_with?","
    line = indent + content
	else 
		line = indent + content + "\n"
  end
	
	print line
end 

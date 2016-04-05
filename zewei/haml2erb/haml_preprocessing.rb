is_comment = false
indent = ""
content = ""

encoding_options = {
  :invalid => :replace,
  :undef => :replace,
  :replace => '',
  :univseral_newline => true
}

File.open(ARGV[0], "r").each_line do |line|

  line = line.encode(Encoding.find('ASCII'), encoding_options)

  if is_comment and (line.start_with?"#{indent} " or line.start_with?"#{indent}\t" or line.start_with?"\n")
    next
  elsif line =~ /[ \t]*.*/
    matched = /([ \t]*)(.*)/.match(line)
    indent = matched[1]
    content = matched[2]
  end
  is_comment = false
  while line.end_with?" " or line.end_with?"\t" or line.end_with?"\n"
    line = line[0..-2]
  end


#  while line.start_with?" " or line.start_with?"\t" or line.start_with?"\n"
#    line = line[1..-1]
#  end
  if line.to_s.strip.length == 0

  end
  if content.start_with?"-#"
    is_comment = true
  end

  if content.end_with?", |"
    content = content[0..-3]
    print indent + content
  end
  if line.end_with?","
    print indent + content
  end

  if line =~ /.*==.*\#{.*}.*/
    line = ""
  end
  if line =~ /.*{[^}]*{.*}[^{]*}.*/
    line.gsub! /{[^}]*{.*}[^{]*}/, "{}\n"
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
  puts line

end

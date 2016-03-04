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
  if content.start_with?"-#"
    is_comment = true
  elsif content.end_with?", |"
    content = content[0..-3]
    print indent + content
  elsif line.end_with?","
    print indent + content
  elsif line =~ /.*==.*\#{.*}.*/
#  elsif line =~ /.*{.*{.*}.*}.*/
  else
    puts line
  end

end

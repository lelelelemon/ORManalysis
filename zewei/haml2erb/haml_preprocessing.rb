

File.open(ARGV[0], "r").each_line do |line|
  while line.end_with?" " or line.end_with?"\t" or line.end_with?"\n"
    line = line[0..-2]
  end
#  while line.start_with?" " or line.start_with?"\t" or line.start_with?"\n"
#    line = line[1..-1]
#  end
  if line.end_with?", |"
    line = line[0..-3]
    print line
  elsif line =~ /.*==.*\#{.*}.*/
  
#  elsif line =~ /.*{.*{.*}.*}.*/

  else
    puts line
  end

end

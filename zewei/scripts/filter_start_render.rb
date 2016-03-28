line_num = 0
text = File.open(ARGV[0]).read
text.each_line do |line|
  if line.start_with?("START", "RENDER")
    puts line
  end
end

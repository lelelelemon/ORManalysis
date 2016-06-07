File.open(ARGV[0], "r").each_line do |line|
  puts line
  if line.start_with? "#visiting page:" 
    line.gsub! "#visiting page: localhost:3000", ""
    while line.end_with?"\n"
      line = line[0..-2]
    end
    puts "route.recognize_path \"#{line}\""
  end
end

#!/usr/local/bin/ruby

File.open(ARGV[0]).each_line do |line|
  data = line.split(" ")
  puts data[1] + " " + data[2]
end

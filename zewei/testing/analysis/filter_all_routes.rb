#!/usr/local/bin/ruby

fin = ARGV[0]

text = File.open(fin).read
text.gsub! /\r\n?/, "\n"

text.each_line do |line|
  items = line.gsub(/\s+/m, ' ').strip.split(" ")
  i = 0
  items.each do |item|
    if item.start_with?"/"
      puts items[i-1] + " " + item
    end
    i += 1
  end
end

require "yard"


total = 0
empty = 0
Dir.glob(ARGV[0] + "**/*") do |item|
  next if not item.end_with?".rb"
  _item = item.gsub(".erb.rb"){".haml"}
  if File.zero?(item) and not File.zero?(_item)
    puts item
    empty += 1
  end
  total += 1
end

puts "total: #{total}"
puts "empty: #{empty}"

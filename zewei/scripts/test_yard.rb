require "yard"


Dir.glob(ARGV[0] + "**/*") do |item|
  next if not item.end_with?"_controller.rb"
  puts item
  content = File.read(item)
  YARD::Parser::Ruby::RubyParser.parse(content).root
end

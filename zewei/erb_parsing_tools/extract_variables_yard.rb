require "benchmark"
require 'yard'
require 'logger'

PATH_ORDER = [
  'lib/yard/autoload.rb',
  'lib/yard/code_objects/base.rb',
  'lib/yard/code_objects/namespace_object.rb',
  'lib/yard/handlers/base.rb',
  'lib/yard/generators/helpers/*.rb',
  'lib/yard/generators/base.rb',
  'lib/yard/generators/method_listing_generator.rb',
  'lib/yard/serializers/base.rb',
  'lib/**/*.rb'
]

abort 'Usage: print_ast_yard.rb <input_filename> <output_filename>' if ARGV.empty?

in_filename = ARGV[0]
out_filename = ARGV[1]

file = File.open(in_filename, "r")
contents = file.read
ast = YARD::Parser::Ruby::RubyParser.parse(contents).root

#cong's code
def traverse_ast(astnode, level)
	@blank = ""
	for i in (0...level)
		@blank = @blank + "   "
	end
	print "#{@blank}level #{level}, #{astnode.type}"
	if astnode.source.length < 30
		puts " -> #{astnode.source}"
	else
		puts " range #{astnode.source_range}"
	end
	astnode.children.each do |child|
		traverse_ast(child, level+1)
	end
end


def traverse_ast_variables(astnode, variable_array)
	astnode.type 
	if astnode.type == :ivar
		variable_array << "<ivar>#{astnode.source}</ivar>"
		#puts astnode.source
	elsif astnode.type == :call
		variable_array << "<call>#{astnode.source}</call>"

	end
	
	astnode.children.each do |child|
		traverse_ast_variables(child, variable_array)
	end
end

variable_array = []
#traverse_ast(ast, 0)
traverse_ast_variables(ast, variable_array)
#puts variable_array
out = File.open(out_filename, "w")
variable_array.uniq.each do |x|
	out << "#{x}\n"
end


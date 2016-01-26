require "yard"

def get_filename_from_path(filename)
	i = filename.rindex('/')
	if i == nil
		return nil
	end
	n = filename[i+1..-1]
	return n
end

def get_nested_path(filepath, basepath)
	i = filepath.rindex(basepath)
	j = filepath.rindex('/')
	if i == nil or j == nil
		return nil
	end
	n = filepath[i+basepath.length..j]
	return n
end

def parse_render_params(line)
	line = line.to_s	
	line = line.split("\n")[0]
	line.gsub! /["' \t]/, ""
	if line.start_with?"render"
		line = line[6..-1]
	end
	if line.start_with?'{' or line.start_with?"("
		line = line[1..-1]
	end
	if line.end_with?')' or line.end_with? == '}'
		line = line[0..-2]
	end
	items = line.split(',')

	
	if not (items[0].include?":action" or items[0].include?":template" or items[0].include?":partial")
		return items[0]
	end

	items.each do |item|
		item.strip!
		a = item.split("=>")
		if a[0] == ':action' or a[0] == ':template' or a[0] == ':partial'
			return a[1]
		end
	end

end

# view: string, content of the view file
#layout: stirng, content of the kayout file
def embed_view_into_layout(view, layout)
	hash = Hash.new

	view_ast = YARD::Parser::Ruby::RubyParser.parse(view).root
	layout_ast = YARD::Parser::Ruby::RubyParser.parse(layout).root
	 
	traverse_ast layout_ast
end

def traverse_ast(ast)
	if ast.source.start_with?"yield"
		puts ast.source
		puts ast.type.to_s
	else
		ast.children.each do |child|
			traverse_ast(child)
		end
	end
end

def get_array_with_keyword(ast, keyword)
	res_arr = Array.new
	ast_arr = Array.new
	ast_arr.push @ast
	while ast_arr.length > 0
		cur_ast = ast_arr.pop
		if cur_ast.source.start_with? keyword 
			res_arr.push cur_ast.source
		else
			cur_ast.children.each do |child|
				ast_arr.push child
			end
		end
	end
	return res_arr
end

def print_rails_tag(tag_arr, named_routes_class)
	tag_arr.each do |tag|
			#puts form_for_tag.source
		url_inside = false
		named_routes_class.get_named_routes.each do |k, v|
			if tag.include? k
				puts "controller: " + v[0] + ", action: " + v[1]
				url_inside = true
			end
		end
		if not url_inside
			puts tag
		end
	end

end

require "yard"
require "pry"

NOT_VALID = "not_valid"

def parse_render_statement(stmt)
  puts "stmt: " + stmt
  ast = YARD::Parser::Ruby::RubyParser.parse(stmt).root
  if ast.type.to_s == "list" and ast.source.start_with?"render"
    ast = ast[0]
  else
    return NOT_VALID
  end

  hash = {}

#  render(partial: "view", layout: "layout_view")
  if ast.type.to_s == "fcall"
    if ast[0].type.to_s == "ident" and ast[0].source.to_s == "render"
      ast = ast[1]
    else
      return NOT_VALID
    end

    if ast.type.to_s == "arg_paren"
      ast = ast[0]
    else 
      return NOT_VALID
    end

    if ast.type.to_s == "list" and ["symbol_literal", "string_literal"].include?(ast[0].type.to_s)
      hash["template"] = ast[0].source.to_s
      ast = ast[1]
    elsif ast.type.to_s == "list"
      ast = ast[0]
    else
      return NOT_VALID
    end
    
    if ast == true or ast == false
    elsif ["list", "hash"].include?(ast.type.to_s)
      ast.children.each do |child|
        if child.type.to_s == "assoc"
          hash.merge! parse_assoc(child)
        elsif ["symbol_literal", "string_literal"].include? child.type.to_s
          hash["template"] == child.source.to_s
        end
      end
    else
      return NOT_VALID
    end
#  render partial: "view", layout: "layout_view"
  elsif ast.type.to_s == "command"
    if ast[0].type.to_s == "ident" and ast[0].source.to_s == "render"
      ast = ast[1]
    else
      return NOT_VALID
    end
  
    if ast.type.to_s == "list" and ["symbol_literal", "string_literal"].include?(ast[0].type.to_s)
      hash["template"] = ast[0].source.to_s
      ast = ast[1]
    elsif ast.type.to_s == "list"
      ast = ast[0]
    else
      return NOT_VALID
    end

    if ast == true or ast == false
    elsif ["list", "hash"].include?(ast.type.to_s)
      ast.children.each do |child|
        if child.type.to_s == "assoc"
          hash.merge! parse_assoc(child)
        end
      end
    else
      return NOT_VALID
    end
  end

  return hash

end

def parse_assoc(ast)
  hash = {}

  puts ast.source

  puts ast[0].type
  puts ast[0].source
  puts ast[1].source
  label = ast[0].source.to_s if ["label", "symbol_literal", "string_literal"].include? ast[0].type.to_s
  value = ast[1].source.to_s

  hash[label] = value

  return hash
end


def get_view_name_from_hash(options_hash, controller_name, action_name)
  res = ""
  if options_hash.has_key?":partial"
    res = options_hash[":partial"]
  elsif options_hash.has_key?"partial"
    res = options_hash["partial"]
  elsif options_hash.has_key?"partial:"
    res = options_hash["partial:"]
  elsif options_hash.has_key?":template"
    res = options_hash[":template"]
  elsif options_hash.has_key?"template"
    res = options_hash["template"]
  elsif options_hash.has_key?"template:"
    res = options_hash["template:"]
  elsif options_hash.has_key?":action"
    res = options_hash[":action"]
  elsif options_hash.has_key?"action"
    res = options_hash["action"]
  elsif options_hash.has_key?"action:"
    res = options_hash["action:"]
  elsif options_hash.has_key?"xml:"
    res = options_hash["xml:"]
  elsif options_hash.has_key?":xml"
    res = options_hash[":xml"]
  elsif options_hash.has_key?"xml"
    res = options_hash["xml"]
  elsif options_hash.has_key?"js"
    res = options_hash["js"]
  elsif options_hash.has_key?":js"
    res = options_hash[":js"]
  elsif options_hash.has_key?"js:"
    res = options_hash["js:"]
  elsif options_hash.has_key?"file:"
    res = options_hash["file"]
  elsif options_hash.has_key?":file"
    res = options_hash[":file"]
  elsif options_hash.has_key?"file"
    res = options_hash["file"]
  end
  res.gsub! /[:"']/, ""
  while res.start_with? "/"
    res = res[1..-1]
  end

  r = res.rindex("/")
  if res == ""
#    res = controller_name + "_" + action_name
    res = "not_valid"
  elsif r == nil
    res = controller_name + "_" + res
  else
    res = res[0..r-1] + "_" + res[r+1..-1]
  end
  
  return res 
end

def get_view_name_from_render_statement(stmt, controller_name, action_name)
  options_hash = parse_render_statement(stmt)
  res = get_view_name_from_hash(options_hash, controller_name, action_name)
  return res
end

def get_layout_name_from_hash(options_hash)
  if options_hash.has_key?"layout"
    res = options_hash["layout"]
  elsif options_hash.has_key?":layout"
    res = options_hash[":layout"]
  elsif options_hash.has_key?"layout:"
    res = options_hash["layout:"]
  end
  if res == nil
    res = "not_valid"
  else
    res.gsub! /[:"']/, ""
    while res.start_with? "/"
      res = res[1..-1]
    end
    r = res.rindex("/")
    if r == nil
    else
      res = res[0..r-1] + "_" + res[r+1..-1]
    end
  end
  return res
end

def get_statement_array(keyword, ast)
  res_arr = []
  ast_arr = [ast]
  while ast_arr.length > 0
    cur_ast = ast_arr.pop
    if cur_ast.source.start_with? keyword and ["command", "fcall", "yield", "yield0"].include?(cur_ast.type.to_s)
      res = cur_ast.source.to_s
      res_arr.push res
    else
      cur_ast.children.each do |child|
        ast_arr.push child
      end
    end
  end
  return res_arr
end

def parse_content_for_stmt(stmt)
  ast = YARD::Parser::Ruby::RubyParser.parse(stmt).root
  if ast.type.to_s == "list"
    ast = ast[0]
  end
  
  if ast[2] != nil and ast[2].type.to_s == "do_block"
    value = ast[2][1].source.to_s
    key = ast[1].source.to_s
  else
    value = ast[1][1].source
    key = ast[1][0].source.to_s
  end
  
  #key: the name of content_for
  #value: the content of content_for
  #stmt: the whole statement
  return {key => [value, [stmt]]}
end

def get_content_hash(content_for_arr)
  hash = {}
  content_for_arr.each do |stmt|
    _hash = parse_content_for_stmt(stmt)
    _hash.each do |k, v|
      if hash.has_key? k
        hash[k][0] = hash[k][0] + v[0]
        hash[k][1].push v[1]
      else
        hash[k] = v
      end
    end
  end
  return hash
end

def parse_yield_stmt(stmt)
  ast = YARD::Parser::Ruby::RubyParser.parse(stmt).root
  if ast.type.to_s == "list"
    ast = ast[0]
  end
  if ast.type.to_s == "yield0"
  elsif ast.type.to_s == "yield"
    ast = ast[0]
    if ["paran", "arg_paran"].include?(ast.type.to_s)
      ast = ast[0]
    end
    return {ast.source => stmt}
  end
  return {}
end

def get_yield_hash(yield_arr)
  hash = {}
  yield_arr.each do |stmt|
    hash.merge! parse_yield_stmt(stmt)
  end
  return hash
end

def merge_layout_content(layout, content)
  puts layout
  layout_ast = YARD::Parser::Ruby::RubyParser.parse(layout).root
  puts "content: "
  puts content
  content_ast = YARD::Parser::Ruby::RubyParser.parse(content).root

  content_for_arr = get_statement_array("content_for", content_ast)
  content_hash = get_content_hash(content_for_arr)

  yield_arr = get_statement_array("yield", layout_ast)
  yield_hash = get_yield_hash(yield_arr)


  puts "content_hash:"
  puts content_hash
  puts "yield_hash:"
  puts yield_hash

  yield_hash.each do |key, value|
    if content_hash.has_key? key
      layout.gsub!(value){content_hash[key][0]}
      content_hash[key][1].each do |stmt|
        content.gsub!(stmt){""}
      end
    end
  end

  layout.gsub!(/yield[ \t]*\n/){content}

  return layout
end

=begin
content = "render_form"
hash = parse_render_statement(content)
binding.pry

content = File.open(ARGV[0], "r").read
content_ast = YARD::Parser::Ruby::RubyParser.parse(content).root

content_for_arr = get_statement_array("content_for", content_ast)
content_hash = get_content_hash(content_for_arr)
binding.pry

stmt = "render(locals: { checkout_account: CheckoutAccountForm.new({ phone_number: @current_user.phone_number }),
                   form_action: person_checkout_account_path(@current_user) })"
stmt = "render :partial => \"listings/profile_listings\", :locals => {person: @person, limit: per_page, listings: listings}"
stmt = "render \"edit_welcome_email\", locals: {
             status_check_url: check_email_status_admin_community_path,
             resend_url: Maybe(user_defined_address).map { |address| resend_verification_email_admin_community_path(address_id: address[:id]) }.or_else(nil),
             support_email: APP_CONFIG.support_email,
             sender_address: sender_address,
             user_defined_address: user_defined_address,
             post_sender_address_url: create_sender_address_admin_community_path,
             can_set_sender_address: can_set_sender_address(@current_plan),
             knowledge_base_url: APP_CONFIG.knowledge_base_url,
           }"
stmt = "render(:edit_welcome_email, locals: {
             status_check_url: check_email_status_admin_community_path,
             resend_url: Maybe(user_defined_address).map { |address| resend_verification_email_admin_community_path(address_id: address[:id]) }.or_else(nil),
             support_email: APP_CONFIG.support_email,
             sender_address: sender_address,
             user_defined_address: user_defined_address,
             post_sender_address_url: create_sender_address_admin_community_path,
             can_set_sender_address: can_set_sender_address(@current_plan),
             knowledge_base_url: APP_CONFIG.knowledge_base_url,
           })"
hash = parse_render_statement(stmt)
binding.pry
=end

def get_render_array(ast)
  res_arr = Array.new
  ast_arr = Array.new
  ast_arr.push @ast
  while ast_arr.length > 0
    cur_ast = ast_arr.pop
    if cur_ast.source.start_with?"render" and (cur_ast.type.to_s == "fcall" or cur_ast.type.to_s == "command" or 
                                               cur_ast.type.to_s == "list" or cur_ast.type.to_s == "if_mod" or cur_ast.type.to_s == "unless_mod")
      res_arr.push cur_ast.source
    else
      cur_ast.children.each do |child|
        ast_arr.push child
      end
    end
  end
  return res_arr
end



def get_render_statement_array(ast=nil)
  keyword = "render"
  ast = @ast if ast == nil
  res_arr = Array.new
  ast_arr = Array.new
  ast_arr.push ast
  while ast_arr.length > 0
    cur_ast = ast_arr.pop
    if cur_ast.source.start_with? keyword
      if cur_ast.parent.parent != nil and cur_ast.parent.parent.source.start_with?"escape_javascript("
        if cur_ast.parent.parent.parent.type.to_s == "ifop"
          res = cur_ast.parent.parent.parent.source.to_s
        else
          res = cur_ast.parent.parent.source.to_s
        end
      elsif cur_ast.parent.type.to_s == "arg_paren" and cur_ast.parent.parent.source.to_s.start_with?("return(", "escape_javascript(")
        res = cur_ast.parent.parent.source.to_s
      elsif cur_ast.parent.source.to_s.start_with?("return", "escape_javascript") and ["return", "command"].include?(cur_ast.parent.type.to_s)
        res = cur_ast.parent.source.to_s
      else
        res =  cur_ast.source.to_s
      end

      if res.end_with?"\ne" or res.end_with?"\te" or res.end_with?" e"
        res = res[0..-2]
      end
      res_arr.push [res, cur_ast.source.to_s]
    else
      cur_ast.children.each do |child|
        ast_arr.push child
      end
    end
  end

  return res_arr
end

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
  label = ast[0].source.to_s if ["label", "symbol_literal"].include? ast[0].type.to_s
  value = ast[1].source.to_s

  hash[label] = value

  return hash
end


def get_view_name_from_hash(options_hash, controller_name)
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
  end
  res.gsub! /[:"']/, ""
  while res.start_with? "/"
    res = res[1..-1]
  end

  r = res.rindex("/")
  if r == nil
    res = controller_name + "_" + res
  else
    res = res[0..r-1] + "_" + res[r+1..-1]
  end
  
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
=begin
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

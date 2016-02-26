require 'yard'

ast = YARD::Parser::Ruby::RubyParser.parse(
  "render :partial => 'layouts/actions' if page_actions.nil?"
).root

require 'pry'
binding.pry

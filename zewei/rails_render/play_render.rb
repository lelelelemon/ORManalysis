require_relative "config/environment.rb"

require "action_controller/test_case"
require "pry"

controller = UsersController.new

#controller.render(action: :index, layout: 'basic')

context = controller.lookup_context

renderer = ActionView::Renderer.new(context)

#template_renderer = ActionView::TemplateRenderer.new(context)

#template_renderer.send(:instance_variable_set, :@details, {})
render_options = controller.send(:_normalize_render, {action: :index, layout: 'basic', local: {}})
renderer.render(context, render_options)
#render_options = controller.send(:_normalize_render, {action: :index})



#binding.pry
puts "Template Path: "
#p template_renderer.send(:determine_template, render_options)
puts
puts "Layout path: "
#p template_renderer.send(:find_layout, render_options[:layout], render_options[:local])

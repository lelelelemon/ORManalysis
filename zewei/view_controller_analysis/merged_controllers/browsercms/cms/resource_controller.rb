#This is meant to be extended by other controller
#Provides basic Restful CRUD
module Cms
class ResourceController < Cms::BaseController

  def index
    instance_variable_set("@#{variable_name.pluralize}", resource.order(order_by_column))
  end

  def new
    instance_variable_set("@#{variable_name}", build_object)
  end

  def create
    @object = build_object(resource_params)
    if @object.save
      flash[:notice] = "#{resource_name.singularize.titleize} '#{object_name}' was created"
      redirect_to after_create_url
    else
      instance_variable_set("@#{variable_name}", @object)
      if (params[:on_fail_action])
        render :action => params[:on_fail_action]
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 javascript_include_tag "cms/application" 
 javascript_include_tag cms_content_editor 
  page_title 
 stylesheet_link_tag 'cms/application' 
 csrf_meta_tags 
 yield :html_head 
 
  link_to current_user.full_name, cms.edit_user_path(current_user) unless current_user.guest? 
 link_to "Settings", "#" unless current_user.guest? 
 link_to "Help", 'https://github.com/browsermedia/browsercms/wiki', target: '_blank' 
 link_to "Logout", cms.logout_path unless current_user.guest? 
 link_to image_tag('cms/logo.png', class: 'main-logo'), "/" 
 if current_user.able_to?(:edit_content) 
 link_to "Dashboard", cms.dashboard_path 
 link_to "Pages", cms.sitemap_path 
  id 
 if library 
 nav_link_to "Text", cms.content_library_path 
 divider_tag 
 end 
 modules = Cms::ContentType.available_by_module
     modules.keys.sort.each_with_index do |module_name, i| 
 divider_tag(i) 
 modules[module_name].each do |type| 
 nav_link_to h(type.display_name), engine_aware_path(type) 
 end 
 end 
 
 end 
 if current_user.able_to? :administrate 
 nav_link_to "Users", cms.users_path 
 nav_link_to "Groups", cms.groups_path 
 divider_tag 
 nav_link_to "Partials", cms.page_partials_path 
 nav_link_to "Page Templates", cms.page_templates_path 
 divider_tag 
 nav_link_to "Redirects", cms.redirects_path 
 nav_link_to "Routes", cms.page_routes_path 
 nav_link_to "Page Cache", cms.cache_path 
 nav_link_to "Email Messages", cms.email_messages_path 
 Rails.application.config.cms.tools_menu.each do |menu_item| 
 nav_link_to(menu_item[:name], self.send(menu_item[:engine]).send(menu_item[:route_name])) 
 end 
 end 
 if current_user.able_to?(:edit_content) 
 menu_button "New", new_button_path, id: 'new-content-button', class: 'btn btn-primary', tabindex: '-1' 
 
   # Allows Sitemap menu to have 'New Page' while New menu has no prefix.
    unless defined?(prefix)
        prefix = ""
    end

 nav_link_to "#{prefix}Page", cms.new_section_page_path(target_section), class: 'add-page-button' 
 nav_link_to "#{prefix}Link", cms.new_section_link_path(target_section), class: 'add-section-button' 
 nav_link_to "#{prefix}Section", cms.new_section_path(:section_id => target_section.id), class: 'add-link-button' 
 divider_tag 
 
 modules = Cms::ContentType.available_by_module
           modules.keys.sort.each_with_index do |module_name, i| 
 divider_tag(i) 
 modules[module_name].each do |type| 
 nav_link_to h(type.display_name), new_engine_aware_path(type), id: "create_new_#{type.param_key}" 
 end 
 end 
 end 
 
 
   flash.each do |name, msg|

 content_tag :div, class: 'flash-message' do 
 msg 
 end 
 end 
 
 if content_for?(:before_main_content) 
 yield :before_main_content  
 end 
 simple_form_for(resource, :as => resource_name, :url => password_path(resource_name), :html => { :method => :post }) do |f| 
 f.error_notification 
 f.input :email, :required => true, :autofocus => true 
 f.button :submit, "Send me reset password instructions" 
 end 
  if controller_name != 'sessions' 
 link_to "Sign in", new_session_path(resource_name) 
 end 
 if devise_mapping.registerable? && controller_name != 'registrations' 
 link_to "Sign up", new_registration_path(resource_name) 
 end 
 if devise_mapping.recoverable? && controller_name != 'passwords' && controller_name != 'registrations' 
 link_to "Forgot your password?", new_password_path(resource_name) 
 end 
 if devise_mapping.confirmable? && controller_name != 'confirmations' 
 link_to "Didn't receive confirmation instructions?", new_confirmation_path(resource_name) 
 end 
 if devise_mapping.lockable? && resource_class.unlock_strategy_enabled?(:email) && controller_name != 'unlocks' 
 link_to "Didn't receive unlock instructions?", new_unlock_path(resource_name) 
 end 
 if devise_mapping.omniauthable? 
 resource_class.omniauth_providers.each do |provider| 
 link_to "Sign in with #{provider.to_s.titleize}", omniauth_authorize_path(resource_name, provider) 
 end 
 end 
 
  Time.now.year 
 link_to "BrowserMedia", "http://www.browsermedia.com" 
 link_to "BrowserCMS", "http://www.browsercms.org" 
 Cms.version 
 Rails.version 
 Rails.env 
 

end

      end
    end
  end

  def show
    instance_variable_set("@#{variable_name}", resource.find(params[:id]))
  end

  def edit
    instance_variable_set("@#{variable_name}", resource.find(params[:id]))
  end

  def update
    @object = resource.find(params[:id])
    if @object.update(resource_params())
      flash[:notice] = "#{resource_name.singularize.titleize} '#{object_name}' was updated"
      redirect_to after_update_url
    else
      instance_variable_set("@#{variable_name}", @object)
      if (params[:on_fail_action])
        render :action => params[:on_fail_action]
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 javascript_include_tag "cms/application" 
 javascript_include_tag cms_content_editor 
  page_title 
 stylesheet_link_tag 'cms/application' 
 csrf_meta_tags 
 yield :html_head 
 
  link_to current_user.full_name, cms.edit_user_path(current_user) unless current_user.guest? 
 link_to "Settings", "#" unless current_user.guest? 
 link_to "Help", 'https://github.com/browsermedia/browsercms/wiki', target: '_blank' 
 link_to "Logout", cms.logout_path unless current_user.guest? 
 link_to image_tag('cms/logo.png', class: 'main-logo'), "/" 
 if current_user.able_to?(:edit_content) 
 link_to "Dashboard", cms.dashboard_path 
 link_to "Pages", cms.sitemap_path 
  id 
 if library 
 nav_link_to "Text", cms.content_library_path 
 divider_tag 
 end 
 modules = Cms::ContentType.available_by_module
     modules.keys.sort.each_with_index do |module_name, i| 
 divider_tag(i) 
 modules[module_name].each do |type| 
 nav_link_to h(type.display_name), engine_aware_path(type) 
 end 
 end 
 
 end 
 if current_user.able_to? :administrate 
 nav_link_to "Users", cms.users_path 
 nav_link_to "Groups", cms.groups_path 
 divider_tag 
 nav_link_to "Partials", cms.page_partials_path 
 nav_link_to "Page Templates", cms.page_templates_path 
 divider_tag 
 nav_link_to "Redirects", cms.redirects_path 
 nav_link_to "Routes", cms.page_routes_path 
 nav_link_to "Page Cache", cms.cache_path 
 nav_link_to "Email Messages", cms.email_messages_path 
 Rails.application.config.cms.tools_menu.each do |menu_item| 
 nav_link_to(menu_item[:name], self.send(menu_item[:engine]).send(menu_item[:route_name])) 
 end 
 end 
 if current_user.able_to?(:edit_content) 
 menu_button "New", new_button_path, id: 'new-content-button', class: 'btn btn-primary', tabindex: '-1' 
 
   # Allows Sitemap menu to have 'New Page' while New menu has no prefix.
    unless defined?(prefix)
        prefix = ""
    end

 nav_link_to "#{prefix}Page", cms.new_section_page_path(target_section), class: 'add-page-button' 
 nav_link_to "#{prefix}Link", cms.new_section_link_path(target_section), class: 'add-section-button' 
 nav_link_to "#{prefix}Section", cms.new_section_path(:section_id => target_section.id), class: 'add-link-button' 
 divider_tag 
 
 modules = Cms::ContentType.available_by_module
           modules.keys.sort.each_with_index do |module_name, i| 
 divider_tag(i) 
 modules[module_name].each do |type| 
 nav_link_to h(type.display_name), new_engine_aware_path(type), id: "create_new_#{type.param_key}" 
 end 
 end 
 end 
 
 
   flash.each do |name, msg|

 content_tag :div, class: 'flash-message' do 
 msg 
 end 
 end 
 
 if content_for?(:before_main_content) 
 yield :before_main_content  
 end 
 simple_form_for(resource, :as => resource_name, :url => password_path(resource_name), :html => { :method => :put }) do |f| 
 f.error_notification 
 f.input :reset_password_token, :as => :hidden 
 f.full_error :reset_password_token 
 f.input :password, :label => "New password", :required => true, :autofocus => true 
 f.input :password_confirmation, :label => "Confirm your new password", :required => true 
 f.button :submit, "Change my password" 
 end 
  if controller_name != 'sessions' 
 link_to "Sign in", new_session_path(resource_name) 
 end 
 if devise_mapping.registerable? && controller_name != 'registrations' 
 link_to "Sign up", new_registration_path(resource_name) 
 end 
 if devise_mapping.recoverable? && controller_name != 'passwords' && controller_name != 'registrations' 
 link_to "Forgot your password?", new_password_path(resource_name) 
 end 
 if devise_mapping.confirmable? && controller_name != 'confirmations' 
 link_to "Didn't receive confirmation instructions?", new_confirmation_path(resource_name) 
 end 
 if devise_mapping.lockable? && resource_class.unlock_strategy_enabled?(:email) && controller_name != 'unlocks' 
 link_to "Didn't receive unlock instructions?", new_unlock_path(resource_name) 
 end 
 if devise_mapping.omniauthable? 
 resource_class.omniauth_providers.each do |provider| 
 link_to "Sign in with #{provider.to_s.titleize}", omniauth_authorize_path(resource_name, provider) 
 end 
 end 
 
  Time.now.year 
 link_to "BrowserMedia", "http://www.browsermedia.com" 
 link_to "BrowserCMS", "http://www.browsercms.org" 
 Cms.version 
 Rails.version 
 Rails.env 
 

end

      end
    end
  end

  def destroy
    @object = resource.find(params[:id])
    if @object.destroy
      flash[:notice] = "#{resource_name.singularize.titleize} '#{object_name}' was deleted"
    end
    redirect_to index_url
  end

  protected

  # Returns the permitted parameters for the current resource, based on:
  # 1. The name of the resource (i.e. :page)
  # 2. The permitted parameters on the resource (i.e. Page.permitted_params)
  #
  # Resources can override permitted_params to add/remove fields as needed.
  def resource_params
    params.require("#{variable_name}").permit(resource.permitted_params)
  end


  def resource_name
    controller_name
  end

  def variable_name
    resource_name.singularize
  end

  def resource
    begin
      "Cms::#{resource_name.classify}".constantize
    rescue NameError
      resource_name.classify.constantize
    end
  end

  def build_object(params={})
    resource.new(params)
  end

  def object_name
    return nil unless @object
    @object.respond_to?(:name) ? @object.name : @object.to_s
  end

  def index_url
    engine_aware_path(resource)
  end

  def after_create_url
    show_url
  end

  def after_update_url
    show_url
  end

  def show_url
    @object
  end

  def order_by_column
    "name"
  end

  def new_template;
    'cms/blocks/new'
  end
  def edit_template;
    'cms/blocks/edit'
  end

end
end
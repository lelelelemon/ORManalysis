module Cms
class PageRouteOptionsController < Cms::BaseController

  before_filter :load_page_route
  before_filter :load_model, :only => [:edit, :update, :destroy]
  
  def new
    @model = resource.new
  end
  
  def create
    @model = resource.new(params[object_name])
    if @model.save
      flash[:notice] = "#{object_name.titleize} added"
      redirect_to cms_page_route_url(@page_route)
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
  
  def update
    if @model.update_attributes(params[object_name])
      flash[:notice] = "#{object_name.titleize} updated"
      redirect_to cms_page_route_url(@page_route)
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
  
  def destroy
    @model.destroy
    flash[:notice] = "#{object_name.titleize} deleted"
    redirect_to cms_page_route_url(@page_route)
  end
  
  protected
    def load_page_route
      @page_route
    end
  
    def load_model
      @model = resource.find(params[:id])      
    end
  
    def resource
      @page_route.send(resource_name.pluralize)
    end
  
    def resource_name
      self.class.name.match(/Cms::PageRoute(\w+)Controller/)[1].downcase.singularize
    end
    
    def object_name
      "page_route_#{resource_name}"
    end
    
end
end
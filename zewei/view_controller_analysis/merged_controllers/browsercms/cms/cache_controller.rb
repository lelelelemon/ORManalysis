module Cms
  class CacheController < Cms::BaseController

    include Cms::AdminTab
    check_permissions :administrate

    def show

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
 use_page_title "Page Cache" 
 render layout: 'page_title' do 
 link_to "Clear", cache_path, class: 'btn btn-primary right http_delete', :rel=>'clear-cache' 
 end 
 render layout: 'main_content' do 
 end 
  Time.now.year 
 link_to "BrowserMedia", "http://www.browsermedia.com" 
 link_to "BrowserCMS", "http://www.browsercms.org" 
 Cms.version 
 Rails.version 
 Rails.env 
 

end

    end

    def destroy
      Cms::Cache.flush
      flash[:notice] = "Page Cache Flushed"
      redirect_to :action => "show"
    end

    private
    def set_menu_section
      @menu_section = 'caching'
    end

  end
end
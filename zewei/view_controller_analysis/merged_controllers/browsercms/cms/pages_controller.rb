module Cms
  class PagesController < Cms::BaseController

    helper Cms::RenderingHelper

    before_filter :load_section, :only => [:new, :create]
    before_filter :load_page, :only => [:versions, :version, :revert_to, :destroy]
    before_filter :load_draft_page, :only => [:edit, :update]
    before_filter :hide_toolbar, :only => [:new, :create]
    before_action :strip_visibility_params, :only => [:create, :update]

    include Cms::PublishWorkflow

    def resource
      @page
    end

    def resource_param
      :page
    end

    def new
      @page = Page.new(:section => @section, :cacheable => true)
      if @section.child_nodes.count < 1
        @page.name = "Overview"
        @page.path = @section.path
      end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 javascript_include_tag "cms/application" 
 javascript_include_tag cms_content_editor 
  page_title 
 stylesheet_link_tag 'cms/application' 
 csrf_meta_tags 
 @page.section.name.to_json.html_safe 
 @page.section.path.to_json.html_safe 
 
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
  
 use_page_title "Add A New Page" 
  simple_form_for(@page) do |f| 
 page_title_with_buttons f 
 render layout: 'main_with_sidebar' do 
 hidden_field_tag :section_id, @page.section_id 
 render :partial => 'main_form', :locals => {:f => f} 
 content_for :sidebar do 
 draft_icon_tag(@block, force: true) 
 if current_user.able_to?(:publish_content) 
 f.input :visibility, label: false, collection: @page.visibilities, prompt: false, input_html: {class: 'input-block-level'} 
 end 
 f.input :cacheable, label: "Allow Caching?", hint: "Uncheck to allow for personalized content." 
 end 
 end 
 bottom_buttons f 
 end 
 
  Time.now.year 
 link_to "BrowserMedia", "http://www.browsermedia.com" 
 link_to "BrowserCMS", "http://www.browsercms.org" 
 Cms.version 
 Rails.version 
 Rails.env 
 

end

    end

    def show
      redirect_to Page.find(params[:id]).path
    end

    def create
      @page = Page.new(page_params)
      @page.section = @section
      if @page.save
        flash[:notice] = "Page was '#{@page.name}' created."
        redirect_to @page
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 javascript_include_tag "cms/application" 
 javascript_include_tag cms_content_editor 
  page_title 
 stylesheet_link_tag 'cms/application' 
 csrf_meta_tags 
 @page.section.name.to_json.html_safe 
 @page.section.path.to_json.html_safe 
 
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
  
 use_page_title "Add A New Page" 
  simple_form_for(@page) do |f| 
 page_title_with_buttons f 
 render layout: 'main_with_sidebar' do 
 hidden_field_tag :section_id, @page.section_id 
 render :partial => 'main_form', :locals => {:f => f} 
 content_for :sidebar do 
 draft_icon_tag(@block, force: true) 
 if current_user.able_to?(:publish_content) 
 f.input :visibility, label: false, collection: @page.visibilities, prompt: false, input_html: {class: 'input-block-level'} 
 end 
 f.input :cacheable, label: "Allow Caching?", hint: "Uncheck to allow for personalized content." 
 end 
 end 
 bottom_buttons f 
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
      if @page.update(page_params)
        flash[:notice] = "Page was '#{@page.name}' updated."
        redirect_to @page
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
 use_page_title "Configure Page" 
  simple_form_for(@page) do |f| 
 page_title_with_buttons f 
 render layout: 'main_with_sidebar' do 
 hidden_field_tag :section_id, @page.section_id 
 render :partial => 'main_form', :locals => {:f => f} 
 content_for :sidebar do 
 draft_icon_tag(@block, force: true) 
 if current_user.able_to?(:publish_content) 
 f.input :visibility, label: false, collection: @page.visibilities, prompt: false, input_html: {class: 'input-block-level'} 
 end 
 f.input :cacheable, label: "Allow Caching?", hint: "Uncheck to allow for personalized content." 
 end 
 end 
 bottom_buttons f 
 end 
 
  Time.now.year 
 link_to "BrowserMedia", "http://www.browsermedia.com" 
 link_to "BrowserCMS", "http://www.browsercms.org" 
 Cms.version 
 Rails.version 
 Rails.env 
 

end

      end
    rescue ActiveRecord::StaleObjectError => e
      @other_version = @page.class.find(@page.id)
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
 use_page_title "Configure Page" 
  simple_form_for(@page) do |f| 
 page_title_with_buttons f 
 render layout: 'main_with_sidebar' do 
 hidden_field_tag :section_id, @page.section_id 
 render :partial => 'main_form', :locals => {:f => f} 
 content_for :sidebar do 
 draft_icon_tag(@block, force: true) 
 if current_user.able_to?(:publish_content) 
 f.input :visibility, label: false, collection: @page.visibilities, prompt: false, input_html: {class: 'input-block-level'} 
 end 
 f.input :cacheable, label: "Allow Caching?", hint: "Uncheck to allow for personalized content." 
 end 
 end 
 bottom_buttons f 
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
      respond_to do |format|
        if @page.destroy
          message = "Page '#{@page.name}' was deleted."
          format.html { flash[:notice] = message; redirect_to(sitemap_url) }
          format.json { render :json => {:success => true, :message => message} }
        else
          message = "Page '#{@page.name}' could not be deleted"
          format.html { flash[:error] = message; redirect_to(sitemap_url) }
          format.json { render :json => {:success => false, :message => message} }
        end
      end
    end

    #status actions
    {:publish => "published", :hide => "hidden", :archive => "archived"}.each do |status, verb|
      define_method status do
        if params[:page_ids]
          @pages = params[:page_ids].map { |id| Page.find(id) }
          raise Cms::Errors::AccessDenied unless @pages.all? { |page| current_user.able_to_edit?(page) }
          @pages.each { |page| page.send(status) }
          flash[:notice] = "#{params[:page_ids].size} pages #{verb}"
          redirect_to dashboard_url
        else
          load_page
          if @page.send(status)
            flash[:notice] = "Page '#{@page.name}' was #{verb}"
          end
          redirect_to @page.path
        end
      end
    end

    def version
      @page = @page.as_of_version(params[:version])
      @show_toolbar = true
      @show_page_toolbar = true
      @_connectors = @page.current_connectors
      @_connectables = @page.contents
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :html_head do 
 Cms.version 
 javascript_include_tag 'jquery' 
 if @show_toolbar 
 javascript_include_tag 'cms/page_editor' 
 stylesheet_link_tag 'cms/page_content_editing' 
 csrf_meta_tags 
 end 
 javascript_include_tag 'cms/site' 
 end 
 if @show_toolbar 
 flash.keep 
 end 
 @_connectors.each_with_index do |connector, i| 
 content_for(connector.container.to_sym) do 
 render_connector_and_connectable(connector, @_connectables[i]) 
 end 
 end 

end

    end

    def revert_to
      if @page.revert_to(params[:version])
        flash[:notice] = "Page '#{@page.name}' was reverted to version #{params[:version]}"
      end

      respond_to do |format|
        format.html { redirect_to @page.path }
        format.js { render :template => 'cms/shared/show_notice' }
      end
    end

    protected


    private

    def page_params
      params.require(:page).permit(Cms::Page.permitted_params)
    end

    def strip_visibility_params
      unless current_user.able_to?(:publish_content)
        params[:page].delete :hidden
        params[:page].delete :archived
        params[:page].delete :visibility
      end
    end

    def load_page
      @page = Page.find(params[:id])
      raise Cms::Errors::AccessDenied unless current_user.able_to_edit?(@page)
    end

    def load_draft_page
      load_page
      @page = @page.as_of_draft_version
    end

    def load_section
      @section = Section.find(params[:section_id])
      raise Cms::Errors::AccessDenied unless current_user.able_to_edit?(@section)
    end

    def hide_toolbar
      @hide_page_toolbar = true
    end

    def load_templates
      @templates = PageTemplate.options
    end

  end
end
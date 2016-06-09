module Cms
  class SectionsController < Cms::BaseController

    before_filter :load_parent, :only => [:new, :create]
    before_filter :load_section, :only => [:edit, :update, :destroy, :move]

    helper_method :public_groups
    helper_method :cms_groups

    def resource
      @section
    end

    def index
      redirect_to cms.sitemap_path
    end

    def show
      redirect_to cms.sitemap_path
    end

    def new
      @section = @parent.build_section
      @section.groups = @parent.groups
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
 use_page_title "Add a New Section" 
 simple_form_for(@section, :id => 'section_form') do |f| 
 hidden_field_tag :section_id, @parent.id 
  page_title_with_buttons f 
 f.input :name, slug_source_if(f.object.new_record?) 
 f.input :path, input_html: {class: 'slug-dest', data: {prefix: parent.path}} if parent 
 f.input :hidden, label: "Hide from menus?" if parent 
 able_to?(:administrate) do 
 f.association :groups,
                        collection: public_groups,
                        as: :check_boxes,
                        label: 'Public Permissions',
                        input_html: {class: "public_group_ids"},
                        hint: 'Which "Public" groups can view pages in this section?'
      
 check_uncheck_tag 'input.public_group_ids' 
 f.association :groups,
                        collection: cms_groups,
                        as: :check_boxes,
                        label: 'CMS Permissions',
                        input_html: {class: "cms_group_ids"},
                        hint: 'Which "CMS" groups can edit pages and content in this section?'
      
 check_uncheck_tag 'input.cms_group_ids' 
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

    def create
      @section = Cms::Section.new(section_params)
      @section.parent = @parent
      @section.groups = @section.parent.groups unless current_user.able_to?(:administrate)
      if @section.save
        flash[:notice] = "Section '#{@section.name}' was created"
        redirect_to @section
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
 use_page_title "Add a New Section" 
 simple_form_for(@section, :id => 'section_form') do |f| 
 hidden_field_tag :section_id, @parent.id 
  page_title_with_buttons f 
 f.input :name, slug_source_if(f.object.new_record?) 
 f.input :path, input_html: {class: 'slug-dest', data: {prefix: parent.path}} if parent 
 f.input :hidden, label: "Hide from menus?" if parent 
 able_to?(:administrate) do 
 f.association :groups,
                        collection: public_groups,
                        as: :check_boxes,
                        label: 'Public Permissions',
                        input_html: {class: "public_group_ids"},
                        hint: 'Which "Public" groups can view pages in this section?'
      
 check_uncheck_tag 'input.public_group_ids' 
 f.association :groups,
                        collection: cms_groups,
                        as: :check_boxes,
                        label: 'CMS Permissions',
                        input_html: {class: "cms_group_ids"},
                        hint: 'Which "CMS" groups can edit pages and content in this section?'
      
 check_uncheck_tag 'input.cms_group_ids' 
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

    def edit
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
 use_page_title "Edit Section" 
 simple_form_for(@section) do |f| 
  page_title_with_buttons f 
 f.input :name, slug_source_if(f.object.new_record?) 
 f.input :path, input_html: {class: 'slug-dest', data: {prefix: parent.path}} if parent 
 f.input :hidden, label: "Hide from menus?" if parent 
 able_to?(:administrate) do 
 f.association :groups,
                        collection: public_groups,
                        as: :check_boxes,
                        label: 'Public Permissions',
                        input_html: {class: "public_group_ids"},
                        hint: 'Which "Public" groups can view pages in this section?'
      
 check_uncheck_tag 'input.public_group_ids' 
 f.association :groups,
                        collection: cms_groups,
                        as: :check_boxes,
                        label: 'CMS Permissions',
                        input_html: {class: "cms_group_ids"},
                        hint: 'Which "CMS" groups can edit pages and content in this section?'
      
 check_uncheck_tag 'input.cms_group_ids' 
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

    def update
      params[:section].delete('group_ids') if params[:section] && !current_user.able_to?(:administrate)
      @section.attributes = section_params()
      if @section.save
        flash[:notice] = "Section '#{@section.name}' was updated"
        redirect_to @section
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
 use_page_title "Edit Section" 
 simple_form_for(@section) do |f| 
  page_title_with_buttons f 
 f.input :name, slug_source_if(f.object.new_record?) 
 f.input :path, input_html: {class: 'slug-dest', data: {prefix: parent.path}} if parent 
 f.input :hidden, label: "Hide from menus?" if parent 
 able_to?(:administrate) do 
 f.association :groups,
                        collection: public_groups,
                        as: :check_boxes,
                        label: 'Public Permissions',
                        input_html: {class: "public_group_ids"},
                        hint: 'Which "Public" groups can view pages in this section?'
      
 check_uncheck_tag 'input.public_group_ids' 
 f.association :groups,
                        collection: cms_groups,
                        as: :check_boxes,
                        label: 'CMS Permissions',
                        input_html: {class: "cms_group_ids"},
                        hint: 'Which "CMS" groups can edit pages and content in this section?'
      
 check_uncheck_tag 'input.cms_group_ids' 
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

    def destroy
      respond_to do |format|
        if @section.deletable? && @section.destroy
          message = "Section '#{@section.name}' was deleted."
          format.html { flash[:notice] = message; redirect_to(sitemap_url) }
          format.json { render :json => {:success => true, :message => message} }
        else
          message = "Section '#{@section.name}' could not be deleted"
          format.html { flash[:error] = message; redirect_to(sitemap_url) }
          format.json { render :json => {:success => false, :message => message} }
        end
      end
    end

    def move
      if params[:section_id]
        @move_to = Section.find(params[:section_id])
      else
        @move_to = Section.root.first
      end
    end

    protected

    def section_params
      params.require(:section).permit(Cms::Section.permitted_params)
    end

    def load_parent
      @parent = Cms::Section.find(params[:section_id])
      raise Cms::Errors::AccessDenied unless current_user.able_to_edit?(@parent)
    end

    def load_section
      @section = Cms::Section.find(params[:id])
      raise Cms::Errors::AccessDenied unless current_user.able_to_edit?(@section)
    end

    def public_groups
      @public_groups ||= Cms::Group.public.order("#{Cms::Group.table_name}.name")
    end

    def cms_groups
      @cms_groups ||= Cms::Group.cms_access.order( "#{Cms::Group.table_name}.name")
    end

  end
end
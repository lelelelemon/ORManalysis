module Cms
  class AttachmentsController < Cms::BaseController

    allow_guests_to [:download]

    include ContentRenderingSupport
    include Cms::Attachments::Serving

    # Returns a specific version of an attachment.
    # Used to display older versions in the editor interface.
    def show
      @attachment = Attachment.unscoped.find(params[:id])
      @attachment = @attachment.as_of_version(params[:version]) if params[:version]
      send_attachment(@attachment)
    end

    # This handles serving files for attachments that don't have a user specified path. If a path is defined,
    # the ContentController#try_to_stream will handle it.
    #
    # Users can only download files if they have permission to view it.
    def download
      @attachment = Attachment.find(params[:id])
      send_attachment(@attachment)
    end

    def create
      @attachment = Attachment.new(permitted_params())
      @attachment.published = true
      if @attachment.save
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
 
   show_delete = true
   show_delete = can_delete if defined?(can_delete)

 dom_id(attachment) 
 if attachment.is_image? 
 link_to(image_tag(attachment_path_for(attachment), :size => '60x60', :data => {:purpose => 'attachment'}), attachment_path_for(attachment), target: "_blank") 
 else 
 image_tag "cms/icons/file_types/#{attachment.icon}.png" 
 end 
 attachment.attachment_name.singularize.capitalize 
 number_to_human_size(attachment.size) 
 link_to("Delete", '#',
                  data: {purpose: 'delete-attachment', id: attachment.id},
                  class: 'btn btn-mini btn-danger') if show_delete 
 
 attachment.id 
  Time.now.year 
 link_to "BrowserMedia", "http://www.browsermedia.com" 
 link_to "BrowserCMS", "http://www.browsercms.org" 
 Cms.version 
 Rails.version 
 Rails.env 
 

end

      else
        #TODO: render html error string
        render :inline => 'an error ocurred'
      end
    end

    def destroy
      @attachment = Attachment.find(params[:id])
      @attachment.destroy
      render :json => @attachment.id
    end

    private
    def permitted_params
      params.require(:attachment).permit(Attachment.permitted_params)
    end
  end
end
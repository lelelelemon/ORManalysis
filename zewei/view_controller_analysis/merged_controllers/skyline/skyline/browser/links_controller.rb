class Skyline::Browser::LinksController < Skyline::ApplicationController
  def index
    @media_dirs = Skyline::MediaDir.group_by_parent_id
    @pages = Skyline::Page.group_by_parent_id
    
    if params[:referable_type].present?
      if params[:referable_type] == "Skyline::MediaFile"
        @media_file = Skyline::MediaFile.find_by_id(params[:referable_id])
        @media_dir = @media_file.directory if @media_file
        @active_tab = "Skyline::MediaFile"
      elsif params[:referable_type] == "Skyline::Page"
        @page = Skyline::Page.find_by_id(params[:referable_id])
        @active_tab = "Skyline::Page"
      elsif Skyline::Linkable.linkables.map(&:name).include?(params[:referable_type])
        @linkable_type = Skyline::Linkable.linkables.find{|l| l.name == params[:referable_type]}
        @linkable = @linkable_type.find_by_id(params[:referable_id])
        @linkables = @linkable_type.all if @linkable
        @active_tab = "Skyline::Linkable"
      end
    end
    
    if @active_tab.nil? && params[:url].present?
      @active_tab = "Skyline::ReferableUri"
    else
      @active_tab ||= "Skyline::Page"
    end    
    
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 tabs = ["Skyline::MediaFile","Skyline::ReferableUri"] 
 tabs.unshift "Skyline::Linkable" if Skyline::Linkable.linkables.any? 
 tabs.unshift "Skyline::Page" if Skyline::Configuration.enable_pages 
 tabs.each do |tab| 
 "active" if @active_tab == tab 
 t(tab, :scope => [:browser,:tabs]) 
 end 
  page_tree(@pages,@pages[nil],
            :node_url => Proc.new{|p| skyline_article_article_version_url(p.id, p["default_variant_id"]) },
            :selected => @page, 
            :id_prefix => "browser_page") 
 @page && @page.id 
hidden_field_tag "browser[referable_title]", @page && @page.default_variant_data.andand.navigation_title || "", :id => "browser_page_referable_title" 
 @page && @page.id 
 @page && skyline_article_article_version_url(@page, @page.default_variant) || "javascript:''"  
 
  @linkable.andand.id 
 @linkable.andand.class.andand.name 
 Skyline::Linkable.linkables.each do |linkable| 
 active = linkable.name == @linkable_type.andand.name 
 linkable.name 
 link_to linkable.model_name.human(:count => 2), skyline_browser_tabs_linkable_path(linkable.name, :referable_id => params[:referable_id]), :class => (active ? "active" : nil), :remote => true 
 end 
  @linkable_type.human_attribute_name(:title) if @linkable_type 
 if @linkables.present? 
 selected_row = nil 
 @linkables.each do |linkable| 
 selected_row = "linkable_#{linkable.id}" if linkable == @linkable 
 cycle("odd","even") 
 "selected" if linkable == @linkable 
 linkable.id 
 linkable.url(:mode => :cms) || linkable.id 
 linkable.id 
 linkable.class.name 
 linkable.title 
 tick_image(linkable.published?) 
 linkable.title.blank? ? "&nbsp;" : linkable.title 
 end 
 end 
 if selected_row 
 selected_row 
 end 
 
 
  media_dir_tree(@media_dirs, @media_dirs[nil], 
              :id_prefix => "browser_dir_node",
              :node_url => Proc.new{|node| skyline_browser_tabs_media_library_media_dir_media_files_path(node) },
              :selected => @media_dir)
  @media_file.andand.file_type 
 @media_file.andand.id 
 @media_file.andand.class.andand.name 
 @media_file.andand.title 
 browser_url = @media_dir && @media_file &&  skyline_media_dir_data_path(:name => @media_file.name, :dir_id => @media_dir) 
 browser_url 
 Skyline::MediaFile.human_attribute_name("name") 
 Skyline::MediaFile.human_attribute_name("type") 
 Skyline::MediaFile.human_attribute_name("size") 
 if @media_dir 
 selected_row = nil 
 @media_dir.files.each do |file| 
 dimen = file.dimension 
 selected_row = "file_#{file.id}" if file == @media_file 
 cycle("odd","even") 
 "selected" if file == @media_file 
 file.id 
 skyline_media_dir_data_path(:name => file.name, :dir_id => @media_dir) 
 file.file_type 
 file.id 
 file.class.name 
 file.title 
 dimen.andand["width"] 
 dimen.andand["height"] 
 file.file_type 
 link_to file.name, skyline_browser_tabs_media_library_media_dir_media_file_path(@media_dir, file), :id => "filelink_#{file.id}" 
 file.file_type 
 number_to_human_size file.size 
 end 
 end 
 if selected_row 
 selected_row 
 end 
 
  if @media_file 
 if @media_file.file_type == "image" 
t(:preview, :scope => [:media, :files, :edit])
 image_tag(skyline_media_dir_data_with_size_path(
                :dir_id => @media_dir,
                :name => @media_file.name,
                :size => '100x100'), 
              :alt => "Image") 
end
 t(:metadata, :scope => [:media, :files,:edit]) 
 if @media_file.file_type ==  "image" && @media_file.dimension.present? 
t(:size, :scope => [:media, :files, :edit])
@media_file.dimension['width'] 
@media_file.dimension['height'] 
end
t(:type, :scope => [:media, :files, :edit])
@media_file.file_type 
t(:filesize, :scope => [:media, :files, :edit])
 number_to_human_size @media_file.size 
 Skyline::MediaFile.human_attribute_name("name") 
 @media_file.name 
 Skyline::MediaFile.human_attribute_name("title") 
 @media_file.title 
 Skyline::MediaFile.human_attribute_name("description")
 @media_file.description
 end 
 
 
  params[:url] if @active_tab == "Skyline::ReferableUri" 
 
 if params[:common] 
 t(:title,:scope => [:browser,:link]) 
 params[:title] 
 t(:target,:scope => [:browser,:link]) 
 cur_target = params[:target].blank? ? nil : params[:target] 
 ["_blank",nil].each do |target| 
 target 
 "selected=\"selected\"" if target == cur_target 
 t(target || "-",:scope => [:browser,:link,:targets]) 
 end 
 params[:ref_id] 
 end 
 link_to_function t(:cancel, :scope => [:buttons]), "Skyline.Dialog.current.cancel()", :class => "cancel" 
 link_to_function button_text(:ok), "Skyline.Dialog.current.select()", :class => "button small green" 
 t(:dialog_title, :scope => [:browser,:link]) 

end

  end
end

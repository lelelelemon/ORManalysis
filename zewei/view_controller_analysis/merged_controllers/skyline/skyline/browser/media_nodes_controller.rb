class Skyline::Browser::MediaNodesController < Skyline::ApplicationController
  def index
    @media_dirs = Skyline::MediaDir.group_by_parent_id
    
    if params[:referable_type].present? && params[:referable_id].present?
      case params[:referable_type]
        when "Skyline::MediaDir" then
          @media_dir = Skyline::MediaDir.find_by_id(params[:referable_id])
          @active_tab = "Skyline::MediaFile"
      end
    end
    
    @active_tab ||= "Skyline::MediaFile"
    
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 ["Skyline::MediaFile"].each do |tab| 
 "active" if @active_tab == tab 
 t(tab, :scope => [:browser,:tabs]) 
 end 
  media_dir_tree(@media_dirs, @media_dirs[nil], 
              :id_prefix => "browser_dir_node",
              :node_url => Proc.new{|node| skyline_browser_tabs_media_nodes_media_dir_media_files_path(node) },
              :selected => @media_dir)
  @media_dir.andand.id 
 @media_dir.andand.class.andand.name 
 @media_dir.andand.title 
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
 
 
 link_to_function t(:cancel, :scope => [:buttons]), "Skyline.Dialog.current.cancel()", :class => "cancel" 
 link_to_function button_text(:ok), "Skyline.Dialog.current.select()", :class => "button small green" 
 t(:dialog_title, :scope => [:browser,:file]) 

end

  end
end

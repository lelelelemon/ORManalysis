class Skyline::Browser::Tabs::MediaNodes::MediaFilesController < Skyline::ApplicationController
  def index
    @media_dir = Skyline::MediaDir.find(params[:media_dir_id])
    @media_file = @media_dir.files.find_by_id(params[:media_file_id])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 

end

  end
  
  # show
  # Renders the requested image with specified size parameters and stores the image in the cache. 
  # If the image is already in the cache then 304 Not Modified is rendered.
  #
  # ==== Parameters
  # size <String> WidthxHeight
  
  def show
    @media_file = Skyline::MediaFile.find(params[:id])
    @media_dir = @media_file.directory
  end

end
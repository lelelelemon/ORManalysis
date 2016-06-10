class Skyline::Media::FilesController < Skyline::ApplicationController
  
  before_filter :find_dir

  self.default_menu = :media_library
  
  authorize :create, :by => "media_file_create"
  authorize :edit, :update, :by => "media_file_update"
  authorize :destroy, :by => "media_file_delete"
  
  def index
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 render_messages_javascript 
 render_notifications_javascript 
  Skyline::MediaFile.human_attribute_name("name") 
 Skyline::MediaFile.human_attribute_name("type") 
 Skyline::MediaFile.human_attribute_name("size") 
 @dir.files.each do |file| 
 cycle("odd","even") 
 "selected" if file == @file 
 file.id 
 skyline_media_dir_file_path(@dir,file) 
 file.file_type 
 link_to file.name, edit_skyline_media_dir_file_path(@dir, file), :id => "filelink_#{file.id}" 
 file.file_type 
 number_to_human_size file.size 
 end 
 form_authenticity_token 
 

end

  end
  
  def edit
    @file = @dir.files.find(params[:id])    
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 render_messages_javascript 
 render_notifications_javascript 
  if current_user.allow?(:media_file_show) 
 @file.name 
 if @file.file_type == "image" 
 image_tag(skyline_media_dir_data_with_size_path(
              :dir_id => @file.parent_id,
              :name => @file.name,
              :size => '100x100'),
              :alt => @file.name) 
 end 
 if @file.file_type == "image" && @file.dimension.present? 
 t(:size, :scope => [:media, :files, :edit])
 @file.dimension['width'] 
 @file.dimension['height'] 
end
 t(:type, :scope => [:media, :files, :edit] )
 @file.file_type 
 t(:filesize, :scope => [:media, :files, :edit]) 
 number_to_human_size(@file.size) 
 link_to t(:download, :scope => [:media, :files, :edit]),
              skyline_media_dir_data_path(:name => @file.name, :dir_id => @file.parent_id),
              :target => "_blank",
              :class => "button small" 
 end 
 if current_user.allow?(:media_file_create) 
 skyline_form_for @file,
        :url => skyline_media_dir_file_path(@dir, @file),
        :remote => true,
        :method => :put,
        :html => {:method=>:put} do |f|
 t(:metadata, :scope => [:media, :files, :edit]) 
 f.label :name, Skyline::MediaFile.human_attribute_name("name")
 f.text_field :name, :class => "full" 
 f.label :title, Skyline::MediaFile.human_attribute_name("title")
 f.text_field :title, :class => "full" 
 f.label :description, Skyline::MediaFile.human_attribute_name("description")
 f.text_area :description, :cols=>20, :rows=>5
 f.label :date, Skyline::MediaFile.human_attribute_name("date")
 f.date_select :date, :use_month_numbers => true, :include_blank => true 
 f.label :raw_tags, Skyline::MediaFile.human_attribute_name("file_tags")
 f.text_area :raw_tags, :rows => nil 
 t(:available_tags, :scope => [:media, :files, :edit])
  (local_assigns.has_key?(:tags) ? local_assigns[:tags] : @tags).each do |t|
t.tag
 end 

 submit_button :save, :class => "small green"
 end 
 t(:actions, :scope => [:media, :files, :edit]) 
 link_to(
              button_text(:delete),
              skyline_media_dir_file_url(@dir,@file),
              :remote => true,
              :method => :delete,
              :confirm => t(:confirm_destroy, :scope => [:media, :files, :edit], :name => @file.name),
              :href => url_for(:action => "destroy", :id => @file.id),
              :class => "button small red")
        
 end 
 

end

  end
  
  # We've got two different kinds of updates:
  # 1. The regular "update" through a form
  # 2. A drag action to a different directory.
  # 
  def update
    @file = @dir.files.find(params[:id])
    @file.attributes = params[:media_file]
    
    # We use an instance variable because we want to use it in the render(:update) block.
    @saved = @file.save

    if @saved
      notifications.now[:success] = t(:success, :scope => [:media, :files, :update, :flashes])
    else
      messages.now[:error] = t(:failed, :scope => [:media, :files, :update, :flashes])
    end    
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 render_messages_javascript 
 render_notifications_javascript 
 if @saved 
  Skyline::MediaFile.human_attribute_name("name") 
 Skyline::MediaFile.human_attribute_name("type") 
 Skyline::MediaFile.human_attribute_name("size") 
 @dir.files.each do |file| 
 cycle("odd","even") 
 "selected" if file == @file 
 file.id 
 skyline_media_dir_file_path(@dir,file) 
 file.file_type 
 link_to file.name, edit_skyline_media_dir_file_path(@dir, file), :id => "filelink_#{file.id}" 
 file.file_type 
 number_to_human_size file.size 
 end 
 form_authenticity_token 
 
 end 
  if current_user.allow?(:media_file_show) 
 @file.name 
 if @file.file_type == "image" 
 image_tag(skyline_media_dir_data_with_size_path(
              :dir_id => @file.parent_id,
              :name => @file.name,
              :size => '100x100'),
              :alt => @file.name) 
 end 
 if @file.file_type == "image" && @file.dimension.present? 
 t(:size, :scope => [:media, :files, :edit])
 @file.dimension['width'] 
 @file.dimension['height'] 
end
 t(:type, :scope => [:media, :files, :edit] )
 @file.file_type 
 t(:filesize, :scope => [:media, :files, :edit]) 
 number_to_human_size(@file.size) 
 link_to t(:download, :scope => [:media, :files, :edit]),
              skyline_media_dir_data_path(:name => @file.name, :dir_id => @file.parent_id),
              :target => "_blank",
              :class => "button small" 
 end 
 if current_user.allow?(:media_file_create) 
 skyline_form_for @file,
        :url => skyline_media_dir_file_path(@dir, @file),
        :remote => true,
        :method => :put,
        :html => {:method=>:put} do |f|
 t(:metadata, :scope => [:media, :files, :edit]) 
 f.label :name, Skyline::MediaFile.human_attribute_name("name")
 f.text_field :name, :class => "full" 
 f.label :title, Skyline::MediaFile.human_attribute_name("title")
 f.text_field :title, :class => "full" 
 f.label :description, Skyline::MediaFile.human_attribute_name("description")
 f.text_area :description, :cols=>20, :rows=>5
 f.label :date, Skyline::MediaFile.human_attribute_name("date")
 f.date_select :date, :use_month_numbers => true, :include_blank => true 
 f.label :raw_tags, Skyline::MediaFile.human_attribute_name("file_tags")
 f.text_area :raw_tags, :rows => nil 
 t(:available_tags, :scope => [:media, :files, :edit])
  (local_assigns.has_key?(:tags) ? local_assigns[:tags] : @tags).each do |t|
t.tag
 end 

 submit_button :save, :class => "small green"
 end 
 t(:actions, :scope => [:media, :files, :edit]) 
 link_to(
              button_text(:delete),
              skyline_media_dir_file_url(@dir,@file),
              :remote => true,
              :method => :delete,
              :confirm => t(:confirm_destroy, :scope => [:media, :files, :edit], :name => @file.name),
              :href => url_for(:action => "destroy", :id => @file.id),
              :class => "button small red")
        
 end 
 

end

  end
  
  def create
    @file = @dir.files.build(:name => params[:name], :data => params[:file])

    if @file.save
      render :json => {:jsonrpc => "2.0", :result => nil, :id => "id"}
    else
      render :json => {:jsonrpc => "2.0", :error => @file.errors.full_messages.to_sentence, :id => "id"}, :status => 200
    end
    
  end  
  
  def destroy
    @file = @dir.files.find(params[:id])
    @file.destroy
    notifications.now[:success] =  t(:success, :scope => [:media, :files,:destroy,:flashes])
    
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 render_messages_javascript 
 render_notifications_javascript 
  link_to button_text(:upload), "#", :id => "toggleUploadPanel", :class => "button small right" if current_user.allow?(:media_file_create) 
 t(:files_in, :directory => @dir.name, :scope => [:media, :dirs, :show]) 
  skyline_media_dir_files_path(@dir, :authenticity_token => form_authenticity_token) 
t(:no_files, :scope => [:media, :files ,:new]) 
t(:files, :scope => [:media, :files ,:new]) 
t(:add_files, :scope => [:buttons]) 
t(:cancel, :scope => [:media, :files ,:new]) 
 submit_button :upload, :class => "small green upload", :id => "uploadbutton" 
 submit_button :ok, :class => "small green finish", :id => "finishedbutton" 
t(:file_progress, :scope => [:media, :files , :new]).html_safe 
t(:percentage_progress, :scope => [:media, :files , :new]).html_safe 
t(:cancel, :scope => [:media, :files ,:new]) 
 
  Skyline::MediaFile.human_attribute_name("name") 
 Skyline::MediaFile.human_attribute_name("type") 
 Skyline::MediaFile.human_attribute_name("size") 
 @dir.files.each do |file| 
 cycle("odd","even") 
 "selected" if file == @file 
 file.id 
 skyline_media_dir_file_path(@dir,file) 
 file.file_type 
 link_to file.name, edit_skyline_media_dir_file_path(@dir, file), :id => "filelink_#{file.id}" 
 file.file_type 
 number_to_human_size file.size 
 end 
 form_authenticity_token 
 
 @dir.id 
 @dir.id 
 
  skyline_form_for @dir, :url => skyline_media_dir_path(@dir), :method => :put, :remote => true do |f|
 f.hidden_field :parent_id 
 t :edit, :scope => [:media, :dirs, :edit] 
f.label :name, Skyline::MediaDir.human_attribute_name("name") + ":" 
 f.text_field :name, :class => "full" 
 submit_button :save, :class => "small green" 
 t :actions, :scope => [:media, :dirs, :edit] 
 if @dir.parent_id.blank? 
 link_to_function button_text(:delete_media_dir), "", :class => "button small disabled" 
 else 
 link_to(
                button_text(:delete_media_dir),
                skyline_media_dir_url(@dir),
                :remote => true,
                :method => :delete,
                :confirm => t(:message, :scope => [:media, :dirs, :destroy]),
                :href => url_for(:action => "destroy", :id => @dir.id),
                :class =>  "button small red")
          
 end 
 end 
 

end

  end

  protected
  
  def find_dir
    @dir = Skyline::MediaDir.find(params[:dir_id])
  end
  
end

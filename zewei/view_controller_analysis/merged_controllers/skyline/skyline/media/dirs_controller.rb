class Skyline::Media::DirsController < Skyline::ApplicationController
  
  layout "skyline/layouts/media"
  self.default_menu = :media_library
  
  authorize :create, :by => "media_dir_create"
  authorize :edit, :update, :by => "media_dir_update"
  authorize :destroy, :by => "media_dir_delete"
  
  def index
    @dirs = Skyline::MediaDir.group_by_parent_id
    @dir = Skyline::MediaDir.root
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 render_messages_javascript 
 render_notifications_javascript 
  if @dirs 
 media_dir_tree(@dirs,@dirs[nil],
          :selected => @dir,
          :id_prefix => "dirItem",
          :node_url => lambda{ |node| skyline_media_dir_path(node) },
          :class => "dir"
        ) 
 end 
 skyline_media_dirs_path 
 
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
  
  def show
    @dir = Skyline::MediaDir.find(params[:id])
    
    # selected_file = params[:selected_file_id].nil? || params[:selected_file_id] == "0" ? nil : Skyline::MediaFile.find(params[:selected_file_id])
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
  
  def create
    parent_id = params[:parent_id] || 0        
    
    @parent = Skyline::MediaDir.find_by_id(parent_id)
    if @parent
      @dir = @parent.subdirectories.build
    else
      @dir = Skyline::MediaDir.new
    end
    @dir.save
    
    @dirs = Skyline::MediaDir.group_by_parent_id    
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 render_messages_javascript 
 render_notifications_javascript 
  if @dirs 
 media_dir_tree(@dirs,@dirs[nil],
          :selected => @dir,
          :id_prefix => "dirItem",
          :node_url => lambda{ |node| skyline_media_dir_path(node) },
          :class => "dir"
        ) 
 end 
 skyline_media_dirs_path 
 
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
  
  def update    
    @dir = Skyline::MediaDir.find(params[:id])
    
    if params[:media_dir]
      @dir.name = params[:media_dir][:name] if !params[:media_dir][:name].blank?
      if params[:media_dir][:parent_id] == "0" || Skyline::MediaDir.find_by_id(params[:media_dir][:parent_id]).nil?
        @dir.parent_id = nil
      else
        @dir.parent_id = params[:media_dir][:parent_id]
      end
      
      @saved = @dir.save
    end
    
    @dirs = Skyline::MediaDir.group_by_parent_id
    
    if @saved
      notifications.now[:success] = t(:success, :scope => [:media, :dirs,:update,:flashes])
    else
      notifications.now[:error] = t(:failed, :scope => [:media, :dirs,:update,:flashes])
    end    
    
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 render_messages_javascript 
 render_notifications_javascript 
  if @dirs 
 media_dir_tree(@dirs,@dirs[nil],
          :selected => @dir,
          :id_prefix => "dirItem",
          :node_url => lambda{ |node| skyline_media_dir_path(node) },
          :class => "dir"
        ) 
 end 
 skyline_media_dirs_path 
 
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
  
  def destroy
    destroy_dir = Skyline::MediaDir.find(params[:id])
    
    @dir = destroy_dir.directory
    destroy_dir.destroy

    @dirs = Skyline::MediaDir.group_by_parent_id        
    notifications.now[:success] = t(:success, :scope => [:media, :dirs,:destroy,:flashes])
    
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 render_messages_javascript 
 render_notifications_javascript 
  if @dirs 
 media_dir_tree(@dirs,@dirs[nil],
          :selected => @dir,
          :id_prefix => "dirItem",
          :node_url => lambda{ |node| skyline_media_dir_path(node) },
          :class => "dir"
        ) 
 end 
 skyline_media_dirs_path 
 
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
  
end
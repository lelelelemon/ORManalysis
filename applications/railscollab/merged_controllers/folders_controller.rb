#==
# RailsCollab
# Copyright (C) 2007 - 2011 James S Urquhart
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++

class FoldersController < ApplicationController

  layout 'project_website'
  helper 'project_items'

  before_filter :process_session
  before_filter :obtain_folder, :except => [:index, :create, :new]
  after_filter  :user_track, :only => [:files]
  
  # GET /folders
  # GET /folders.xml
  def index
    @folders = @active_project.folders
    
    respond_to do |format|
      format.html { redirect_to(files_path) }
      format.xml  {
        render :xml => @folders.to_xml(:root => 'folders')
      }
    end
  end

  # GET /folders/1
  # GET /folders/1.xml
  def show
    authorize! :show, @folder
    
    respond_to do |format|
      format.html {
        redirect_to(files_folder_path)
      }
      format.xml  { 
        render :xml => @folder.to_xml
      }
    end
  end

  # GET /folders/new
  # GET /folders/new.xml
  def new
    authorize! :create_folder, @active_project
    
    @folder = @active_project.folders.build()
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @folder.to_xml(:root => 'folder') }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_tag folders_path 
  error_messages_for :folder 
 t('name') 
 text_field 'folder', 'name', :id => 'folderFormName' 
 
 t('add_folder') 

end

  end

  # GET /folders/1/edit
  def edit
    authorize! :edit, @folder
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_tag folder_path(:id => @folder.id), :method => :put 
  error_messages_for :folder 
 t('name') 
 text_field 'folder', 'name', :id => 'folderFormName' 
 
 t('edit_folder') 

end

  end

  # POST /folders
  # POST /folders.xml
  def create
    authorize! :create_folder, @active_project
    
    @folder = @active_project.folders.build(params[:folder])
    @folder.created_by = @logged_user
    
    respond_to do |format|
      if @folder.save
        format.html {
          error_status(false, :success_added_folder)
          redirect_back_or_default(@folder)
        }
        
        format.xml  { render :xml => @folder.to_xml(:root => 'folder'), :status => :created, :location => @folder }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_tag folders_path 
  error_messages_for :folder 
 t('name') 
 text_field 'folder', 'name', :id => 'folderFormName' 
 
 t('add_folder') 

end
 }
        
        format.xml  { render :xml => @folder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /folders/1
  # PUT /folders/1.xml
  def update
    authorize! :edit, @folder
    
    @folder.updated_by = @logged_user
    
    respond_to do |format|
      if @folder.update_attributes(params[:folder])
        format.html {
          error_status(false, :success_edited_folder)
          redirect_back_or_default(@folder)
        }
        
        format.xml  { head :ok }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_tag folder_path(:id => @folder.id), :method => :put 
  error_messages_for :folder 
 t('name') 
 text_field 'folder', 'name', :id => 'folderFormName' 
 
 t('edit_folder') 

end
 }
        
        format.xml  { render :xml => @folder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /folders/1
  # DELETE /folders/1.xml
  def destroy
    authorize! :delete, @folder
    
    @folder.updated_by = @logged_user
    @folder.destroy

    respond_to do |format|
      format.html {
        error_status(false, :success_deleted_folder)
        redirect_back_or_default(files_url)
      }
      
      format.xml  { head :ok }
    end
  end
  
  # /folders/1/files
  # /folders/1/files.xml
  def files
    authorize! :show, @folder
    
    # conditions
    file_conditions = {'folder_id' => @folder.id, 'project_id' => @active_project.id, 'is_visible' => true}
    file_conditions['is_private'] = false unless @logged_user.member_of_owner?
    
    sort_type = params[:orderBy]
    sort_type = 'created_on' unless ['filename'].include?(params[:orderBy])
    sort_order = 'DESC'

    @current_folder = @folder
    @order = sort_type
    
    respond_to do |format|
      format.html {
        @content_for_sidebar = 'files/index_sidebar'
        
        @page = params[:page].to_i
        @page = 1 unless @page > 0
        
        result_set, @files = ProjectFile.find_grouped(sort_type, :conditions => file_conditions, :page => @page, :per_page => Rails.configuration.files_per_page, :order => "#{sort_type} #{sort_order}")
        @pagination = []
        result_set.total_pages.times {|page| @pagination << page+1}
        
        # Important files and folders (html only)
        @important_files = @active_project.project_files.important
        @important_files = @important_files.is_public unless @logged_user.member_of_owner?
        @folders = @active_project.folders
        
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|

  @page_actions = []
  
  if can? :create_file, @active_project
    if @folder.nil?
      @page_actions << {:title => :add_file, :url => new_file_path}
    else
      @page_actions << {:title => :add_file, :url => new_file_path(:folder_id => @folder.id)}
    end
  end

  if can? :create_folder, @active_project
    @page_actions << {:title => :add_folder, :url => new_folder_path}
  end

 if @files.empty? 
 t('no_files_in_location') 
 else 
  t('order_by') 

	temp_actions = [
		{:name => t('filename'), :url => {:page => (page == 0 ? nil : page), :orderBy => 'filename'}, :cond => true, :class => (order == 'filename' ? 'selected' : nil)},
		{:name => t('post_time'), :url => {:page => (page == 0 ? nil : page), :orderBy => 'created_on'}, :cond => true, :class => (order == 'created_on' ? 'selected' : nil)}
	]

 action_list temp_actions 
 pagination_links "#{url_for {}}?", pagination unless pagination.length <= 1 
 
 end 

end

      }
      format.xml  { 
        @files = ProjectFile.where(file_conditions)
                            .offset(params[:offset])
                            .limit(params[:limit] || Rails.configuration.files_per_page)
        
        render :xml => @files.to_xml(:only => [:id,
                                               :filename,
                                               :created_by_id, 
                                               :created_on,
                                               :updated_on,
                                               :is_private,
                                               :is_important,
                                               :is_locked,
                                               :comments_count, 
                                               :comments_enabled], :root => 'files')
      }
    end
  end

private

  def obtain_folder
    if params[:folder_name]
      begin
        @folder = @active_project.folders.where(:name => params[:folder_name]).first!
      rescue ActiveRecord::RecordNotFound
        error_status(true, :invalid_folder)
        redirect_back_or_default files_path
        return false
      end
    elsif params[:id]
      begin
        @folder = @active_project.folders.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        error_status(true, :invalid_folder)
        redirect_back_or_default files_path
        return false
      end
    end

  end
end

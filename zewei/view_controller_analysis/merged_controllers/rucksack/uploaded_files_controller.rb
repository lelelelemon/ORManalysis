#==
# Copyright (C) 2008 James S Urquhart
# 
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#++

class UploadedFilesController < ApplicationController
  before_filter :grab_page, :except => [:icon]
  before_filter :load_uploaded_file, :except => [:index, :new, :create, :icon]
  
  cache_sweeper :page_sweeper, :only => [:create, :update, :destroy]
  
  # GET /uploaded_files
  # GET /uploaded_files.xml
  def index
    @uploaded_files = @page.uploaded_files.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @uploaded_files }
    end
  end

  # GET /uploaded_files/1
  # GET /uploaded_files/1.xml
  def show
    @new_file = !params[:is_new].nil?
    
    @slot_id = @uploaded_file.page_slot.id
    slots = @page.slot_ids
    @insert_element = 'page_slot_footer'
    slots.each_index do |idx|
      if slots[idx] == @slot_id
        if idx+1 != slots.length
          # Not end of page
          @insert_element = "page_slot_#{slots[idx+1]}"
        end
        
        break
      end
    end
    
    respond_to do |format|
      format.html { redirect_to @uploaded_file.data.url }
      format.js
      format.xml  { render :xml => @uploaded_file }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 hhandle = "page_slot_handle_#{page_slot.id}" 
 hhandle 
 hhandle 
 file_icon_for(object.object_name) 
 hhandle 
 object.data.url 
 h object.object_name 
 format_size(object.data_file_size) 
 if object.description? 
 h object.description 
 end 

end

  end

  # GET /uploaded_files/new
  # GET /uploaded_files/new.xml
  def new
    return error_status(true, :cannot_create_uploaded_file) unless (UploadedFile.can_be_created_by(@logged_user, @page))
    
    @uploaded_file = @page.uploaded_files.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @uploaded_file }
    end
  end

  # GET /uploaded_files/1/edit
  def edit
    return error_status(true, :cannot_edit_uploaded_file) unless (@uploaded_file.can_be_edited_by(@logged_user))

    respond_to do |format|
      format.html
      format.js
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 "page_slot_#{@uploaded_file.page_slot.id}" 
  if @uploaded_file.nil? or @uploaded_file.new_record? 
 fpath = page_uploaded_files_path(@page) 
 fmethod = :post 
 fid = 'fixedWidgetForm upload' 
 else 
 fpath = page_uploaded_file_path(@page, @uploaded_file) 
 fmethod = :put 
 fid = 'widgetForm upload' 
 end 
 form_tag( fpath, :method => fmethod, :class => fid, :multipart => true) do 
 raw(file_field 'uploaded_file', 'data', :class => 'uploadedFileFormTitle', :class => 'autofocus long') 
 raw(text_field 'uploaded_file', 'description', :id => 'uploadedFileFormDescription', :class => 'long') 
 if @uploaded_file.nil? or @uploaded_file.new_record? 
 t('upload') 
 else 
 t('update') 
 end 
 t('cancel') 
 end 
 
 "page_slot_#{@uploaded_file.page_slot.id}" 

end

  end

  # POST /uploaded_files
  # POST /uploaded_files.xml
  def create
    return error_status(true, :cannot_create_uploaded_file) unless (UploadedFile.can_be_created_by(@logged_user, @page))
    
    calculate_position
    
    # Make the darn note
    @uploaded_file = @page.uploaded_files.build(params[:uploaded_file])
    @uploaded_file.created_by = @logged_user
    saved = @uploaded_file.save
    
    # And the slot, don't forget the slot
    save_slot(@uploaded_file) if saved

    respond_to do |format|
      if @uploaded_file.save
        flash[:notice] = 'uploaded_file was successfully created.'
        format.html { redirect_to(@uploaded_file.page) }
        format.js { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 page_uploaded_file_url(@page, @uploaded_file) 

end
 }
        format.xml  { render :xml => @uploaded_file, :status => :created, :location => page_uploaded_file_path(:page_id => @page.id, :id => @uploaded_file.id) }
      else
        format.html { render :action => "new" }
        format.js { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 page_uploaded_file_url(@page, @uploaded_file) 

end
 }
        format.xml  { render :xml => @uploaded_file.errors, :status => :unprocessable_entity }
      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 page_uploaded_file_url(@page, @uploaded_file) 

end

  end

  # PUT /uploaded_files/1
  # PUT /uploaded_files/1.xml
  def update
    return error_status(true, :cannot_edit_uploaded_file) unless (@uploaded_file.can_be_edited_by(@logged_user))
    
    @uploaded_file.updated_by = @logged_user

    respond_to do |format|
      if @uploaded_file.update_attributes(params[:uploaded_file])
        flash[:notice] = 'uploaded_file was successfully updated.'
        format.html { redirect_to(@uploaded_file) }
        format.js { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 page_uploaded_file_url(@page, @uploaded_file) 

end
  }
        format.xml  { head :ok }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 "page_slot_#{@uploaded_file.page_slot.id}" 
  if @uploaded_file.nil? or @uploaded_file.new_record? 
 fpath = page_uploaded_files_path(@page) 
 fmethod = :post 
 fid = 'fixedWidgetForm upload' 
 else 
 fpath = page_uploaded_file_path(@page, @uploaded_file) 
 fmethod = :put 
 fid = 'widgetForm upload' 
 end 
 form_tag( fpath, :method => fmethod, :class => fid, :multipart => true) do 
 raw(file_field 'uploaded_file', 'data', :class => 'uploadedFileFormTitle', :class => 'autofocus long') 
 raw(text_field 'uploaded_file', 'description', :id => 'uploadedFileFormDescription', :class => 'long') 
 if @uploaded_file.nil? or @uploaded_file.new_record? 
 t('upload') 
 else 
 t('update') 
 end 
 t('cancel') 
 end 
 
 "page_slot_#{@uploaded_file.page_slot.id}" 

end
 }
        format.js { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 page_uploaded_file_url(@page, @uploaded_file) 

end
 }
        format.xml  { render :xml => @uploaded_file.errors, :status => :unprocessable_entity }
      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 page_uploaded_file_url(@page, @uploaded_file) 

end

  end

  # DELETE /uploaded_files/1
  # DELETE /uploaded_files/1.xml
  def destroy
    return error_status(true, :cannot_delete_uploaded_file) unless (@uploaded_file.can_be_deleted_by(@logged_user))
    
    @slot_id = @uploaded_file.page_slot.id
    @uploaded_file.page_slot.destroy
    @uploaded_file.updated_by = @logged_user
    @uploaded_file.destroy

    respond_to do |format|
      format.html { redirect_to(uploaded_files_url) }
      format.js {}
      format.xml  { head :ok }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 "page_slot_#{@slot_id}" 

end

  end
  
  def icon
    redirect_to path_to_image('file_icons/genericGray.png'), :status => 301
  end

protected
  
  def load_uploaded_file
    begin
      @uploaded_file = @page.uploaded_files.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      error_status(true, :cannot_find_uploaded_file)
      return false
    end
  end
end

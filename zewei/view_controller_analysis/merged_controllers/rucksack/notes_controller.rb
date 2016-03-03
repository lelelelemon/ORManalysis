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

class NotesController < ApplicationController
  before_filter :grab_page
  before_filter :load_note, :except => [:index, :new, :create]
  
  cache_sweeper :page_sweeper, :only => [:create, :update, :destroy]
  
  # GET /notes
  # GET /notes.xml
  def index
    @notes = @page.notes.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @notes }
    end
  end

  # GET /notes/1
  # GET /notes/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.js
      format.xml  { render :xml => @note }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 empty_note = !(object.title? or object.content? or object.show_date) 
 hover_handle = "page_slot_handle_#{page_slot.id}" 
 if object.title? or object.show_date 
 hover_handle 
 if object.title? 
 h object.title 
 end 
 if object.show_date 
 hover_handle 
 object.created_at.strftime(@time_now.year != object.created_at.year ? t('date_format_dmy') : t('date_format_dm')) 
 end 
 end 
 if empty_note 
 hover_handle 
 t('empty_note') 
 else 
 end 

end

  end

  # GET /notes/new
  # GET /notes/new.xml
  def new
    return error_status(true, :cannot_create_note) unless (Note.can_be_created_by(@logged_user, @page))
    
    @note = @page.notes.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @note }
    end
  end

  # GET /notes/1/edit
  def edit
    return error_status(true, :cannot_edit_note) unless (@note.can_be_edited_by(@logged_user))

    respond_to do |format|
      format.html
      format.js
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 "page_slot_#{@note.page_slot.id}" 
  if @note.nil? or @note.new_record? 
 fpath = page_notes_path(@page) 
 fmethod = :post 
 fid = 'fixedWidgetForm' 
 else 
 fpath = page_note_path(@page, @note) 
 fmethod = :put 
 fid = 'widgetForm' 
 end 
 form_tag( fpath, :method => fmethod, :class => fid) do 
 if @note.nil? or @note.new_record? 
 t('add_note') 
 end 
 raw(text_field 'note', 'title', :id => 'noteFormTitle', :class => 'autofocus long') 
 raw(text_area 'note', 'content', :id => 'noteFormContent', :rows => 8, :class => 'long') 
 raw(check_box('note', 'show_date')) 
 "Show date in title" 
 if @note.nil? or @note.new_record? 
 t('add_note') 
 else 
 t('edit_note') 
 end 
 t('cancel') 
 end 
 
 "page_slot_#{@note.page_slot.id}" 

end

  end

  # POST /notes
  # POST /notes.xml
  def create
    return error_status(true, :cannot_create_note) unless (Note.can_be_created_by(@logged_user, @page))
    
    calculate_position
    
    # Make the darn note
    @note = @page.notes.build(params[:note])
    @note.created_by = @logged_user
    saved = @note.save
    
    # And the slot, don't forget the slot
    save_slot(@note) if saved
    
    respond_to do |format|
      if saved
        error_status(false, :success_note_created)
        format.html { redirect_to(@note) }
        format.js {}
        format.xml  { render :xml => @note, :status => :created, :location => page_note_path(:page_id => @page.id, :id => @note.id) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 ec = escape_javascript("<div class=\"pageSlot\" id=\"page_slot_#{@slot.id}\" slot=\"#{@slot.id}\"></div>").html_safe 
 if @insert_before 
 @insert_element 
 ec 
 else 
 @insert_element 
 ec 
 end 
 "page_slot_#{@slot.id}" 
  page_url = @page.can_be_edited_by(@logged_user) ? "/#{page_slot.rel_object_type.pluralize.tableize}/#{page_slot.rel_object_id}" : '' 
 page_url 
 if @page.can_be_edited_by(@logged_user) 
 raw(page_handle widget_options(object), "page_slot_handle_#{page_slot.id}", '.pageWidget') 
 end 
 raw(render :partial => object.view_partial, :locals => {:object => object, :page_slot => page_slot}) 
 
 "page_slot_#{@slot.id}" 

end

  end

  # PUT /notes/1
  # PUT /notes/1.xml
  def update
    return error_status(true, :cannot_edit_note) unless (@note.can_be_edited_by(@logged_user))
    
    @note.updated_by = @logged_user

    respond_to do |format|
      if @note.update_attributes(params[:note])
        flash[:notice] = 'Note was successfully updated.'
        format.html { redirect_to(@note) }
        format.js {}
        format.xml  { head :ok }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 "page_slot_#{@note.page_slot.id}" 
  if @note.nil? or @note.new_record? 
 fpath = page_notes_path(@page) 
 fmethod = :post 
 fid = 'fixedWidgetForm' 
 else 
 fpath = page_note_path(@page, @note) 
 fmethod = :put 
 fid = 'widgetForm' 
 end 
 form_tag( fpath, :method => fmethod, :class => fid) do 
 if @note.nil? or @note.new_record? 
 t('add_note') 
 end 
 raw(text_field 'note', 'title', :id => 'noteFormTitle', :class => 'autofocus long') 
 raw(text_area 'note', 'content', :id => 'noteFormContent', :rows => 8, :class => 'long') 
 raw(check_box('note', 'show_date')) 
 "Show date in title" 
 if @note.nil? or @note.new_record? 
 t('add_note') 
 else 
 t('edit_note') 
 end 
 t('cancel') 
 end 
 
 "page_slot_#{@note.page_slot.id}" 

end
 }
        format.js {}
        format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 "page_slot_#{@note.page_slot.id}" 
  page_url = @page.can_be_edited_by(@logged_user) ? "/#{page_slot.rel_object_type.pluralize.tableize}/#{page_slot.rel_object_id}" : '' 
 page_url 
 if @page.can_be_edited_by(@logged_user) 
 raw(page_handle widget_options(object), "page_slot_handle_#{page_slot.id}", '.pageWidget') 
 end 
 raw(render :partial => object.view_partial, :locals => {:object => object, :page_slot => page_slot}) 
 

end

  end

  # DELETE /notes/1
  # DELETE /notes/1.xml
  def destroy
    return error_status(true, :cannot_delete_note) unless (@note.can_be_deleted_by(@logged_user))
    
    @slot_id = @note.page_slot.id
    @note.page_slot.destroy
    @note.updated_by = @logged_user
    @note.destroy

    respond_to do |format|
      format.html { redirect_to(notes_url) }
      format.js {}
      format.xml  { head :ok }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 "page_slot_#{@slot_id}" 

end

  end

protected
  
  def load_note
    begin
      @note = @page.notes.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      error_status(true, :cannot_find_note)
      return false
    end
  end

end

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

class SeparatorsController < ApplicationController
  before_filter :grab_page
  before_filter :load_separator, :except => [:index, :new, :create]
  
  # GET /separators
  # GET /separators.xml
  def index
    @separators = @page.separators.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @separators }
    end
  end

  # GET /separators/1
  # GET /separators/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.js
      format.xml  { render :xml => @separator }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 hhandle = "page_slot_handle_#{page_slot.id}" 
 hhandle 
 hhandle 
 h object.title 

end

  end

  # GET /separators/new
  # GET /separators/new.xml
  def new
    return error_status(true, :cannot_create_separator) unless (Separator.can_be_created_by(@logged_user, @page))
    
    @separator = @page.separators.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @separator }
    end
  end

  # GET /separators/1/edit
  def edit
    return error_status(true, :cannot_edit_separator) unless (@separator.can_be_edited_by(@logged_user))

    respond_to do |format|
      format.html
      format.js
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 "page_slot_#{@separator.page_slot.id}" 
  if @separator.nil? or @separator.new_record? 
 fpath = page_separators_path(@page) 
 fmethod = :post 
 fid = 'fixedWidgetForm' 
 else 
 fpath = page_separator_path(@page, @separator) 
 fmethod = :put 
 fid = 'widgetForm' 
 end 
 form_tag( fpath, :method => fmethod, :class => fid) do 
 raw(text_field 'separator', 'title', :class => 'separatorFormTitle', :class => 'autofocus moderate') 
 if @separator.nil? or @separator.new_record? 
 t('add_separator') 
 else 
 t('edit_separator') 
 end 
 t('cancel') 
 end 
 
 "page_slot_#{@separator.page_slot.id}" 

end

  end

  # POST /separators
  # POST /separators.xml
  def create
    return error_status(true, :cannot_create_separator) unless (Separator.can_be_created_by(@logged_user, @page))
    
    calculate_position
    
    # Make the darn note
    @separator = @page.separators.build(params[:separator])
    @separator.created_by = @logged_user
    saved = @separator.save
    
    # And the slot, don't forget the slot
    save_slot(@separator) if saved

    respond_to do |format|
      if @separator.save
        flash[:notice] = 'Separator was successfully created.'
        format.html { redirect_to(@separator) }
        format.js {}
        format.xml  { render :xml => @separator, :status => :created, :location => page_separator_path(:page_id => @page.id, :id => @separator.id) }
      else
        format.html { render :action => "new" }
        format.js {}
        format.xml  { render :xml => @separator.errors, :status => :unprocessable_entity }
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
 

end

  end

  # PUT /separators/1
  # PUT /separators/1.xml
  def update
    return error_status(true, :cannot_edit_separator) unless (@separator.can_be_edited_by(@logged_user))
    
    @separator.updated_by = @logged_user

    respond_to do |format|
      if @separator.update_attributes(params[:separator])
        flash[:notice] = 'Separator was successfully updated.'
        format.html { redirect_to(@separator) }
        format.js {}
        format.xml  { head :ok }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 "page_slot_#{@separator.page_slot.id}" 
  if @separator.nil? or @separator.new_record? 
 fpath = page_separators_path(@page) 
 fmethod = :post 
 fid = 'fixedWidgetForm' 
 else 
 fpath = page_separator_path(@page, @separator) 
 fmethod = :put 
 fid = 'widgetForm' 
 end 
 form_tag( fpath, :method => fmethod, :class => fid) do 
 raw(text_field 'separator', 'title', :class => 'separatorFormTitle', :class => 'autofocus moderate') 
 if @separator.nil? or @separator.new_record? 
 t('add_separator') 
 else 
 t('edit_separator') 
 end 
 t('cancel') 
 end 
 
 "page_slot_#{@separator.page_slot.id}" 

end
 }
        format.js {}
        format.xml  { render :xml => @separator.errors, :status => :unprocessable_entity }
      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 "page_slot_#{@separator.page_slot.id}" 
  page_url = @page.can_be_edited_by(@logged_user) ? "/#{page_slot.rel_object_type.pluralize.tableize}/#{page_slot.rel_object_id}" : '' 
 page_url 
 if @page.can_be_edited_by(@logged_user) 
 raw(page_handle widget_options(object), "page_slot_handle_#{page_slot.id}", '.pageWidget') 
 end 
 raw(render :partial => object.view_partial, :locals => {:object => object, :page_slot => page_slot}) 
 

end

  end

  # DELETE /separators/1
  # DELETE /separators/1.xml
  def destroy
    return error_status(true, :cannot_delete_separator) unless (@separator.can_be_deleted_by(@logged_user))
    
    @slot_id = @separator.page_slot.id
    @separator.page_slot.destroy
    @separator.updated_by = @logged_user
    @separator.destroy

    respond_to do |format|
      format.html { redirect_to(separators_url) }
      format.js {}
      format.xml  { head :ok }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 "page_slot_#{@slot_id}" 

end

  end

protected
  
  def load_separator
    begin
      @separator = @page.separators.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      error_status(true, :cannot_find_separator)
      return false
    end
  end
  
end

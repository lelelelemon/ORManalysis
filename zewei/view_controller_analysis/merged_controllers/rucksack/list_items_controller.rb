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

class ListItemsController < ApplicationController
  before_filter :grab_page
  before_filter :grab_list
  before_filter :load_list_item, :except => [:index, :new, :create]
  
  cache_sweeper :page_sweeper, :only => [:create, :update, :destroy, :status]
  
  # GET /list_items
  # GET /list_items.xml
  def index
    if params[:completed]
      conds = ['completed_on NOT NULL']
    else
      conds = nil
    end
    
    @list_items = @list.list_items.where(conds).offset(params[:offset]).limit(params[:limit])

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.xml  { render :xml => @list_items }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  # GET /list_items/1
  # GET /list_items/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.js
      format.xml  { render :xml => @list_item }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 url = show.can_be_completed_by(@logged_user) ? "/lists/#{show.list_id}/items/#{show.id}" : nil 
 show.id 
 show.id 
 url 
 if show.can_be_completed_by(@logged_user) 
 unless show.is_completed? or !show.can_be_edited_by(@logged_user) 
 page_handle [ ['delete', '-'], ['edit', t('edit')], ['handle', '+'] ], "page_item_handle_#{show.id}", '.listItem' 
 end 
 (show.is_completed? ? 'checked' : nil) 
 show.id 
 else 
 show.is_completed? ? render_icon('checked', t('list_item_completed')) : render_icon('not-checked', t('list_item_open')) 
 end 
 show.id 
 (show.is_completed? and show.can_be_edited_by(@logged_user)) ? render_icon('del_gen', '', {:class => 'itemDelete'}) : '' 
 raw(textilize h(show.content), true, {'hover_handle' => "page_item_handle_#{show.id}"}) 

end

  end

  # GET /list_items/new
  # GET /list_items/new.xml
  def new
    return error_status(true, :cannot_create_listitem) unless (ListItem.can_be_created_by(@logged_user, @list))
    
    @list_item = @list.list_items.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @list_item }
    end
  end

  # GET /list_items/1/edit
  def edit
    return error_status(true, :cannot_edit_listitem) unless (@list_item.can_be_edited_by(@logged_user))
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 "list_item_#{@list_item.id}" 
  form_tag page_list_list_item_path(@page, @list, @list_item), :method => :put do 
 text_field 'list_item', 'content', :class => 'autofocus moderate' 
 t('rename_item') 
 t('cancel') 
 end 
 
 "list_item_#{@list_item.id}" 

end

  end

  # POST /list_items
  # POST /list_items.xml
  def create
    return error_status(true, :cannot_create_listitem) unless (ListItem.can_be_created_by(@logged_user, @list))
    
    @list_item = @list.list_items.build(params[:list_item])
    @list_item.created_by = @logged_user

    respond_to do |format|
      if @list_item.save
        flash[:notice] = 'ListItem was successfully created.'
        format.html { redirect_to(@list_item) }
        format.js
        format.xml  { render :xml => @list_item, :status => :created, :location => page_list_list_item_path(:page_id => @page.id, :list_id => @list.id, :id => @list_item.id) }
      else
        format.html { render :action => "new" }
        format.js
        format.xml  { render :xml => @list_item.errors, :status => :unprocessable_entity }
      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 select_class = @list_item.is_completed? ? 'completedItems' : 'openItems' 
 "list_#{@list.id} .#{select_class} .listItems:first" 
 escape_javascript render({:partial => 'show', :collection => [@list_item]}) 

end

  end

  # PUT /list_items/1
  # PUT /list_items/1.xml
  def update
    return error_status(true, :cannot_edit_listitem) unless (@list_item.can_be_edited_by(@logged_user))
    
    @list_item.updated_by = @logged_user

    respond_to do |format|
      if @list_item.update_attributes(params[:list_item])
        flash[:notice] = 'ListItem was successfully updated.'
        format.html { redirect_to(@list_item) }
        format.js
        format.xml  { head :ok }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 "list_item_#{@list_item.id}" 
  form_tag page_list_list_item_path(@page, @list, @list_item), :method => :put do 
 text_field 'list_item', 'content', :class => 'autofocus moderate' 
 t('rename_item') 
 t('cancel') 
 end 
 
 "list_item_#{@list_item.id}" 

end
 }
        format.js
        format.xml  { render :xml => @list_item.errors, :status => :unprocessable_entity }
      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 "list_item_#{@list_item.id}" 
  url = show.can_be_completed_by(@logged_user) ? "/lists/#{show.list_id}/items/#{show.id}" : nil 
 show.id 
 show.id 
 url 
 if show.can_be_completed_by(@logged_user) 
 unless show.is_completed? or !show.can_be_edited_by(@logged_user) 
 page_handle [ ['delete', '-'], ['edit', t('edit')], ['handle', '+'] ], "page_item_handle_#{show.id}", '.listItem' 
 end 
 (show.is_completed? ? 'checked' : nil) 
 show.id 
 else 
 show.is_completed? ? render_icon('checked', t('list_item_completed')) : render_icon('not-checked', t('list_item_open')) 
 end 
 show.id 
 (show.is_completed? and show.can_be_edited_by(@logged_user)) ? render_icon('del_gen', '', {:class => 'itemDelete'}) : '' 
 raw(textilize h(show.content), true, {'hover_handle' => "page_item_handle_#{show.id}"}) 
 

end

  end

  # DELETE /list_items/1
  # DELETE /list_items/1.xml
  def destroy
    return error_status(true, :cannot_edit_listitem) unless (@list_item.can_be_deleted_by(@logged_user))
    
    @list_item.updated_by = @logged_user
    @list_item.destroy

    respond_to do |format|
      format.html { redirect_to(list_items_url) }
        format.js
      format.xml  { head :ok }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 "list_item_#{@list_item.id}" 

end

  end
  
  # PUT /list_items/1
  def status
    return error_status(true, :cannot_edit_listitem) unless (@list_item.can_be_completed_by(@logged_user))
    
    @list_item.set_completed(params[:list_item][:completed] == 'true', @logged_user)
    @list_item.position = @list.list_items.length
    @list_item.save

    respond_to do |format|
      format.html { redirect_to(list_items_url) }
      format.js
      format.xml  { head :ok }
    end

ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 insert_into = @list_item.is_completed? ? 'completedItems' : 'openItems' 
 "list_item_#{@list_item.id}" 
 "list_#{@list.id} .#{insert_into} ul:first" 
 escape_javascript render({:partial => 'show', :collection => [@list_item]}) 

end

  end

protected

  def load_list_item
    begin
      @list_item = @list.list_items.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      error_status(true, :cannot_find_listitem)
      return false
    end
  end

  def grab_list
    begin
        @list = @page.lists.find(params[:list_id])
    rescue ActiveRecord::RecordNotFound
        error_status(true, :cannot_find_list)
        return false
    end
    
    true
  end
end

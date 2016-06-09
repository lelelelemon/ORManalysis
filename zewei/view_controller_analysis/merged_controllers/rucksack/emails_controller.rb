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

class EmailsController < ApplicationController
  layout nil
  
  before_filter :grab_page
  before_filter :load_email, :except => [:index, :new, :create]
  
  cache_sweeper :page_sweeper, :only => [:create, :update, :destroy]
  
  # GET /emails
  # GET /emails.xml
  def index
    @emails = @page.emails.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @emails }
    end
  end

  # GET /emails/1
  # GET /emails/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.js
      format.xml  { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 ": \n" 
 ": \n" 
 ": \n" 
 textilize @email.body 

end
 }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 ": \n" 
 ": \n" 
 ": \n" 
 textilize @email.body 

end

  end

  # GET /emails/new
  # GET /emails/new.xml
  def new
    return error_status(true, :cannot_create_email) unless (Email.can_be_created_by(@logged_user, @page))
    
    @email = @page.emails.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @email }
    end
  end

  # GET /emails/1/edit
  def edit
    return error_status(true, :cannot_edit_email) unless (@email.can_be_edited_by(@logged_user))

    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /emails
  # POST /emails.xml
  def create
    return error_status(true, :cannot_create_email) unless (Email.can_be_created_by(@logged_user, @page))
    
    calculate_position
    
    # Make the darn note
    @email = @page.emails.build(params[:email])
    @email.created_by = @logged_user
    saved = @email.save
    
    # And the slot, don't forget the slot
    save_slot(@email) if saved

    respond_to do |format|
      if @email.save
        flash[:notice] = 'email was successfully created.'
        format.html { redirect_to(@email) }
        format.js {}
        format.xml  { render :xml => @email, :status => :created, :location => page_email_path(:page_id => @page.id, :id => @email.id) }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title = t('new_page') 
 @tabbed_navigation_items = common_tabs(:pages) 
 @user_navigation_items = user_tabs(nil) 
 form_tag pages_path(:use_route => nil) do 
 raw(error_messages_for :page) 
 raw(text_field 'page', 'title', :id => 'newpage_title', :class => 'long') 
 raw(submit_tag t('page_create')) 
 end 
 pages_path 
 t('page_back') 

end
 }
        format.js {}
        format.xml  { render :xml => @email.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /emails/1
  # PUT /emails/1.xml
  def update
    return error_status(true, :cannot_edit_email) unless (@email.can_be_edited_by(@logged_user))
    
    @email.updated_by = @logged_user

    respond_to do |format|
      if @email.update_attributes(params[:email])
        flash[:notice] = 'email was successfully updated.'
        format.html { redirect_to(@email) }
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
        format.xml  { render :xml => @email.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /emails/1
  # DELETE /emails/1.xml
  def destroy
    return error_status(true, :cannot_delete_email) unless (@email.can_be_deleted_by(@logged_user))
    
    @slot_id = @email.page_slot.id
    @email.page_slot.destroy
    @email.updated_by = @logged_user
    @email.destroy

    respond_to do |format|
      format.html { redirect_to(emails_url) }
      format.js {}
      format.xml  { head :ok }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 "page_slot_#{@slot_id}" 

end

  end
  
  def public
    return error_status(true, :cannot_see_email) unless (@email.can_be_seen_by(@logged_user))

    respond_to do |format|
      format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 ": \n" 
 ": \n" 
 ": \n" 
 textilize @email.body 

end
 }
    end
  end

protected
 
  def authorized?(action = action_name, resource = nil)
    if action == 'public'
      public_auth
    else
      logged_in?
    end
  end
  
  def load_email
    begin
      @email = @page.emails.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      error_status(true, :cannot_find_email)
      return false
    end
  end
  
end

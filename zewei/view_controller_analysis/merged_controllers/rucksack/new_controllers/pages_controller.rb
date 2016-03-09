#==
# Copyright (C) 2008 James S Urquhart
# Portions Copyright (C) 2009 Qiushi He
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

class PagesController < ApplicationController
  layout :page_layout
  
  before_filter :grab_user
  before_filter :load_page, :except => [:index, :new, :create, :reorder_sidebar, :current]
  after_filter  :user_track, :except => 'public'
  
  caches_page :public
  cache_sweeper :page_sweeper, :only => [:update, :destroy, :reorder, :reorder_sidebar, :share, :transfer, :tags, :resize]
  
  # GET /pages
  # GET /pages.xml
  def index
    return error_status(true, :cannot_see_pages) unless (@user.pages_can_be_seen_by(@logged_user))
    
    search

    if @find_opts.nil? or [:html, :js].include?(request.format.to_sym)
      @pages = @user.pages
      @shared_pages = @user.shared_pages
    else
      @pages = @user.pages.find(:all).where(@find_opts[:conditions]).joins(@find_opts[:joins]).group("pages.id HAVING COUNT(tags.id) = #{params[:tags].length}").all
      @shared_pages = @user.shared_pages.where(@find_opts[:conditions]).all
    end
    
    @content_for_sidebar = 'page_sidebar'

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.xml  { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 # Tags 
  crumb 
 pages_url(:tags => [crumb]) 
 h crumb 
 
  crumb 
 pages_url(:tags => [crumb]) 
 h crumb 
 
 # Clear old results 
 # Add new results 
  (shared ? 'mine' : nil) 
 page_tag_list(index_page) 
 page_path(index_page) 
 h index_page.title 
 
  (shared ? 'mine' : nil) 
 page_tag_list(index_page) 
 page_path(index_page) 
 h index_page.title 
 

end
 }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 # Tags 
  crumb 
 pages_url(:tags => [crumb]) 
 h crumb 
 
  crumb 
 pages_url(:tags => [crumb]) 
 h crumb 
 
 # Clear old results 
 # Add new results 
  (shared ? 'mine' : nil) 
 page_tag_list(index_page) 
 page_path(index_page) 
 h index_page.title 
 
  (shared ? 'mine' : nil) 
 page_tag_list(index_page) 
 page_path(index_page) 
 h index_page.title 
 

end

  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    return error_status(true, :cannot_see_page) unless (@page.can_be_seen_by(@logged_user))
    
    @content_for_sidebar = 'page_sidebar' if @logged_user.member_of_owner?
    
    session['page_id'] = @page.id

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end
 }
      format.rss { 
        conds = {'page_id' => @page.id}
        conds['is_private'] = false if !@logged_user.member_of_owner?
        @activity_log = ApplicationLog.where(conds).limit(params[:limit] || 50).order('created_on DESC').all
        render :layout => false
      }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end
  
  # GET /pages/1/public(.html)
  def public
    return error_status(true, :cannot_see_page) unless (@page.can_be_seen_by(@logged_user))

    respond_to do |format|
      format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end
 }
    end
  end

  # GET /pages/new
  # GET /pages/new.xml
  def new
    return error_status(true, :cannot_create_page) unless ((@logged_user.id == @user.id) and Page.can_be_created_by(@user))
    
    @page = @user.pages.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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

  end

  # GET /pages/1/edit
  def edit
    return error_status(true, :cannot_edit_page) unless (@page.can_be_edited_by(@logged_user))
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  form_tag page_path(@page), :method => :put do 
 raw(text_field 'page', 'title', :class => 'autofocus moderate') 
 t('rename_page') 
 t('cancel') 
 end 
 

end

  end

  # POST /pages
  # POST /pages.xml
  def create
    return error_status(true, :cannot_create_page) unless ((@logged_user.id == @user.id) and Page.can_be_created_by(@user))
    @page = @user.pages.new(params[:page])

    respond_to do |format|
      if @page.save
        @user.favourite_pages << @page
        
        flash[:notice] = 'Page was successfully created.'
        format.html { redirect_to(@page) }
        format.js   { 
          @page = (!params[:active_page].nil? ? Page.find(params[:active_page]) : nil)
          @pages = [] if @page.nil? 
          ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 unless @set_favourite.nil? 
 @set_favourite 
 end 
  cclass = @pages.nil? ? nil : 'current' 
 (@logged_user.home_page == @page ? 'current' : nil) 
 @logged_user.home_page_id 
 page_path(@logged_user.home_page) 
 h @logged_user.home_page.title 
 cclass 
 pages_path 
 t('all_pages') 
 (@logged_user.favourite_pages.sort { |x,y| x.sidebar_order <=> y.sidebar_order }).each do |page| 
 (page == @page ? 'current' : nil) 
 page.id 
 page.id 
 page_path(page) 
 h page.title 
 end 
 

end
 
        }
        format.xml  { render :xml => @page, :status => :created, :location => @page }
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
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    return error_status(true, :cannot_edit_page) unless (@page.can_be_edited_by(@logged_user))

    respond_to do |format|
      if @page.update_attributes(params[:page])
        flash[:notice] = 'Page was successfully updated.'
        format.html { redirect_to(@page) }
        format.js { }
        format.xml  { head :ok }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  form_tag page_path(@page), :method => :put do 
 raw(text_field 'page', 'title', :class => 'autofocus moderate') 
 t('rename_page') 
 t('cancel') 
 end 
 

end
 }
        format.js { }
        format.xml  { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 escape_javascript("<h1><span hover_handle=\"page_header_handle\">#{h(@page.title)}</span></h1>").html_safe 
  cclass = @pages.nil? ? nil : 'current' 
 (@logged_user.home_page == @page ? 'current' : nil) 
 @logged_user.home_page_id 
 page_path(@logged_user.home_page) 
 h @logged_user.home_page.title 
 cclass 
 pages_path 
 t('all_pages') 
 (@logged_user.favourite_pages.sort { |x,y| x.sidebar_order <=> y.sidebar_order }).each do |page| 
 (page == @page ? 'current' : nil) 
 page.id 
 page.id 
 page_path(page) 
 h page.title 
 end 
 

end
 }
      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 escape_javascript("<h1><span hover_handle=\"page_header_handle\">#{h(@page.title)}</span></h1>").html_safe 
  cclass = @pages.nil? ? nil : 'current' 
 (@logged_user.home_page == @page ? 'current' : nil) 
 @logged_user.home_page_id 
 page_path(@logged_user.home_page) 
 h @logged_user.home_page.title 
 cclass 
 pages_path 
 t('all_pages') 
 (@logged_user.favourite_pages.sort { |x,y| x.sidebar_order <=> y.sidebar_order }).each do |page| 
 (page == @page ? 'current' : nil) 
 page.id 
 page.id 
 page_path(page) 
 h page.title 
 end 
 

end

  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    return error_status(true, :cannot_delete_page) unless (@page.can_be_deleted_by(@logged_user))
    
    @page.destroy

    respond_to do |format|
      format.html { redirect_to(pages_url) }
      format.js { } # destroy.js.rjs
      format.xml  { head :ok }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 escape_javascript(pages_path(:use_route => nil)) 

end

  end
  
  # POST /pages/1/reorder
  def reorder
    return error_status(true, :insufficient_permissions) unless (@page.can_be_edited_by(@logged_user))
    
    order = params[:slots].collect { |id| id.to_i }
    
    @page.slots.each do |slot|
      idx = order.index(slot.id)
      slot.position = idx
      slot.save!
    end

    respond_to do |format|
      format.html { head :ok }
      format.xml  { head :ok }
    end
  end
  
  # POST /pages
  # POST /pages.xml
  def reorder_sidebar
    index = 0
    params[:page_ids].each do |page_id|
        p = Page.find(page_id)
        p.sidebar_order = index
        p.save!
        index += 1
    end
    
    respond_to do |format|
        format.html { head :ok }
        format.xml  { head :ok }
    end
  end
  
  def transfer
    @slot = PageSlot.find(params[:page_slot][:id])
    
    return error_status(true, :insufficient_permissions) unless (@page.can_be_edited_by(@logged_user) and @slot.page.can_be_edited_by(@logged_user))
    
    @slot.page = @page
    @slot.rel_object.page = @page
    @slot.rel_object.save
    @slot.position = @page.slots.length
    @slot.save

    respond_to do |format|
      format.html { head :ok }
      format.js { }
      format.xml  { head :ok }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 "page_slot_#{@slot.id}" 

end

  end
  
  def favourite
    return error_status(true, :insufficient_permissions) unless (@user.can_add_favourite(@logged_user))
    
    @set_favourite = params[:page][:is_favourite].to_i != 0
    if @set_favourite
      @user.favourite_pages << @page unless @page.is_favourite?(@user)
    else
      @user.favourite_pages.delete(@page)
    end

    respond_to do |format|
      format.html { head :ok }
      format.js { }
      format.xml  { head :ok }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 unless @set_favourite.nil? 
 @set_favourite 
 end 
  cclass = @pages.nil? ? nil : 'current' 
 (@logged_user.home_page == @page ? 'current' : nil) 
 @logged_user.home_page_id 
 page_path(@logged_user.home_page) 
 h @logged_user.home_page.title 
 cclass 
 pages_path 
 t('all_pages') 
 (@logged_user.favourite_pages.sort { |x,y| x.sidebar_order <=> y.sidebar_order }).each do |page| 
 (page == @page ? 'current' : nil) 
 page.id 
 page.id 
 page_path(page) 
 h page.title 
 end 
 

end

  end
  
  def share
    return error_status(true, :insufficient_permissions) unless (@page.can_be_shared_by(@logged_user))
    
    grab_users = Proc.new {|sid| 
      begin
        User.find(sid)
      rescue ActiveRecord::RecordNotFound
        nil
      end
    }
    
    set_users = []
    page_attribs = params[:page]
    unless page_attribs.nil?
      set_users = page_attribs[:shared_users]
      set_users ||= []
    else
      page_attribs = {}
    end
    
    set_public = page_attribs.has_key?(:is_public) and page_attribs[:is_public] == 'true'
    
    case request.method_symbol
    when :get
    when :post
      # Set afresh
      unless set_users.nil?
          guest_users = @page.shared_users.collect { |user| user.account_id.nil? ? user : nil }.compact
          @page.shared_users = guest_users + set_users.collect(&grab_users).compact
      end
    when :put
      # Insert into list
      unless set_users.nil?
          set_users.collect(&grab_users).compact.each {|user| @page.shared_users << user unless @page.shared_users_ids.include?(user.id)}
      end
    when :delete
      # Delete from list
      unless set_users.nil?
          set_users.collect(&grab_users).compact.each {|user| @page.shared_users.delete(user)}
      end
    end
    
    # Merge in emails
    unless request.method_symbol == :get
      @page.updated_by = @logged_user
      @page.is_public = set_public
      @page.shared_emails = page_attribs[:shared_emails]
      @page.save unless request.method_symbol == :get
    end

    respond_to do |format|
      format.html { if request.method_symbol != :get; redirect_to(page_url(@page)) end }
      format.js { }
      format.xml  { head :ok }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @tabbed_navigation_items = common_tabs(:pages) 
 @user_navigation_items = user_tabs(nil) 
 @page_title = t('share_page') 
 form_tag share_page_path(:id => @page.id), :method => :post, :class => 'pageShareForm' do 
 raw(error_messages_for :page) 
 raw(check_box_tag 'page[is_public]', true, @page.is_public, :id => "pageSetPublic") 
 t('share_by_email') 
 raw(text_area 'page', 'shared_emails', :class => 'short', :rows => 10, :cols => 40, :id => 'pageShareEmail') 
 t('share_by_email_desc') 
 t('users_who_can_see_page') 
 Account.owner.users.each do |user| 
 next if user.id == @page.created_by_id 
 user.gravatar_url(:size => 50) 
 h user.display_name 
 raw(check_box_tag 'page[shared_users][]', user.id, @page.shared_user_ids.include?(user.id), :id => "pageShareUser#{user.id}") 
 end 
 raw(submit_tag t('update')) 
 page_path(:id => @page.id) 
 t('cancel') 
 end 

end

  end
  
  def current
    begin
      if !session['page_id'].nil?
        page = Page.find(session['page_id'])
        unless page.can_be_seen_by(@logged_user)
            page = @user.home_page
            session['page_id'] = page.id
        end
      else
        page = @user.home_page
      end
    rescue
      page = @user.home_page
      session['page_id'] = page.id
    end
    
    unless page.nil?
      redirect_to(page)
    else
      redirect_to(pages_url)
    end
  end
  
  def duplicate
    return error_status(true, :cannot_duplicate_page) unless (@page.can_be_duplicated_by(@logged_user))
    
    begin
      @new_page = @page.duplicate(@logged_user)
      @logged_user.favourite_pages << @new_page
    rescue Object => o
      logger.warn o
      return error_status(true, :cannot_duplicate_page)
    end
    
    respond_to do |format|
      format.html { head :ok }
      format.js { }
      format.xml  { head :ok }
    end 
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 escape_javascript(page_path(:id => @new_page.id, :use_route => nil)) 

end

  end
  
  def tags
    return error_status(true, :cannot_edit_page) unless (@page.can_be_edited_by(@logged_user))
    
    case request.method_symbol
      when :get
        @view = 'tags_form'
      when :post
        @page.tags = params[:page][:tags]
        @view = 'tags'
        @page.save
    end
    
    respond_to do |format|
      format.html { head :ok }
      format.js { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  pages_url(:tags => [show]) 
 h show 
 

end
 }
      format.xml  { head :ok }
    end 
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  pages_url(:tags => [show]) 
 h show 
 

end

  end
  
  def resize
    return error_status(true, :cannot_edit_page) unless (@page.can_be_edited_by(@logged_user))
    
    if params.has_key?(:page) and params[:page].has_key?(:width)
      @saved = @page.update_attribute('width', params[:page][:width].to_i || 400)
    end
    
    respond_to do |format|
      format.html { head :ok }
      format.js { }
      format.xml  { head :ok }
    end 
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @saved 
 @page.width 
 end 

end

  end
  
  def reset_address
    return error_status(true, :cannot_edit_page) unless (@page.can_reset_email(@logged_user))
    
    @page.update_attribute('address', 'random')
    
    respond_to do |format|
      format.html { head :ok }
      format.js
      format.xml  { head :ok }
    end 
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 escape_javascript(page_path(@page, :use_route => nil)) 

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
  
  def search
    @find_opts = nil
    if !params[:tags].nil? and params[:tags].class == Array
      @search_tags = params[:tags]
      @find_opts = {:conditions => ['tags.name IN (?)', params[:tags]],
                    :joins => Tag.find_object_join(Page),
                    :group => "pages.id HAVING COUNT(tags.id) = #{params[:tags].length}"}
      
      @avail_tags = Tag.list_in_page(nil) - @search_tags
    else
      @avail_tags = Tag.list_in_page(nil)
    end
  end
  
  def load_page
    begin
      @page = Page.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      return error_status(true, :page_not_found)
    end
  end
  
  def page_layout
    return nil unless action_name != 'add_widget'
    return 'public_page' if action_name == 'public'
    ['index', 'new', 'edit', 'share'].include?(action_name)?  'pages':'page'
  end
end

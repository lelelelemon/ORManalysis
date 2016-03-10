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

class JournalsController < ApplicationController
  layout 'pages'
  
  before_filter :grab_user
  before_filter :load_journal, :except => [:index, :new, :create]
  
  # GET /journals
  # GET /journals.xml
  def index
    return error_status(true, :cannot_see_journals) unless (@user.journals_can_be_seen_by(@logged_user))
    
    query_users = (request.format == :html or params[:part] == 'users')
    
    if query_users
      user_ids = Account.owner.user_ids - [@logged_user.id]
      @user_journals = user_ids.collect do |uid|
        journals = Journal.where('user_id' => uid).order('created_at DESC').limit(4)
        journals.empty? ? nil : [User.find_by_id(uid), journals]
      end.compact
    end
    
    if params[:part].nil?
      @journals = get_journals(@user.id, params[:from].try(:to_i))
      @grouped_journals = get_groups(@journals)
    end
    
    @status = @user.status || @user.build_status
    @content_for_sidebar = 'journals/users_sidebar'

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.xml  { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 "#{site_name} - #{h(@page_title)}" 
 stylesheet_link_tag 'pages' 
 unless @additional_stylesheets.nil? 
 @additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end 
 end 
 ie_stylesheet_link_tag 'ie_hack' 
 javascript_include_tag 'jquery.js' 
 javascript_include_tag 'jquery_ujs.js' 
 javascript_include_tag 'jquery.ui.all.js' 
 javascript_include_tag 'application.js' 
 csrf_meta_tag 
  if !@tabbed_navigation_items.nil? 
 @tabbed_navigation_items.each do |item| 
 if !site_account.send("#{item[:id]}_hidden?") 
 (item[:id] == @selected_navigation_item ? 'active' : nil) 
 item[:id] 
 item[:url] 
 t item[:id] 
 end 
 end 
 end 
 if !@user_navigation_items.nil? 
 @user_navigation_items.each do |item| 
 (item[:id] == @selected_user_item ? 'active' : nil) 
 item[:id] 
 item[:url] 
 t item[:id] 
 end 
 if @logged_user.can_be_edited_by(@logged_user) 
 (@selected_user_item == :my_profile ? 'active' : nil) 
 current_users_path 
 t('my_profile') 
 t('logout') 
 end 
 end 
 
 status_bar 
 if @no_page_tile.nil? 
 h @page_title 
 end 
  unless @user_journals.nil? 
  unless @user_journals.empty? 
 t('user_journals_desc') 
 end 
 @user_journals.each do |ugroup| 
 h(ugroup[0].display_name) 
 ugroup[0].status.nil? ? '' : h(ugroup[0].status.content) 
 ugroup[1].each do |journal| 
 h(journal.content) 
 end 
 end 
 
 end 
 unless @journals.nil? 
 unless @journals.empty? 
  list[0] 
  journal.id 
 journal.id 
 journal_path(journal) 
 if journal.can_be_edited_by(@logged_user) 
 page_handle widget_options(journal), "journal_handle_#{journal.id}", '.journalEntry' 
 end 
 h(journal.content) 
 fancy_journal_time(journal.created_at) 
 
 
 end 
 if @journals.size >= 25 
 @journals.last.id 
 else 
 end 
 end 
 render :partial => (@content_for_sidebar.nil? ? 'layouts/blank_sidebar' : @content_for_sidebar ) 
  site_name 
 image_tag('icons/loading.gif') 
 

end
 }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 "#{site_name} - #{h(@page_title)}" 
 stylesheet_link_tag 'pages' 
 unless @additional_stylesheets.nil? 
 @additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end 
 end 
 ie_stylesheet_link_tag 'ie_hack' 
 javascript_include_tag 'jquery.js' 
 javascript_include_tag 'jquery_ujs.js' 
 javascript_include_tag 'jquery.ui.all.js' 
 javascript_include_tag 'application.js' 
 csrf_meta_tag 
  if !@tabbed_navigation_items.nil? 
 @tabbed_navigation_items.each do |item| 
 if !site_account.send("#{item[:id]}_hidden?") 
 (item[:id] == @selected_navigation_item ? 'active' : nil) 
 item[:id] 
 item[:url] 
 t item[:id] 
 end 
 end 
 end 
 if !@user_navigation_items.nil? 
 @user_navigation_items.each do |item| 
 (item[:id] == @selected_user_item ? 'active' : nil) 
 item[:id] 
 item[:url] 
 t item[:id] 
 end 
 if @logged_user.can_be_edited_by(@logged_user) 
 (@selected_user_item == :my_profile ? 'active' : nil) 
 current_users_path 
 t('my_profile') 
 t('logout') 
 end 
 end 
 
 status_bar 
 if @no_page_tile.nil? 
 h @page_title 
 end 
  unless @user_journals.nil? 
  unless @user_journals.empty? 
 t('user_journals_desc') 
 end 
 @user_journals.each do |ugroup| 
 h(ugroup[0].display_name) 
 ugroup[0].status.nil? ? '' : h(ugroup[0].status.content) 
 ugroup[1].each do |journal| 
 h(journal.content) 
 end 
 end 
 
 end 
 unless @journals.nil? 
 unless @journals.empty? 
  list[0] 
  journal.id 
 journal.id 
 journal_path(journal) 
 if journal.can_be_edited_by(@logged_user) 
 page_handle widget_options(journal), "journal_handle_#{journal.id}", '.journalEntry' 
 end 
 h(journal.content) 
 fancy_journal_time(journal.created_at) 
 
 
 end 
 if @journals.size >= 25 
 @journals.last.id 
 else 
 end 
 end 
 render :partial => (@content_for_sidebar.nil? ? 'layouts/blank_sidebar' : @content_for_sidebar ) 
  site_name 
 image_tag('icons/loading.gif') 
 

end

  end

  # GET /journals/1
  # GET /journals/1.xml
  def show
    return error_status(true, :cannot_see_journal) unless (@journal.can_be_seen_by(@logged_user))

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @journal }
    end
  end

  # GET /journals/new
  # GET /journals/new.xml
  def new
    return error_status(true, :cannot_create_journal) unless (Journal.can_be_created_by(@logged_user))
    @journal = @user.journals.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @journal }
    end
  end

  # GET /journals/1/edit
  def edit
    return error_status(true, :cannot_edit_journal) unless (@journal.can_be_edited_by(@logged_user))
  end

  # POST /journals
  # POST /journals.xml
  def create
    return error_status(true, :cannot_create_journal) unless (Journal.can_be_created_by(@logged_user))
    @journal = @user.journals.build(params[:journal])

    respond_to do |format|
      if @journal.save
        if request.format == :js
          @journals = get_journals(Account.owner.user_ids)
          @grouped_journals = get_groups(@journals)
        end
        
        flash[:notice] = 'Journal was successfully created.'
        format.html { redirect_to(@journal) }
        format.js
        format.xml  { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 "#{site_name} - #{h(@page_title)}" 
 stylesheet_link_tag 'pages' 
 unless @additional_stylesheets.nil? 
 @additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end 
 end 
 ie_stylesheet_link_tag 'ie_hack' 
 javascript_include_tag 'jquery.js' 
 javascript_include_tag 'jquery_ujs.js' 
 javascript_include_tag 'jquery.ui.all.js' 
 javascript_include_tag 'application.js' 
 csrf_meta_tag 
  if !@tabbed_navigation_items.nil? 
 @tabbed_navigation_items.each do |item| 
 if !site_account.send("#{item[:id]}_hidden?") 
 (item[:id] == @selected_navigation_item ? 'active' : nil) 
 item[:id] 
 item[:url] 
 t item[:id] 
 end 
 end 
 end 
 if !@user_navigation_items.nil? 
 @user_navigation_items.each do |item| 
 (item[:id] == @selected_user_item ? 'active' : nil) 
 item[:id] 
 item[:url] 
 t item[:id] 
 end 
 if @logged_user.can_be_edited_by(@logged_user) 
 (@selected_user_item == :my_profile ? 'active' : nil) 
 current_users_path 
 t('my_profile') 
 t('logout') 
 end 
 end 
 
 status_bar 
 if @no_page_tile.nil? 
 h @page_title 
 end 
  @grouped_journals.first[0] 
  list[0] 
  journal.id 
 journal.id 
 journal_path(journal) 
 if journal.can_be_edited_by(@logged_user) 
 page_handle widget_options(journal), "journal_handle_#{journal.id}", '.journalEntry' 
 end 
 h(journal.content) 
 fancy_journal_time(journal.created_at) 
 
 
 render :partial => (@content_for_sidebar.nil? ? 'layouts/blank_sidebar' : @content_for_sidebar ) 
  site_name 
 image_tag('icons/loading.gif') 
 

end
 }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 "#{site_name} - #{h(@page_title)}" 
 stylesheet_link_tag 'pages' 
 unless @additional_stylesheets.nil? 
 @additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end 
 end 
 ie_stylesheet_link_tag 'ie_hack' 
 javascript_include_tag 'jquery.js' 
 javascript_include_tag 'jquery_ujs.js' 
 javascript_include_tag 'jquery.ui.all.js' 
 javascript_include_tag 'application.js' 
 csrf_meta_tag 
  if !@tabbed_navigation_items.nil? 
 @tabbed_navigation_items.each do |item| 
 if !site_account.send("#{item[:id]}_hidden?") 
 (item[:id] == @selected_navigation_item ? 'active' : nil) 
 item[:id] 
 item[:url] 
 t item[:id] 
 end 
 end 
 end 
 if !@user_navigation_items.nil? 
 @user_navigation_items.each do |item| 
 (item[:id] == @selected_user_item ? 'active' : nil) 
 item[:id] 
 item[:url] 
 t item[:id] 
 end 
 if @logged_user.can_be_edited_by(@logged_user) 
 (@selected_user_item == :my_profile ? 'active' : nil) 
 current_users_path 
 t('my_profile') 
 t('logout') 
 end 
 end 
 
 status_bar 
 if @no_page_tile.nil? 
 h @page_title 
 end 
  @grouped_journals.first[0] 
  list[0] 
  journal.id 
 journal.id 
 journal_path(journal) 
 if journal.can_be_edited_by(@logged_user) 
 page_handle widget_options(journal), "journal_handle_#{journal.id}", '.journalEntry' 
 end 
 h(journal.content) 
 fancy_journal_time(journal.created_at) 
 
 
 render :partial => (@content_for_sidebar.nil? ? 'layouts/blank_sidebar' : @content_for_sidebar ) 
  site_name 
 image_tag('icons/loading.gif') 
 

end
 }
        format.js {}
        format.xml  { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 "#{site_name} - #{h(@page_title)}" 
 stylesheet_link_tag 'pages' 
 unless @additional_stylesheets.nil? 
 @additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end 
 end 
 ie_stylesheet_link_tag 'ie_hack' 
 javascript_include_tag 'jquery.js' 
 javascript_include_tag 'jquery_ujs.js' 
 javascript_include_tag 'jquery.ui.all.js' 
 javascript_include_tag 'application.js' 
 csrf_meta_tag 
  if !@tabbed_navigation_items.nil? 
 @tabbed_navigation_items.each do |item| 
 if !site_account.send("#{item[:id]}_hidden?") 
 (item[:id] == @selected_navigation_item ? 'active' : nil) 
 item[:id] 
 item[:url] 
 t item[:id] 
 end 
 end 
 end 
 if !@user_navigation_items.nil? 
 @user_navigation_items.each do |item| 
 (item[:id] == @selected_user_item ? 'active' : nil) 
 item[:id] 
 item[:url] 
 t item[:id] 
 end 
 if @logged_user.can_be_edited_by(@logged_user) 
 (@selected_user_item == :my_profile ? 'active' : nil) 
 current_users_path 
 t('my_profile') 
 t('logout') 
 end 
 end 
 
 status_bar 
 if @no_page_tile.nil? 
 h @page_title 
 end 
  @grouped_journals.first[0] 
  list[0] 
  journal.id 
 journal.id 
 journal_path(journal) 
 if journal.can_be_edited_by(@logged_user) 
 page_handle widget_options(journal), "journal_handle_#{journal.id}", '.journalEntry' 
 end 
 h(journal.content) 
 fancy_journal_time(journal.created_at) 
 
 
 render :partial => (@content_for_sidebar.nil? ? 'layouts/blank_sidebar' : @content_for_sidebar ) 
  site_name 
 image_tag('icons/loading.gif') 
 

end
 }
      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 "#{site_name} - #{h(@page_title)}" 
 stylesheet_link_tag 'pages' 
 unless @additional_stylesheets.nil? 
 @additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end 
 end 
 ie_stylesheet_link_tag 'ie_hack' 
 javascript_include_tag 'jquery.js' 
 javascript_include_tag 'jquery_ujs.js' 
 javascript_include_tag 'jquery.ui.all.js' 
 javascript_include_tag 'application.js' 
 csrf_meta_tag 
  if !@tabbed_navigation_items.nil? 
 @tabbed_navigation_items.each do |item| 
 if !site_account.send("#{item[:id]}_hidden?") 
 (item[:id] == @selected_navigation_item ? 'active' : nil) 
 item[:id] 
 item[:url] 
 t item[:id] 
 end 
 end 
 end 
 if !@user_navigation_items.nil? 
 @user_navigation_items.each do |item| 
 (item[:id] == @selected_user_item ? 'active' : nil) 
 item[:id] 
 item[:url] 
 t item[:id] 
 end 
 if @logged_user.can_be_edited_by(@logged_user) 
 (@selected_user_item == :my_profile ? 'active' : nil) 
 current_users_path 
 t('my_profile') 
 t('logout') 
 end 
 end 
 
 status_bar 
 if @no_page_tile.nil? 
 h @page_title 
 end 
  @grouped_journals.first[0] 
  list[0] 
  journal.id 
 journal.id 
 journal_path(journal) 
 if journal.can_be_edited_by(@logged_user) 
 page_handle widget_options(journal), "journal_handle_#{journal.id}", '.journalEntry' 
 end 
 h(journal.content) 
 fancy_journal_time(journal.created_at) 
 
 
 render :partial => (@content_for_sidebar.nil? ? 'layouts/blank_sidebar' : @content_for_sidebar ) 
  site_name 
 image_tag('icons/loading.gif') 
 

end

  end

  # PUT /journals/1
  # PUT /journals/1.xml
  def update
    return error_status(true, :cannot_edit_journal) unless (@journal.can_be_edited_by(@logged_user))

    respond_to do |format|
      if @journal.update_attributes(params[:journal])
        flash[:notice] = 'Journal was successfully updated.'
        format.html { redirect_to(@journal) }
        format.js {}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.js {}
        format.xml  { render :xml => @journal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /journals/1
  # DELETE /journals/1.xml
  def destroy
    return error_status(true, :cannot_delete_journal) unless (@journal.can_be_deleted_by(@logged_user))
    @journal.destroy

    respond_to do |format|
      format.html { redirect_to(journals_url) }
      format.js { }
      format.xml  { head :ok }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 "#{site_name} - #{h(@page_title)}" 
 stylesheet_link_tag 'pages' 
 unless @additional_stylesheets.nil? 
 @additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end 
 end 
 ie_stylesheet_link_tag 'ie_hack' 
 javascript_include_tag 'jquery.js' 
 javascript_include_tag 'jquery_ujs.js' 
 javascript_include_tag 'jquery.ui.all.js' 
 javascript_include_tag 'application.js' 
 csrf_meta_tag 
  if !@tabbed_navigation_items.nil? 
 @tabbed_navigation_items.each do |item| 
 if !site_account.send("#{item[:id]}_hidden?") 
 (item[:id] == @selected_navigation_item ? 'active' : nil) 
 item[:id] 
 item[:url] 
 t item[:id] 
 end 
 end 
 end 
 if !@user_navigation_items.nil? 
 @user_navigation_items.each do |item| 
 (item[:id] == @selected_user_item ? 'active' : nil) 
 item[:id] 
 item[:url] 
 t item[:id] 
 end 
 if @logged_user.can_be_edited_by(@logged_user) 
 (@selected_user_item == :my_profile ? 'active' : nil) 
 current_users_path 
 t('my_profile') 
 t('logout') 
 end 
 end 
 
 status_bar 
 if @no_page_tile.nil? 
 h @page_title 
 end 
  "journal_#{@journal.id}" 
 render :partial => (@content_for_sidebar.nil? ? 'layouts/blank_sidebar' : @content_for_sidebar ) 
  site_name 
 image_tag('icons/loading.gif') 
 

end

  end
  
protected

  def load_journal
    begin
      @journal = @user.journals.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      error_status(true, :cannot_find_journal)
      return false
    end
  end

  def get_journals(users, from=nil)
    conditions = from.nil? ? ['user_id IN (?)', users] : ['user_id IN (?) AND id < ?', users, from]
    Journal.where(conditions).order('created_at DESC').limit(params[:limit] || 25).all
  end
  
  def get_groups(list)
    now = Time.zone.now.to_date
    list.group_by do |journal|
      date = journal.created_at.to_date
      if date == now
        t('journal_date_today')
      else
        date.strftime(date.year == now.year ? t('journal_date_format') : t('journal_date_format_extended'))
      end
    end.map{|k,v| [k,v]}
  end
end

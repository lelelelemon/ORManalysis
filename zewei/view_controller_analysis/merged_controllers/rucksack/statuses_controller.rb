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

class StatusesController < ApplicationController
  layout 'pages'
  
  before_filter :grab_user

  # GET /statuses/1
  # GET /statuses/1.xml
  def show
    user_ids = Account.owner.user_ids - [@user.id]
    
    @status = @user.status
    return error_status(true, :cannot_see_status) unless (@status.can_be_seen_by(@logged_user))
    
    @statuses = Status.where({'user_id' => user_ids}).all

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => [@status] + @statuses }
    end
  end

  # PUT /statuses/1
  # PUT /statuses/1.xml
  def update
    @status = @user.status || @user.build_status(:content => t('status'))
    return error_status(true, :cannot_edit_status) unless (@status.can_be_edited_by(@logged_user))
    
    @status.attributes = params[:status]

    respond_to do |format|
      if @status.save
        flash[:notice] = 'Status was successfully updated.'
        format.html { redirect_to(journals_url) }
        format.js {}
        format.xml  { head :ok }
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
  escape_javascript(@user.status.content) 
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
  escape_javascript(@user.status.content) 
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
  escape_javascript(@user.status.content) 
 render :partial => (@content_for_sidebar.nil? ? 'layouts/blank_sidebar' : @content_for_sidebar ) 
  site_name 
 image_tag('icons/loading.gif') 
 

end

  end
end

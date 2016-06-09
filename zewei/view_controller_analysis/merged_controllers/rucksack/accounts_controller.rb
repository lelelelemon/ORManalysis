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

class AccountsController < ApplicationController
  layout 'pages'

  # GET /settings
  # GET /settings.xml
  def show
    @account = Account.owner

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 " - " 
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
 # Top of page (tabs, user box, etc) 
  if !@tabbed_navigation_items.nil? 
 @tabbed_navigation_items.each do |item| 
 if !site_account.send("_hidden?") 
 item[:url] 
 t item[:id] 
 end 
 end 
 end 
 if !@user_navigation_items.nil? 
 @user_navigation_items.each do |item| 
 item[:url] 
 t item[:id] 
 end 
 if @logged_user.can_be_edited_by(@logged_user) 
 current_users_path 
 t('my_profile') 
 t('logout') 
 end 
 end 
 
 # Displays general alerts 
 status_bar 
 if @no_page_tile.nil? 
 h @page_title 
 end 
 # Content 
 @page_title = t('settings') 
 @tabbed_navigation_items = common_tabs(nil) 
 @user_navigation_items = user_tabs(:settings) 
 form_tag account_path(), :method => :put do 
  error_messages_for :account 
 t('site_name') 
 text_field 'account', 'site_name', :id => 'settingsFormSiteName', :class => 'long' 
 t('site_name_info') 
 t('host_name') 
 text_field 'account', 'host_name', :id => 'settingsFormHostName', :class => 'moderate' 
 t('host_name_info') 
 t('tabs_visible') 
 "()" 
 Account::Tabs.each do |tab| 
 check_box 'account', "_hidden", :id => "setting__hidden" 
 t tab 
 end 
 Account::Colours.each do |colour| 
 " " 
 text_field 'account', "_colour", :id => 'setting__colour', :class => 'short' 
 "()" 
 end 
 
 end 
 render :partial => (@content_for_sidebar.nil? ? 'layouts/blank_sidebar' : @content_for_sidebar ) 
  site_name 
 image_tag('icons/loading.gif') 
 

end
 }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 " - " 
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
 # Top of page (tabs, user box, etc) 
  if !@tabbed_navigation_items.nil? 
 @tabbed_navigation_items.each do |item| 
 if !site_account.send("_hidden?") 
 item[:url] 
 t item[:id] 
 end 
 end 
 end 
 if !@user_navigation_items.nil? 
 @user_navigation_items.each do |item| 
 item[:url] 
 t item[:id] 
 end 
 if @logged_user.can_be_edited_by(@logged_user) 
 current_users_path 
 t('my_profile') 
 t('logout') 
 end 
 end 
 
 # Displays general alerts 
 status_bar 
 if @no_page_tile.nil? 
 h @page_title 
 end 
 # Content 
 @page_title = t('settings') 
 @tabbed_navigation_items = common_tabs(nil) 
 @user_navigation_items = user_tabs(:settings) 
 form_tag account_path(), :method => :put do 
  error_messages_for :account 
 t('site_name') 
 text_field 'account', 'site_name', :id => 'settingsFormSiteName', :class => 'long' 
 t('site_name_info') 
 t('host_name') 
 text_field 'account', 'host_name', :id => 'settingsFormHostName', :class => 'moderate' 
 t('host_name_info') 
 t('tabs_visible') 
 "()" 
 Account::Tabs.each do |tab| 
 check_box 'account', "_hidden", :id => "setting__hidden" 
 t tab 
 end 
 Account::Colours.each do |colour| 
 " " 
 text_field 'account', "_colour", :id => 'setting__colour', :class => 'short' 
 "()" 
 end 
 
 end 
 render :partial => (@content_for_sidebar.nil? ? 'layouts/blank_sidebar' : @content_for_sidebar ) 
  site_name 
 image_tag('icons/loading.gif') 
 

end

  end
  
  # PUT /settings
  # PUT /settings.xml
  def update
    @account = Account.owner

    respond_to do |format|
      if @account.update_attributes(params[:account])
        flash[:notice] = t('settings_updated')
        format.html { redirect_back_or_default(:action => 'show') }
        format.xml  { head :ok }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 " - " 
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
 # Top of page (tabs, user box, etc) 
  if !@tabbed_navigation_items.nil? 
 @tabbed_navigation_items.each do |item| 
 if !site_account.send("_hidden?") 
 item[:url] 
 t item[:id] 
 end 
 end 
 end 
 if !@user_navigation_items.nil? 
 @user_navigation_items.each do |item| 
 item[:url] 
 t item[:id] 
 end 
 if @logged_user.can_be_edited_by(@logged_user) 
 current_users_path 
 t('my_profile') 
 t('logout') 
 end 
 end 
 
 # Displays general alerts 
 status_bar 
 if @no_page_tile.nil? 
 h @page_title 
 end 
 # Content 
 @page_title = t('settings') 
 @tabbed_navigation_items = common_tabs(nil) 
 @user_navigation_items = user_tabs(:settings) 
 form_tag account_path(), :method => :put do 
  error_messages_for :account 
 t('site_name') 
 text_field 'account', 'site_name', :id => 'settingsFormSiteName', :class => 'long' 
 t('site_name_info') 
 t('host_name') 
 text_field 'account', 'host_name', :id => 'settingsFormHostName', :class => 'moderate' 
 t('host_name_info') 
 t('tabs_visible') 
 "()" 
 Account::Tabs.each do |tab| 
 check_box 'account', "_hidden", :id => "setting__hidden" 
 t tab 
 end 
 Account::Colours.each do |colour| 
 " " 
 text_field 'account', "_colour", :id => 'setting__colour', :class => 'short' 
 "()" 
 end 
 
 end 
 render :partial => (@content_for_sidebar.nil? ? 'layouts/blank_sidebar' : @content_for_sidebar ) 
  site_name 
 image_tag('icons/loading.gif') 
 

end
 }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

protected

  def authorized?(action = action_name, resource = nil)
    logged_in? and @logged_user.owner_of_owner?
  end

end

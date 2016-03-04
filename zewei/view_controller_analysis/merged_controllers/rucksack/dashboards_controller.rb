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

class DashboardsController < ApplicationController
  layout 'pages'
  
  # GET /dashboard
  def show
    @cached_users = {}
    @recent_activities = ApplicationLog.grouped_nicely(@logged_user).group_by do |obj|
      obj.created_on.to_date.to_s
    end.map do |date, items|
      [date, items.group_by { |obj| @cached_users[obj.created_by_id] ||= obj.created_by; obj.created_by_id }.map{|k,v|[k,v]}]
    end
    
    respond_to do |format|
      format.html # show.html.erb
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title = t('overview') 
 @tabbed_navigation_items = common_tabs(:overview) 
 @user_navigation_items = user_tabs(nil) 
 @recent_activities.each do |items| 
 items[0] 
  user = @cached_users[user_activity[0]] 
 user.gravatar_url(:size => 30) 
 user.id == @logged_user.id ? t('you') : user.display_name 
 user_activity[1].each do |log| 
 if !log.page_id.nil? 
 raw(t "activity_edit_Page", :object_name => h(log.page.object_name), :previous_name => h(log.previous_name), :url => !log.page.nil? ? url_for(log.page) : '#') 
 else 
 raw(t "activity_#{log.action}_#{log.rel_object_type}", :object_name => h(log.object_name), :previous_name => h(log.previous_name), :url => !log.rel_object.nil? ? url_for(log.rel_object) : '#') 
 end 
 end 
 
 end 

end

  end

protected

  def authorized?(action = action_name, resource = nil)
    logged_in? and @logged_user.member_of_owner?
  end
end

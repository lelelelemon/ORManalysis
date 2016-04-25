#==
# RailsCollab
# Copyright (C) 2007 - 2011 James S Urquhart
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++

class CategoriesController < ApplicationController

  layout 'project_website'
  helper 'project_items'

  before_filter :process_session
  after_filter  :user_track, :only => [:index, :show]
  
  # GET /categories
  # GET /categories.xml
  def index
    @categories = @active_project.categories
    
    respond_to do |format|
      format.html {}
      format.xml  {
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 unless @active_project.nil? 
 h @active_project.name 
 h page_title 
 h Company.owner.name 
 else 
 h page_title 
 h Company.owner.name 
 end 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'application.js' 
 javascript_tag "var PROJECT_ID = #{@active_project.id}; var LOGGED_USER_ID=#{@logged_user.id};" 
 unless @active_project.is_active? 
 t('project_locked_header') 
 if can?(:change_status, @active_project) 
 link_to t('mark_project_as_active'), open_project_path(:id => @active_project.id), :method => :put, :confirm => t('mark_project_as_active_confirmation') 
 end 
 end 
 h @active_project.name 
  if user.is_anonymous? 
 t('welcome_anonymous') 
 link_to(t('login'), logout_path) 
 else 
 t('welcome_back', :user => h(user.display_name)).html_safe 
 link_to t('logout'), logout_path, :confirm => t('are_you_sure_logout') 
 end 
 @running_times.empty? ? 'none' : 'block' 
 t('running_times', :count => @running_times.size) 
 render_icon 'bullet_drop_down', '', :id => 'running_times', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 unless user.is_anonymous? 
 link_to t('account'), @logged_user 
 render_icon 'bullet_drop_down', '', :id => 'account_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless projects.blank? 
 link_to t('projects'), :controller => 'dashboard', :action => 'my_projects' 
 render_icon 'bullet_drop_down', '', :id => 'projects_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 if user.is_admin 
 link_to t('administration'), :controller => 'administration' 
 render_icon 'bullet_drop_down', '', :id => 'administration_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless user.is_anonymous? 
 t('account') 
 link_to t('edit_profile'), edit_user_path(:id => user.id) 
 link_to t('update_avatar'), avatar_user_path(:id => user.id) 
 t('userbox_more') 
 link_to t('my_projects'), :controller => 'dashboard', :action => 'my_projects' 
 link_to t('my_tasks'), :controller => 'dashboard', :action => 'my_tasks' 
 end 
 unless projects.blank? 
 t('projects') 
 projects.each do |project| 
 link_to h(project.name), project_path(:id => project.id) 
 end 
 end 
 if user.is_admin 
 t('administration') 
 link_to t('company'), Company.owner 
 link_to t('members'), companies_path 
 link_to t('projects'), projects_path 
 end 
  listed.id 
 link_to h(listed.name), listed.object_url 
 link_to render_icon('stop', t('stop_time')), stop_time_path(:active_project => listed.project_id , :id => listed.id), :class => 'blank stopTime' 
 
 
  unless tabs.nil? 
 current_tab = self.current_tab 
 tabs.each do |item| 
 "item_#{item[:id]}" 
 'class="active"'.html_safe if item[:id] == current_tab 
 item[:url] 
 t(item[:id]) 
 end 
 end 
 
  unless crumbs.nil? 
 crumbs.each do |crumb| 
 if crumb[:url] 
 crumb[:url] 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 else 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 end 
 end 
 end 
 
 if Rails.configuration.search_enabled 
 form_tag search_project_path(:id => @active_project.id) 

  @search_field_default_value = t('search_box_default')
  @last_search ||= @search_field_default_value
  @search_field_attrs = {
    :onfocus => "if (event.target.value == '#{@search_field_default_value}') event.target.value=''",
    :onblur => "if (event.target.value == '#{@search_field_default_value}') event.target.value=''"
  }

 text_field_tag 'search_id', (h @last_search), @search_field_attrs 
 t('go') 
 end 
 if flash[:message] 
 flash[:error] ? 'error' : 'success' 
 flash[:error] ? 'flash_error' : 'flash_success' 
 h flash[:message] 
 end 
 h page_title 
 if @private_object 
 image_path('icons/private.gif') 
 end 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 
 if @categories.length > 0 
  task_list = show 
 task_list.id 
 if task_list.is_private? 
 t('private_task_list') 
 t('private_task_list') 
 end 
 link_to (h task_list.name), task_list_path(:id => task_list.id) 
 if task_list.description 
 textilize task_list.description 
 end 
 task_list.id 
 if task_list.open_tasks.length > 0 
  task_item = show 
 task_item.id 
 if can?(:edit,task_item) && !task_item.is_completed? 
 end 
 if can?(:edit,task_item) 
 link_to render_icon('trash', 'Trash'), task_path(:id => task_item.id, :task_list_id => task_item.task_list_id), {:confirm => t('task_delete_confirm'), :method => :delete, :class => 'blank taskDelete', 'data-remote' => true, 'data-type' => :json} 
 link_to 'Edit', edit_task_path(:id => task_item.id, :task_list_id => task_item.task_list_id), {:class => 'blank taskEdit edit', 'data-remote' => true, 'data-type' => :json} 
 end 
 if can?(:edit,task_item) 
 if task_item.is_completed? 
 end 
 link_to '', status_task_path(:id => task_item, :task_list_id => task_item.task_list_id) 
 else 
 render_icon( (task_item.completed_on.nil? ? 'not-checked' : 'checked'), t('task_open')) 
 end 
 if not task_item.assigned_to.nil? 
 task_item.assigned_to.object_name 
 end 
 h task_item.text 
 t('task_created_by', 
                            :user => link_to(h(task_item.created_by.display_name), user_path(:id => task_item.created_by_id))).html_safe 
 if task_item.is_completed? 
 t('task_list_completed_time_with_user', 
                            :time => format_usertime(task_item.completed_on, :task_list_completed_time_format),
                            :user => link_to_unless(task_item.completed_by.nil?, h(task_item.completed_by.try(:display_name)), user_path(:id => task_item.completed_by_id))).html_safe 
 end 
 if can?(:comment, task_item) 
 link_to render_icon('comment','', { :class => "comment" }), task_path(:id => task_item.id, :task_list_id => task_item.task_list_id), {:class => 'blank'} 
 end 
 if !task_item.is_completed? && can?(:create_time, task_item.project) 
 running_time = running_time_for_task(task_item) 
unless running_time.nil? 
 link_to render_icon('stop', t('stop_time')), stop_time_path(:active_project => running_time.project_id, :id => running_time.id), :class => 'blank stopTime' 
 else 
 link_to render_icon('start', t('start_time')), times_path, :class => 'blank startTime', :task_id => task_item.id 
 end 
 end 
 
 end 
 if can?(:edit,task_list) 
  show_form = @new_list.nil? ? false : true 
 if show_form 
 end 
 link_to t('add_task'), new_task_path(:task_list_id => task_list.id) 
 unless show_form 
 end 
 form_tag tasks_path(:task_list_id => task_list.id), { 'data-remote' => true, 'data-type' => :json } do 
  task = form 
 error_messages_for :task, :object => task 
 if not task.new_record? and @no_show_list.nil? 
 task.id 
 t('task_list') 
 select 'task', 'task_list_id', TaskList.select_list(@active_project), {}, :id => "addTaskTaskList#{task.id}" 
 end 
 task.id 
 t('text') 
 text_area 'task', 'text', :id => "addTaskText#{task.id}", :class => 'short autofocus', :rows => 10, :cols => 40  
 task.id 
 t('assign_to') 
 assign_project_select 'task', 'assigned_to_id', @active_project, :id => "taskAssignedTo#{task.id}" 
 check_box_tag 'send_notification', '1', params[:send_notification], :id => "taskSendNotification#{task.id}", :class => 'checkbox'  
 task.id 
 t('send_email_notification_to_user') 
 t('estimated_hours') 
 text_field 'task', 'estimated_hours', :id => 'addTaskHours', :class => 'short' 
 
 end 
 end 
 if on_list_page 
 t('completed_tasks') 
 else 
 t('recent_completed_tasks') 
 end 
  task_item = show 
 task_item.id 
 if can?(:edit,task_item) && !task_item.is_completed? 
 end 
 if can?(:edit,task_item) 
 link_to render_icon('trash', 'Trash'), task_path(:id => task_item.id, :task_list_id => task_item.task_list_id), {:confirm => t('task_delete_confirm'), :method => :delete, :class => 'blank taskDelete', 'data-remote' => true, 'data-type' => :json} 
 link_to 'Edit', edit_task_path(:id => task_item.id, :task_list_id => task_item.task_list_id), {:class => 'blank taskEdit edit', 'data-remote' => true, 'data-type' => :json} 
 end 
 if can?(:edit,task_item) 
 if task_item.is_completed? 
 end 
 link_to '', status_task_path(:id => task_item, :task_list_id => task_item.task_list_id) 
 else 
 render_icon( (task_item.completed_on.nil? ? 'not-checked' : 'checked'), t('task_open')) 
 end 
 if not task_item.assigned_to.nil? 
 task_item.assigned_to.object_name 
 end 
 h task_item.text 
 t('task_created_by', 
                            :user => link_to(h(task_item.created_by.display_name), user_path(:id => task_item.created_by_id))).html_safe 
 if task_item.is_completed? 
 t('task_list_completed_time_with_user', 
                            :time => format_usertime(task_item.completed_on, :task_list_completed_time_format),
                            :user => link_to_unless(task_item.completed_by.nil?, h(task_item.completed_by.try(:display_name)), user_path(:id => task_item.completed_by_id))).html_safe 
 end 
 if can?(:comment, task_item) 
 link_to render_icon('comment','', { :class => "comment" }), task_path(:id => task_item.id, :task_list_id => task_item.task_list_id), {:class => 'blank'} 
 end 
 if !task_item.is_completed? && can?(:create_time, task_item.project) 
 running_time = running_time_for_task(task_item) 
unless running_time.nil? 
 link_to render_icon('stop', t('stop_time')), stop_time_path(:active_project => running_time.project_id, :id => running_time.id), :class => 'blank stopTime' 
 else 
 link_to render_icon('start', t('start_time')), times_path, :class => 'blank startTime', :task_id => task_item.id 
 end 
 end 
 
 if !on_list_page and task_list.completed_tasks.length > 5 
 link_to t('view_all_completed_tasks'), :controller => 'task_lists', :action => 'show', :id => task_list.id 
 end 
 t('tags') 
 tag_list task_list 
 action_list actions_for_task_list(task_list) 
 t('edit_tasks') 
 
 else 
 t('config_category_empty') 
 end 
 unless @content_for_sidebar.nil? 
 render :partial => @content_for_sidebar 
 end 
  if not Company.owner.homepage.nil? 
 Company.owner.homepage 
 Company.owner.name 
 else 
 Company.owner.name 
 end 
 product_signature 
 

end

      }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 unless @active_project.nil? 
 h @active_project.name 
 h page_title 
 h Company.owner.name 
 else 
 h page_title 
 h Company.owner.name 
 end 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'application.js' 
 javascript_tag "var PROJECT_ID = #{@active_project.id}; var LOGGED_USER_ID=#{@logged_user.id};" 
 unless @active_project.is_active? 
 t('project_locked_header') 
 if can?(:change_status, @active_project) 
 link_to t('mark_project_as_active'), open_project_path(:id => @active_project.id), :method => :put, :confirm => t('mark_project_as_active_confirmation') 
 end 
 end 
 h @active_project.name 
  if user.is_anonymous? 
 t('welcome_anonymous') 
 link_to(t('login'), logout_path) 
 else 
 t('welcome_back', :user => h(user.display_name)).html_safe 
 link_to t('logout'), logout_path, :confirm => t('are_you_sure_logout') 
 end 
 @running_times.empty? ? 'none' : 'block' 
 t('running_times', :count => @running_times.size) 
 render_icon 'bullet_drop_down', '', :id => 'running_times', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 unless user.is_anonymous? 
 link_to t('account'), @logged_user 
 render_icon 'bullet_drop_down', '', :id => 'account_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless projects.blank? 
 link_to t('projects'), :controller => 'dashboard', :action => 'my_projects' 
 render_icon 'bullet_drop_down', '', :id => 'projects_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 if user.is_admin 
 link_to t('administration'), :controller => 'administration' 
 render_icon 'bullet_drop_down', '', :id => 'administration_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless user.is_anonymous? 
 t('account') 
 link_to t('edit_profile'), edit_user_path(:id => user.id) 
 link_to t('update_avatar'), avatar_user_path(:id => user.id) 
 t('userbox_more') 
 link_to t('my_projects'), :controller => 'dashboard', :action => 'my_projects' 
 link_to t('my_tasks'), :controller => 'dashboard', :action => 'my_tasks' 
 end 
 unless projects.blank? 
 t('projects') 
 projects.each do |project| 
 link_to h(project.name), project_path(:id => project.id) 
 end 
 end 
 if user.is_admin 
 t('administration') 
 link_to t('company'), Company.owner 
 link_to t('members'), companies_path 
 link_to t('projects'), projects_path 
 end 
  listed.id 
 link_to h(listed.name), listed.object_url 
 link_to render_icon('stop', t('stop_time')), stop_time_path(:active_project => listed.project_id , :id => listed.id), :class => 'blank stopTime' 
 
 
  unless tabs.nil? 
 current_tab = self.current_tab 
 tabs.each do |item| 
 "item_#{item[:id]}" 
 'class="active"'.html_safe if item[:id] == current_tab 
 item[:url] 
 t(item[:id]) 
 end 
 end 
 
  unless crumbs.nil? 
 crumbs.each do |crumb| 
 if crumb[:url] 
 crumb[:url] 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 else 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 end 
 end 
 end 
 
 if Rails.configuration.search_enabled 
 form_tag search_project_path(:id => @active_project.id) 

  @search_field_default_value = t('search_box_default')
  @last_search ||= @search_field_default_value
  @search_field_attrs = {
    :onfocus => "if (event.target.value == '#{@search_field_default_value}') event.target.value=''",
    :onblur => "if (event.target.value == '#{@search_field_default_value}') event.target.value=''"
  }

 text_field_tag 'search_id', (h @last_search), @search_field_attrs 
 t('go') 
 end 
 if flash[:message] 
 flash[:error] ? 'error' : 'success' 
 flash[:error] ? 'flash_error' : 'flash_success' 
 h flash[:message] 
 end 
 h page_title 
 if @private_object 
 image_path('icons/private.gif') 
 end 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 
 if @categories.length > 0 
  task_list = show 
 task_list.id 
 if task_list.is_private? 
 t('private_task_list') 
 t('private_task_list') 
 end 
 link_to (h task_list.name), task_list_path(:id => task_list.id) 
 if task_list.description 
 textilize task_list.description 
 end 
 task_list.id 
 if task_list.open_tasks.length > 0 
  task_item = show 
 task_item.id 
 if can?(:edit,task_item) && !task_item.is_completed? 
 end 
 if can?(:edit,task_item) 
 link_to render_icon('trash', 'Trash'), task_path(:id => task_item.id, :task_list_id => task_item.task_list_id), {:confirm => t('task_delete_confirm'), :method => :delete, :class => 'blank taskDelete', 'data-remote' => true, 'data-type' => :json} 
 link_to 'Edit', edit_task_path(:id => task_item.id, :task_list_id => task_item.task_list_id), {:class => 'blank taskEdit edit', 'data-remote' => true, 'data-type' => :json} 
 end 
 if can?(:edit,task_item) 
 if task_item.is_completed? 
 end 
 link_to '', status_task_path(:id => task_item, :task_list_id => task_item.task_list_id) 
 else 
 render_icon( (task_item.completed_on.nil? ? 'not-checked' : 'checked'), t('task_open')) 
 end 
 if not task_item.assigned_to.nil? 
 task_item.assigned_to.object_name 
 end 
 h task_item.text 
 t('task_created_by', 
                            :user => link_to(h(task_item.created_by.display_name), user_path(:id => task_item.created_by_id))).html_safe 
 if task_item.is_completed? 
 t('task_list_completed_time_with_user', 
                            :time => format_usertime(task_item.completed_on, :task_list_completed_time_format),
                            :user => link_to_unless(task_item.completed_by.nil?, h(task_item.completed_by.try(:display_name)), user_path(:id => task_item.completed_by_id))).html_safe 
 end 
 if can?(:comment, task_item) 
 link_to render_icon('comment','', { :class => "comment" }), task_path(:id => task_item.id, :task_list_id => task_item.task_list_id), {:class => 'blank'} 
 end 
 if !task_item.is_completed? && can?(:create_time, task_item.project) 
 running_time = running_time_for_task(task_item) 
unless running_time.nil? 
 link_to render_icon('stop', t('stop_time')), stop_time_path(:active_project => running_time.project_id, :id => running_time.id), :class => 'blank stopTime' 
 else 
 link_to render_icon('start', t('start_time')), times_path, :class => 'blank startTime', :task_id => task_item.id 
 end 
 end 
 
 end 
 if can?(:edit,task_list) 
  show_form = @new_list.nil? ? false : true 
 if show_form 
 end 
 link_to t('add_task'), new_task_path(:task_list_id => task_list.id) 
 unless show_form 
 end 
 form_tag tasks_path(:task_list_id => task_list.id), { 'data-remote' => true, 'data-type' => :json } do 
  task = form 
 error_messages_for :task, :object => task 
 if not task.new_record? and @no_show_list.nil? 
 task.id 
 t('task_list') 
 select 'task', 'task_list_id', TaskList.select_list(@active_project), {}, :id => "addTaskTaskList#{task.id}" 
 end 
 task.id 
 t('text') 
 text_area 'task', 'text', :id => "addTaskText#{task.id}", :class => 'short autofocus', :rows => 10, :cols => 40  
 task.id 
 t('assign_to') 
 assign_project_select 'task', 'assigned_to_id', @active_project, :id => "taskAssignedTo#{task.id}" 
 check_box_tag 'send_notification', '1', params[:send_notification], :id => "taskSendNotification#{task.id}", :class => 'checkbox'  
 task.id 
 t('send_email_notification_to_user') 
 t('estimated_hours') 
 text_field 'task', 'estimated_hours', :id => 'addTaskHours', :class => 'short' 
 
 end 
 end 
 if on_list_page 
 t('completed_tasks') 
 else 
 t('recent_completed_tasks') 
 end 
  task_item = show 
 task_item.id 
 if can?(:edit,task_item) && !task_item.is_completed? 
 end 
 if can?(:edit,task_item) 
 link_to render_icon('trash', 'Trash'), task_path(:id => task_item.id, :task_list_id => task_item.task_list_id), {:confirm => t('task_delete_confirm'), :method => :delete, :class => 'blank taskDelete', 'data-remote' => true, 'data-type' => :json} 
 link_to 'Edit', edit_task_path(:id => task_item.id, :task_list_id => task_item.task_list_id), {:class => 'blank taskEdit edit', 'data-remote' => true, 'data-type' => :json} 
 end 
 if can?(:edit,task_item) 
 if task_item.is_completed? 
 end 
 link_to '', status_task_path(:id => task_item, :task_list_id => task_item.task_list_id) 
 else 
 render_icon( (task_item.completed_on.nil? ? 'not-checked' : 'checked'), t('task_open')) 
 end 
 if not task_item.assigned_to.nil? 
 task_item.assigned_to.object_name 
 end 
 h task_item.text 
 t('task_created_by', 
                            :user => link_to(h(task_item.created_by.display_name), user_path(:id => task_item.created_by_id))).html_safe 
 if task_item.is_completed? 
 t('task_list_completed_time_with_user', 
                            :time => format_usertime(task_item.completed_on, :task_list_completed_time_format),
                            :user => link_to_unless(task_item.completed_by.nil?, h(task_item.completed_by.try(:display_name)), user_path(:id => task_item.completed_by_id))).html_safe 
 end 
 if can?(:comment, task_item) 
 link_to render_icon('comment','', { :class => "comment" }), task_path(:id => task_item.id, :task_list_id => task_item.task_list_id), {:class => 'blank'} 
 end 
 if !task_item.is_completed? && can?(:create_time, task_item.project) 
 running_time = running_time_for_task(task_item) 
unless running_time.nil? 
 link_to render_icon('stop', t('stop_time')), stop_time_path(:active_project => running_time.project_id, :id => running_time.id), :class => 'blank stopTime' 
 else 
 link_to render_icon('start', t('start_time')), times_path, :class => 'blank startTime', :task_id => task_item.id 
 end 
 end 
 
 if !on_list_page and task_list.completed_tasks.length > 5 
 link_to t('view_all_completed_tasks'), :controller => 'task_lists', :action => 'show', :id => task_list.id 
 end 
 t('tags') 
 tag_list task_list 
 action_list actions_for_task_list(task_list) 
 t('edit_tasks') 
 
 else 
 t('config_category_empty') 
 end 
 unless @content_for_sidebar.nil? 
 render :partial => @content_for_sidebar 
 end 
  if not Company.owner.homepage.nil? 
 Company.owner.homepage 
 Company.owner.name 
 else 
 Company.owner.name 
 end 
 product_signature 
 

end

  end

  # GET /categories/1
  # GET /categories/1.xml
  def show
    begin
      @category = @active_project.categories.find(params[:id])
    rescue
      return error_status(true, :invalid_message_category)
    end
    
    authorize! :show, @category
    
    respond_to do |format|
      format.html {
        @content_for_sidebar = 'messages/index_sidebar'
      }
      format.xml  { 
        render :xml => @category.to_xml
      }
    end
  end

  # GET /categories/new
  # GET /categories/new.xml
  def new
    authorize! :create_message_category, @active_project
    
    @category = @active_project.categories.build()
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 unless @active_project.nil? 
 h @active_project.name 
 h page_title 
 h Company.owner.name 
 else 
 h page_title 
 h Company.owner.name 
 end 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'application.js' 
 javascript_tag "var PROJECT_ID = #{@active_project.id}; var LOGGED_USER_ID=#{@logged_user.id};" 
 unless @active_project.is_active? 
 t('project_locked_header') 
 if can?(:change_status, @active_project) 
 link_to t('mark_project_as_active'), open_project_path(:id => @active_project.id), :method => :put, :confirm => t('mark_project_as_active_confirmation') 
 end 
 end 
 h @active_project.name 
  if user.is_anonymous? 
 t('welcome_anonymous') 
 link_to(t('login'), logout_path) 
 else 
 t('welcome_back', :user => h(user.display_name)).html_safe 
 link_to t('logout'), logout_path, :confirm => t('are_you_sure_logout') 
 end 
 @running_times.empty? ? 'none' : 'block' 
 t('running_times', :count => @running_times.size) 
 render_icon 'bullet_drop_down', '', :id => 'running_times', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 unless user.is_anonymous? 
 link_to t('account'), @logged_user 
 render_icon 'bullet_drop_down', '', :id => 'account_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless projects.blank? 
 link_to t('projects'), :controller => 'dashboard', :action => 'my_projects' 
 render_icon 'bullet_drop_down', '', :id => 'projects_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 if user.is_admin 
 link_to t('administration'), :controller => 'administration' 
 render_icon 'bullet_drop_down', '', :id => 'administration_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless user.is_anonymous? 
 t('account') 
 link_to t('edit_profile'), edit_user_path(:id => user.id) 
 link_to t('update_avatar'), avatar_user_path(:id => user.id) 
 t('userbox_more') 
 link_to t('my_projects'), :controller => 'dashboard', :action => 'my_projects' 
 link_to t('my_tasks'), :controller => 'dashboard', :action => 'my_tasks' 
 end 
 unless projects.blank? 
 t('projects') 
 projects.each do |project| 
 link_to h(project.name), project_path(:id => project.id) 
 end 
 end 
 if user.is_admin 
 t('administration') 
 link_to t('company'), Company.owner 
 link_to t('members'), companies_path 
 link_to t('projects'), projects_path 
 end 
  listed.id 
 link_to h(listed.name), listed.object_url 
 link_to render_icon('stop', t('stop_time')), stop_time_path(:active_project => listed.project_id , :id => listed.id), :class => 'blank stopTime' 
 
 
  unless tabs.nil? 
 current_tab = self.current_tab 
 tabs.each do |item| 
 "item_#{item[:id]}" 
 'class="active"'.html_safe if item[:id] == current_tab 
 item[:url] 
 t(item[:id]) 
 end 
 end 
 
  unless crumbs.nil? 
 crumbs.each do |crumb| 
 if crumb[:url] 
 crumb[:url] 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 else 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 end 
 end 
 end 
 
 if Rails.configuration.search_enabled 
 form_tag search_project_path(:id => @active_project.id) 

  @search_field_default_value = t('search_box_default')
  @last_search ||= @search_field_default_value
  @search_field_attrs = {
    :onfocus => "if (event.target.value == '#{@search_field_default_value}') event.target.value=''",
    :onblur => "if (event.target.value == '#{@search_field_default_value}') event.target.value=''"
  }

 text_field_tag 'search_id', (h @last_search), @search_field_attrs 
 t('go') 
 end 
 if flash[:message] 
 flash[:error] ? 'error' : 'success' 
 flash[:error] ? 'flash_error' : 'flash_success' 
 h flash[:message] 
 end 
 h page_title 
 if @private_object 
 image_path('icons/private.gif') 
 end 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 
 form_tag categories_path 
  error_messages_for :category 
 t('name') 
 text_field 'category', 'name', :id => 'categoryFormName' 
 
 t('add_category') 
 unless @content_for_sidebar.nil? 
 render :partial => @content_for_sidebar 
 end 
  if not Company.owner.homepage.nil? 
 Company.owner.homepage 
 Company.owner.name 
 else 
 Company.owner.name 
 end 
 product_signature 
 

end
 }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 unless @active_project.nil? 
 h @active_project.name 
 h page_title 
 h Company.owner.name 
 else 
 h page_title 
 h Company.owner.name 
 end 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'application.js' 
 javascript_tag "var PROJECT_ID = #{@active_project.id}; var LOGGED_USER_ID=#{@logged_user.id};" 
 unless @active_project.is_active? 
 t('project_locked_header') 
 if can?(:change_status, @active_project) 
 link_to t('mark_project_as_active'), open_project_path(:id => @active_project.id), :method => :put, :confirm => t('mark_project_as_active_confirmation') 
 end 
 end 
 h @active_project.name 
  if user.is_anonymous? 
 t('welcome_anonymous') 
 link_to(t('login'), logout_path) 
 else 
 t('welcome_back', :user => h(user.display_name)).html_safe 
 link_to t('logout'), logout_path, :confirm => t('are_you_sure_logout') 
 end 
 @running_times.empty? ? 'none' : 'block' 
 t('running_times', :count => @running_times.size) 
 render_icon 'bullet_drop_down', '', :id => 'running_times', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 unless user.is_anonymous? 
 link_to t('account'), @logged_user 
 render_icon 'bullet_drop_down', '', :id => 'account_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless projects.blank? 
 link_to t('projects'), :controller => 'dashboard', :action => 'my_projects' 
 render_icon 'bullet_drop_down', '', :id => 'projects_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 if user.is_admin 
 link_to t('administration'), :controller => 'administration' 
 render_icon 'bullet_drop_down', '', :id => 'administration_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless user.is_anonymous? 
 t('account') 
 link_to t('edit_profile'), edit_user_path(:id => user.id) 
 link_to t('update_avatar'), avatar_user_path(:id => user.id) 
 t('userbox_more') 
 link_to t('my_projects'), :controller => 'dashboard', :action => 'my_projects' 
 link_to t('my_tasks'), :controller => 'dashboard', :action => 'my_tasks' 
 end 
 unless projects.blank? 
 t('projects') 
 projects.each do |project| 
 link_to h(project.name), project_path(:id => project.id) 
 end 
 end 
 if user.is_admin 
 t('administration') 
 link_to t('company'), Company.owner 
 link_to t('members'), companies_path 
 link_to t('projects'), projects_path 
 end 
  listed.id 
 link_to h(listed.name), listed.object_url 
 link_to render_icon('stop', t('stop_time')), stop_time_path(:active_project => listed.project_id , :id => listed.id), :class => 'blank stopTime' 
 
 
  unless tabs.nil? 
 current_tab = self.current_tab 
 tabs.each do |item| 
 "item_#{item[:id]}" 
 'class="active"'.html_safe if item[:id] == current_tab 
 item[:url] 
 t(item[:id]) 
 end 
 end 
 
  unless crumbs.nil? 
 crumbs.each do |crumb| 
 if crumb[:url] 
 crumb[:url] 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 else 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 end 
 end 
 end 
 
 if Rails.configuration.search_enabled 
 form_tag search_project_path(:id => @active_project.id) 

  @search_field_default_value = t('search_box_default')
  @last_search ||= @search_field_default_value
  @search_field_attrs = {
    :onfocus => "if (event.target.value == '#{@search_field_default_value}') event.target.value=''",
    :onblur => "if (event.target.value == '#{@search_field_default_value}') event.target.value=''"
  }

 text_field_tag 'search_id', (h @last_search), @search_field_attrs 
 t('go') 
 end 
 if flash[:message] 
 flash[:error] ? 'error' : 'success' 
 flash[:error] ? 'flash_error' : 'flash_success' 
 h flash[:message] 
 end 
 h page_title 
 if @private_object 
 image_path('icons/private.gif') 
 end 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 
 form_tag categories_path 
  error_messages_for :category 
 t('name') 
 text_field 'category', 'name', :id => 'categoryFormName' 
 
 t('add_category') 
 unless @content_for_sidebar.nil? 
 render :partial => @content_for_sidebar 
 end 
  if not Company.owner.homepage.nil? 
 Company.owner.homepage 
 Company.owner.name 
 else 
 Company.owner.name 
 end 
 product_signature 
 

end

  end

  # GET /categories/1/edit
  def edit
    begin
      @category = @active_project.categories.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      return error_status(true, :invalid_message_category)
    end
    
    authorize! :edit, @category
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 unless @active_project.nil? 
 h @active_project.name 
 h page_title 
 h Company.owner.name 
 else 
 h page_title 
 h Company.owner.name 
 end 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'application.js' 
 javascript_tag "var PROJECT_ID = #{@active_project.id}; var LOGGED_USER_ID=#{@logged_user.id};" 
 unless @active_project.is_active? 
 t('project_locked_header') 
 if can?(:change_status, @active_project) 
 link_to t('mark_project_as_active'), open_project_path(:id => @active_project.id), :method => :put, :confirm => t('mark_project_as_active_confirmation') 
 end 
 end 
 h @active_project.name 
  if user.is_anonymous? 
 t('welcome_anonymous') 
 link_to(t('login'), logout_path) 
 else 
 t('welcome_back', :user => h(user.display_name)).html_safe 
 link_to t('logout'), logout_path, :confirm => t('are_you_sure_logout') 
 end 
 @running_times.empty? ? 'none' : 'block' 
 t('running_times', :count => @running_times.size) 
 render_icon 'bullet_drop_down', '', :id => 'running_times', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 unless user.is_anonymous? 
 link_to t('account'), @logged_user 
 render_icon 'bullet_drop_down', '', :id => 'account_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless projects.blank? 
 link_to t('projects'), :controller => 'dashboard', :action => 'my_projects' 
 render_icon 'bullet_drop_down', '', :id => 'projects_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 if user.is_admin 
 link_to t('administration'), :controller => 'administration' 
 render_icon 'bullet_drop_down', '', :id => 'administration_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless user.is_anonymous? 
 t('account') 
 link_to t('edit_profile'), edit_user_path(:id => user.id) 
 link_to t('update_avatar'), avatar_user_path(:id => user.id) 
 t('userbox_more') 
 link_to t('my_projects'), :controller => 'dashboard', :action => 'my_projects' 
 link_to t('my_tasks'), :controller => 'dashboard', :action => 'my_tasks' 
 end 
 unless projects.blank? 
 t('projects') 
 projects.each do |project| 
 link_to h(project.name), project_path(:id => project.id) 
 end 
 end 
 if user.is_admin 
 t('administration') 
 link_to t('company'), Company.owner 
 link_to t('members'), companies_path 
 link_to t('projects'), projects_path 
 end 
  listed.id 
 link_to h(listed.name), listed.object_url 
 link_to render_icon('stop', t('stop_time')), stop_time_path(:active_project => listed.project_id , :id => listed.id), :class => 'blank stopTime' 
 
 
  unless tabs.nil? 
 current_tab = self.current_tab 
 tabs.each do |item| 
 "item_#{item[:id]}" 
 'class="active"'.html_safe if item[:id] == current_tab 
 item[:url] 
 t(item[:id]) 
 end 
 end 
 
  unless crumbs.nil? 
 crumbs.each do |crumb| 
 if crumb[:url] 
 crumb[:url] 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 else 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 end 
 end 
 end 
 
 if Rails.configuration.search_enabled 
 form_tag search_project_path(:id => @active_project.id) 

  @search_field_default_value = t('search_box_default')
  @last_search ||= @search_field_default_value
  @search_field_attrs = {
    :onfocus => "if (event.target.value == '#{@search_field_default_value}') event.target.value=''",
    :onblur => "if (event.target.value == '#{@search_field_default_value}') event.target.value=''"
  }

 text_field_tag 'search_id', (h @last_search), @search_field_attrs 
 t('go') 
 end 
 if flash[:message] 
 flash[:error] ? 'error' : 'success' 
 flash[:error] ? 'flash_error' : 'flash_success' 
 h flash[:message] 
 end 
 h page_title 
 if @private_object 
 image_path('icons/private.gif') 
 end 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 
 form_tag category_path(:id => @category.id), :method => :put 
  error_messages_for :category 
 t('name') 
 text_field 'category', 'name', :id => 'categoryFormName' 
 
 t('edit_category') 
 unless @content_for_sidebar.nil? 
 render :partial => @content_for_sidebar 
 end 
  if not Company.owner.homepage.nil? 
 Company.owner.homepage 
 Company.owner.name 
 else 
 Company.owner.name 
 end 
 product_signature 
 

end

  end

  # POST /categories
  # POST /categories.xml
  def create
    authorize! :create_message_category, @active_project
    
    @category = @active_project.categories.build(params[:category])
    @category.created_by = @logged_user
    
    respond_to do |format|
      if @category.save
        format.html {
          error_status(false, :success_added_message_category)
          redirect_back_or_default(@category)
        }
        format.xml  { render :xml => @category.to_xml(:root => 'category'), :status => :created, :location => @category }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 unless @active_project.nil? 
 h @active_project.name 
 h page_title 
 h Company.owner.name 
 else 
 h page_title 
 h Company.owner.name 
 end 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'application.js' 
 javascript_tag "var PROJECT_ID = #{@active_project.id}; var LOGGED_USER_ID=#{@logged_user.id};" 
 unless @active_project.is_active? 
 t('project_locked_header') 
 if can?(:change_status, @active_project) 
 link_to t('mark_project_as_active'), open_project_path(:id => @active_project.id), :method => :put, :confirm => t('mark_project_as_active_confirmation') 
 end 
 end 
 h @active_project.name 
  if user.is_anonymous? 
 t('welcome_anonymous') 
 link_to(t('login'), logout_path) 
 else 
 t('welcome_back', :user => h(user.display_name)).html_safe 
 link_to t('logout'), logout_path, :confirm => t('are_you_sure_logout') 
 end 
 @running_times.empty? ? 'none' : 'block' 
 t('running_times', :count => @running_times.size) 
 render_icon 'bullet_drop_down', '', :id => 'running_times', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 unless user.is_anonymous? 
 link_to t('account'), @logged_user 
 render_icon 'bullet_drop_down', '', :id => 'account_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless projects.blank? 
 link_to t('projects'), :controller => 'dashboard', :action => 'my_projects' 
 render_icon 'bullet_drop_down', '', :id => 'projects_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 if user.is_admin 
 link_to t('administration'), :controller => 'administration' 
 render_icon 'bullet_drop_down', '', :id => 'administration_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless user.is_anonymous? 
 t('account') 
 link_to t('edit_profile'), edit_user_path(:id => user.id) 
 link_to t('update_avatar'), avatar_user_path(:id => user.id) 
 t('userbox_more') 
 link_to t('my_projects'), :controller => 'dashboard', :action => 'my_projects' 
 link_to t('my_tasks'), :controller => 'dashboard', :action => 'my_tasks' 
 end 
 unless projects.blank? 
 t('projects') 
 projects.each do |project| 
 link_to h(project.name), project_path(:id => project.id) 
 end 
 end 
 if user.is_admin 
 t('administration') 
 link_to t('company'), Company.owner 
 link_to t('members'), companies_path 
 link_to t('projects'), projects_path 
 end 
  listed.id 
 link_to h(listed.name), listed.object_url 
 link_to render_icon('stop', t('stop_time')), stop_time_path(:active_project => listed.project_id , :id => listed.id), :class => 'blank stopTime' 
 
 
  unless tabs.nil? 
 current_tab = self.current_tab 
 tabs.each do |item| 
 "item_#{item[:id]}" 
 'class="active"'.html_safe if item[:id] == current_tab 
 item[:url] 
 t(item[:id]) 
 end 
 end 
 
  unless crumbs.nil? 
 crumbs.each do |crumb| 
 if crumb[:url] 
 crumb[:url] 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 else 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 end 
 end 
 end 
 
 if Rails.configuration.search_enabled 
 form_tag search_project_path(:id => @active_project.id) 

  @search_field_default_value = t('search_box_default')
  @last_search ||= @search_field_default_value
  @search_field_attrs = {
    :onfocus => "if (event.target.value == '#{@search_field_default_value}') event.target.value=''",
    :onblur => "if (event.target.value == '#{@search_field_default_value}') event.target.value=''"
  }

 text_field_tag 'search_id', (h @last_search), @search_field_attrs 
 t('go') 
 end 
 if flash[:message] 
 flash[:error] ? 'error' : 'success' 
 flash[:error] ? 'flash_error' : 'flash_success' 
 h flash[:message] 
 end 
 h page_title 
 if @private_object 
 image_path('icons/private.gif') 
 end 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 
 form_tag categories_path 
  error_messages_for :category 
 t('name') 
 text_field 'category', 'name', :id => 'categoryFormName' 
 
 t('add_category') 
 unless @content_for_sidebar.nil? 
 render :partial => @content_for_sidebar 
 end 
  if not Company.owner.homepage.nil? 
 Company.owner.homepage 
 Company.owner.name 
 else 
 Company.owner.name 
 end 
 product_signature 
 

end
 }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    begin
      @category = @active_project.categories.find(params[:id])
    rescue
      return error_status(true, :invalid_message_category)
    end
    
    authorize! :edit, @category
    
    @category.updated_by = @logged_user
    
    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html {
          error_status(false, :success_edited_message_category)
          redirect_back_or_default(@category)
        }
        format.xml  { head :ok }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 unless @active_project.nil? 
 h @active_project.name 
 h page_title 
 h Company.owner.name 
 else 
 h page_title 
 h Company.owner.name 
 end 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'application.js' 
 javascript_tag "var PROJECT_ID = #{@active_project.id}; var LOGGED_USER_ID=#{@logged_user.id};" 
 unless @active_project.is_active? 
 t('project_locked_header') 
 if can?(:change_status, @active_project) 
 link_to t('mark_project_as_active'), open_project_path(:id => @active_project.id), :method => :put, :confirm => t('mark_project_as_active_confirmation') 
 end 
 end 
 h @active_project.name 
  if user.is_anonymous? 
 t('welcome_anonymous') 
 link_to(t('login'), logout_path) 
 else 
 t('welcome_back', :user => h(user.display_name)).html_safe 
 link_to t('logout'), logout_path, :confirm => t('are_you_sure_logout') 
 end 
 @running_times.empty? ? 'none' : 'block' 
 t('running_times', :count => @running_times.size) 
 render_icon 'bullet_drop_down', '', :id => 'running_times', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 unless user.is_anonymous? 
 link_to t('account'), @logged_user 
 render_icon 'bullet_drop_down', '', :id => 'account_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless projects.blank? 
 link_to t('projects'), :controller => 'dashboard', :action => 'my_projects' 
 render_icon 'bullet_drop_down', '', :id => 'projects_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 if user.is_admin 
 link_to t('administration'), :controller => 'administration' 
 render_icon 'bullet_drop_down', '', :id => 'administration_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless user.is_anonymous? 
 t('account') 
 link_to t('edit_profile'), edit_user_path(:id => user.id) 
 link_to t('update_avatar'), avatar_user_path(:id => user.id) 
 t('userbox_more') 
 link_to t('my_projects'), :controller => 'dashboard', :action => 'my_projects' 
 link_to t('my_tasks'), :controller => 'dashboard', :action => 'my_tasks' 
 end 
 unless projects.blank? 
 t('projects') 
 projects.each do |project| 
 link_to h(project.name), project_path(:id => project.id) 
 end 
 end 
 if user.is_admin 
 t('administration') 
 link_to t('company'), Company.owner 
 link_to t('members'), companies_path 
 link_to t('projects'), projects_path 
 end 
  listed.id 
 link_to h(listed.name), listed.object_url 
 link_to render_icon('stop', t('stop_time')), stop_time_path(:active_project => listed.project_id , :id => listed.id), :class => 'blank stopTime' 
 
 
  unless tabs.nil? 
 current_tab = self.current_tab 
 tabs.each do |item| 
 "item_#{item[:id]}" 
 'class="active"'.html_safe if item[:id] == current_tab 
 item[:url] 
 t(item[:id]) 
 end 
 end 
 
  unless crumbs.nil? 
 crumbs.each do |crumb| 
 if crumb[:url] 
 crumb[:url] 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 else 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 end 
 end 
 end 
 
 if Rails.configuration.search_enabled 
 form_tag search_project_path(:id => @active_project.id) 

  @search_field_default_value = t('search_box_default')
  @last_search ||= @search_field_default_value
  @search_field_attrs = {
    :onfocus => "if (event.target.value == '#{@search_field_default_value}') event.target.value=''",
    :onblur => "if (event.target.value == '#{@search_field_default_value}') event.target.value=''"
  }

 text_field_tag 'search_id', (h @last_search), @search_field_attrs 
 t('go') 
 end 
 if flash[:message] 
 flash[:error] ? 'error' : 'success' 
 flash[:error] ? 'flash_error' : 'flash_success' 
 h flash[:message] 
 end 
 h page_title 
 if @private_object 
 image_path('icons/private.gif') 
 end 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 
 form_tag category_path(:id => @category.id), :method => :put 
  error_messages_for :category 
 t('name') 
 text_field 'category', 'name', :id => 'categoryFormName' 
 
 t('edit_category') 
 unless @content_for_sidebar.nil? 
 render :partial => @content_for_sidebar 
 end 
  if not Company.owner.homepage.nil? 
 Company.owner.homepage 
 Company.owner.name 
 else 
 Company.owner.name 
 end 
 product_signature 
 

end
 }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    begin
      @category = @active_project.categories.find(params[:id])
    rescue
      return error_status(true, :invalid_message_category)
    end
    
    authorize! :delete, @category
    
    @category.updated_by = @logged_user
    @category.destroy

    respond_to do |format|
      format.html {
        error_status(false, :success_deleted_message_category)
        redirect_back_or_default(categories_url)
      }
      format.xml  { head :ok }
    end
  end
  
  # /categories/1/posts
  # /categories/1/posts.xml
  def posts
    begin
      @category = @active_project.categories.find(params[:id])
    rescue
      return error_status(true, :invalid_message_category)
    end
    
    authorize! :show, @category
    
    # conditions
    msg_conditions = {}
    msg_conditions['is_private'] = false unless @logged_user.member_of_owner?

    # probably should make this more generic...
    if params[:display] == 'list'
      session[:msglist] = true
    elsif params[:display] == 'summary'
      session[:msglist] = false
    end
    @display_list = session[:msglist] || false
    
    respond_to do |format|
      format.html {
        @content_for_sidebar = 'messages/index_sidebar'
    
        @page = params[:page].to_i
        @page = 1 unless @page > 0
        
        @messages = @category.messages.where(msg_conditions)
                                              .paginate(:page => @page, :per_page => Rails.configuration.messages_per_page)
        
        @pagination = []
        @messages.total_pages.times {|page| @pagination << page+1}
        
        # Important messages (html only)
        important_conditions = {'is_important' => true}
        important_conditions['is_private'] = false unless @logged_user.member_of_owner?
        @important_messages = @active_project.messages.where(important_conditions)

        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 unless @active_project.nil? 
 h @active_project.name 
 h page_title 
 h Company.owner.name 
 else 
 h page_title 
 h Company.owner.name 
 end 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'application.js' 
 javascript_tag "var PROJECT_ID = #{@active_project.id}; var LOGGED_USER_ID=#{@logged_user.id};" 
 unless @active_project.is_active? 
 t('project_locked_header') 
 if can?(:change_status, @active_project) 
 link_to t('mark_project_as_active'), open_project_path(:id => @active_project.id), :method => :put, :confirm => t('mark_project_as_active_confirmation') 
 end 
 end 
 h @active_project.name 
  if user.is_anonymous? 
 t('welcome_anonymous') 
 link_to(t('login'), logout_path) 
 else 
 t('welcome_back', :user => h(user.display_name)).html_safe 
 link_to t('logout'), logout_path, :confirm => t('are_you_sure_logout') 
 end 
 @running_times.empty? ? 'none' : 'block' 
 t('running_times', :count => @running_times.size) 
 render_icon 'bullet_drop_down', '', :id => 'running_times', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 unless user.is_anonymous? 
 link_to t('account'), @logged_user 
 render_icon 'bullet_drop_down', '', :id => 'account_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless projects.blank? 
 link_to t('projects'), :controller => 'dashboard', :action => 'my_projects' 
 render_icon 'bullet_drop_down', '', :id => 'projects_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 if user.is_admin 
 link_to t('administration'), :controller => 'administration' 
 render_icon 'bullet_drop_down', '', :id => 'administration_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless user.is_anonymous? 
 t('account') 
 link_to t('edit_profile'), edit_user_path(:id => user.id) 
 link_to t('update_avatar'), avatar_user_path(:id => user.id) 
 t('userbox_more') 
 link_to t('my_projects'), :controller => 'dashboard', :action => 'my_projects' 
 link_to t('my_tasks'), :controller => 'dashboard', :action => 'my_tasks' 
 end 
 unless projects.blank? 
 t('projects') 
 projects.each do |project| 
 link_to h(project.name), project_path(:id => project.id) 
 end 
 end 
 if user.is_admin 
 t('administration') 
 link_to t('company'), Company.owner 
 link_to t('members'), companies_path 
 link_to t('projects'), projects_path 
 end 
  listed.id 
 link_to h(listed.name), listed.object_url 
 link_to render_icon('stop', t('stop_time')), stop_time_path(:active_project => listed.project_id , :id => listed.id), :class => 'blank stopTime' 
 
 
  unless tabs.nil? 
 current_tab = self.current_tab 
 tabs.each do |item| 
 "item_#{item[:id]}" 
 'class="active"'.html_safe if item[:id] == current_tab 
 item[:url] 
 t(item[:id]) 
 end 
 end 
 
  unless crumbs.nil? 
 crumbs.each do |crumb| 
 if crumb[:url] 
 crumb[:url] 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 else 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 end 
 end 
 end 
 
 if Rails.configuration.search_enabled 
 form_tag search_project_path(:id => @active_project.id) 

  @search_field_default_value = t('search_box_default')
  @last_search ||= @search_field_default_value
  @search_field_attrs = {
    :onfocus => "if (event.target.value == '#{@search_field_default_value}') event.target.value=''",
    :onblur => "if (event.target.value == '#{@search_field_default_value}') event.target.value=''"
  }

 text_field_tag 'search_id', (h @last_search), @search_field_attrs 
 t('go') 
 end 
 if flash[:message] 
 flash[:error] ? 'error' : 'success' 
 flash[:error] ? 'flash_error' : 'flash_success' 
 h flash[:message] 
 end 
 h page_title 
 if @private_object 
 image_path('icons/private.gif') 
 end 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 
 if not @messages.empty? 
 pagination_links "#{messages_path(@active_project)}?", @pagination unless @pagination.length <= 1 
 render :partial => (@display_list ? 'messages/show_list' : 'messages/show'),
           :collection => @messages, :locals => {:on_message_page => false} 
 pagination_links "#{messages_path(@active_project)}?", @pagination unless @pagination.length <= 1 
 else 
 if @category.nil? 
 t('no_messages_in_project') 
 else 
 t('no_messages_in_category') 
 end 
 end 
 unless @content_for_sidebar.nil? 
 render :partial => @content_for_sidebar 
 end 
  if not Company.owner.homepage.nil? 
 Company.owner.homepage 
 Company.owner.name 
 else 
 Company.owner.name 
 end 
 product_signature 
 

end

      }
      format.xml  { 
        @messages = @category.messages.where(msg_conditions)
                                              .offset(params[:offset])
                                              .limit(params[:limit] || Rails.configuration.messages_per_page)
        
        render :xml => @messages.to_xml(:only => [:id,
                                                  :title,
                                                  :created_by_id, 
                                                  :created_on,
                                                  :updated_on,
                                                  :is_private,
                                                  :is_important,
                                                  :milestone_id,
                                                  :attached_files_count, 
                                                  :comments_enabled], :root => 'messages')
      }
    end
  end
  
end

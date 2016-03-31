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

class TaskListsController < ApplicationController

  layout 'project_website'
  helper 'project_items'

  before_filter :process_session
  after_filter  :user_track, :only => [:index, :show]
  
  # GET /task_lists
  # GET /task_lists.xml
  def index
    include_private = @logged_user.member_of_owner?
    
    respond_to do |format|
      format.html {
        index_lists(include_private)
      }
      format.js {
        index_lists(include_private)
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
 
 if @open_task_lists.length > 0 
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
 t('no_open_task_lists_for_project') 
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
        conds = include_private ? {} : {'is_private' => false}
        @task_lists = @active_project.task_lists.where(conds)
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
 
 if @open_task_lists.length > 0 
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
 t('no_open_task_lists_for_project') 
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
 
 if @open_task_lists.length > 0 
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
 t('no_open_task_lists_for_project') 
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

  # GET /task_lists/1
  # GET /task_lists/1.xml
  def show
    begin
      @task_list = @active_project.task_lists.find(params[:id])
    rescue
      return error_status(true, :invalid_task_list)
    end
    
    authorize! :show, @task_list

    respond_to do |format|
      format.html {
        index_lists(@logged_user.member_of_owner?)
      }
      
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

  # GET /task_lists/new
  # GET /task_lists/new.xml
  def new
    authorize! :create_task_list, @active_project
    
    @task_list = @active_project.task_lists.build()
    
    begin
      @task_list.milestone = @active_project.milestones.find(params[:milestone_id])
      @task_list.is_private = @task_list.milestone.is_private
    rescue ActiveRecord::RecordNotFound
      @task_list.milestone_id = 0
    end
    
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
 
 form_tag task_lists_path 
  error_messages_for :task_list 
 t('name') 
 text_field 'task_list', 'name', :id => 'taskListFormName', :class => 'long' 
 t('priority') 
 text_field 'task_list', 'priority', :id => 'taskListPriority', :class => 'long' 
 t('description') 
 text_area 'task_list', 'description', :id => 'taskListFormDescription', :class => 'short', :rows => 10, :cols => 40 
 t('milestone') 
 select 'task_list', 'milestone_id', select_milestone_options(@active_project), {}, {:class => 'select_milestone', :id => 'taskListFormMilestone'} 
 if @logged_user.member_of_owner? 
 t('is_private_list') 
 t('is_private_list_info') 
 yesno_toggle 'task_list', 'is_private', :id => 'taskListFormIsPrivate', :class => 'yes_no'  
 end 
 t('tags') 
 text_field 'task_list', 'tags', :id => 'taskListFormTags', :class => 'long' 
t('tags_info') 
 
 t('add_task_list') 
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
 
 form_tag task_lists_path 
  error_messages_for :task_list 
 t('name') 
 text_field 'task_list', 'name', :id => 'taskListFormName', :class => 'long' 
 t('priority') 
 text_field 'task_list', 'priority', :id => 'taskListPriority', :class => 'long' 
 t('description') 
 text_area 'task_list', 'description', :id => 'taskListFormDescription', :class => 'short', :rows => 10, :cols => 40 
 t('milestone') 
 select 'task_list', 'milestone_id', select_milestone_options(@active_project), {}, {:class => 'select_milestone', :id => 'taskListFormMilestone'} 
 if @logged_user.member_of_owner? 
 t('is_private_list') 
 t('is_private_list_info') 
 yesno_toggle 'task_list', 'is_private', :id => 'taskListFormIsPrivate', :class => 'yes_no'  
 end 
 t('tags') 
 text_field 'task_list', 'tags', :id => 'taskListFormTags', :class => 'long' 
t('tags_info') 
 
 t('add_task_list') 
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

  # GET /task_lists/1/edit
  def edit
    begin
      @task_list = @active_project.task_lists.find(params[:id])
    rescue
      return error_status(true, :invalid_task_list)
    end
    
    authorize! :edit, @task_list
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
 
 form_tag task_list_path(:id => @task_list.id), :method => :put 
  error_messages_for :task_list 
 t('name') 
 text_field 'task_list', 'name', :id => 'taskListFormName', :class => 'long' 
 t('priority') 
 text_field 'task_list', 'priority', :id => 'taskListPriority', :class => 'long' 
 t('description') 
 text_area 'task_list', 'description', :id => 'taskListFormDescription', :class => 'short', :rows => 10, :cols => 40 
 t('milestone') 
 select 'task_list', 'milestone_id', select_milestone_options(@active_project), {}, {:class => 'select_milestone', :id => 'taskListFormMilestone'} 
 if @logged_user.member_of_owner? 
 t('is_private_list') 
 t('is_private_list_info') 
 yesno_toggle 'task_list', 'is_private', :id => 'taskListFormIsPrivate', :class => 'yes_no'  
 end 
 t('tags') 
 text_field 'task_list', 'tags', :id => 'taskListFormTags', :class => 'long' 
t('tags_info') 
 
 t('edit_task_list') 
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

  # POST /task_lists
  # POST /task_lists.xml
  def create
    authorize! :create_task_list, @active_project
    
    @task_list = @active_project.task_lists.build(params[:task_list])
    @task_list.created_by = @logged_user

    respond_to do |format|
      if @task_list.save
        flash[:notice] = 'List was successfully created.'
        format.html {
          error_status(false, :success_added_task_list)
          redirect_back_or_default(@task_list)
        }
        format.js { return index }
        format.xml  { render :xml => @task_list.to_xml(:root => 'task-list'), :status => :created, :location => @task_list }
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
 
 form_tag task_lists_path 
  error_messages_for :task_list 
 t('name') 
 text_field 'task_list', 'name', :id => 'taskListFormName', :class => 'long' 
 t('priority') 
 text_field 'task_list', 'priority', :id => 'taskListPriority', :class => 'long' 
 t('description') 
 text_area 'task_list', 'description', :id => 'taskListFormDescription', :class => 'short', :rows => 10, :cols => 40 
 t('milestone') 
 select 'task_list', 'milestone_id', select_milestone_options(@active_project), {}, {:class => 'select_milestone', :id => 'taskListFormMilestone'} 
 if @logged_user.member_of_owner? 
 t('is_private_list') 
 t('is_private_list_info') 
 yesno_toggle 'task_list', 'is_private', :id => 'taskListFormIsPrivate', :class => 'yes_no'  
 end 
 t('tags') 
 text_field 'task_list', 'tags', :id => 'taskListFormTags', :class => 'long' 
t('tags_info') 
 
 t('add_task_list') 
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
        
        format.xml  { render :xml => @list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /task_lists/1
  # PUT /task_lists/1.xml
  def update
    begin
      @task_list = @active_project.task_lists.find(params[:id])
    rescue
      return error_status(true, :invalid_task_list)
    end
    
    authorize! :edit, @task_list
    
    @task_list.updated_by = @logged_user

    respond_to do |format|
      if @task_list.update_attributes(params[:task_list])
        flash[:notice] = 'List was successfully updated.'
        format.html {
          error_status(false, :success_edited_task_list)
          redirect_back_or_default(@task_list)
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
 
 form_tag task_list_path(:id => @task_list.id), :method => :put 
  error_messages_for :task_list 
 t('name') 
 text_field 'task_list', 'name', :id => 'taskListFormName', :class => 'long' 
 t('priority') 
 text_field 'task_list', 'priority', :id => 'taskListPriority', :class => 'long' 
 t('description') 
 text_area 'task_list', 'description', :id => 'taskListFormDescription', :class => 'short', :rows => 10, :cols => 40 
 t('milestone') 
 select 'task_list', 'milestone_id', select_milestone_options(@active_project), {}, {:class => 'select_milestone', :id => 'taskListFormMilestone'} 
 if @logged_user.member_of_owner? 
 t('is_private_list') 
 t('is_private_list_info') 
 yesno_toggle 'task_list', 'is_private', :id => 'taskListFormIsPrivate', :class => 'yes_no'  
 end 
 t('tags') 
 text_field 'task_list', 'tags', :id => 'taskListFormTags', :class => 'long' 
t('tags_info') 
 
 t('edit_task_list') 
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
        
        format.xml  { render :xml => @list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /task_lists/1
  # DELETE /task_lists/1.xml
  def destroy
    begin
      @task_list = @active_project.task_lists.find(params[:id])
    rescue
      return error_status(true, :invalid_task_list)
    end
    
    authorize! :delete, @task_list

    @on_page = (params[:on_page] || '').to_i == 1
    @removed_id = @task_list.id
    @task_list.updated_by = @logged_user
    @task_list.destroy

    respond_to do |format|
      format.html {
        error_status(false, :success_deleted_task_list)
        redirect_to(task_lists_url)
      }
      format.js { index_lists(@logged_user.member_of_owner?) }
      format.xml  { head :ok }
    end
  end
  
  # POST /task_lists/1/reorder
  def reorder
    begin
      @task_list = @active_project.task_lists.find(params[:id])
    rescue
      return error_status(true, :invalid_task_list)
    end
    
    authorize! :edit, @task_list
    
    order = (params[:tasks]||[]).collect { |id| id.to_i }
    
    @task_list.tasks.each do |item|
        idx = order.index(item.id)
        item.order = idx || @task_list.tasks.length
        item.save!
    end
    
    respond_to do |format|
      format.html { head :ok }
      format.json { head :ok }
      format.xml  { head :ok }
    end
  end

protected

  def index_lists(include_private)
    @open_task_lists = @active_project.task_lists.is_open
    @open_task_lists = @open_task_lists.is_public unless include_private
    @completed_task_lists = @active_project.task_lists.completed
    @completed_task_lists = @completed_task_lists.is_public unless include_private
    @content_for_sidebar = 'index_sidebar'
  end

end

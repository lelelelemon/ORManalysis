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

class TasksController < ApplicationController

  layout 'project_website'
  helper 'project_items'

  before_filter :process_session
  before_filter :grab_list, :except => [:create, :new]
  before_filter :grab_list_required, :only => [:index, :create, :new]
  after_filter  :user_track, :only => [:index, :show]
  
  # GET /tasks
  # GET /tasks.xml
  def index
    respond_to do |format|
      format.html {
        @open_task_lists = @active_project.task_lists.is_open
        @open_task_lists = @open_task_lists.is_public unless @logged_user.member_of_owner?
        @completed_task_lists = @active_project.task_lists.completed
        @completed_task_lists = @completed_task_lists.is_public unless @logged_user.member_of_owner?
        @content_for_sidebar = 'task_lists/index_sidebar'
      }
      format.xml  {
        @tasks = @task_list.tasks
        render :xml => @tasks.to_xml(:root => 'tasks')
      }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    begin
      @task = (@task_list||@active_project).tasks.find(params[:id])
      @task_list ||= @task.task_list
    rescue
      return error_status(true, :invalid_task)
    end
    
    respond_to do |format|
      format.html { }
      format.js { respond_with_task(@task) }
      format.xml  { render :xml => @task.to_xml(:root => 'task') }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 render :partial => 'files/list_attached_files', :locals => {:dont_add => false, :attached_files => comment.attached_files(@logged_user.member_of_owner?), :attached_files_object => comment} 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
 render :partial => 'comments/form' 
 t('add_comment') 
 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 render :partial => 'files/list_attached_files', :locals => {:dont_add => false, :attached_files => comment.attached_files(@logged_user.member_of_owner?), :attached_files_object => comment} 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
 render :partial => 'comments/form' 
 t('add_comment') 
 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 
	@additional_stylesheets ||= []
	@additional_stylesheets << 'project/attach_files'

 if !attached_files.empty? or (!dont_add and can?(:add_file, attached_files_object)) 
 attached_files.each do |attached_file| 
 attached_file.download_url 
 h attached_file.filename 
 format_size attached_file.file_size 
 action_list actions_for_attached_files(attached_file, attached_files_object) 
 end 
 if !dont_add and can?(:add_file, attached_files_object) 
 link_to t('attach_files'), attach_file_path(:object_type => attached_files_object.class.to_s , :object_id => attached_files_object.id) 
 end 
 end 
 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
  error_messages_for :comment 
 if @logged_user.is_anonymous? 
 t('name') 
 text_field 'comment', 'author_name', :id => 'commentFormName', :class => 'long' 
 t('email_address') 
 text_field 'comment', 'author_email', :id => 'commentFormEmail', :class => 'long' 
 end 
 t('text') 
 text_area 'comment', 'text', :id => 'addCommentText', :class => 'comment' 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_comment') 
 yesno_toggle 'comment', 'is_private', :class => 'yes_no', :id => 'commentFormIsPrivate' 
 t('private_comment_info') 
 end 
 if can? :create_file, @active_project 
 render :partial => 'files/attach_file' 
 Rails.configuration.max_attachments 
 end 
 
 t('add_comment') 
 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 render :partial => 'files/list_attached_files', :locals => {:dont_add => false, :attached_files => comment.attached_files(@logged_user.member_of_owner?), :attached_files_object => comment} 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
 render :partial => 'comments/form' 
 t('add_comment') 
 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 render :partial => 'files/list_attached_files', :locals => {:dont_add => false, :attached_files => comment.attached_files(@logged_user.member_of_owner?), :attached_files_object => comment} 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
 render :partial => 'comments/form' 
 t('add_comment') 
 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 
	@additional_stylesheets ||= []
	@additional_stylesheets << 'project/attach_files'

 if !attached_files.empty? or (!dont_add and can?(:add_file, attached_files_object)) 
 attached_files.each do |attached_file| 
 attached_file.download_url 
 h attached_file.filename 
 format_size attached_file.file_size 
 action_list actions_for_attached_files(attached_file, attached_files_object) 
 end 
 if !dont_add and can?(:add_file, attached_files_object) 
 link_to t('attach_files'), attach_file_path(:object_type => attached_files_object.class.to_s , :object_id => attached_files_object.id) 
 end 
 end 
 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
  error_messages_for :comment 
 if @logged_user.is_anonymous? 
 t('name') 
 text_field 'comment', 'author_name', :id => 'commentFormName', :class => 'long' 
 t('email_address') 
 text_field 'comment', 'author_email', :id => 'commentFormEmail', :class => 'long' 
 end 
 t('text') 
 text_area 'comment', 'text', :id => 'addCommentText', :class => 'comment' 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_comment') 
 yesno_toggle 'comment', 'is_private', :class => 'yes_no', :id => 'commentFormIsPrivate' 
 t('private_comment_info') 
 end 
 if can? :create_file, @active_project 
 render :partial => 'files/attach_file' 
 Rails.configuration.max_attachments 
 end 
 
 t('add_comment') 
 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 
	@additional_stylesheets ||= []
	@additional_stylesheets << 'project/attach_files'

 if !attached_files.empty? or (!dont_add and can?(:add_file, attached_files_object)) 
 attached_files.each do |attached_file| 
 attached_file.download_url 
 h attached_file.filename 
 format_size attached_file.file_size 
 action_list actions_for_attached_files(attached_file, attached_files_object) 
 end 
 if !dont_add and can?(:add_file, attached_files_object) 
 link_to t('attach_files'), attach_file_path(:object_type => attached_files_object.class.to_s , :object_id => attached_files_object.id) 
 end 
 end 
 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
  error_messages_for :comment 
 if @logged_user.is_anonymous? 
 t('name') 
 text_field 'comment', 'author_name', :id => 'commentFormName', :class => 'long' 
 t('email_address') 
 text_field 'comment', 'author_email', :id => 'commentFormEmail', :class => 'long' 
 end 
 t('text') 
 text_area 'comment', 'text', :id => 'addCommentText', :class => 'comment' 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_comment') 
 yesno_toggle 'comment', 'is_private', :class => 'yes_no', :id => 'commentFormIsPrivate' 
 t('private_comment_info') 
 end 
 if can? :create_file, @active_project 
  t('attach_files') 
 
 end 
 
 t('add_comment') 
 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 render :partial => 'files/list_attached_files', :locals => {:dont_add => false, :attached_files => comment.attached_files(@logged_user.member_of_owner?), :attached_files_object => comment} 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
 render :partial => 'comments/form' 
 t('add_comment') 
 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 render :partial => 'files/list_attached_files', :locals => {:dont_add => false, :attached_files => comment.attached_files(@logged_user.member_of_owner?), :attached_files_object => comment} 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
 render :partial => 'comments/form' 
 t('add_comment') 
 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 
	@additional_stylesheets ||= []
	@additional_stylesheets << 'project/attach_files'

 if !attached_files.empty? or (!dont_add and can?(:add_file, attached_files_object)) 
 attached_files.each do |attached_file| 
 attached_file.download_url 
 h attached_file.filename 
 format_size attached_file.file_size 
 action_list actions_for_attached_files(attached_file, attached_files_object) 
 end 
 if !dont_add and can?(:add_file, attached_files_object) 
 link_to t('attach_files'), attach_file_path(:object_type => attached_files_object.class.to_s , :object_id => attached_files_object.id) 
 end 
 end 
 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
  error_messages_for :comment 
 if @logged_user.is_anonymous? 
 t('name') 
 text_field 'comment', 'author_name', :id => 'commentFormName', :class => 'long' 
 t('email_address') 
 text_field 'comment', 'author_email', :id => 'commentFormEmail', :class => 'long' 
 end 
 t('text') 
 text_area 'comment', 'text', :id => 'addCommentText', :class => 'comment' 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_comment') 
 yesno_toggle 'comment', 'is_private', :class => 'yes_no', :id => 'commentFormIsPrivate' 
 t('private_comment_info') 
 end 
 if can? :create_file, @active_project 
 render :partial => 'files/attach_file' 
 Rails.configuration.max_attachments 
 end 
 
 t('add_comment') 
 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 render :partial => 'files/list_attached_files', :locals => {:dont_add => false, :attached_files => comment.attached_files(@logged_user.member_of_owner?), :attached_files_object => comment} 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
 render :partial => 'comments/form' 
 t('add_comment') 
 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 if @task.is_completed? 
 
  @bread_crumbs = project_crumbs(@task.text, [
  	{:title => :tasks, :url => task_lists_path},
  	{:title => @task.task_list.name, :url => task_list_path(:id => @task_list.id)}
  ])

 @task_list.id 
 @task_list.object_url 
 @task_list.id 
 unless @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 if @task.is_completed? 
 render :partial => 'tasks/show', :collection => [@task], :locals => {:tprefix => "openTasksList#{@task_list.id}"} 
 end 
 render :partial => 'comments/object_comments', :locals => {:comments => @logged_user.member_of_owner? ? @task.comments : @task.comments.is_public} 
 if can? :comment, @task 
 render :partial => 'comments/add_form', :locals => {:commented_object => @task} 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 render :partial => 'files/list_attached_files', :locals => {:dont_add => false, :attached_files => comment.attached_files(@logged_user.member_of_owner?), :attached_files_object => comment} 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
 render :partial => 'comments/form' 
 t('add_comment') 
 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 
	@additional_stylesheets ||= []
	@additional_stylesheets << 'project/attach_files'

 if !attached_files.empty? or (!dont_add and can?(:add_file, attached_files_object)) 
 attached_files.each do |attached_file| 
 attached_file.download_url 
 h attached_file.filename 
 format_size attached_file.file_size 
 action_list actions_for_attached_files(attached_file, attached_files_object) 
 end 
 if !dont_add and can?(:add_file, attached_files_object) 
 link_to t('attach_files'), attach_file_path(:object_type => attached_files_object.class.to_s , :object_id => attached_files_object.id) 
 end 
 end 
 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
  error_messages_for :comment 
 if @logged_user.is_anonymous? 
 t('name') 
 text_field 'comment', 'author_name', :id => 'commentFormName', :class => 'long' 
 t('email_address') 
 text_field 'comment', 'author_email', :id => 'commentFormEmail', :class => 'long' 
 end 
 t('text') 
 text_area 'comment', 'text', :id => 'addCommentText', :class => 'comment' 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_comment') 
 yesno_toggle 'comment', 'is_private', :class => 'yes_no', :id => 'commentFormIsPrivate' 
 t('private_comment_info') 
 end 
 if can? :create_file, @active_project 
 render :partial => 'files/attach_file' 
 Rails.configuration.max_attachments 
 end 
 
 t('add_comment') 
 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 
	@additional_stylesheets ||= []
	@additional_stylesheets << 'project/attach_files'

 if !attached_files.empty? or (!dont_add and can?(:add_file, attached_files_object)) 
 attached_files.each do |attached_file| 
 attached_file.download_url 
 h attached_file.filename 
 format_size attached_file.file_size 
 action_list actions_for_attached_files(attached_file, attached_files_object) 
 end 
 if !dont_add and can?(:add_file, attached_files_object) 
 link_to t('attach_files'), attach_file_path(:object_type => attached_files_object.class.to_s , :object_id => attached_files_object.id) 
 end 
 end 
 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
  error_messages_for :comment 
 if @logged_user.is_anonymous? 
 t('name') 
 text_field 'comment', 'author_name', :id => 'commentFormName', :class => 'long' 
 t('email_address') 
 text_field 'comment', 'author_email', :id => 'commentFormEmail', :class => 'long' 
 end 
 t('text') 
 text_area 'comment', 'text', :id => 'addCommentText', :class => 'comment' 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_comment') 
 yesno_toggle 'comment', 'is_private', :class => 'yes_no', :id => 'commentFormIsPrivate' 
 t('private_comment_info') 
 end 
 if can? :create_file, @active_project 
  t('attach_files') 
 
 end 
 
 t('add_comment') 
 
 end 
 
 end 
 
  @additional_stylesheets ||= []
  @additional_stylesheets << 'project/comments'

 t('comments') 
 if comments.empty? 
 t('no_comments_for_object') 
 else 
 counter = 0 
 comments.each do |comment| 
 counter += 1 
 cycle('odd', 'even') 
 comment.id 
 if comment.is_private 
 t('private_comment') 
 t('private_comment') 
 end 
 "#{comment.rel_object.object_url}\#comment#{counter}" 
 t('permalink') 
 counter 
 if comment.is_anonymous? 
 t('comment_posted', 
                  :name => comment.author_name,
                  :time => format_usertime(comment.created_on, :comment_posted_format)) 
 if @logged_user.is_admin 
 h(comment.author_homepage) 
 end 
 elsif not comment.created_by.nil? 
 t('comment_posted_with_user', 
                  :time => format_usertime(comment.created_on, :comment_posted_format),
                  :user => "<a href=\"#{comment.created_by.object_url}\">#{h(comment.created_by.display_name)}</a>").html_safe 
 else 
 format_usertime(comment.created_on, :comment_posted_format) 
 end 
 unless comment.created_by.nil? 
 comment.created_by.avatar_url 
 h comment.created_by.display_name 
 end 
 textilize comment.text 
 
	@additional_stylesheets ||= []
	@additional_stylesheets << 'project/attach_files'

 if !attached_files.empty? or (!dont_add and can?(:add_file, attached_files_object)) 
 attached_files.each do |attached_file| 
 attached_file.download_url 
 h attached_file.filename 
 format_size attached_file.file_size 
 action_list actions_for_attached_files(attached_file, attached_files_object) 
 end 
 if !dont_add and can?(:add_file, attached_files_object) 
 link_to t('attach_files'), attach_file_path(:object_type => attached_files_object.class.to_s , :object_id => attached_files_object.id) 
 end 
 end 
 
 action_list actions_for_comment(comment) 
 end 
 end 
 
 if can? :comment, @task 
  t('post_comment') 
 form_tag( object_comments_url(commented_object), :multipart => true ) 
  error_messages_for :comment 
 if @logged_user.is_anonymous? 
 t('name') 
 text_field 'comment', 'author_name', :id => 'commentFormName', :class => 'long' 
 t('email_address') 
 text_field 'comment', 'author_email', :id => 'commentFormEmail', :class => 'long' 
 end 
 t('text') 
 text_area 'comment', 'text', :id => 'addCommentText', :class => 'comment' 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_comment') 
 yesno_toggle 'comment', 'is_private', :class => 'yes_no', :id => 'commentFormIsPrivate' 
 t('private_comment_info') 
 end 
 if can? :create_file, @active_project 
  t('attach_files') 
 
 end 
 
 t('add_comment') 
 
 end 

end

  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    authorize! :create_task, @task_list
    
    @task = @task_list.tasks.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task.to_xml(:root => 'task') }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

  @page_actions = []
  
  if can? :create_task_list, @active_project
    @page_actions << {:title => :add_task_list, :url=> new_task_list_path}
  end

 form_tag new_task_path(:task_list_id => @task_list.id) do 
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

  end

  # GET /tasks/1/edit
  def edit
    begin
      @task = @task_list.tasks.find(params[:id])
    rescue
      return error_status(true, :invalid_task)
    end
    
    authorize! :edit, @task
    
    respond_to do |f|
      f.html
      f.js { respond_with_task(@task, 'ajax_form') }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

  @page_actions = []
  
  if can? :create_task_list, @active_project
    @page_actions << {:title => :add_task_list, :url=> new_task_list_path}
  end

 form_tag task_path(:task_list_id => @task.task_list_id, :id => @task.id), :method => :put do 
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

  end

  # POST /tasks
  # POST /tasks.xml
  def create
    authorize! :create_task, @task_list
    
    @task = @task_list.tasks.build(params[:task])
    @task.created_by = @logged_user
    
    respond_to do |format|
      if @task.save
        Notifier.deliver_task(@task.user, @task) if params[:send_notification] and @task.user
        flash[:notice] = 'ListItem was successfully created.'
        format.html { redirect_back_or_default(task_lists_path) }
        format.js { respond_with_task(@task) }
        format.xml  { render :xml => @task.to_xml(:root => 'task'), :status => :created, :location => @task }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|

  @page_actions = []
  
  if can? :create_task_list, @active_project
    @page_actions << {:title => :add_task_list, :url=> new_task_list_path}
  end

 form_tag new_task_path(:task_list_id => @task_list.id) do 
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
 }
        format.js { respond_with_task(@task) }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    begin
      @task = @task_list.tasks.find(params[:id])
    rescue
      return error_status(true, :invalid_task)
    end
    
    authorize! :edit, @task
    
    @task.updated_by = @logged_user

    respond_to do |format|
      if @task.update_attributes(params[:task])
        Notifier.deliver_task(@task.user, @task) if params[:send_notification] and @task.user
        flash[:notice] = 'ListItem was successfully updated.'
        format.html { redirect_back_or_default(task_lists_path) }
        format.js { respond_with_task(@task) }
        format.xml  { head :ok }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|

  @page_actions = []
  
  if can? :create_task_list, @active_project
    @page_actions << {:title => :add_task_list, :url=> new_task_list_path}
  end

 form_tag task_path(:task_list_id => @task.task_list_id, :id => @task.id), :method => :put do 
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
 }
        format.js { respond_with_task(@task) }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    begin
      @task = @task_list.tasks.find(params[:id])
    rescue
      return error_status(true, :invalid_task)
    end
    
    authorize! :delete, @task
    
    @task.updated_by = @logged_user
    @task.destroy

    respond_to do |format|
      format.html { redirect_back_or_default(task_lists_url) }
      format.js { render :json => { :id => @task.id } }
      format.xml  { head :ok }
    end
  end

  # PUT /tasks/1/status
  # PUT /tasks/1/status.xml
  def status
    begin
      @task = @task_list.tasks.find(params[:id])
    rescue
      return error_status(true, :invalid_task)
    end
    
    authorize! :complete, @task
    
    @task.set_completed(params[:task][:completed] == 'true', @logged_user)
    @task.order = @task_list.tasks.length
    @task.save

    respond_to do |format|
      format.html { redirect_back_or_default(task_lists_url) }
      format.js { respond_with_task(@task) }
      format.xml  { head :ok }
    end

  end

protected

  def respond_with_task(task, partial='show')
    task_class = task.is_completed? ? 'completedTasks' : 'openTasks'
    if task.errors
      render :json => {:task_class => task_class, :id => task.id, :content => render_to_string({:partial => partial, :collection => [task]})}
    else
      render :json => {:task_class => task_class, :id => task.id, :errors => task.errors}, :status => :unprocessable_entity
    end
  end
  
  def grab_list_required
    if params[:task_list_id].nil?
      error_status(true, :invalid_task)
      return false
    end
    grab_list
  end

  def grab_list
    return if params[:task_list_id].nil?
    begin
      @task_list = @active_project.task_lists.find(params[:task_list_id])
      authorize! :show, @task_list
    rescue ActiveRecord::RecordNotFound
      error_status(true, :invalid_task)
      return false
    end
    
    true
  end
end

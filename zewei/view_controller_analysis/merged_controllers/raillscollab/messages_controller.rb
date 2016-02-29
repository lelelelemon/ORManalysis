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

class MessagesController < ApplicationController

  layout 'project_website'
  helper 'project_items'

  before_filter :process_session
  before_filter :obtain_message, :except => [:index, :new, :create]
  after_filter  :user_track, :only => [:index, :show]
  
  # GET /messages
  # GET /messages.xml
  def index
    begin
      @category = @active_project.categories.find(params[:category_id])
    rescue
      @category = nil
    end
    
    unless @category.nil?
      authorize! :show, @category
    end
    
    # conditions
    msg_conditions = {}
    msg_conditions['category_id'] = @category.id unless @category.nil?
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
        @content_for_sidebar = 'index_sidebar'
    
        @page = params[:page].to_i
        @page = 1 unless @page > 0
        @messages = @active_project.messages.where(msg_conditions)
                                                    .paginate(:page => @page, :per_page => Rails.configuration.messages_per_page)
        
        @pagination = []
        @messages.total_pages.times {|page| @pagination << page+1}
        
        # Important messages (html only)
        important_conditions = {'is_important' => true}
        important_conditions['category_id'] = @category.id unless @category.nil?
        important_conditions['is_private'] = false unless @logged_user.member_of_owner?
        @important_messages = @active_project.messages.where(important_conditions)

        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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

end

      }
      format.xml  { 
        @messages = @active_project.messages.where(msg_conditions)
                                                    .offset(params[:offset])
                                                    .limit(params[:limit] || Rails.configuration.messages_per_page)
        render :xml => @messages.to_xml(:root => 'messages')
      }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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

end

  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
    authorize! :show, @message
    
    @private_object = @message.is_private

    @subscribers = @message.subscribers
    @content_for_sidebar = 'view_sidebar'
    
    respond_to do |format|
      format.html {}
      format.xml  { 
        render :xml => @message.to_xml(:root => 'message')
      }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if not @message.created_by.nil? 
 @message.created_by.avatar_url 
 h @message.created_by.display_name 
 t('from') 
 link_to( h(@message.created_by.display_name), user_path(:id => @message.created_by.id)) 
 end 
 t('log_date') 
 format_usertime(@message.created_on, :message_created_format) 
 unless @message.milestone.nil? 
 t('milestone') 
 link_to h(@message.milestone.object_name), @message.milestone.object_url 
 end 
 t('tags') 
 @message.tags 
 textilize @message.text 
 
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
 
 action_list actions_for_message(@message) 
 
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
 
 if can? :comment, @message 
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

  # GET /messages/new
  # GET /messages/new.xml
  def new
    authorize! :create_message, @active_project
    
    @message = @active_project.messages.build()
    
    # Set milestone
    @message.milestone_id = @milestone.id if @milestone
    
    # Grab default category
    begin
      @category = @active_project.categories.find(params[:category_id])
    rescue ActiveRecord::RecordNotFound
      @category = nil
    end

    if @category
      @message.category_id = @category.id
    else
      @category = @active_project.categories.where(['name = ?', Rails.configuration.default_project_message_category]).first
    end

    @message.comments_enabled = true unless (params[:message] and params[:message].has_key?(:comments_enabled))
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message.to_xml(:root => 'message') }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_tag( messages_path, :multipart => true ) 
  error_messages_for :message 
 t('title') 
 text_field 'message', 'title', :id => 'messageFormTitle', :class => 'title' 
 t('text') 
 text_area 'message', 'text', :id => 'messageFormText', :class => 'editor' 
 t('milestone') 
 select 'message', 'milestone_id', select_milestone_options(@active_project), {}, {:class => 'select_milestone', :id => 'messageFormMilestone'} 
 t('category') 
 select 'message', 'category_id', Category.select_list(@active_project), {}, {:class => 'select_milestone', :id => 'messageFormCategory'} 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_message') 
 yesno_toggle 'message', 'is_private', :class => 'yes_no', :id => 'messageFormIsPrivate' 
 t('private_message_info') 
 t('important_message') 
 yesno_toggle 'message', 'is_important', :class => 'yes_no', :id => 'messageFormIsImportant' 
 t('important_message_info') 
 t('enable_comments') 
 yesno_toggle 'message', 'comments_enabled', :class => 'yes_no', :id => 'messageFormEnableComments' 
 t('enable_comments_info') 
 if Rails.configuration.allow_anonymous 
 t('enable_anonymous_comments') 
 yesno_toggle 'message', 'anonymous_comments_enabled', :class => 'yes_no', :id => 'messageFormEnableAnonymousComments' 
 t('enable_anonymous_comments_info') 
 end 
 end 
 t('tags') 
 text_field 'message', 'tags', :id => 'messageFormTags', :class => 'long' 
t('tags_info') 
 if @message.new_record? 
 t('email_notification') 
 t('email_notification_info') 
 @active_project.companies.each do |company| 
 company.id 
 company.id 
 users_on_project = company.users_on_project(@active_project) 
 check_box_tag "notify_company[]", "#{company.id}", false, {:id => "notifyCompany#{company.id}", :class => 'checkbox', :onclick => "notify_form_select_company(#{company.id})"} 
 "notifyCompany#{company.id}" 
 h company.name 
 users_on_project.each do |user| 
 check_box_tag "notify_user[]", "#{user.id}", false, {:id => "notifyUser#{user.id}", :class => 'checkbox', :onclick => "notify_form_select(#{company.id}, #{user.id})"} 
 "notifyUser#{user.id}" 
 h user.display_name 
 company.id 
 user.id 
 end 
 company.id 
 end 
 end 
 if can? :create_file, @active_project 
  t('attach_files') 
 
 end 
 
 t('add_message') 

end

  end

  # GET /messages/1/edit
  def edit
    authorize! :edit, @message
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_tag( message_path(:id => @message.id), :method => :put, :multipart => true ) 
  error_messages_for :message 
 t('title') 
 text_field 'message', 'title', :id => 'messageFormTitle', :class => 'title' 
 t('text') 
 text_area 'message', 'text', :id => 'messageFormText', :class => 'editor' 
 t('milestone') 
 select 'message', 'milestone_id', select_milestone_options(@active_project), {}, {:class => 'select_milestone', :id => 'messageFormMilestone'} 
 t('category') 
 select 'message', 'category_id', Category.select_list(@active_project), {}, {:class => 'select_milestone', :id => 'messageFormCategory'} 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_message') 
 yesno_toggle 'message', 'is_private', :class => 'yes_no', :id => 'messageFormIsPrivate' 
 t('private_message_info') 
 t('important_message') 
 yesno_toggle 'message', 'is_important', :class => 'yes_no', :id => 'messageFormIsImportant' 
 t('important_message_info') 
 t('enable_comments') 
 yesno_toggle 'message', 'comments_enabled', :class => 'yes_no', :id => 'messageFormEnableComments' 
 t('enable_comments_info') 
 if Rails.configuration.allow_anonymous 
 t('enable_anonymous_comments') 
 yesno_toggle 'message', 'anonymous_comments_enabled', :class => 'yes_no', :id => 'messageFormEnableAnonymousComments' 
 t('enable_anonymous_comments_info') 
 end 
 end 
 t('tags') 
 text_field 'message', 'tags', :id => 'messageFormTags', :class => 'long' 
t('tags_info') 
 if @message.new_record? 
 t('email_notification') 
 t('email_notification_info') 
 @active_project.companies.each do |company| 
 company.id 
 company.id 
 users_on_project = company.users_on_project(@active_project) 
 check_box_tag "notify_company[]", "#{company.id}", false, {:id => "notifyCompany#{company.id}", :class => 'checkbox', :onclick => "notify_form_select_company(#{company.id})"} 
 "notifyCompany#{company.id}" 
 h company.name 
 users_on_project.each do |user| 
 check_box_tag "notify_user[]", "#{user.id}", false, {:id => "notifyUser#{user.id}", :class => 'checkbox', :onclick => "notify_form_select(#{company.id}, #{user.id})"} 
 "notifyUser#{user.id}" 
 h user.display_name 
 company.id 
 user.id 
 end 
 company.id 
 end 
 end 
 if can? :create_file, @active_project 
  t('attach_files') 
 
 end 
 
 t('edit_message') 

end

  end

  # POST /messages
  # POST /messages.xml
  def create
    authorize! :create_message, @active_project
    
    @message = @active_project.messages.build(params[:message])
    
    message_attribs = params[:message]
    @message.attributes = message_attribs
    @message.created_by = @logged_user
    
    saved = @message.save
    estatus = :success_added_message
    
    if saved
      @message.tags = message_attribs[:tags]
      
      # Notify the subscribers
      unless params[:notify_user].nil?
        valid_users = params[:notify_user].collect do |user_id|
          real_id = user_id.to_i
          next if real_id == @logged_user.id # will be subscribed below

          number_of_users = Person.count(['user_id = ? AND project_id = ?', real_id, @active_project.id])
          next if number_of_users == 0

          real_id
        end.compact
        
        User.find(valid_users).each do |user|
          @message.ensure_subscribed(user)
          @message.send_notification(user)
        end
      end

      # Subscribe
      @message.ensure_subscribed(@logged_user) if @message.class == Message
      
      # Handle uploaded files
      if (!params[:uploaded_files].nil? and ProjectFile.handle_files(params[:uploaded_files], @message, @logged_user, @message.is_private) != params[:uploaded_files].length)
        estatus = :success_added_message_failed_attachments
        error_status(false, :success_added_message_failed_attachments)
      end
    end
    
    respond_to do |format|
      if saved
        format.html {
          error_status(false, estatus)
          redirect_back_or_default(@message)
        }
        
        format.xml  { render :xml => @message.to_xml(:root => 'message'), :status => :created, :location => @message }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_tag( messages_path, :multipart => true ) 
  error_messages_for :message 
 t('title') 
 text_field 'message', 'title', :id => 'messageFormTitle', :class => 'title' 
 t('text') 
 text_area 'message', 'text', :id => 'messageFormText', :class => 'editor' 
 t('milestone') 
 select 'message', 'milestone_id', select_milestone_options(@active_project), {}, {:class => 'select_milestone', :id => 'messageFormMilestone'} 
 t('category') 
 select 'message', 'category_id', Category.select_list(@active_project), {}, {:class => 'select_milestone', :id => 'messageFormCategory'} 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_message') 
 yesno_toggle 'message', 'is_private', :class => 'yes_no', :id => 'messageFormIsPrivate' 
 t('private_message_info') 
 t('important_message') 
 yesno_toggle 'message', 'is_important', :class => 'yes_no', :id => 'messageFormIsImportant' 
 t('important_message_info') 
 t('enable_comments') 
 yesno_toggle 'message', 'comments_enabled', :class => 'yes_no', :id => 'messageFormEnableComments' 
 t('enable_comments_info') 
 if Rails.configuration.allow_anonymous 
 t('enable_anonymous_comments') 
 yesno_toggle 'message', 'anonymous_comments_enabled', :class => 'yes_no', :id => 'messageFormEnableAnonymousComments' 
 t('enable_anonymous_comments_info') 
 end 
 end 
 t('tags') 
 text_field 'message', 'tags', :id => 'messageFormTags', :class => 'long' 
t('tags_info') 
 if @message.new_record? 
 t('email_notification') 
 t('email_notification_info') 
 @active_project.companies.each do |company| 
 company.id 
 company.id 
 users_on_project = company.users_on_project(@active_project) 
 check_box_tag "notify_company[]", "#{company.id}", false, {:id => "notifyCompany#{company.id}", :class => 'checkbox', :onclick => "notify_form_select_company(#{company.id})"} 
 "notifyCompany#{company.id}" 
 h company.name 
 users_on_project.each do |user| 
 check_box_tag "notify_user[]", "#{user.id}", false, {:id => "notifyUser#{user.id}", :class => 'checkbox', :onclick => "notify_form_select(#{company.id}, #{user.id})"} 
 "notifyUser#{user.id}" 
 h user.display_name 
 company.id 
 user.id 
 end 
 company.id 
 end 
 end 
 if can? :create_file, @active_project 
  t('attach_files') 
 
 end 
 
 t('add_message') 

end
 }
        
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.xml
  def update
    authorize! :edit, @message
    
    message_attribs = params[:message]
    @message.attributes = message_attribs
    
    @message.updated_by = @logged_user
    @message.tags = message_attribs[:tags]

    saved = @message.save
    estatus = :success_edited_message
    
    # handle uploaded files
    if saved
      if (!params[:uploaded_files].nil? and ProjectFile.handle_files(params[:uploaded_files], @message, @logged_user, @message.is_private) != params[:uploaded_files].length)
        estatus = :success_edited_message_failed_attachments
      end
    end

    respond_to do |format|
      if saved
        format.html {
          error_status(false, estatus)
          redirect_back_or_default(@message)
        }
        
        format.xml  { head :ok }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_tag( message_path(:id => @message.id), :method => :put, :multipart => true ) 
  error_messages_for :message 
 t('title') 
 text_field 'message', 'title', :id => 'messageFormTitle', :class => 'title' 
 t('text') 
 text_area 'message', 'text', :id => 'messageFormText', :class => 'editor' 
 t('milestone') 
 select 'message', 'milestone_id', select_milestone_options(@active_project), {}, {:class => 'select_milestone', :id => 'messageFormMilestone'} 
 t('category') 
 select 'message', 'category_id', Category.select_list(@active_project), {}, {:class => 'select_milestone', :id => 'messageFormCategory'} 
 if @logged_user.member_of_owner? 
 t('options') 
 t('private_message') 
 yesno_toggle 'message', 'is_private', :class => 'yes_no', :id => 'messageFormIsPrivate' 
 t('private_message_info') 
 t('important_message') 
 yesno_toggle 'message', 'is_important', :class => 'yes_no', :id => 'messageFormIsImportant' 
 t('important_message_info') 
 t('enable_comments') 
 yesno_toggle 'message', 'comments_enabled', :class => 'yes_no', :id => 'messageFormEnableComments' 
 t('enable_comments_info') 
 if Rails.configuration.allow_anonymous 
 t('enable_anonymous_comments') 
 yesno_toggle 'message', 'anonymous_comments_enabled', :class => 'yes_no', :id => 'messageFormEnableAnonymousComments' 
 t('enable_anonymous_comments_info') 
 end 
 end 
 t('tags') 
 text_field 'message', 'tags', :id => 'messageFormTags', :class => 'long' 
t('tags_info') 
 if @message.new_record? 
 t('email_notification') 
 t('email_notification_info') 
 @active_project.companies.each do |company| 
 company.id 
 company.id 
 users_on_project = company.users_on_project(@active_project) 
 check_box_tag "notify_company[]", "#{company.id}", false, {:id => "notifyCompany#{company.id}", :class => 'checkbox', :onclick => "notify_form_select_company(#{company.id})"} 
 "notifyCompany#{company.id}" 
 h company.name 
 users_on_project.each do |user| 
 check_box_tag "notify_user[]", "#{user.id}", false, {:id => "notifyUser#{user.id}", :class => 'checkbox', :onclick => "notify_form_select(#{company.id}, #{user.id})"} 
 "notifyUser#{user.id}" 
 h user.display_name 
 company.id 
 user.id 
 end 
 company.id 
 end 
 end 
 if can? :create_file, @active_project 
  t('attach_files') 
 
 end 
 
 t('edit_message') 

end
 }
        
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
    authorize! :delete, @message
    
    @message.updated_by = @logged_user
    @message.destroy
    
    respond_to do |format|
      format.html {
        error_status(false, :success_deleted_message)
        redirect_back_or_default(messages_url(:category_id => params[:category_id]))
      }
      
      format.xml  { head :ok }
    end
  end

  # PUT /messages/1/subscribe
  def subscribe
    authorize! :show, @message

    @message.ensure_subscribed(@logged_user) if @message.class == Message

    respond_to do |format|
      format.html {
        error_status(false, :success_deleted_message)
        redirect_back_or_default(message_url(:id => @message.id))
      }
      
      format.xml  { head :ok }
    end
  end

  # PUT /messages/1/unsubscribe
  def unsubscribe
    authorize! :show, @message

  	@message.subscribers.delete(@logged_user)

    respond_to do |format|
      format.html {
        error_status(false, :success_deleted_message)
        redirect_back_or_default(message_url(:id => @message.id))
      }
      
      format.xml  { head :ok }
    end
  end

private

   def obtain_message
     begin
        @message = @active_project.messages.find(params[:id])
     rescue ActiveRecord::RecordNotFound
       error_status(true, :invalid_message)
       redirect_back_or_default messages_path
       return false
     end
     
     return true
  end

end

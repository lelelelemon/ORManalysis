#==
# RailsCollab
# Copyright (C) 2007 - 2011 James S Urquhart
# Portions Copyright (C) René Scheibe
# Portions Copyright (C) Ariejan de Vroom
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

class MilestonesController < ApplicationController

  layout 'project_website'
  helper 'project_items'

  before_filter :process_session
  before_filter :obtain_milestone, :except => [:index, :new, :create]
  after_filter  :user_track,       :only   => [:index, :show]

  def index
    @content_for_sidebar = 'index_sidebar'
    
    respond_to do |format|
      format.html {
        index_lists(@logged_user.member_of_owner?, false)
      }
      format.xml  {
        @milestones = @logged_user.member_of_owner? ? @active_project.milestones : @active_project.milestones.is_public
        render :xml => @milestones.to_xml(:root => 'milestones')
      }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  unless @late_milestones.empty? and @calendar_milestones.empty? and @upcoming_milestones.empty? 
 unless @late_milestones.empty? 
 t('late_milestones') 
           render :partial => 'show', :collection => [@milestone] 
 
 
 
 
 
 
 
 
 
 
 end 
 unless @upcoming_milestones.empty? 
 t('upcoming_milestones') 
 unless @calendar_milestones.empty? 
 t('due_in_next_n_days', :num => 14) 
  now = @time_now.to_date
    prev_month = now.month
    days_calendar now, now + 13.days, 'dayCal' do |date|
      unless date == now
        if date.month != prev_month
          prev_month = date.month
          calendar_block(t(date, :format => '%b %d'), @calendar_milestones["#{date.month}-#{date.day}"], 'day')
        else
          calendar_block(date.day, @calendar_milestones["#{date.month}-#{date.day}"], 'day')
        end
      else
        calendar_block(t('today'), @calendar_milestones["#{date.month}-#{date.day}"], 'today', true)
      end
    end 
 
 end 
 t('all_upcoming_milestones') 
           render :partial => 'show', :collection => [@milestone] 
 
 
 
 
 
 
 
 
 
 
 end 
 else 
 t('no_active_milestones_in_project') 
 end 
 

end

  end

  def show
    authorize! :show, @milestone
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
            render :partial => 'show', :collection => [@milestone] 
 
 
 
 
 
 
 
 
 
 
 

end

  end

  def new
    authorize! :create_milestone, @active_project
    @milestone = @active_project.milestones.build
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_tag milestones_path 
  error_messages_for :milestone 
 t('name') 
 text_field 'milestone', 'name', :id => 'milestoneFormName', :class => 'long' 
 t('description') 
 text_area 'milestone', 'description', :id => 'milestoneFormDesc', :class => 'short', :rows => 10, :cols => 40 
 t('due_date') 
 date_select 'milestone', 'due_date', :id => 'milestoneDueDate', :class => 'short' 
 if @logged_user.member_of_owner? 
 t('private_milestone') 
 t('milestones_private_info') 
 yesno_toggle 'milestone', 'is_private', :id => 'milestoneIsPrivate', :class => 'checkbox'  
 end 
 t('assign_to') 
 assign_project_select 'milestone', 'assigned_to_id', @active_project, :id => 'milestoneFormAssignedTo' 
 check_box_tag 'send_notification', '1', params[:send_notification], :id => 'milestoneFormSendNotification', :class => 'checkbox'  
 t('send_email_notification_to_user') 
 t('tags') 
 text_field 'milestone', 'tags', :id => 'milestoneFormTags', :class => 'long' 
 t('tags_info') 
 
 t('add_milestone') 

end

  end
  
  def create
    authorize! :create_milestone, @active_project
    @milestone = @active_project.milestones.build
    
    milestone_attribs = params[:milestone]
    @milestone.attributes = milestone_attribs
    @milestone.created_by = @logged_user
    
    saved = @milestone.save
    if saved
      @milestone.tags = milestone_attribs[:tags]
      Notifier.deliver_milestone(@milestone.user, @milestone) if params[:send_notification] and @milestone.user
    end
    
    respond_to do |format|
      if saved
        format.html {
          error_status(false, :success_added_milestone)
          redirect_back_or_default(@milestone)
        }
        format.xml  { render :xml => @milestone.to_xml(:root => 'milestone'), :status => :created, :location => @milestone }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_tag milestones_path 
  error_messages_for :milestone 
 t('name') 
 text_field 'milestone', 'name', :id => 'milestoneFormName', :class => 'long' 
 t('description') 
 text_area 'milestone', 'description', :id => 'milestoneFormDesc', :class => 'short', :rows => 10, :cols => 40 
 t('due_date') 
 date_select 'milestone', 'due_date', :id => 'milestoneDueDate', :class => 'short' 
 if @logged_user.member_of_owner? 
 t('private_milestone') 
 t('milestones_private_info') 
 yesno_toggle 'milestone', 'is_private', :id => 'milestoneIsPrivate', :class => 'checkbox'  
 end 
 t('assign_to') 
 assign_project_select 'milestone', 'assigned_to_id', @active_project, :id => 'milestoneFormAssignedTo' 
 check_box_tag 'send_notification', '1', params[:send_notification], :id => 'milestoneFormSendNotification', :class => 'checkbox'  
 t('send_email_notification_to_user') 
 t('tags') 
 text_field 'milestone', 'tags', :id => 'milestoneFormTags', :class => 'long' 
 t('tags_info') 
 
 t('add_milestone') 

end
 }
        format.xml  { render :xml => @milestone.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    authorize! :edit, @milestone
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_tag milestone_path(:id => @milestone.id), :method => :put 
  error_messages_for :milestone 
 t('name') 
 text_field 'milestone', 'name', :id => 'milestoneFormName', :class => 'long' 
 t('description') 
 text_area 'milestone', 'description', :id => 'milestoneFormDesc', :class => 'short', :rows => 10, :cols => 40 
 t('due_date') 
 date_select 'milestone', 'due_date', :id => 'milestoneDueDate', :class => 'short' 
 if @logged_user.member_of_owner? 
 t('private_milestone') 
 t('milestones_private_info') 
 yesno_toggle 'milestone', 'is_private', :id => 'milestoneIsPrivate', :class => 'checkbox'  
 end 
 t('assign_to') 
 assign_project_select 'milestone', 'assigned_to_id', @active_project, :id => 'milestoneFormAssignedTo' 
 check_box_tag 'send_notification', '1', params[:send_notification], :id => 'milestoneFormSendNotification', :class => 'checkbox'  
 t('send_email_notification_to_user') 
 t('tags') 
 text_field 'milestone', 'tags', :id => 'milestoneFormTags', :class => 'long' 
 t('tags_info') 
 
 t('edit_milestone') 

end

  end
  
  def update
    authorize! :edit, @milestone
 
    milestone_attribs = params[:milestone]
    @milestone.attributes = milestone_attribs
    
    @milestone.updated_by = @logged_user
    @milestone.tags = milestone_attribs[:tags]

    saved = @milestone.save
    
    respond_to do |format|
      if saved
        Notifier.deliver_milestone(@milestone.user, @milestone) if params[:send_notification] and @milestone.user
        format.html {
          error_status(false, :success_edited_milestone)
          redirect_back_or_default(@milestone)
        }
        format.xml  { head :ok }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_tag milestone_path(:id => @milestone.id), :method => :put 
  error_messages_for :milestone 
 t('name') 
 text_field 'milestone', 'name', :id => 'milestoneFormName', :class => 'long' 
 t('description') 
 text_area 'milestone', 'description', :id => 'milestoneFormDesc', :class => 'short', :rows => 10, :cols => 40 
 t('due_date') 
 date_select 'milestone', 'due_date', :id => 'milestoneDueDate', :class => 'short' 
 if @logged_user.member_of_owner? 
 t('private_milestone') 
 t('milestones_private_info') 
 yesno_toggle 'milestone', 'is_private', :id => 'milestoneIsPrivate', :class => 'checkbox'  
 end 
 t('assign_to') 
 assign_project_select 'milestone', 'assigned_to_id', @active_project, :id => 'milestoneFormAssignedTo' 
 check_box_tag 'send_notification', '1', params[:send_notification], :id => 'milestoneFormSendNotification', :class => 'checkbox'  
 t('send_email_notification_to_user') 
 t('tags') 
 text_field 'milestone', 'tags', :id => 'milestoneFormTags', :class => 'long' 
 t('tags_info') 
 
 t('edit_milestone') 

end
 }
        format.xml  { render :xml => @milestone.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize! :delete, @milestone

    @on_page = (params[:on_page] || '').to_i == 1
    @removed_id = @milestone.id
    @milestone.updated_by = @logged_user
    @milestone.destroy

    respond_to do |format|
      format.html {
        error_status(false, :success_deleted_milestone)
        redirect_back_or_default(milestones_url)
      }
      format.xml  { head :ok }
    end
  end

  def complete
    authorize! :change_status, @milestone
    return error_status(true, :milestone_already_completed) if (@milestone.is_completed?)

    @milestone.set_completed(true, @logged_user)
    
    error_status(true, :error_saving) unless @milestone.save
    redirect_back_or_default milestone_path(:id => @milestone.id)
  end

  def open
    authorize! :change_status, @milestone
    return error_status(true, :milestone_already_open) unless (@milestone.is_completed?)

    @milestone.set_completed(false, @logged_user)
    
    error_status(true, :error_saving) unless @milestone.save
    redirect_back_or_default milestone_path(:id => @milestone.id)
  end

  private

  def obtain_milestone
    begin
      @milestone = @active_project.milestones.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      error_status(true, :invalid_milestone)
      redirect_back_or_default milestones_path
      return false
    end

    true
  end

  def index_lists(include_private, calendar_only)
    @time_now = Time.zone.now

    unless calendar_only
      @late_milestones = @active_project.milestones.late
      @late_milestones = @late_milestones.is_public unless include_private
    end
    @upcoming_milestones = Milestone.all_assigned_to(@logged_user, nil, @time_now.utc.to_date, nil, [@active_project])
    unless calendar_only
      @completed_milestones = @active_project.milestones.completed
      @completed_milestones = @completed_milestones.is_public unless include_private
    end

    end_date = (@time_now + 14.days).to_date
    @calendar_milestones = @upcoming_milestones.select{|m| m.due_date < end_date}.group_by do |obj|
      date = obj.due_date.to_date
      "#{date.month}-#{date.day}"
    end
  end
end

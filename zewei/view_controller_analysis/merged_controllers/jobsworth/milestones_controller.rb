# encoding: UTF-8
# Handle basic CRUD functionality regarding Milestones
class MilestonesController < ApplicationController
  before_filter :access_to_milestones, :except => [:index, :new, :create, :get_milestones]

  def index
    all_project_ids = current_user.all_project_ids
    
    @scheduled_milestones = current_user.company.milestones.active.where([ "project_id in (?)", all_project_ids ]).where("due_at IS NOT NULL").order("due_at ASC")
    @unscheduled_milestones = current_user.company.milestones.active.where([ "project_id in (?)", all_project_ids ]).where(:due_at => nil)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title = t("milestones.edit_title", title: Setting.productName) 
 t("milestones.milestones") 
 current_day = nil 
 today_drawn = false 
 @scheduled_milestones.each do |ml| 
 if current_day != ml.due_at.strftime("%a, %d %b %Y")  
 if current_day 
 end 
 current_day = ml.due_at.strftime("%a, %d %b %Y") 
 if !today_drawn and ml.due_at > Time.now 
 today_drawn = true 
 end 
 current_day 
 end 
 link_to_milestone ml, :text => "#{ml.project.name}/#{ml.name}" 
 milestone_status_tag(ml) 
 if current_user.can?(ml.project, 'milestone') 
 link_to '<i class="icon-pencil"></i>'.html_safe, edit_milestone_path(ml), :class => "hide action" 
 end 
 ml.description 
 number_to_percentage(ml.percent_complete, :precision => 0)  
 end 
 if current_day 
 end 
 if @unscheduled_milestones.count > 0 
 t("milestones.unscheduled") 
 @unscheduled_milestones.each do |ml| 
 link_to_milestone ml, :text => "#{ml.project.name}/#{ml.name}" 
 milestone_status_tag(ml) 
 if current_user.can?(ml.project, 'milestone') 
 link_to '<i class="icon-pencil"></i>'.html_safe, edit_milestone_path(ml), :class => "hide action" 
 end 
 ml.description 
 number_to_percentage(ml.percent_complete, :precision => 0)  
 end 
 end 

end

  end

  def new
    @milestone = Milestone.new
    @milestone.user = current_user
    @milestone.project_id = params[:project_id]

    unless current_user.can?(@milestone.project, 'milestone')
      message = t('flash.alert.access_denied_to_model', model: Project.human_attribute_name(:milestones))

      if request.xhr?
        render text: message
      else
        redirect_to "/activities", alert: message
      end
      return
    end

    if request.xhr?
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t("milestones.create") 
 form_tag '/milestones/create' , :remote => true, :name => 'milestoneForm', :id => "add_milestone_form", :class => "form-horizontal" do 
  t("milestones.project") 
 select 'milestone', 'project_id', grouped_client_projects_options(current_user.projects) 
 t("milestones.name") 
 text_field 'milestone', 'name'  
 t("milestones.status") 
 milestone_status_select_tag(@milestone) 
 milestone_status_tip(@milestone.status_name || :planning) 
 current_user.dateFormat 
 t("milestones.due_date") 
 text_field 'milestone', 'due_at', :class=>:datefield, :value=> (@milestone.due_date.nil? ? "" : @milestone.due_date.utc.strftime("#{current_user.date_format}"))  
 t("milestones.description") 
 text_area 'milestone', 'description', :rows => 5, :class => "input-xxlarge"  
 
 end 

end

    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title = t("milestones.new_title", title: Setting.productName) 
 form_tag({:action => 'create'}, {:class => "form-horizontal"}) do 
 "<legend>#{ t("milestones.new") }</legend>".html_safe unless @disable_title 
  t("milestones.project") 
 select 'milestone', 'project_id', grouped_client_projects_options(current_user.projects) 
 t("milestones.name") 
 text_field 'milestone', 'name'  
 t("milestones.status") 
 milestone_status_select_tag(@milestone) 
 milestone_status_tip(@milestone.status_name || :planning) 
 current_user.dateFormat 
 t("milestones.due_date") 
 text_field 'milestone', 'due_at', :class=>:datefield, :value=> (@milestone.due_date.nil? ? "" : @milestone.due_date.utc.strftime("#{current_user.date_format}"))  
 t("milestones.description") 
 text_area 'milestone', 'description', :rows => 5, :class => "input-xxlarge"  
 
 t("button.create") 
 end 

end

  end

  # Ajax callback from milestone popup window to create a new milestone on submitting the form
  def create
    @milestone = Milestone.new(params[:milestone])
    unless current_user.can?(@milestone.project, 'milestone')
      flash[:error] = t('flash.alert.access_denied_to_model', model: Project.human_attribute_name(:milestones))
      redirect_to "/activities"
      return
    end
    logger.debug "Creating new milestone #{@milestone.name}"
    set_due_at
    @milestone.company_id = current_user.company_id
    @milestone.user = current_user

    if @milestone.save
      unless request.xhr?
        flash[:success] = t('flash.notice.model_created', model: Milestone.model_name.human)
        redirect_to :controller => 'projects', :action => 'edit', :id => @milestone.project
      else
        #bind 'ajax:success' event
        #return json to provide refreshMilestones parameters
        render :json => {:project_id => @milestone.project_id, :milestone_id => @milestone.id, :status => "success"}
      end
    else
      flash[:error] = @milestone.errors.full_messages.join(". ")
      if request.xhr?
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title = t("milestones.new_title", title: Setting.productName) 
 form_tag({:action => 'create'}, {:class => "form-horizontal"}) do 
 "<legend>#{ t("milestones.new") }</legend>".html_safe unless @disable_title 
  t("milestones.project") 
 select 'milestone', 'project_id', grouped_client_projects_options(current_user.projects) 
 t("milestones.name") 
 text_field 'milestone', 'name'  
 t("milestones.status") 
 milestone_status_select_tag(@milestone) 
 milestone_status_tip(@milestone.status_name || :planning) 
 current_user.dateFormat 
 t("milestones.due_date") 
 text_field 'milestone', 'due_at', :class=>:datefield, :value=> (@milestone.due_date.nil? ? "" : @milestone.due_date.utc.strftime("#{current_user.date_format}"))  
 t("milestones.description") 
 text_area 'milestone', 'description', :rows => 5, :class => "input-xxlarge"  
 
 t("button.create") 
 end 

end

      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title = t("milestones.new_title", title: Setting.productName) 
 form_tag({:action => 'create'}, {:class => "form-horizontal"}) do 
 "<legend>#{ t("milestones.new") }</legend>".html_safe unless @disable_title 
  t("milestones.project") 
 select 'milestone', 'project_id', grouped_client_projects_options(current_user.projects) 
 t("milestones.name") 
 text_field 'milestone', 'name'  
 t("milestones.status") 
 milestone_status_select_tag(@milestone) 
 milestone_status_tip(@milestone.status_name || :planning) 
 current_user.dateFormat 
 t("milestones.due_date") 
 text_field 'milestone', 'due_at', :class=>:datefield, :value=> (@milestone.due_date.nil? ? "" : @milestone.due_date.utc.strftime("#{current_user.date_format}"))  
 t("milestones.description") 
 text_area 'milestone', 'description', :rows => 5, :class => "input-xxlarge"  
 
 t("button.create") 
 end 

end

      end
    end
  end

  def edit
    if @milestone.closed?
      flash[:error] = t('flash.error.model_closed', model: Milestone.model_name.human)
      redirect_to edit_project_path(@milestone.project)
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title = t("milestones.edit_title", title: "#{@milestone.name} - #{Setting.productName}") 
 form_for(@milestone, :html => {:class => "form-horizontal"}) do 
 t("milestones.edit") 
 link_to_tasks_filtered_by(t("milestones.view_tasks"), @milestone, :class => "btn btn-success pull-right") 
  t("milestones.project") 
 select 'milestone', 'project_id', grouped_client_projects_options(current_user.projects) 
 t("milestones.name") 
 text_field 'milestone', 'name'  
 t("milestones.status") 
 milestone_status_select_tag(@milestone) 
 milestone_status_tip(@milestone.status_name || :planning) 
 current_user.dateFormat 
 t("milestones.due_date") 
 text_field 'milestone', 'due_at', :class=>:datefield, :value=> (@milestone.due_date.nil? ? "" : @milestone.due_date.utc.strftime("#{current_user.date_format}"))  
 t("milestones.description") 
 text_area 'milestone', 'description', :rows => 5, :class => "input-xxlarge"  
 
 t("button.save") 
 if current_user.can?( @milestone.project, 'milestone' ) 
 link_to t("button.delete"), milestone_path(@milestone), :method => :delete, :confirm => t("shared.are_you_sure"), :class => "btn btn-mini btn-danger pull-right"  
 if @milestone.closed? 
 link_to t("milestones.reopen"), revert_milestone_path(@milestone), :confirm => t("shared.are_you_sure"), :method => :post, :class => "btn" 
 else 
 link_to t("milestones.complete"), complete_milestone_path(@milestone), :confirm => t("shared.are_you_sure"), :method => :post, :class => "btn" 
 end 
 end 
 end 
 if current_user.company.use_score_rules? 
 t("milestones.score_rules") 
 container_name 
 container_id 
 
 end 

end

  end

  def update
    if @milestone.closed?
      flash[:error] = t('flash.error.model_closed', model: Milestone.model_name.human)
      redirect_to edit_project_path(@milestone.project)
    end

    @milestone.attributes = params[:milestone]
    set_due_at
    if @milestone.save
      flash[:success] = t('flash.notice.model_updated', model: Milestone.model_name.human)
      redirect_to :controller => 'projects', :action => 'edit', :id => @milestone.project
    else
      flash[:error] = @milestone.errors.full_messages.join(". ")
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title = t("milestones.edit_title", title: "#{@milestone.name} - #{Setting.productName}") 
 form_for(@milestone, :html => {:class => "form-horizontal"}) do 
 t("milestones.edit") 
 link_to_tasks_filtered_by(t("milestones.view_tasks"), @milestone, :class => "btn btn-success pull-right") 
  t("milestones.project") 
 select 'milestone', 'project_id', grouped_client_projects_options(current_user.projects) 
 t("milestones.name") 
 text_field 'milestone', 'name'  
 t("milestones.status") 
 milestone_status_select_tag(@milestone) 
 milestone_status_tip(@milestone.status_name || :planning) 
 current_user.dateFormat 
 t("milestones.due_date") 
 text_field 'milestone', 'due_at', :class=>:datefield, :value=> (@milestone.due_date.nil? ? "" : @milestone.due_date.utc.strftime("#{current_user.date_format}"))  
 t("milestones.description") 
 text_area 'milestone', 'description', :rows => 5, :class => "input-xxlarge"  
 
 t("button.save") 
 if current_user.can?( @milestone.project, 'milestone' ) 
 link_to t("button.delete"), milestone_path(@milestone), :method => :delete, :confirm => t("shared.are_you_sure"), :class => "btn btn-mini btn-danger pull-right"  
 if @milestone.closed? 
 link_to t("milestones.reopen"), revert_milestone_path(@milestone), :confirm => t("shared.are_you_sure"), :method => :post, :class => "btn" 
 else 
 link_to t("milestones.complete"), complete_milestone_path(@milestone), :confirm => t("shared.are_you_sure"), :method => :post, :class => "btn" 
 end 
 end 
 end 
 if current_user.company.use_score_rules? 
 t("milestones.score_rules") 
 container_name 
 container_id 
 
 end 

end

    end
  end

  def destroy
    @milestone.destroy
    redirect_to :controller => 'projects', :action => 'edit', :id => @milestone.project
  end

  def complete
    @milestone.completed_at = Time.now.utc
    @milestone.status_name = :closed
    @milestone.save
    flash[:success] = t('flash.notice.completed',  model: @milestone.to_s)
    redirect_to edit_project_path(@milestone.project)
  end

  def revert
    @milestone.completed_at = nil
    @milestone.status_name = :open
    @milestone.save
    flash[:success] = t('flash.notice.model_reverted', model: @milestone.to_s)
    redirect_to edit_milestone_path(@milestone)
  end

  # Return a json formatted list of options to refresh the Milestone dropdown in tasks create/update page
  # TODO: use MilestonesController#list with json format instead of MilestonesController#get_milestone
  def get_milestones
    if params[:project_id].blank?
      render :text => "" and return
    end

    @milestones = Milestone.can_add_task.order('milestones.due_at, milestones.name').where('company_id = ? AND project_id = ?', current_user.company_id, params[:project_id])
    render :file => 'milestones/get_milestones.json.erb'
  end

  private

  def access_to_milestones
    @milestone = Milestone.where("company_id = ?", current_user.company_id).find(params[:id])
    unless current_user.can?(@milestone.project, 'milestone')
      flash[:error] = t('flash.alert.access_denied_to_model', model: Project.human_attribute_name(:milestones))
      redirect_to "/activities"
      return false
    end
  end

  def set_due_at
    unless params[:milestone][:due_at].blank?
      begin
        # Only care about the date part, parse the input date string into DateTime in UTC.
        # Later, the date part will be converted from DateTime to string display in UTC, so that it doesn't change.
        format = "#{current_user.date_format}"
        @milestone.due_at = DateTime.strptime(params[:milestone][:due_at], format).ago(-12.hours)
      rescue
      end
    end
  end
end

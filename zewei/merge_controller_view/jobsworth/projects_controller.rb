# encoding: UTF-8
# Handle Projects for a company, including permissions

class ProjectsController < ApplicationController
  before_filter :authorize_user_is_admin, :except => [:index, :new, :create, :show, :list_completed]
  before_filter :authorize_user_can_create_projects, :only => [:new, :create]
  before_filter :scope_projects, :except => [:new, :create]

  def index
    @projects = @project_relation
                .in_progress.order('customer_id')
                .includes(:customer, :milestones)
                .paginate(:page => params[:page], :per_page => 100)

    @completed_projects = @project_relation.completed
 @page_title = t("projects.index_title", title: Setting.productName) 
 Project.model_name.human(count: 2) 
 render @projects 
 if current_user.completed_projects.size > 0 
 link_to t("projects.n_completed_projects", n: current_user.completed_projects.size),
              controller: 'projects', action: 'list_completed' 
 end 

  end

  def new
    @project = Project.new
 @page_title = t("projects.new_title", title: Setting.productName) 
 form_tag({:action => 'create'}, :class => "form-horizontal") do 
 t("projects.new_project") 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 t("projects.name") 
 text_field 'project', 'name', {:autocomplete=>"off"}  
 t("projects.company") 
 text_field :customer, :name, {
          :id=>"project_customer_name",
          :value => @project.customer.nil? ? "" :@project.customer.name,
          :autocomplete => "off",
          :rel => "tooltip",
          :title => t("shared.customer_placeholder")
        }
    
 @project.customer.nil? ? "#" : "/customers/edit/#{@project.customer.id}" 
 t("users.goto_company") 
 t("projects.default_user") 
 text_field :default, :user,{:size=> "12", :id => "default_user_name_auto_complete" , :title => t("projects.default_user_placeholder")}
 if @default_users 
 @default_users.each do |user|
 render(:partial => "projects/add_default_user", :locals => { :user => user}) 
 end 
 end 
 t("projects.default_estimate") 
 text_field 'project', 'default_estimate', :title => t("projects.estimate_placeholder"), :rel => "tooltip" 
 if @project.billing_enabled? 
 t("projects.suppressBilling") 
 check_box 'project', 'suppressBilling' 
 t("projects.billing_tip") 
 end 
@project.customer.nil? ? 0 :@project.customer.id 
 t("projects.description") 
 text_area 'project', 'description', :rows => 5, :class => "input-xxlarge"  

end
 
 if current_user.all_projects.size > 0 
 t("permissions.copy_permissions") 
 t("shared.none") 
 options_for_select current_user.all_projects.collect{|p| ["#{p.name} [#{p.customer.name}]",p.id]}, params[:copy_project_id].to_i 
 end 
 t("button.create") 
 end 

  end

  def add_default_user
    if params[:user_id]
      user = current_user.company.users.active.find(params[:user_id])
    end
    if params[:users]
      @existing_users = User.where("name in (?)", params[:users])
      if @existing_users.include?(user)
        user = []
      end
    end
    render(:partial => "projects/add_default_user", :locals => { :user => user})
 if user.present? 
 active_class = user.active ? "":"inactive" 
 link_to user.to_html, [:edit, user], :class => "username pull-left #{active_class}", :target => "_blank" 
 hidden_field_tag("project[default_user_ids][]", user.id) 
 link_to('<i class="icon-remove"></i>'.html_safe, "#", :class => "removeLink") 
 end 

  end

  def create
    @project = Project.new(params[:project])
    @project.company_id = current_user.company_id
    if (params[:project][:customer_id].to_i == 0)
      @project.customer_id = current_user.company.internal_customer.id  
    end

    if @project.save
      # create a task filter for the project
      open = current_user.company.statuses.first
      TaskFilter.create(:qualifiers_attributes => [{:qualifiable => @project}, {:qualifiable => open}], :shared => true, :user => current_user, :name => @project.name)

      create_project_permissions_for(@project, params[:copy_project_id])
      check_if_project_has_users(@project)
    else
      flash[:error] = @project.errors.full_messages.join(". ")
      render :new
    end
  end

  def edit
    @project = @project_relation.find(params[:id])

    if @project.nil?
      flash[:error] = t('flash.error.not_exists_or_no_permission', model: Project.model_name.human)
      redirect_to root_path
    else
      @users = User.where("company_id = ?", current_user.company_id).order("users.name")
      @default_users = User.joins("INNER JOIN default_project_users on default_project_users.user_id = users.id").where("default_project_users.project_id = ?", @project.id)
    end
 @page_title = t("projects.edit_title", title: "#{@project.name} - #{Setting.productName}") 
 form_for(@project, :html => {:class => "form-horizontal"}) do 
 t("projects.edit") 
 link_to_tasks_filtered_by(t('projects.view_tasks'), @project, :class => "btn btn-success pull-right") 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 t("projects.name") 
 text_field 'project', 'name', {:autocomplete=>"off"}  
 t("projects.company") 
 text_field :customer, :name, {
          :id=>"project_customer_name",
          :value => @project.customer.nil? ? "" :@project.customer.name,
          :autocomplete => "off",
          :rel => "tooltip",
          :title => t("shared.customer_placeholder")
        }
    
 @project.customer.nil? ? "#" : "/customers/edit/#{@project.customer.id}" 
 t("users.goto_company") 
 t("projects.default_user") 
 text_field :default, :user,{:size=> "12", :id => "default_user_name_auto_complete" , :title => t("projects.default_user_placeholder")}
 if @default_users 
 @default_users.each do |user|
 render(:partial => "projects/add_default_user", :locals => { :user => user}) 
 end 
 end 
 t("projects.default_estimate") 
 text_field 'project', 'default_estimate', :title => t("projects.estimate_placeholder"), :rel => "tooltip" 
 if @project.billing_enabled? 
 t("projects.suppressBilling") 
 check_box 'project', 'suppressBilling' 
 t("projects.billing_tip") 
 end 
@project.customer.nil? ? 0 :@project.customer.id 
 t("projects.description") 
 text_area 'project', 'description', :rows => 5, :class => "input-xxlarge"  

end
 
 if current_user.admin?
 link_to t("button.delete"), project_path(@project), :method => "delete", :confirm => t("shared.are_you_sure"), :class => "btn btn-mini btn-danger pull-right" 
 end 
 if current_user.can?( @project, 'grant' ) || current_user.admin > 0 
 if @project.complete? 
 link_to( t("projects.reopen"), revert_project_path(@project), :confirm => t("shared.are_you_sure"), :method => :post, :class => "btn") 
 else 
 link_to( t("projects.complete"), complete_project_path(@project), :confirm => t("shared.are_you_sure"), :method => :post, :class => "btn") 
 end 
 end 
 end 
 if current_user.can?( @project, 'milestone' ) || current_user.admin > 0 
 link_to t("projects.new_milestone"), new_milestone_path(:project_id => @project), :class => "btn pull-right"  
 end 
 t("projects.milestones") 
 t("projects.completed_milestones") 
 if current_user.company.use_score_rules? 
 t("projects.score_rules") 
 end 
 if current_user.can?( @project, 'grant' ) 
 t("projects.access_control") 
 end 
 for milestone in @project.milestones.active.scheduled.order("due_at, milestones.name").includes(:user) 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 milestone.due_at ? milestone.due_at.strftime("%a, %d %b %Y") : t("milestones.unscheduled") 
 link_to_milestone milestone 
 milestone_status_tag(milestone) 
 if current_user.can?(milestone.project, 'milestone') 
 link_to '<i class="icon-pencil"></i>'.html_safe, edit_milestone_path(milestone), :class => "hide action" 
 end 
 milestone.description 
 number_to_percentage(milestone.percent_complete, :precision => 0)  

end
end 
 for milestone in @project.milestones.active.unscheduled.order("due_at, milestones.name").includes(:user) 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 milestone.due_at ? milestone.due_at.strftime("%a, %d %b %Y") : t("milestones.unscheduled") 
 link_to_milestone milestone 
 milestone_status_tag(milestone) 
 if current_user.can?(milestone.project, 'milestone') 
 link_to '<i class="icon-pencil"></i>'.html_safe, edit_milestone_path(milestone), :class => "hide action" 
 end 
 milestone.description 
 number_to_percentage(milestone.percent_complete, :precision => 0)  

end
end 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 t("milestones.name") 
 t("milestones.completed") 
 t("milestones.tasks") 
 if current_user.can?(project, 'milestone' ) || current_user.admin > 0 
 end 
 project.milestones.completed.each do |m| 
 "#{m.project.customer.name} / #{m.project.name} / #{m.name}" 
 tz.utc_to_local(m.completed_at).strftime(current_user.date_format) 
 link_to_milestone m, :text => m.tasks.size 
 if current_user.can?(project, 'milestone' ) || current_user.admin > 0 
 link_to( t("milestones.revert"), revert_milestone_path(m), :method => :post, :confirm => t("shared.are_you_sure") ) 
 end 
 end 

end
  
 if current_user.company.use_score_rules? 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
container_name 
 container_id 

end
 
 end 
 if current_user.can?( @project, 'grant' ) 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 t("projects.user") 
 t("permissions.read") 
 t("permissions.comment") 
 t("permissions.work") 
 t("permissions.close") 
 t("permissions.see_unwatched") 
 t("permissions.create") 
 t("permissions.edit") 
 t("permissions.assign") 
 t("permissions.milestones") 
 t("permissions.reports") 
 t("permissions.grant") 
 t("permissions.all") 
 @project.users.each do |user| 
 @user = user 
 render(:partial => "users/project", :locals => { :project => @project, :user_edit => false }) 
 end 
 t("users.add_project_to_user") 
 text_field :user, :name, {:id => "project_user_name_autocomplete", :value => "" } 
 @project.id 

end
 
 end 

  end

  def show
    @project = @project_relation.find(params[:id])
    if @project.nil?
      flash[:error] = t('flash.error.not_exists_or_no_permission', model: Project.model_name.human)
      redirect_to root_path
    else
      @users = User.where("company_id = ?", current_user.company_id).order("users.name")
    end
 @page_title = t("projects.edit_title", title: "#{@project.name} - #{Setting.productName}") 
 @project.name 
 link_to_tasks_filtered_by( t("projects.view_tasks"), @project, :class => "btn btn-success pull-right") 
 t("projects.name") 
 @project.name 
 t("projects.customer") 
 @project.customer 
 @project.customer.nil? ? "#" : "/customers/edit/#{@project.customer.id}" 
 t("projects.estimate") 
 @project.default_estimate 
 if @project.billing_enabled? 
 t("projects.suppressBilling") 
 @project.suppressBilling 
 end 
 t("projects.description") 
 @project.description 
 if current_user.admin?
 link_to t("button.delete"), project_path(@project), :method => "delete", :confirm => t("shared.are_you_sure"), :class => "btn btn-mini btn-danger pull-right" 
 if @project.complete? 
 link_to( t("projects.reopen"), revert_project_path(@project), :confirm => t("shared.are_you_sure"), :method => :post, :class => "btn") 
 else 
 link_to( t("projects.complete"), complete_project_path(@project), :confirm => t("shared.are_you_sure"), :method => :post, :class => "btn") 
 end 
 link_to( t("button.edit"), {:controller => 'projects', :action => 'edit', :id => @project}, :class => "btn") 
 end 
 if current_user.can?( @project, 'milestone' ) || current_user.admin > 0 
 link_to t("projects.new_milestone"), new_milestone_path(:project_id => @project), :class => "btn pull-right"  
 end 
 t("projects.milestones") 
 t("projects.completed_milestones") 
 if current_user.company.use_score_rules? 
 t("projects.score_rules") 
 end 
 for milestone in @project.milestones.active.scheduled.order("due_at, milestones.name").includes(:user) 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 milestone.due_at ? milestone.due_at.strftime("%a, %d %b %Y") : t("milestones.unscheduled") 
 link_to_milestone milestone 
 milestone_status_tag(milestone) 
 if current_user.can?(milestone.project, 'milestone') 
 link_to '<i class="icon-pencil"></i>'.html_safe, edit_milestone_path(milestone), :class => "hide action" 
 end 
 milestone.description 
 number_to_percentage(milestone.percent_complete, :precision => 0)  

end
end 
 for milestone in @project.milestones.active.unscheduled.order("due_at, milestones.name").includes(:user) 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 milestone.due_at ? milestone.due_at.strftime("%a, %d %b %Y") : t("milestones.unscheduled") 
 link_to_milestone milestone 
 milestone_status_tag(milestone) 
 if current_user.can?(milestone.project, 'milestone') 
 link_to '<i class="icon-pencil"></i>'.html_safe, edit_milestone_path(milestone), :class => "hide action" 
 end 
 milestone.description 
 number_to_percentage(milestone.percent_complete, :precision => 0)  

end
end 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 t("milestones.name") 
 t("milestones.completed") 
 t("milestones.tasks") 
 if current_user.can?(project, 'milestone' ) || current_user.admin > 0 
 end 
 project.milestones.completed.each do |m| 
 "#{m.project.customer.name} / #{m.project.name} / #{m.name}" 
 tz.utc_to_local(m.completed_at).strftime(current_user.date_format) 
 link_to_milestone m, :text => m.tasks.size 
 if current_user.can?(project, 'milestone' ) || current_user.admin > 0 
 link_to( t("milestones.revert"), revert_milestone_path(m), :method => :post, :confirm => t("shared.are_you_sure") ) 
 end 
 end 

end
  
 if current_user.company.use_score_rules? 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
container_name 
 container_id 

end
 
 end 

  end

  def update
    @project = @project_relation.in_progress.find(params[:id])

    if @project.update_attributes(params[:project])
      flash[:success] = t('flash.notice.model_updated', model: Project.model_name.human)
      redirect_to projects_path
    else
      render :edit
    end
  end

  def destroy
    project = @project_relation.find(params[:id])

    if project.destroy
      flash[:success] = t('flash.notice.model_deleted', model: Project.model_name.human)
    else
      flash[:error] = project.errors[:base].join(', ')
    end

    redirect_to projects_path
  end

  ###
  # TODO: 'complete' and 'revert' can be replaced by 'update'...
  # remove this two actions after refactoring the view
  ###
  def complete
    project = @project_relation.in_progress.find(params[:id])

    unless project.nil?
      project.completed_at = Time.now.utc
      project.save
      flash[:success] = t('flash.notice.model_completed', model: project.name)
    end

    redirect_to edit_project_path(project)
  end

  def revert
    project = @project_relation.completed.find(params[:id])

    unless project.nil?
      project.completed_at = nil
      project.save
      flash[:success] = t('flash.notice.model_reverted', model: project.name)
    end

    redirect_to edit_project_path(project)
  end

  def list_completed
    @completed_projects = @project_relation.completed.order("completed_at DESC")
 @page_title = t("projects.completed_title", title: Setting.productName) 
 t("projects.completed_projects") 
 t("projects.name") 
 t("projects.completed") 
 t("projects.tasks") 
 @completed_projects.each do |p| 
 "#{p.customer.name} / #{p.name}" 
 tz.utc_to_local(p.completed_at).strftime(current_user.date_format) 
 p.tasks.size 
 link_to( t("projects.revert"), revert_project_path(p), :method => :post, :confirm => t("shared.are_you_sure") ) 
 end 

  end

  ###
  ## TODO: Move this to the ProjectsPermissions controller
  ###
  def ajax_remove_permission
    permission = ProjectPermission.where("user_id = ? AND project_id = ? AND company_id = ?", params[:user_id], params[:id], current_user.company_id).first

    if params[:perm].nil? && permission
      permission.destroy
    elsif permission
      permission.remove(params[:perm])
      permission.save
    end

    if params[:user_edit] == "true"
      @user = current_user.company.users.find(params[:user_id])
      render :partial => "/users/project_permissions"
    else
      @project = current_user.company.projects.find(params[:id])
      @users = Company.find(current_user.company_id).users.order("users.name")
      ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 t("projects.user") 
 t("permissions.read") 
 t("permissions.comment") 
 t("permissions.work") 
 t("permissions.close") 
 t("permissions.see_unwatched") 
 t("permissions.create") 
 t("permissions.edit") 
 t("permissions.assign") 
 t("permissions.milestones") 
 t("permissions.reports") 
 t("permissions.grant") 
 t("permissions.all") 
 @project.users.each do |user| 
 @user = user 
 render(:partial => "users/project", :locals => { :project => @project, :user_edit => false }) 
 end 
 t("users.add_project_to_user") 
 text_field :user, :name, {:id => "project_user_name_autocomplete", :value => "" } 
 @project.id 

end

    end
  end

  def ajax_add_permission
    user = User.active.where("company_id = ?", current_user.company_id).find(params[:user_id])

    if current_user.admin?
      @project = current_user.company.projects.find(params[:id])
    else
      @project = current_user.projects.find(params[:id])
    end

    if @project && user && ProjectPermission.where("user_id = ? AND project_id = ?", user.id, @project.id).empty?
      permission = ProjectPermission.new
      permission.user_id = user.id
      permission.project_id = @project.id
      permission.company_id = current_user.company_id
      permission.can_comment = 1
      permission.can_work = 1
      permission.can_close = 1
      permission.save
    else
      permission = ProjectPermission.where("user_id = ? AND project_id = ?", user.id, @project.id).first
      permission.set(params[:perm])
      permission.save
    end

    if params[:user_edit] == "true" && current_user.admin?
      @user = current_user.company.users.find(params[:user_id])
      ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 t("users.project") 
 t("permissions.read") 
 t("permissions.comment") 
 t("permissions.work") 
 t("permissions.close") 
 t("permissions.see_unwatched") 
 t("permissions.create") 
 t("permissions.edit") 
 t("permissions.assign") 
 t("permissions.milestones") 
 t("permissions.reports") 
 t("permissions.grant") 
 t("permissions.all") 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 project.dom_id 
 if user_edit 
 link_to project.name, "/projects/edit/#{project.id}" 
 else 
 link_to @user.name, "/users/edit/#{@user.id}" 
 end 

   perm = @user.project_permissions.where("project_id=?", project.id).first
   perms = ProjectPermission.permissions
 if current_user.admin? and perm 
 link_to_function image_tag("tick.png", :title => t("users.remove_all_access", user: escape_twice(@user.name)).html_safe),
              "jQuery.ajax({url: '#{url_for(:controller => 'projects', :action => 'ajax_remove_permission', :user_id => @user.id, :id => project.id, :user_edit => user_edit)}',
               success: function(response){ jQuery('#permission_list').html(response); }
               })" 
 for p in perms 
 link_to_function image_tag("tick.png", :title => t("users.remove_all_access", user: escape_twice(@user.name)).html_safe),
              "jQuery.ajax({url: '#{url_for(:controller => 'projects', :action => 'ajax_remove_permission', :user_id => @user.id, :id => project.id, :perm => p, :user_edit => user_edit )}',
               success: function(response){ jQuery('#permission_list').html(response); }
               })" if perm.can?(p) 
 link_to_function image_tag("delete.png", :title => t("users.grant_access", access: p, user: escape_twice(@user.name)).html_safe),
              "jQuery.ajax({url: '#{url_for(:controller => 'projects', :action => 'ajax_add_permission', :user_id => @user.id, :id => project.id, :perm => p, :user_edit => user_edit )}',
               success: function(response){ jQuery('#permission_list').html(response); }
               })" unless perm.can?(p) 
 end 
 end 

end
 
 if @user.active 
 t("users.add_project_to_user") 
 text_field :project, :name, {:id => "user_project_name_autocomplete", :value => "" }
 end 
 @user.id 

end

    else
      @users = Company.find(current_user.company_id).users.order("users.name")
      ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 t("projects.user") 
 t("permissions.read") 
 t("permissions.comment") 
 t("permissions.work") 
 t("permissions.close") 
 t("permissions.see_unwatched") 
 t("permissions.create") 
 t("permissions.edit") 
 t("permissions.assign") 
 t("permissions.milestones") 
 t("permissions.reports") 
 t("permissions.grant") 
 t("permissions.all") 
 @project.users.each do |user| 
 @user = user 
 render(:partial => "users/project", :locals => { :project => @project, :user_edit => false }) 
 end 
 t("users.add_project_to_user") 
 text_field :user, :name, {:id => "project_user_name_autocomplete", :value => "" } 
 @project.id 

end

    end
  end

  private

  def authorize_user_can_create_projects
    # msg = "You're not allowed to create new projects. Have your admin give you access."
    msg = t('flash.alert.unauthorized_operation')
    deny_access(msg) unless current_user.create_projects?
  end

  def create_project_permissions_for(project, copy_project_id)
    if copy_project_id.to_i > 0
      project_to_copy = current_user.all_projects.find(copy_project_id)
      project.copy_permissions_from(project_to_copy, current_user)
    else
      project.create_default_permissions_for(current_user)
    end
  end

  def check_if_project_has_users(project)
    msg = t('flash.notice.model_created', model: Project.model_name.human)

    if project.has_users?
      redirect_to projects_path, notice: msg
    else
      hint = t('hint.project.add_users')
      redirect_to edit_project_path(project), notice: [msg, hint].join(' ')
    end
  end

  def deny_access(msg)
    flash[:error] = msg
    redirect_from_last
  end

  def scope_projects
    @project_relation = current_user.get_projects
  end
end

# encoding: UTF-8

class ScmProjectsController < ApplicationController
  before_filter :authorize_user_is_admin

  def new
    @scm_project= ScmProject.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_for(@scm_project, :html => {:class => "form-horizontal"}) do |f| 
 t("scm_projects.new") 
 f.label :scm_type, t("scm_project.scm_type") 
 f.text_field :scm_type 
 f.label :location, t("scm_project.location") 
 f.text_field :location 
 if @scm_project.new_record? 
 submit_tag t("button.create"), :class => 'btn btn-primary' 
 else 
 submit_tag t("button.save"), :class => 'btn btn-primary' 
 end 
 end 

end

  end

  def create
    @scm_project= ScmProject.new(params[:scm_project])
    @scm_project.company= current_user.company
    if @scm_project.save
      flash[:success] = t('flash.notice.model_created', model: Project.model_name.human)
      redirect_to scm_project_url(@scm_project)
    else
      flash[:error] = @scm_project.errors.full_messages.join(". ")
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_for(@scm_project, :html => {:class => "form-horizontal"}) do |f| 
 t("scm_projects.new") 
 f.label :scm_type, t("scm_project.scm_type") 
 f.text_field :scm_type 
 f.label :location, t("scm_project.location") 
 f.text_field :location 
 if @scm_project.new_record? 
 submit_tag t("button.create"), :class => 'btn btn-primary' 
 else 
 submit_tag t("button.save"), :class => 'btn btn-primary' 
 end 
 end 

end

    end
  end

  def show
    @scm_project=ScmProject.find(params[:id])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @scm_project.dom_id 
 t("scm_projects.scm_type") 
 @scm_project.scm_type 
 t("scm_projects.location") 
 @scm_project.location 
 t("scm_projects.secret_key") 
 @scm_project.secret_key

end

  end
end

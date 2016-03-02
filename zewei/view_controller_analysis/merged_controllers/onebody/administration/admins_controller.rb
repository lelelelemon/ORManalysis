class Administration::AdminsController < ApplicationController
  before_filter :only_admins

  def index
    if params[:groups]
      @group_admins = Membership.where(admin: true).includes(:group, :person) \
        .map { |m| [m.person, m.group] } \
        .sort_by { |a| (params[:sort] == 'group' ? a[1] : a[0]).name }
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :sidebar do 
 t('admin.group_administrators_help') 
 end 
 t('admin.group_administrators') 
 link_to 'Admin', administration_admins_path(groups: true, sort: 'admin') 
 link_to 'Group', administration_admins_path(groups: true, sort: 'group') 
 @group_admins.each do |person, group| 
 link_to person.name, person 
 link_to group.name, group 
 link_to t('edit'), group_memberships_path(group) 
 end 

end

    else
      @order = case params[:order]
               when 'template'
                 "admins.super_admin, admins.template_name, people.last_name, people.first_name"
               else
                 'people.last_name, people.first_name'
               end
      @people = Person.where('admin_id is not null').order(@order).includes(:admin)
      @templates = Admin.where('template_name is not null').order(:template_name).select('*, (select count(*) from people where admin_id=admins.id) as people_count')
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('admin.admin_count', count: @people.length) 
 link_to t('name'), '?order=name' 
 link_to t('admin.template'), '?order=template' 
 @people.each do |person| 
 person.id 
 content_tag :a, href: person_path(person) do 
 avatar_tag(person) 
 end 
 link_to person.name, edit_administration_admin_path(person.admin_id) 
 if person.admin.super_admin? 
 t('admin.super_admin') 
 elsif person.admin.template_name 
 person.admin.template_name 
 end 
 link_to administration_admin_path(person.admin, person_id: person.id), data: { remote: true, method: :delete, confirm: t('are_you_sure') }, class: 'btn btn-delete' do 
 icon 'fa fa-trash-o' 
 end 
 end 
 t('admin.add_individual') 
 form_tag search_path, remote: true do 
 hidden_field_tag :select_person, true 
 t('name') 
 text_field_tag 'name', '', class: 'form-control' 
 button_tag t('admin.add_person'), class: 'btn btn-info' 
 end 
 form_tag(administration_admins_path) do 
 select_tag :template_id, options_for_select([['Individual', 0]] + @templates.map { |t| [t.template_name, t.id] }), class: 'form-control' 
 button_tag t('admin.add_selected'), class: 'btn btn-success' 
 end 
 t('admin.templates') 
 t('admin.admin_template_description') 
 @templates.each do |template| 
 link_to template.template_name, edit_administration_admin_path(template.id) 
 end 
 link_to_function t('admin.new_admin_template'), "$('#new-template-form').show();$('#template_name')[0].focus();$(this).parent().hide();", class: 'add-icon' 
 form_tag administration_admins_path, id: 'new-template-form', style: 'display:none;' do 
 t('admin.new_admin_template') 
 t('name') 
 text_field_tag 'template_name', '', class: 'form-control' 
 button_tag t('admin.add_template'), class: 'btn btn-success' 
 end 
 t('admin.group_administrators') 
 t('admin.group_administrators_description') 
 link_to t('admin.manage_group_administrators'), administration_admins_path(groups: true), class: 'right-icon' 

end

  end

  def edit
    @admin = Admin.find(params[:id])
    @people = @admin.people.order('last_name, first_name')
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = @admin.template? ? @admin.template_name : @admin.person.name 
  form_for @admin, url: administration_admin_path(@admin) do |form| 
 if not @admin.template? and @logged_in.super_admin? 
 check_box_tag "super_admin", true, @admin.super_admin?, data: { toggle: '.standard', 'toggle-selector' => ':not(:checked)' } 
 label_tag 'super_admin', t('admin.super_admin') 
 t('admin.super_admin_about') 
 end 
 Admin.privileges_for_show.each do |priv| 
 check_box_tag "privileges[#{priv[:name]}]", true, @admin.flags[priv[:name]], id: priv[:name] 
 label_tag priv[:name], priv[:title] 
 priv[:about] 
 end 
 form.button t('save_changes'), class: 'btn btn-info' 
 if @admin.template? 
 link_to t('Delete'), administration_admin_path(@admin), data: { method: 'delete', confirm: t('are_you_sure') }, class: 'btn btn-delete pull-right' 
 end 
 end 
 
 if @admin.template? 
 form_tag search_path, remote: true do 
 hidden_field_tag :select_person, true 
 t('admin.add_individual') 
 t('name') 
 text_field_tag 'name', '', class: 'form-control' 
 button_tag t('admin.add_person'), class: 'btn btn-info' 
 end 
 form_tag(administration_admins_path) do 
 hidden_field_tag :redirect_to, edit_administration_admin_path(@admin) 
 hidden_field_tag :template_id, @admin.id 
 button_tag t('admin.add_selected'), class: 'btn btn-success' 
 end 
 @people.each do |person| 
 person.id 
 avatar_tag(person) 
 link_to person.name, person 
 link_to administration_admin_path(person.admin, person_id: person.id), data: { remote: true, method: :delete, confirm: t('are_you_sure') }, class: 'btn btn-delete' do 
 icon 'fa fa-trash-o' 
 end 
 end 
 end 

end

  end

  def update
    @admin = Admin.find(params[:id])
    Admin.privileges.each do |priv|
      @admin.flags[priv] = params[:privileges] && params[:privileges][priv] == 'true'
    end
    if @logged_in.super_admin?
      if @admin.super_admin = params[:super_admin] == 'true'
        Admin.privileges.each do |priv|
          @admin.flags[priv] = false
        end
      end
    end
    flash[:notice] = t('Changes_saved')
    @admin.save!
    redirect_to administration_admins_path
  end

  def create
    flash[:notice] = ''
    params[:ids].to_a.each do |id|
      if Site.current.max_admins.nil? or Admin.people_count < Site.current.max_admins
        person = Person.find(id)
        if person.admin?
          flash[:notice] += t('admin.already_admin', name: person.name) + " "
        else
          person.admin = params[:template_id].to_i > 0 ? Admin.find(params[:template_id]) : Admin.create!
          person.save!
          if person.save
            flash[:notice] += t('admin.admin_added', name: person.name) + " "
          else
            add_errors_to_flash(person)
          end
        end
      else
        flash[:notice] += t('admin.no_more_admins') + " "
        break
      end
    end
    if params[:template_name]
      Admin.create!(template_name: params[:template_name])
      flash[:notice] += t('application.template_created')
    end
    if params[:redirect_to]
      redirect_to URI.parse(params[:redirect_to]).path
    else
      redirect_to administration_admins_path
    end
  end

  def destroy
    @admin = Admin.find(params[:id])
    if params[:person_id]
      @person = Person.find(params[:person_id])
      @person.update_attribute(:admin_id, nil)
      respond_to do |format|
        format.html
        format.js
      end
    else
      @admin.destroy
      flash[:notice] = t('admin.admin_removed')
      redirect_to administration_admins_path
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @person.id 

end

  end

  private

    def only_admins
      unless @logged_in.admin?(:manage_access)
        render text: t('only_admins'), layout: true, status: 401
        return false
      end
    end

end

class MembershipsController < ApplicationController
  skip_before_action :authenticate_user, only: %w(show update)
  before_action :authenticate_user_with_code_or_session, only: %w(show update)

  load_parent :group

  before_action :authorize_group_for_read,   only: :index
  before_action :authorize_group_for_update, only: :batch

  def show
    # allow email links to work (since they will be GET requests)
    if params[:email]
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_tag group_membership_path(@group, params[:id]), method: 'PATCH', id: 'email_form' do |form| 
 hidden_field_tag :email, params[:email] 
 hidden_field_tag :code, params[:code] 
 end 
 content_for(:js) do 
 end 

end

    else
      fail ActionController::UnknownAction, t('No_action_to_show')
    end
  end

  def index
    @memberships = @group.memberships.includes(:person).paginate(page: params[:page], per_page: 100)
    if params[:birthdays]
      @memberships = @memberships.order_by_birthday
    else
      @memberships = @memberships.order_by_name
    end
    @requests = @group.membership_requests
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('.heading', group: link_to(@group.name, @group)).html_safe 
 if @logged_in.can_update?(@group) and @requests.any? 
 form_tag batch_group_memberships_path(@group) do |form| 
 t('memberships.requests.heading') 
 t('memberships.requests.name') 
 t('memberships.requests.created_at') 
 @requests.each do |req| 
 check_box_tag 'ids[]', req.person.try(:id), false, class: 'checkbox' 
 avatar_tag req.person 
 link_to req.person.try(:name), req.person 
 req.created_at.to_s(:date) 
 end 
 t('memberships.requests.select_some') 
 button_tag name: 'commit', value: 'accept', class: 'btn btn-success' do 
 icon 'fa fa-plus-circle' 
 t('memberships.requests.accept.button') 
 end 
 button_tag name: 'commit', value: 'ignore', class: 'btn btn-danger' do 
 icon 'fa fa-minus-circle' 
 t('memberships.requests.ignore.button') 
 end 
 end 
 end 
 pagination @memberships 
 if @group.people.any? 
 form_tag batch_group_memberships_path(@group), method: :delete do 
 if @logged_in.can_update?(@group) 
 end 
 t('.details.name') 
 if params[:birthdays] 
 t('.details.birthday') 
 else 
 t('.details.created_at') 
 end 
 if @logged_in.can_update?(@group) 
 end 
 @memberships.includes(:person).order('people.last_name', 'people.first_name').each do |membership| 
 if person = membership.person 
  person = membership.person 
 if @logged_in.can_update?(@group) 
 check_box_tag 'ids[]', person.try(:id), false, class: 'checkbox simple' 
 end 
 avatar_tag person 
 link_to person.name, person 
 if params[:birthdays] 
 person.birthday.to_s(:date_without_year) if person.birthday 
 else 
 membership.created_at.to_s(:date) if membership.created_at 
 end 
 if @logged_in.can_update?(@group) 
 if (@group.linked? or @group.parents_of?) and not membership.auto? 
 icon 'fa fa-exclamation-circle text-gray', title: t('memberships.index.details.manual.tooltip') 
 end 
 if membership.admin? 
 link_to group_membership_path(@group, membership, promote: false), data: { method: :put, confirm: t('are_you_sure') }, class: 'btn btn-warning btn-xs', title: t('memberships.demote') do 
 icon 'fa fa-toggle-down' 
 end 
 else 
 link_to group_membership_path(@group, membership, promote: true), data: { method: :put, confirm: t('are_you_sure') }, class: 'btn btn-info btn-xs', title: t('memberships.promote') do 
 icon 'fa fa-toggle-up' 
 end 
 end 
 end 
 
 end 
 end 
 if @logged_in.can_update?(@group) 
 button_tag class: 'btn btn-delete' do 
 icon 'fa fa-minus-circle' 
 t('.remove.button') 
 end 
 end 
 end 
 else 
 t('none') 
 end 
 pagination @memberships 
 if @logged_in.can_update?(@group) 
 t('memberships.add.heading') 
 if @group.approved? 
 form_tag search_path, remote: true do 
 hidden_field_tag :select_person, true 
 label_tag :add_person_name do 
 t('memberships.add.description') 
 end 
 text_field_tag 'name', nil, id: 'add_person_name', class: 'form-control', placeholder: t('memberships.add.name_placeholder') 
 if @group.parents_of? 
 t('memberships.add.parents_of_warning_html', group: link_to(@group.parents_of_group.try(:name), @group.parents_of_group)) 
 elsif @group.linked? 
 t('memberships.add.linked_group_warning_html', code: @group.link_code) 
 end 
 button_tag t('search.search_by_name'), class: 'btn btn-info' 
 end 
 form_tag batch_group_memberships_path(@group), remote: true, id: 'add_people_form' do 
 hidden_field_tag(:birthdays, true) if params[:birthdays] 
 button_tag t('search.add_selected'), class: 'btn btn-success' 
 end 
 else 
 t('memberships.group_pending_approval') 
 end 
 end 

end

  end

  # join group
  def create
    @person = Person.find(params[:id])
    if @logged_in.can_create?(@group.memberships.new)
      @group.memberships.create(person: @person)
    elsif me?
      @group.membership_requests.create(person: @person)
      flash[:warning] = t('groups.join.request_sent')
    end
    redirect_to :back
  end

  def update
    if params[:email]
      update_email
    elsif params[:promote] && @logged_in.can_update?(@group)
      update_admin
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @group.id 
 if @get_email 
 else 
 end 

end

  end

  def update_email
    @person = Person.find(params[:id])
    if can_update_email?
      @get_email = params[:email] == 'on'
      @group.set_options_for @person, get_email: @get_email
      respond_to do |format|
        format.html do
          render text: t('groups.email_settings_changed'), layout: true
        end
        format.js
      end
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
  end

  def update_admin
    @membership = @group.memberships.find(params[:id])
    @membership.update_attribute(:admin, params[:promote] == 'true')
    flash[:notice] = t('groups.user_settings_saved')
    redirect_to :back
  end

  # leave group
  def destroy
    @membership = @group.memberships.where(person_id: params[:id]).first!
    if @logged_in.can_delete?(@membership)
      if @membership.only_admin?
        flash[:warning] = t('groups.last_admin_remove', name: @membership.person.name)
      else
        @membership.destroy
      end
    end
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 params[:id] 
 escape_javascript t('people.person', count: @group.people.count) 

end

  end

  def batch
    batch = MembershipBatch.new(@group, params[:ids])
    if request.post?
      batch.delete_requests
      @added = batch.create unless params[:commit] == 'ignore'
    elsif request.delete?
      batch.delete
    end
    @added ||= []
    respond_to do |format|
      format.js
      format.html { redirect_to :back }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  person = membership.person 
 if @logged_in.can_update?(@group) 
 check_box_tag 'ids[]', person.try(:id), false, class: 'checkbox simple' 
 end 
 avatar_tag person 
 link_to person.name, person 
 if params[:birthdays] 
 person.birthday.to_s(:date_without_year) if person.birthday 
 else 
 membership.created_at.to_s(:date) if membership.created_at 
 end 
 if @logged_in.can_update?(@group) 
 if (@group.linked? or @group.parents_of?) and not membership.auto? 
 icon 'fa fa-exclamation-circle text-gray', title: t('memberships.index.details.manual.tooltip') 
 end 
 if membership.admin? 
 link_to group_membership_path(@group, membership, promote: false), data: { method: :put, confirm: t('are_you_sure') }, class: 'btn btn-warning btn-xs', title: t('memberships.demote') do 
 icon 'fa fa-toggle-down' 
 end 
 else 
 link_to group_membership_path(@group, membership, promote: true), data: { method: :put, confirm: t('are_you_sure') }, class: 'btn btn-info btn-xs', title: t('memberships.promote') do 
 icon 'fa fa-toggle-up' 
 end 
 end 
 end 
 
 @added.map { |m| '#'+dom_id(m) }.join(',') 

end

  end

  private

  def can_update_email?
    @logged_in.can_update?(@group) || @logged_in.can_update?(@person)
  end

  def authorize_group_for_read
    return if @logged_in.can_read?(@group)
    render text: t('not_authorized'), layout: true, status: :unauthorized
    false
  end

  def authorize_group_for_update
    return if @logged_in.can_update?(@group)
    render text: t('not_authorized'), layout: true, status: :unauthorized
    false
  end
end

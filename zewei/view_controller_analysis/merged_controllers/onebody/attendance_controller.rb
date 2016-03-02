class AttendanceController < ApplicationController

  skip_before_action :authenticate_user,
    if: -> c { %w(index batch).include?(c.action_name) and params[:public] }

  before_action :eliminate_checkin_error # TEMP

  load_parent :group, optional: true
  before_action :authorize_group
  before_action :ensure_attendance_enabled_for_group

  def index
    @attended_at = Date.parse_in_locale(params[:attended_at]) || begin
      if params[:attended_at].present?
        flash[:warning] = t('attendance.wrong_date_format')
      end
      Date.current
    end
    @records = @group.get_people_attendance_records_for_date(@attended_at)
    if params[:public]
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('attendance.heading_without_date', group: @group.name) 
 form_tag group_attendance_index_path(@group), method: :get do 
 hidden_field_tag :public, true 
 hidden_field_tag :token, params[:token] 
 icon 'fa fa-calendar' 
 date_field_tag :attended_at, @attended_at.to_s(:date), class: 'form-control' 
 end 
 form_tag batch_group_attendance_index_path(@group), id: 'attendance_form' do 
 hidden_field_tag :public, true 
 hidden_field_tag :token, params[:token] 
 hidden_field_tag :attended_at, @attended_at.to_s(:date) 
 @records.each do |person, record| 
 check_box_tag 'ids[]', person.id, record ? true : false, id: "ids_#{person.id}", class: 'simple icon-check' 
 person.id 
 person.name 
 person.id 
 avatar_tag person, fallback_to_family: true 
 end 
 label_tag :notes, t('attendance.notes.label') 
 text_area_tag :notes, '', class: 'form-control' 
 t('attendance.notes.help') 
 button_tag t('attendance.submit_notes'), class: 'btn btn-success' 
 end 

end

    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('attendance.heading_html', group: link_to(@group.name, @group), when: @attended_at.to_s(:date)) 
 label_tag :attended_at, t('attendance.date') 
 icon 'fa fa-calendar' 
 date_field_tag :attended_at, @attended_at.to_s(:date), class: 'form-control' 
 form_tag batch_group_attendance_index_path(@group), id: 'attendance_form' do 
 hidden_field_tag :attended_at, @attended_at 
 @records.each do |person, record| 
 check_box_tag 'ids[]', person.id, record ? true : false, id: "ids_#{person.id}" 
 label_tag "ids_#{person.id}", person.name, class: 'inline' 
 end 
 label_tag :notes, t('attendance.notes.label') 
 text_area_tag :notes, '', class: 'form-control' 
 t('attendance.notes.help') 
 button_tag t('attendance.save'), class: 'btn btn-success' 
 end 
 icon 'fa fa-plus-circle' 
 t('attendance.add.heading') 
 form_tag search_path, remote: true, style: 'border:none;' do 
 hidden_field_tag :select_person, true 
 hidden_field_tag :no_auto_submit, true 
 t('attendance.add.intro') 
 text_field_tag 'name', nil, id: 'add_person_name', class: 'form-control' 
 button_tag t('search.search_by_name'), class: 'btn btn-info' 
 end 
 form_tag group_attendance_index_path(@group), method: 'post', id: 'add_people_form' do 
 hidden_field_tag :attended_at, @attended_at, id: nil 
 button_tag t('search.add_selected'), class: 'btn btn-success' 
 end 
 t('attendance.add.footer_html', url: group_memberships_path(@group)) 
 if @group.admin?(@logged_in) 
 icon 'fa fa-check-square' 
 t('attendance.share.heading') 
 t('attendance.share.intro_html') 
 link_to({ public: true, token: @group.share_token }, class: 'btn btn-success') do 
 icon 'fa fa-share' 
 t('attendance.share.button') 
 end 
 end 

end

  end

  # this method is similar to batch, but does not clear all the existing records for the group first
  # this method also allows you to record attendance for people not in the database (used for checkin 'add a friend' feature)
  def create
    batch = AttendanceBatch.new(@group, params[:attended_at])
    batch.update(params[:ids])
    batch.create_unlinked(params[:person]) if params[:person]
    respond_to do |format|
      format.html do
        redirect_to group_attendance_index_path(@group, attended_at: batch.attended_at)
      end
      format.json do
        render json: { status: 'success' }
      end
    end
  end

  # this method clears all existing attendance for the entire date and adds what is sent in params
  def batch
    batch = AttendanceBatch.new(@group, params[:attended_at])
    unless batch.attended_at
      render_text t('attendance.wrong_date_format'), :bad_request
      return
    end
    batch.clear_all_for_date
    attendance_records = batch.update(params[:ids])
    if params[:public]
      if params[:notes].present?
        Notifier.attendance_submission(@group, attendance_records, @logged_in, params[:notes]).deliver_now
      end
      render_text t('attendance.saved')
    else
      Notifier.attendance_submission(@group, attendance_records, @logged_in, params[:notes]).deliver_now
      flash[:notice] = t('changes_saved')
      redirect_to group_attendance_index_path(@group, attended_at: batch.attended_at.to_s(:date))
    end
  end

  protected

  def render_text(message, status=:ok)
    respond_to do |format|
      format.html { render text: message, layout: 'signed_out', status: status }
      format.json { render json: { status: status, message: message } }
    end
  end

  def authorize_group
    unless @group.admin?(@logged_in) or authorized_with_token?
      render_text t('not_authorized'), :unauthorized
      return false
    end
  end

  def authorized_with_token?
    params[:token].present? and @group and @group.share_token == params[:token]
  end

  def ensure_attendance_enabled_for_group
    unless @group and @group.attendance?
      render text: t('attendance.not_enabled'), layout: true, status: :bad_request
      return false
    end
  end

  # TEMP - this is only needed due to legacy check-in software
  # submitting bogus attendance (that can be ignored) at /groups/0/attendance.json
  def eliminate_checkin_error
    if params[:group_id] == '0' and params[:action] == 'create'
      render status: 404, text: 'group not found'
      return false
    end
  end

end

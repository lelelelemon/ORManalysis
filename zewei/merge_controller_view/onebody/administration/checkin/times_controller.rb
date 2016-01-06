class Administration::Checkin::TimesController < ApplicationController

  before_filter :only_admins

  def index
    @recurring_times = CheckinTime.recurring.order(:weekday, :time)
    @single_times = CheckinTime.future_singles.order(:the_datetime)
 @title = t('checkin.times.heading') 
 t('checkin.times.recurring.heading') 
 link_to '#', class: 'btn btn-success btn-xs', data: { toggle: '#new_recurring_time' } do 
 icon 'fa fa-plus' 
 t('checkin.times.recurring.new.button') 
 end 
 form_for :checkin_time, url: administration_checkin_times_path, html: { class: 'form-inline', style: 'display:none;', id: 'new_recurring_time' }, method: 'post' do |form| 
 form.select :weekday, Date::DAYNAMES.each_with_index.to_a, {}, class: 'form-control' 
 form.text_field :time, size: 8, class: 'form-control', placeholder: t('checkin.times.recurring.time') 
 form.select :campus, options_for_select([[t('checkin.times.edit.campus.new'), '!']] + CheckinTime.campuses), { include_blank: true }, class: 'form-control can-create' 
 form.button t('checkin.times.recurring.add.button'), class: 'btn btn-success' 
 end 
 if @recurring_times.any? 
 render partial: 'times', object: @recurring_times 
 else 
 t('none') 
 end 
 t('checkin.times.single.heading') 
 link_to '#', class: 'btn btn-success btn-xs', data: { toggle: '#new_single_time' } do 
 icon 'fa fa-plus' 
 t('checkin.times.single.new.button') 
 end 
 form_for :checkin_time, url: administration_checkin_times_path, html: { class: 'form-inline', style: 'display:none;', id: 'new_single_time' }, method: 'post' do |form| 
 form.text_field :the_datetime, size: 15, class: 'form-control', placeholder: t('checkin.times.single.datetime') 
 form.select :campus, options_for_select([[t('checkin.times.edit.campus.new'), '!']] + CheckinTime.campuses), { include_blank: true }, class: 'form-control can-create' 
 form.button t('checkin.times.single.add.button'), class: 'btn btn-success' 
 end 
 if @single_times.any? 
 render partial: 'times', object: @single_times 
 else 
 t('none') 
 end 

  end

  def show
    redirect_to administration_checkin_time_groups_path(params[:id])
  end

  def edit
    @time = CheckinTime.find(params[:id])
 @title = t('checkin.times.edit.heading') 
 form_for @time, url: administration_checkin_time_path(@time) do |form| 
 if @time.weekday 
 form.select :weekday, Date::DAYNAMES.each_with_index.to_a, {}, class: 'form-control' 
 form.text_field :time, value: @time.time_to_s, size: 8, class: 'form-control', placeholder: t('checkin.times.recurring.time') 
 else 
 form.text_field :the_datetime, value: @time.to_s, size: 15, class: 'form-control', placeholder: t('checkin.times.single.datetime') 
 end 
 form.select :campus, options_for_select([[t('checkin.times.edit.campus.new'), '!']] + CheckinTime.campuses, @time.campus), {}, class: 'form-control can-create' 
 form.button t('checkin.times.edit.save.button'), class: 'btn btn-success' 
 link_to administration_checkin_time_path(@time), data: { method: 'delete', confirm: t('are_you_sure') }, class: 'btn btn-delete' do 
 icon 'fa fa-trash-o' 
 t('checkin.times.edit.delete.button') 
 end 
 end 

  end

  def create
    @time = CheckinTime.create(time_params)
    add_errors_to_flash(@time) unless @time.valid?
    redirect_to administration_checkin_times_path
  end

  def update
    @time = CheckinTime.find(params[:id])
    if @time.update_attributes(time_params)
      flash[:notice] = t('changes_saved')
    else
      add_errors_to_flash(@time)
    end
    redirect_to administration_checkin_times_path
  end

  def destroy
    @time = CheckinTime.find(params[:id])
    @time.destroy
    redirect_to administration_checkin_times_path
  end

  private

  def time_params
    params.require(:checkin_time).permit(:weekday, :time, :the_datetime, :campus)
  end

  def only_admins
    unless @logged_in.admin?(:manage_checkin)
      render :text => 'You must be an administrator to use this section.', :layout => true, :status => 401
      return false
    end
  end

  def feature_enabled?
    unless Setting.get(:features, :checkin)
      render :text => 'This feature is unavailable.', :layout => true
      false
    end
  end

end

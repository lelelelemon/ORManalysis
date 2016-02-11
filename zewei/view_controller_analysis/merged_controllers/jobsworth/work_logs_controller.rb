# encoding: UTF-8
class WorkLogsController < ApplicationController
  before_filter :load_log, :only => [ :edit, :update, :destroy ]
  before_filter :load_task_and_build_log, :only => [ :new, :create ]

  include WorkLogsHelper

  def new
 @page_title = t("work_logs.title", title: Setting.productName) 
 t("work_logs.new_title") 
 form_for(@log, :as => :work_log, :html => {:class => "form-horizontal"}) do |f| 
  hidden_field_tag :task_id, @log.task.task_num 
 if current_user.option_tracktime.to_i == 1 
 label :started_at, @log.human_name(:started_at) 
 if @log.new_record? 
 text_field(:work_log, :started_at, :value => Time.now.strftime("#{current_user.date_format} #{current_user.time_format}")) 
 else 
 text_field(:work_log, :started_at, :value => @log.started_at.strftime("#{current_user.date_format} #{current_user.time_format}")) 
 end 
  values = object.all_custom_attribute_values 
 values.each do |value| 
 prefix = "#{ object.class.name.underscore }[set_custom_attribute_values]" 
 ca = value.custom_attribute 
 field_id = custom_attribute_field_id 
 fields_for(prefix, value) do |f| 
 f.hidden_field(:custom_attribute_id, :index => nil) 
 label_tag field_id, value.custom_attribute.display_name 
 if ca and ca.preset? 
 options = objects_to_names_and_ids(ca.custom_attribute_choices, :name_method => :value) 
 options.unshift("") if ca.mandatory? 
 f.select(:choice_id, options, { }, :id => field_id, :index => nil) 
 elsif value.custom_attribute.max_length.to_i >= 100 
 f.text_area(:value, :id => field_id, :index => nil, :class => "input-xxlarge", :rows => 10) 
 else 
 f.text_field(:value, :id => field_id, :index => nil, :class => "value") 
 end 
 multi_links(value) 
 end 
 end 
 
 if @log.worktime? 
 label :work_log, :customer_name, t("work_logs.client") 
 select :work_log, :customer_id, work_log_customer_options(@log) 
 t("work_logs.time_worked") 
 text_field(:work_log, :duration, :value => TimeParser.format_duration(@log.duration),
            :size => 10, :rel => 'tooltip', :title => t("work_logs.time_worked_tooltip"), "data-placement" => "right") 
 end 
 end 
 @log.human_name :body 
 text_area(:work_log, :body, :rows => 10, :value => @log.body, :class => "input-xxlarge") 
 
 end 

  end

  def create
    params[:work_log][:duration] = TimeParser.parse_time(params[:work_log][:duration])

    @log.attributes = params[:work_log]
    @log.user = current_user
    @log.project = @task.project

    if @log.save
      flash[:success] = t('flash.notice.model_created', model: WorkLog.model_name.human)
      redirect_to tasks_path
    else
      flash[:error] = @log.errors.full_messages.join(". ")
       @page_title = t("work_logs.title", title: Setting.productName) 
 t("work_logs.new_title") 
 form_for(@log, :as => :work_log, :html => {:class => "form-horizontal"}) do |f| 
  hidden_field_tag :task_id, @log.task.task_num 
 if current_user.option_tracktime.to_i == 1 
 label :started_at, @log.human_name(:started_at) 
 if @log.new_record? 
 text_field(:work_log, :started_at, :value => Time.now.strftime("#{current_user.date_format} #{current_user.time_format}")) 
 else 
 text_field(:work_log, :started_at, :value => @log.started_at.strftime("#{current_user.date_format} #{current_user.time_format}")) 
 end 
  values = object.all_custom_attribute_values 
 values.each do |value| 
 prefix = "#{ object.class.name.underscore }[set_custom_attribute_values]" 
 ca = value.custom_attribute 
 field_id = custom_attribute_field_id 
 fields_for(prefix, value) do |f| 
 f.hidden_field(:custom_attribute_id, :index => nil) 
 label_tag field_id, value.custom_attribute.display_name 
 if ca and ca.preset? 
 options = objects_to_names_and_ids(ca.custom_attribute_choices, :name_method => :value) 
 options.unshift("") if ca.mandatory? 
 f.select(:choice_id, options, { }, :id => field_id, :index => nil) 
 elsif value.custom_attribute.max_length.to_i >= 100 
 f.text_area(:value, :id => field_id, :index => nil, :class => "input-xxlarge", :rows => 10) 
 else 
 f.text_field(:value, :id => field_id, :index => nil, :class => "value") 
 end 
 multi_links(value) 
 end 
 end 
 
 if @log.worktime? 
 label :work_log, :customer_name, t("work_logs.client") 
 select :work_log, :customer_id, work_log_customer_options(@log) 
 t("work_logs.time_worked") 
 text_field(:work_log, :duration, :value => TimeParser.format_duration(@log.duration),
            :size => 10, :rel => 'tooltip', :title => t("work_logs.time_worked_tooltip"), "data-placement" => "right") 
 end 
 end 
 @log.human_name :body 
 text_area(:work_log, :body, :rows => 10, :value => @log.body, :class => "input-xxlarge") 
 
 end 

    end
  end

  def edit
 @page_title = t("work_logs.title", title: Setting.productName) 
 t("work_logs.edit_title") 
 @log.task 
 form_for(@log, :as => :work_log, :html => {:class => "form-horizontal"}) do |f| 
  hidden_field_tag :task_id, @log.task.task_num 
 if current_user.option_tracktime.to_i == 1 
 label :started_at, @log.human_name(:started_at) 
 if @log.new_record? 
 text_field(:work_log, :started_at, :value => Time.now.strftime("#{current_user.date_format} #{current_user.time_format}")) 
 else 
 text_field(:work_log, :started_at, :value => @log.started_at.strftime("#{current_user.date_format} #{current_user.time_format}")) 
 end 
  values = object.all_custom_attribute_values 
 values.each do |value| 
 prefix = "#{ object.class.name.underscore }[set_custom_attribute_values]" 
 ca = value.custom_attribute 
 field_id = custom_attribute_field_id 
 fields_for(prefix, value) do |f| 
 f.hidden_field(:custom_attribute_id, :index => nil) 
 label_tag field_id, value.custom_attribute.display_name 
 if ca and ca.preset? 
 options = objects_to_names_and_ids(ca.custom_attribute_choices, :name_method => :value) 
 options.unshift("") if ca.mandatory? 
 f.select(:choice_id, options, { }, :id => field_id, :index => nil) 
 elsif value.custom_attribute.max_length.to_i >= 100 
 f.text_area(:value, :id => field_id, :index => nil, :class => "input-xxlarge", :rows => 10) 
 else 
 f.text_field(:value, :id => field_id, :index => nil, :class => "value") 
 end 
 multi_links(value) 
 end 
 end 
 
 if @log.worktime? 
 label :work_log, :customer_name, t("work_logs.client") 
 select :work_log, :customer_id, work_log_customer_options(@log) 
 t("work_logs.time_worked") 
 text_field(:work_log, :duration, :value => TimeParser.format_duration(@log.duration),
            :size => 10, :rel => 'tooltip', :title => t("work_logs.time_worked_tooltip"), "data-placement" => "right") 
 end 
 end 
 @log.human_name :body 
 text_area(:work_log, :body, :rows => 10, :value => @log.body, :class => "input-xxlarge") 
 
 end 

  end

  def update
    params[:work_log][:duration] = TimeParser.parse_time(params[:work_log][:duration])

    @log.attributes = params[:work_log]
    @log.project = @task.project

    if @log.save
      flash[:success] = t('flash.notice.model_saved', model: WorkLog.model_name.human)
      redirect_to tasks_path
    else
      flash[:error] = @log.errors.full_messages.join(". ")
       @page_title = t("work_logs.title", title: Setting.productName) 
 t("work_logs.edit_title") 
 @log.task 
 form_for(@log, :as => :work_log, :html => {:class => "form-horizontal"}) do |f| 
  hidden_field_tag :task_id, @log.task.task_num 
 if current_user.option_tracktime.to_i == 1 
 label :started_at, @log.human_name(:started_at) 
 if @log.new_record? 
 text_field(:work_log, :started_at, :value => Time.now.strftime("#{current_user.date_format} #{current_user.time_format}")) 
 else 
 text_field(:work_log, :started_at, :value => @log.started_at.strftime("#{current_user.date_format} #{current_user.time_format}")) 
 end 
  values = object.all_custom_attribute_values 
 values.each do |value| 
 prefix = "#{ object.class.name.underscore }[set_custom_attribute_values]" 
 ca = value.custom_attribute 
 field_id = custom_attribute_field_id 
 fields_for(prefix, value) do |f| 
 f.hidden_field(:custom_attribute_id, :index => nil) 
 label_tag field_id, value.custom_attribute.display_name 
 if ca and ca.preset? 
 options = objects_to_names_and_ids(ca.custom_attribute_choices, :name_method => :value) 
 options.unshift("") if ca.mandatory? 
 f.select(:choice_id, options, { }, :id => field_id, :index => nil) 
 elsif value.custom_attribute.max_length.to_i >= 100 
 f.text_area(:value, :id => field_id, :index => nil, :class => "input-xxlarge", :rows => 10) 
 else 
 f.text_field(:value, :id => field_id, :index => nil, :class => "value") 
 end 
 multi_links(value) 
 end 
 end 
 
 if @log.worktime? 
 label :work_log, :customer_name, t("work_logs.client") 
 select :work_log, :customer_id, work_log_customer_options(@log) 
 t("work_logs.time_worked") 
 text_field(:work_log, :duration, :value => TimeParser.format_duration(@log.duration),
            :size => 10, :rel => 'tooltip', :title => t("work_logs.time_worked_tooltip"), "data-placement" => "right") 
 end 
 end 
 @log.human_name :body 
 text_area(:work_log, :body, :rows => 10, :value => @log.body, :class => "input-xxlarge") 
 
 end 

    end
  end

  def destroy
    if can_delete_log?(@log)
      @log.destroy
      flash[:success] = t('flash.notice.model_deleted', model: WorkLog.model_name.human)
    else
      flash[:error] = t('flash.alert.access_denied_to_model', model: WorkLog.model_name.human)
    end

    redirect_to tasks_path
  end

  def update_work_log
    unless current_user.can_approve_work_logs?
      render :nothing => true
      return false
    end
    log = WorkLog.accessed_by(current_user).find(params[:id])
    log.status= params[:work_log][:status]

    render :text => log.save.to_s
  end

  private

  # Loads the log using the given params
  def load_log
    @log = WorkLog.all_accessed_by(current_user).find(params[:id])
    @task = @log.task
  end

  # Loads the task new logs should be linked to
  def load_task_and_build_log
    @task = current_user.company.tasks.find_by_task_num(params[:task_id])
    @log  = current_user.company.work_logs.build(params[:work_log])
    @log.task = @task
    @log.started_at = Time.now.utc - @log.duration
  end

end

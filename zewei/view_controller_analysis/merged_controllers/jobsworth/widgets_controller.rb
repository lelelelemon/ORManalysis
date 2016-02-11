# encoding: UTF-8
class WidgetsController < ApplicationController

  OVERDUE    = 0
  TODAY      = 1
  TOMORROW   = 2
  THIS_WEEK  = 3
  NEXT_WEEK  = 4

  def show
    begin
      @widget = Widget.where("company_id = ? AND user_id = ?", current_user.company_id, current_user.id).find(params[:id])
    rescue
      render :nothing => true
      return
    end

    unless @widget.configured?
      render :partial => "widget_#{@widget.widget_type}_config"
      return
    end

    # TODO use constants
    case @widget.widget_type
    when 0 then
      tasks_extracted_from_show
    when 2 then
      # Recent Activities : already removed
    when 3 then
      task_graph_extracted_from_show
    when 4 then
      burndown_extracted_from_show
    when 5 then
      burnup_extracted_from_show
    when 6 then
      comments_extracted_from_show
    when 7 then
      schedule_extracted_from_show
    when 8 then
      # Google Gadget
    when 9 then
      work_status_extracted_from_show
    when 10 then
      sheets_extracted_from_show
    end

    # TODO unify case's
    case @widget.widget_type
      when 0 then
         for task in tasks 
  if session[:hide_deferred].to_i == 0 || task.snoozed? 
task.id 

 depth ||= 1
 depth = 1 if depth < 1
 classes = ""

 can_complete = { :disabled => "disabled" } unless current_user.can?(task.project, 'close')
 can_complete ||= {}

 can_work = { :disabled => "disabled" } unless current_user.can?(task.project, 'work')
 can_work ||= {}

 classes << " #{task.project.to_css_name}"
 classes << " override_filter" if defined?(override_filter) && override_filter
 classes << " waiting_deferred" unless task.snoozed?

 classes << " task_active_others" if task.worked_on?
 classes << " task_active" if @current_sheet && @current_sheet.task_id == task.id
 classes << " task_done" if task.done?
 classes << " task_paused" if @current_sheet && @current_sheet.task_id == task.id && @current_sheet.paused?
 classes << " #{task.dom_id}"
 classes << " unread" if task.unread?(current_user)

classes
 color_style(task) 
 if depth > 1 
 8 + (depth - 1) * 16
 end 
 @task = task 
task.dom_id
 task_icon(task) 
 if (@current_sheet && @current_sheet.task_id == task.id) || task.done? 
task.id
 if !(@current_sheet && @current_sheet.task_id == task.id) 
 if task.done? 
 if task.hidden == 0 
 link_to_function image_tag("folder_add.png", :border => 0, :title => t("tasks.archive_task_html", task: task.name), :rel => "tooltip"),
               "jQuery.ajax({url: '/tasks/ajax_hide/#{task.id}', success:  function(response){ jQuery('#task_#{task.id}').fadeOut(500); }})" 
 else 
 link_to_function image_tag("folder_go.png", :border => 0, :title => t("tasks.restore_task_html", task: task.name) , :rel => "tooltip"),
              "jQuery.ajax({url: '/tasks/ajax_restore/#{task.id}', success:  function(response){ jQuery('#task_#{task.id}').fadeOut(500); }})" 
 end 
 end 
 end 
 end 
task.id
 image_tag('drag.gif', :border => 0) 
 image_tag "spacer.gif", :width => "16", :height => "16" 
 avatar_for task.users.first, 25 unless task.users.empty? 
 if controller.controller_name != 'search' 
 link_to_task(task) 
 else 
 link_to_task(task, false, @keys)  
 end 
  if current_user.option_tracktime.to_i == 1 
 if task.duration.to_i > 0 
 worked_and_duration_class(task) 
"(#{TimeParser.format_duration(task.worked_minutes)} / #{TimeParser.format_duration( task.duration )})"
 end 
 "(#{TimeParser.format_duration(task.worked_minutes)})" if( task.duration.to_i == 0 && task.worked_minutes > 0) 
 end 
 unless task.milestone_id.to_i == 0 
 task.milestone.name 
 end 
 name = t("tasks.no_one")
      name = task.users.collect{|u| u.name}.join(', ') unless task.users.empty?
   
 if controller.controller_name != 'search' 
 if task.project 
 task.project.full_name 
 task.tags.each do |t| 
 t.name 
 t.name.capitalize.gsub(/\"/,'&quot;'.html_safe) 
 end 
 end 
 else 
 highlight_all(task.full_name_without_links, @keys) 
 end 
 name 
 due_in_words(task) unless task.due_date && task.done?
 "[#{overdue_time(task.completed_at)}]" if task.done?
 end 
nd 

      when 1 then
        # removed
      when 2 then
        # Recent Activities : already removed
      when 3..10 then
        render :partial => "widgets/widget_#{@widget.widget_type}"
    end

  end

  def add
     form_tag({:controller => 'widgets', :action => 'create' }, :id => "add_widget", :remote => true, :class => "form-inline") do  
 t("widgets.widget_title") 
 text_field 'widget', 'name', {:size => 15} 

    gadgets = [
                [t("widgets.tasks"),0],
                [t("widgets.due_tasks"),7],
                [t("widgets.comments"),6],
                [t("widgets.time_chart"),3],
                [t("widgets.burndown"),4],
                [t("widgets.burnup"),5],
                [t("widgets.resolution"),9],
                [t("widgets.active_tasks"),10] ]

   if current_user.widgets.where("widget_type = 8").count == 0
     gadgets << [t("widgets.google_gadget"),8]
   end
  
 t("widgets.type") 
 select( 'widget', 'widget_type', gadgets) 
 submit_tag t("button.create"), :class => "btn" 
 link_to_function(t("button.cancel"), "jQuery('#add-widget').addClass('hide');") 
 end 
nd

  def destroy
    begin
      @widget = Widget.where("company_id = ? AND user_id = ?", current_user.company_id, current_user.id).find(params[:id])
    rescue
      return render :json => {:success => false}
    end
    @widget.destroy
    render :json => {:success => true}
  end

  def create
    @widget = Widget.new(params[:widget])
    @widget.user = current_user
    @widget.company = current_user.company
    @widget.configured = false
    @widget.column = 0
    @widget.position = 0
    @widget.collapsed = false

    unless @widget.save
      return render :json => { :success => false }
    end

    html = render_to_string :partial => "widget"
    render :json => { :success => true, :html => html }.merge(@widget.as_json)
  end

  def edit
    begin
      @widget = Widget.where("company_id = ? AND user_id = ?", current_user.company_id, current_user.id).find(params[:id])
    rescue
      render :nothing => true
      return
    end
    render :partial => "widget_#{@widget.widget_type}_config.html.erb"
  end

  def update
    begin
      @widget = Widget.where("company_id = ? AND user_id = ?", current_user.company_id, current_user.id).find(params[:id])
    rescue
      render :nothing => true
      return
    end

    @widget.configured = true
    unless @widget.update_attributes(params[:widget])
      return render :nothing => true
    end

    render :json => {
             :widget_name => @widget.name,
             :widget_type => @widget.widget_type,
             :gadget_url => @widget.gadget_url,
             :configured => @widget.configured,
             :status => "success" }
  end

  def save_order
    params[:order].each do |column, widgets|
      widgets.each_index do |position|
        id = widgets[position]
        w = current_user.widgets.find(id) rescue next
        w.column = column
        w.position = position
        w.save
      end
    end
    render :nothing => true
  end

  def toggle_display
    begin
      @widget = current_user.widgets.find(params[:id])
    rescue
      render :nothing => true, :layout => false
      return
    end

    @widget.collapsed = !@widget.collapsed?
    @widget.save
    render :json => {:collapsed => @widget.collapsed?, :dom_id => @widget.dom_id}
  end

  private

  def filter_from_filter_by
    @widget.filter_from_filter_by
  end

  def tasks_extracted_from_show
     filter = filter_from_filter_by

      unless @widget.mine?
        @items = TaskRecord.accessed_by(current_user).where("tasks.completed_at IS NULL #{filter} AND (tasks.hide_until IS NULL OR tasks.hide_until < ?) AND (tasks.milestone_id NOT IN (?) OR tasks.milestone_id IS NULL)", tz.now.utc.to_s(:db), completed_milestone_ids).includes(:milestone,  :dependencies, :dependants, :todos, :tags)
      else
        @items = current_user.tasks.where("tasks.project_id IN (?) #{filter} AND tasks.completed_at IS NULL AND (tasks.hide_until IS NULL OR tasks.hide_until < ?) AND (tasks.milestone_id NOT IN (?) OR tasks.milestone_id IS NULL)", current_project_ids, tz.now.utc.to_s(:db), completed_milestone_ids).includes(:milestone, { :project => :customer }, :dependencies, :dependants, :todos, :tags)
      end

      @items = case @widget.order_by
               when 'priority' then
                 current_user.company.sort(@items)[0, @widget.number]
               when 'date' then
                 @items.sort_by {|t| t.created_at.to_i }.last(@widget.number)
               end
  end

  def task_graph_extracted_from_show
    start, step, interval, range, tick = @widget.calculate_start_step_interval_range_tick(tz)

    filter = filter_from_filter_by

      @items = []
      @dates = []
      @range = []
      0.upto(range * step) do |d|

        unless @widget.mine?
          @items[d] = TaskRecord.accessed_by(current_user).where("tasks.created_at < ? AND (tasks.completed_at IS NULL OR tasks.completed_at > ?) #{filter}", start + d*interval, start + d*interval).count
        else
          @items[d] = current_user.tasks.where("tasks.project_id IN (?) AND tasks.created_at < ? AND (tasks.completed_at IS NULL OR tasks.completed_at > ?) #{filter}", current_project_ids, start + d*interval, start + d*interval).count
        end

        @dates[d] = tz.utc_to_local(start + d * interval - 1.hour).strftime(tick) if(d % step == 0)
        @range[0] ||= @items[d]
        @range[1] ||= @items[d]
        @range[0] = @items[d] if @range[0] > @items[d]
        @range[1] = @items[d] if @range[1] < @items[d]
      end
  end

  def  burndown_extracted_from_show
    start, step, interval, range, tick = @widget.calculate_start_step_interval_range_tick(tz)
      filter = filter_from_filter_by

      @items = []
      @dates = []
      @range = []
      velocity = 0
      0.upto(range * step) do |d|

        unless @widget.mine?
          @items[d] = TaskRecord.accessed_by(current_user).where("tasks.created_at < ? AND (tasks.completed_at IS NULL OR tasks.completed_at > ?) #{filter}", start + d*interval, start + d*interval).sum('duration').to_f / 480
          worked = TaskRecord.accessed_by(current_user).where("tasks.project_id IN (?) AND tasks.created_at < ? AND (tasks.completed_at IS NULL OR tasks.completed_at > ?) #{filter} AND tasks.duration > 0 AND work_logs.started_at < ?", current_project_ids, start + d*interval, start + d*interval, start + d*interval).includes(:work_logs).sum('work_logs.duration').to_f / 480
          @items[d] = (@items[d] - worked > 0) ? (@items[d] - worked) : 0

        else
          @items[d] = current_user.tasks.where("tasks.project_id IN (?) AND tasks.created_at < ? AND (tasks.completed_at IS NULL OR tasks.completed_at > ?) #{filter}", current_project_ids, start + d*interval, start + d*interval).sum('duration').to_f / 480
          worked = current_user.tasks.where("tasks.project_id IN (?) AND tasks.created_at < ? AND (tasks.completed_at IS NULL OR tasks.completed_at > ?) #{filter} AND tasks.duration > 0 AND work_logs.started_at < ?", current_project_ids, start + d*interval, start + d*interval, start + d*interval).includes(:work_logs).sum('work_logs.duration').to_f / 480
          @items[d] = (@items[d] - worked > 0) ? (@items[d] - worked) : 0
        end

        @dates[d] = tz.utc_to_local(start + d * interval - 1.hour).strftime(tick) if(d % step == 0)
        @range[0] ||= @items[d]
        @range[1] ||= @items[d]
        @range[0] = @items[d] if @range[0] > @items[d]
        @range[1] = @items[d] if @range[1] < @items[d]

      end

      velocity = (@items[0] - @items[-1]) / ((interval * range * step) / 1.day)
      velocity = velocity * (interval / 1.day)

      logger.info("Burndown Velocity: #{velocity}")

      @end_date = nil
      if velocity > 0.0
        days_left = @items[-1] / (velocity)
        @end_date = Time.now + days_left.days
        logger.info("Burndown Velocity left #{@items[-1]}")
        logger.info("Burndown Velocity days: #{days_left}")
        logger.info("Burndown Velocity End date: #{@end_date}")
      end

      start = @items[0]

      @velocity = []
      0.upto(range * step) do |d|
        @velocity[d] = start - velocity * d
      end
  end

  def burnup_extracted_from_show
    start, step, interval, range, tick = @widget.calculate_start_step_interval_range_tick(tz)
    filter = filter_from_filter_by

      @items  = []
      @totals = []
      @dates  = []
      @range  = []
      velocity = 0
      0.upto(range * step) do |d|

        unless @widget.mine?
          @totals[d]  = TaskRecord.accessed_by(current_user).where("tasks.created_at < ? AND tasks.duration > 0 #{filter}", start + d*interval).sum('duration').to_f / 480
          @totals[d] += TaskRecord.accessed_by(current_user).where("tasks.created_at < ? AND tasks.duration = 0 AND work_logs.started_at < ? #{filter}", start + d*interval, start + d*interval).includes(:work_logs).sum('work_logs.duration').to_f / 480

          @items[d] = TaskRecord.accessed_by(current_user).where("(tasks.completed_at IS NOT NULL AND tasks.completed_at < ?) #{filter} AND tasks.created_at < ?  AND tasks.duration > 0", start + d*interval, start + d*interval).sum('tasks.duration').to_f / 480
          @items[d] += TaskRecord.accessed_by(current_user).where("tasks.created_at < ? AND (tasks.completed_at IS NULL OR tasks.completed_at > ?) #{filter} AND tasks.duration = 0 AND work_logs.started_at < ?", start + d*interval, start + d*interval, start + d*interval).includes(:work_logs).sum('work_logs.duration').to_f / 480
        else
          @totals[d]  = current_user.tasks.where("tasks.project_id IN (?) #{filter} AND tasks.created_at < ? AND tasks.duration > 0", current_project_ids, start + d*interval).sum('duration').to_f / 480
          @totals[d] += current_user.tasks.where("tasks.project_id IN (?) #{filter} AND tasks.created_at < ? AND tasks.duration = 0 AND work_logs.started_at < ?", current_project_ids, start + d*interval, start + d*interval).includes(:work_logs).sum('work_logs.duration').to_f / 480

          @items[d] = current_user.tasks.where("tasks.project_id IN (?) #{filter} AND (tasks.completed_at IS NOT NULL AND tasks.completed_at < ?) AND tasks.created_at < ?  AND tasks.duration > 0", current_project_ids, start + d*interval, start + d*interval).sum('tasks.duration').to_f / 480
          @items[d] += current_user.tasks.where("tasks.project_id IN (?) #{filter} AND tasks.created_at < ?  AND tasks.duration = 0 AND (tasks.completed_at IS NULL OR tasks.completed_at > ?) AND work_logs.started_at < ?", current_project_ids, start + d*interval, start + d*interval, start + d*interval).includes(:work_logs).sum('work_logs.duration').to_f / 480
        end

        @dates[d] = tz.utc_to_local(start + d * interval - 1.hour).strftime(tick) if(d % step == 0)
        @range[0] ||= @items[d]
        @range[1] ||= @items[d]
        @range[0] = @items[d] if @range[0] > @items[d]
        @range[1] = @items[d] if @range[1] < @items[d]

        @range[0] = @totals[d] if @range[0] > @totals[d]
        @range[1] = @totals[d] if @range[1] < @totals[d]

      end

      velocity = (@items[0] - @items[-1]) / ((interval * range * step) / 1.day)
      velocity = velocity * (interval/1.day)

      logger.info("Burnup Velocity: #{velocity}")
      @end_date = nil
      if velocity < 0.0
        days_left = (@totals[-1] - @items[-1]) / (-velocity)
        @end_date = Time.now + days_left.days
        logger.info("Burnup Velocity left: #{@totals[-1] - @items[-1]}")
        logger.info("Burnup Velocity days: #{days_left}")
        logger.info("Burnup Velocity End date: #{@end_date}")
      end

      start = @items[0]

      @velocity = []
      0.upto(range * step) do |d|
        @velocity[d] = start - velocity * d
      end
  end

  def comments_extracted_from_show
    if @widget.mine?
      @items = WorkLog.comments.on_tasks_owned_by(current_user).accessed_by(current_user).order("started_at desc").limit(@widget.number)
    else
      @items = WorkLog.comments.accessed_by(current_user).order("started_at desc").limit(@widget.number)
    end
  end

  def schedule_extracted_from_show
      filter = filter_from_filter_by

      if @widget.mine?
        tasks = current_user.tasks.includes(:users, :tags, :sheets, :todos, :dependencies, :dependants, { :project => :customer}, :milestone).where("tasks.completed_at IS NULL AND projects.completed_at IS NULL #{filter} AND (tasks.due_at IS NOT NULL OR tasks.milestone_id IS NOT NULL)")
      else
        tasks = TaskRecord.accessed_by(current_user).includes(:tags, :sheets, :todos, :dependencies, :dependants, :milestone).where("tasks.completed_at IS NULL AND projects.completed_at IS NULL #{filter} AND (tasks.due_at IS NOT NULL OR tasks.milestone_id IS NOT NULL)")
      end
      # first use default sorting
      tasks = tasks.sort_by { |t| t.due_date.to_i }
      @tasks = []

      tasks.each do |t|
        next if t.due_date.nil?

        if t.overdue?
          (@tasks[OVERDUE] ||= []) << t
        elsif t.due_date < ( tz.local_to_utc(tz.now.utc.tomorrow.midnight) )
          (@tasks[TODAY] ||= []) << t
        elsif t.due_date < ( tz.local_to_utc(tz.now.utc.since(2.days).midnight) )
          (@tasks[TOMORROW] ||= []) << t
        elsif t.due_date < ( tz.local_to_utc(tz.now.utc.next_week.beginning_of_week) )
          (@tasks[THIS_WEEK] ||= []) << t
        elsif t.due_date < ( tz.local_to_utc(tz.now.utc.since(2.weeks).beginning_of_week) )
          (@tasks[NEXT_WEEK] ||= []) << t
        end
      end
  end

  def work_status_extracted_from_show
    @last_completed = @widget.last_completed
    @counts = @widget.counts
  end

  def sheets_extracted_from_show
    filter = filter_from_filter_by
    @sheets = Sheet.order('users.name').includes(:user, :task, :project ).where("tasks.project_id IN (?) #{filter}", current_project_ids)
  end
end

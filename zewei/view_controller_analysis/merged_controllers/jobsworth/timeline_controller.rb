# encoding: UTF-8
# Filter WorkLogs in different ways, with pagination

class TimelineController < ApplicationController
  def index
    params[:filter_date] ||= 1
    params[:filter_project] ||= 0
    params[:filter_status] ||= -1
    @logs = EventLog.event_logs_for_timeline(current_user, params)

    if request.xhr?
      render :template => "timeline/index.json"
    else
       @page_title = t("timeline.title", title: Setting.productName) 
 t("timeline.timeline") 

  @users = objects_to_names_and_ids(User.order('name').where(:company_id => current_user.company_id))
  filter_count = 0

 form_tag('/timeline/index') do 
 if current_user.projects.any? 
 t("billings.any_project") 
 projects = current_user.projects.includes(:customer).except(:order).order("customers.name, projects.name") 
 client_projects = grouped_client_projects_options(projects)
 client_projects.each do |c| 
 c.first 
 c.last.each do |p| 
p.last
 " selected" if p.last.to_s == params[:filter_project] 
 p.first 
 end 
 end 
 end 

      @status = [[t("filter_status.any_type"), "-1"],
                [t("filter_status.closed"), EventLog::TASK_COMPLETED.to_s],
                [t("filter_status.work_log"), EventLog::TASK_WORK_ADDED.to_s],
                [t("filter_status.resolution_change"), EventLog::TASK_REVERTED.to_s],
                [t("filter_status.created"), EventLog::TASK_CREATED.to_s],
                [t("filter_status.comment"), EventLog::TASK_COMMENT.to_s],
                [t("filter_status.modified"), EventLog::TASK_MODIFIED.to_s]]

      @status << [t("filter_status.wiki_additions"), EventLog::WIKI_CREATED.to_s] if current_user.company.show_wiki?
      @status << [t("filter_status.wiki_changes"), EventLog::WIKI_MODIFIED.to_s] if current_user.company.show_wiki?
      @status <<  [t("filter_status.password_request"), EventLog::RESOURCE_PASSWORD_REQUESTED.to_s] if current_user.use_resources?

    
 options_for_select @status, params[:filter_status] 
 @dates =  [[t("filter_date.start_point"), "0"],
                  [t("filter_date.now"), "1"],
                  [t("filter_date.custom"),"2"]] 
 options_for_select @dates, params[:filter_date] || 1 
 text_field '', '',
        {
          :id => 'start_date',
          :name => 'start_date',
          :size => 12,
          :value => (params[:start_date]) ? params[:start_date] : ""
        }
      
 end 
 day = 0; @logs.each do |log| 
 if day != tz.utc_to_local(log.started_at).day 
 day = tz.utc_to_local(log.started_at).day 
 I18n.l(tz.utc_to_local(log.started_at), format: "%A, %d %B %Y") 
 end 
 if  log.target_type == 'WorkLog' 
  date_format = current_user.time_format 
 log.access_level_id
 if log.comment? && (log.user_id.to_i == current_user.id || current_user.admin?)
 link_to("#{tz.utc_to_local(log.started_at).strftime(date_format)}", edit_work_log_path(log)) 
 else 
 "#{tz.utc_to_local(log.started_at).strftime(date_format)}"
 if log.duration > 0 
 "#{tz.utc_to_local(log.ended_at).strftime(date_format)}"
 end 
 end 
 link_to "#{TimeParser.format_duration(log.duration)}", edit_work_log_path(log) if (log.duration > 0 && ((log.user && log.user.id == current_user.id) || current_user.admin?) )
 if log.event_log 
 image_tag('accept.png', :alt => t("activities.complete")) if log.event_log.event_type == EventLog::TASK_COMPLETED 
 image_tag('cancel.png', :alt => t("activities.reverted")) if log.event_log.event_type == EventLog::TASK_REVERTED 
 log.task.type.try(:to_html) if log.event_log.event_type == EventLog::TASK_CREATED 
 image_tag('edit.png', :alt => t("button.edit")) if log.event_log.event_type == EventLog::TASK_MODIFIED 
 image_tag('comment_add.png', :alt => t("activities.new_comment")) if log.event_log.event_type == EventLog::TASK_COMMENT 
 image_tag('time_add.png', :alt => t("activities.work_done")) if log.event_log.event_type == EventLog::TASK_WORK_ADDED 
 image_tag('folder_add.png', :alt => t("activities.archived")) if log.event_log.event_type == EventLog::TASK_ARCHIVED 
 image_tag('folder_go.png', :alt => t("activities.archived")) if log.event_log.event_type == EventLog::TASK_RESTORED 
 end 
 if log.task_id.to_i > 0 && log.task 
 link_to_task log.task 
 end 
 "<br/>".html_safe if (log.task_id.to_i > 0) 
 if log.task_id.to_i > 0 
 if log.task.project 
 log.task.project.full_name 
 log.task.tags.each do |t| 
 t.name 
 simple_format(h(t.name.capitalize)) 
 end 
 end 
 end 
 "<small><span class=\"otheruser\">[".html_safe + log.user.name + "]</span></small>".html_safe if log.user 
 avatar_for log.user, 25 if log.user 
 if log.body && log.body.length > 0 
simple_format(h(log.body)) if log.body 
 end 
 
 else 
  date_format = current_user.time_format 
 "#{tz.utc_to_local(log.created_at).strftime(date_format)}"
 image_tag('page_add.png', :alt => t("activities.wiki_page_added")) if log.event_type == EventLog::WIKI_CREATED 
 image_tag('page_edit.png', :alt => t("activities.wiki_page_modified")) if log.event_type == EventLog::WIKI_MODIFIED 
 image_tag('package_add.png', :alt => t("activities.file_added")) if log.event_type == EventLog::FILE_UPLOADED 
 if log.target.is_a? TaskRecord 
 link_to_task log.target 
 elsif log.target.is_a? WikiPage 
 log.target.to_url 
 elsif log.target.is_a? ProjectFile 
 "#{link_to_task(log.target.task)} [".html_safe if log.target.task 
 "<a href=\"/project_files/show/#{log.target_id}\" title=\"<img src=/project_files/thumbnail/#{log.target_id}>\" rel=\"tooltip\">#{log.target.filename}</a>".html_safe 
 "]".html_safe if log.target.task 
 else 
 log_title_for(log) 
 end 
 "<br/>".html_safe if(log.user || (log.target.respond_to?(:task) && log.target.task) ) 
 "<span class=\"optional\">#{log.target.task.full_name}</span> ".html_safe if( log.target.respond_to?(:task) && log.target.task )
 "<small><span class=\"otheruser\">[#{log.user.name}]</span></small>".html_safe if log.user 
 avatar_for log.user, 25 if log.user 
 if log.body && log.body.length > 0 
 log.body.gsub(/\n/, "<br/>").html_safe  
 end 
 
 end 
 end 
 if @logs.count > 0 
 t("shared.load_more") 
 else 
 t("shared.no_item_found") 
 end 
 current_user.dateFormat 
 (I18n.l(tz.utc_to_local(@logs.last.started_at), format: "%A, %d %B %Y") rescue "") 
 @logs.count 
 params[:filter_project] 
 params[:filter_status] 
 params[:filter_date] 
 params[:start_date] 

    end
 @page_title = t("timeline.title", title: Setting.productName) 
 t("timeline.timeline") 

  @users = objects_to_names_and_ids(User.order('name').where(:company_id => current_user.company_id))
  filter_count = 0

 form_tag('/timeline/index') do 
 if current_user.projects.any? 
 t("billings.any_project") 
 projects = current_user.projects.includes(:customer).except(:order).order("customers.name, projects.name") 
 client_projects = grouped_client_projects_options(projects)
 client_projects.each do |c| 
 c.first 
 c.last.each do |p| 
p.last
 " selected" if p.last.to_s == params[:filter_project] 
 p.first 
 end 
 end 
 end 

      @status = [[t("filter_status.any_type"), "-1"],
                [t("filter_status.closed"), EventLog::TASK_COMPLETED.to_s],
                [t("filter_status.work_log"), EventLog::TASK_WORK_ADDED.to_s],
                [t("filter_status.resolution_change"), EventLog::TASK_REVERTED.to_s],
                [t("filter_status.created"), EventLog::TASK_CREATED.to_s],
                [t("filter_status.comment"), EventLog::TASK_COMMENT.to_s],
                [t("filter_status.modified"), EventLog::TASK_MODIFIED.to_s]]

      @status << [t("filter_status.wiki_additions"), EventLog::WIKI_CREATED.to_s] if current_user.company.show_wiki?
      @status << [t("filter_status.wiki_changes"), EventLog::WIKI_MODIFIED.to_s] if current_user.company.show_wiki?
      @status <<  [t("filter_status.password_request"), EventLog::RESOURCE_PASSWORD_REQUESTED.to_s] if current_user.use_resources?

    
 options_for_select @status, params[:filter_status] 
 @dates =  [[t("filter_date.start_point"), "0"],
                  [t("filter_date.now"), "1"],
                  [t("filter_date.custom"),"2"]] 
 options_for_select @dates, params[:filter_date] || 1 
 text_field '', '',
        {
          :id => 'start_date',
          :name => 'start_date',
          :size => 12,
          :value => (params[:start_date]) ? params[:start_date] : ""
        }
      
 end 
 day = 0; @logs.each do |log| 
 if day != tz.utc_to_local(log.started_at).day 
 day = tz.utc_to_local(log.started_at).day 
 I18n.l(tz.utc_to_local(log.started_at), format: "%A, %d %B %Y") 
 end 
 if  log.target_type == 'WorkLog' 
  date_format = current_user.time_format 
 log.access_level_id
 if log.comment? && (log.user_id.to_i == current_user.id || current_user.admin?)
 link_to("#{tz.utc_to_local(log.started_at).strftime(date_format)}", edit_work_log_path(log)) 
 else 
 "#{tz.utc_to_local(log.started_at).strftime(date_format)}"
 if log.duration > 0 
 "#{tz.utc_to_local(log.ended_at).strftime(date_format)}"
 end 
 end 
 link_to "#{TimeParser.format_duration(log.duration)}", edit_work_log_path(log) if (log.duration > 0 && ((log.user && log.user.id == current_user.id) || current_user.admin?) )
 if log.event_log 
 image_tag('accept.png', :alt => t("activities.complete")) if log.event_log.event_type == EventLog::TASK_COMPLETED 
 image_tag('cancel.png', :alt => t("activities.reverted")) if log.event_log.event_type == EventLog::TASK_REVERTED 
 log.task.type.try(:to_html) if log.event_log.event_type == EventLog::TASK_CREATED 
 image_tag('edit.png', :alt => t("button.edit")) if log.event_log.event_type == EventLog::TASK_MODIFIED 
 image_tag('comment_add.png', :alt => t("activities.new_comment")) if log.event_log.event_type == EventLog::TASK_COMMENT 
 image_tag('time_add.png', :alt => t("activities.work_done")) if log.event_log.event_type == EventLog::TASK_WORK_ADDED 
 image_tag('folder_add.png', :alt => t("activities.archived")) if log.event_log.event_type == EventLog::TASK_ARCHIVED 
 image_tag('folder_go.png', :alt => t("activities.archived")) if log.event_log.event_type == EventLog::TASK_RESTORED 
 end 
 if log.task_id.to_i > 0 && log.task 
 link_to_task log.task 
 end 
 "<br/>".html_safe if (log.task_id.to_i > 0) 
 if log.task_id.to_i > 0 
 if log.task.project 
 log.task.project.full_name 
 log.task.tags.each do |t| 
 t.name 
 simple_format(h(t.name.capitalize)) 
 end 
 end 
 end 
 "<small><span class=\"otheruser\">[".html_safe + log.user.name + "]</span></small>".html_safe if log.user 
 avatar_for log.user, 25 if log.user 
 if log.body && log.body.length > 0 
simple_format(h(log.body)) if log.body 
 end 
 
 else 
  date_format = current_user.time_format 
 "#{tz.utc_to_local(log.created_at).strftime(date_format)}"
 image_tag('page_add.png', :alt => t("activities.wiki_page_added")) if log.event_type == EventLog::WIKI_CREATED 
 image_tag('page_edit.png', :alt => t("activities.wiki_page_modified")) if log.event_type == EventLog::WIKI_MODIFIED 
 image_tag('package_add.png', :alt => t("activities.file_added")) if log.event_type == EventLog::FILE_UPLOADED 
 if log.target.is_a? TaskRecord 
 link_to_task log.target 
 elsif log.target.is_a? WikiPage 
 log.target.to_url 
 elsif log.target.is_a? ProjectFile 
 "#{link_to_task(log.target.task)} [".html_safe if log.target.task 
 "<a href=\"/project_files/show/#{log.target_id}\" title=\"<img src=/project_files/thumbnail/#{log.target_id}>\" rel=\"tooltip\">#{log.target.filename}</a>".html_safe 
 "]".html_safe if log.target.task 
 else 
 log_title_for(log) 
 end 
 "<br/>".html_safe if(log.user || (log.target.respond_to?(:task) && log.target.task) ) 
 "<span class=\"optional\">#{log.target.task.full_name}</span> ".html_safe if( log.target.respond_to?(:task) && log.target.task )
 "<small><span class=\"otheruser\">[#{log.user.name}]</span></small>".html_safe if log.user 
 avatar_for log.user, 25 if log.user 
 if log.body && log.body.length > 0 
 log.body.gsub(/\n/, "<br/>").html_safe  
 end 
 
 end 
 end 
 if @logs.count > 0 
 t("shared.load_more") 
 else 
 t("shared.no_item_found") 
 end 
 current_user.dateFormat 
 (I18n.l(tz.utc_to_local(@logs.last.started_at), format: "%A, %d %B %Y") rescue "") 
 @logs.count 
 params[:filter_project] 
 params[:filter_status] 
 params[:filter_date] 
 params[:start_date] 

  end
end

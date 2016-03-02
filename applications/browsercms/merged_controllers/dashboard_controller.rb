  class DashboardController < BaseController

    def index
      @unpublished_pages = Page.unpublished.order("updated_at desc")
      @unpublished_pages = @unpublished_pages.select { |page| current_user.able_to_publish?(page) }
      @incomplete_tasks = current_user.tasks.incomplete.
          includes(:page).
          order("#{Task.table_name}.due_date desc, #{Page.table_name}.name").
          references(:page)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Dashboard" 
  form_tag cms.complete_tasks_path, :method => :put do 
 unless @incomplete_tasks.empty? 
 end 
 if @incomplete_tasks.empty? 
 else 
 @incomplete_tasks.each do |task| 
 check_box_tag "task_ids[]", task.id, false, :id => "complete_task_#{task.id}" 
 link_to h(task.page.name_with_section_path), task.page.path 
 h task.assigned_by.login 
 task.due_date ? task.due_date.strftime("%b %d, %Y") : nil 
 end 
 submit_tag("Complete Selected", :class => "submit btn btn-mini btn-primary") 
 end 
 end 
 
  form_tag cms.publish_pages_path, :method => :put do 
 unless @unpublished_pages.empty? 
 end 
 if @unpublished_pages.empty? 
 else 
 @unpublished_pages.each do |page| 
 check_box_tag "page_ids[]", page.id, false, :id => "publish_page_#{page.id}" 
 link_to h(page.name_with_section_path), page.path 
 h(page.updated_by ? page.updated_by.login : nil) 
 page.updated_at.strftime("%b %d, %Y") 
 end 
 submit_tag("Publish Selected", :class => "submit btn btn-mini btn-primary") 
 end 
 end 
 

end

    end
  end
  class TasksController < BaseController

    before_filter :load_page, :only => [:new, :create]

    def new
      @task = @page.tasks.build(:assigned_by => current_user)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Assign Task" 
 content_for :buttons, 'save_buttons' 
 content_for :sidebar do 
 link_to @page.name, page_path(@page), target: '_blank' 
 end 
 simple_form_for(@task, :url => @task.new_record? ? page_tasks_path(@page) : page_task_path(@page, @task)) do |f| 
 render layout: 'form_with_buttons', locals: {f: f} do 
 f.association :assigned_to,
                          label: "Assign To",
                          collection: User.active.able_to_edit_or_publish_content.order("first_name, last_name, login"),
                          include_blank: false,
                          label_method: :full_name_with_login
        
 f.input :due_date, as: :date_picker, hint: "Leave blank for no due date" 
 f.input :comment 
 end 
 end 

end

    end

    def create
      @task = @page.tasks.build(task_params())
      @task.assigned_by = current_user
      if @task.save
        flash[:notice] = "Page was assigned to '#{@task.assigned_to.login}'"
        redirect_to @page.path
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Assign Task" 
 content_for :buttons, 'save_buttons' 
 content_for :sidebar do 
 link_to @page.name, page_path(@page), target: '_blank' 
 end 
 simple_form_for(@task, :url => @task.new_record? ? page_tasks_path(@page) : page_task_path(@page, @task)) do |f| 
 render layout: 'form_with_buttons', locals: {f: f} do 
 f.association :assigned_to,
                          label: "Assign To",
                          collection: User.active.able_to_edit_or_publish_content.order("first_name, last_name, login"),
                          include_blank: false,
                          label_method: :full_name_with_login
        
 f.input :due_date, as: :date_picker, hint: "Leave blank for no due date" 
 f.input :comment 
 end 
 end 

end

      end
    end

    def complete
      if params[:task_ids]
        Task.where(["id in (?)", params[:task_ids]]).each do |t|
          if t.assigned_to == current_user
            t.mark_as_complete!
          end
        end
        flash[:notice] = "Tasks marked as complete"
        redirect_to dashboard_path
      else
        @task = Task.find(params[:id])
        if @task.assigned_to == current_user
          if @task.mark_as_complete!
            flash[:notice] = "Task was marked as complete"
          end
        else
          flash[:error] = "You cannot complete tasks that are not assigned to you"
        end
        redirect_to @task.page.path
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "No tasks were marked for completion"
      redirect_to dashboard_path
    end

    private
    def task_params
      params.require(:task).permit(Task.permitted_params)
    end

    def load_page
      @page = Page.find(params[:page_id])
    end

  end
# encoding: UTF-8
class TodosController < ApplicationController
  before_filter :load_task, :except => [:list_clone, :toggle_done_for_uncreated_task]
  before_filter :load_todo, :only => [:update, :toggle_done, :destroy]

  def create
    @todo = @task.todos.build(params[:todo])
    @todo.creator_id = current_user.id
    @todo.save

    render :file => "/todos/todos_container.json.erb"
  end

  def update
    @todo.update_attributes(params[:todo])
    ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 @task.id 
 render :partial => "todos/todo.html.erb", :collection => @task.todos.order("todos.id") 
 text_field_tag("todo[name]", "", :size => 50, :placeholder => t("todos.add_todo_placeholder")) 

end

  end

  def toggle_done
    if @todo.done?
      @todo.completed_at = nil
      @todo.completed_by_user_id = nil
    else
      @todo.completed_at = Time.now
      @todo.completed_by_user_id = current_user.id
    end

    @todo.save
    render :file => "/todos/todos_container.json.erb"
  end

  def toggle_done_for_uncreated_task
    todo = Todo.new(:creator_id => current_user.id, :name => params[:name])
    if params[:id] == "true"
      todo.completed_at = Time.now
      todo.completed_by_user_id = current_user.id
    else
      todo.completed_at = nil
      todo.completed_by_user_id = nil
    end

    render :partial => "/todos/new_todo", :locals => {:todo => todo}
  end

  def destroy
    @todo.destroy
    render :file => "/todos/todos_container.json.erb"
  end

  def reorder
    params[:todos].values.each{ |todo| t=@task.todos.find(todo[:id]); t.position=todo[:position]; t.save!}
    render :nothing=>true
  end

  #for todos at task creation page (from template)
  def list_clone
    @task = TaskRecord.new
    Template.find(params[:id]).clone_todos.collect{|t| @task.todos.build(t.attributes) }

    ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 @task.todos.each do |todo| 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 todo.position 
 todo.css_classes
 new_todo_open_close_check_box(todo) 
 hidden_field_tag "todos[][creator_id]", todo.creator_id, :class => "creator_id" 
 hidden_field_tag "todos[][completed_by_user_id]", todo.completed_by_user_id, :class => "completed_by_user_id" 
 hidden_field_tag "todos[][completed_at]", todo.completed_at, :class => "completed_at" 
h todo.name 
 text_field_tag("todos[][name]", todo.name) 
 link_to(t("button.cancel"), "#", :class => "toggle-todo-edit") 
 if todo.done? 
h "[#{ formatted_datetime_for_current_user(tz.utc_to_local(todo.completed_at)) }]" 
h "[#{ todo.completed_by_user.name }]" if todo.completed_by_user 
 else 
 link_to('<i class="icon-pencil"></i>'.html_safe, "#", :class => "toggle-todo-edit") 
 end 
 link_to '<i class="icon-remove"></i>'.html_safe, "#", :rel => "tooltip", :title => t("todos.delete_todo_html", todo: h(todo.name)),
              :onClick => "jQuery(this).parent().remove(); return false;"

end
 
 end 
 template = render_to_string(:partial => "todos/new_todo", :locals => {:todo => Todo.new(:creator_id => current_user.id )}) 
 template 
 text_field_tag("todo[name]", "", :size => 50, :placeholder => t("todos.add_todo_placeholder")) 

end

  end

  private

  def load_task
    @task = TaskRecord.accessed_by(current_user).find_by_id(params[:task_id])
    ###################### code smell begin ################################################################
    # this code allow usage  TodosController in TaskTemplatesController#edit
    #NOTE: Template is a Task, using single table inheritance
    if @task.nil?
      @task= Template.where("company_id = ?", current_user.company_id).find_by_id(params[:task_id])
    end
    ###################### code smell end ##################################################################
    if @task.nil?
      flash[:error] = t('flash.alert.access_denied_to_model', model: Todo.model_name.human)
      redirect_from_last
    end
  end

  def load_todo
    @todo = @task.todos.find(params[:id])
  end
end

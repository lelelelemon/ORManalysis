class TasksController < ApplicationController
  load_and_authorize_parent :group, optional: true
  load_and_authorize_resource

  def index
    if !@group
      @groups = @logged_in.tasks.map(&:group).uniq
    elsif @logged_in.member_of?(@group)
      @tasks = tasks.order(completed: :asc, duedate: :asc).page(params[:page])
    else
      render text: t('not_authorized'), layout: true, status: :forbidden
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @group 
 @title = t('tasks.index.group_heading', group: @group.name) 
 else 
 @title = t('tasks.index.heading') 
 end 
 if @group 
 link_to new_group_task_path(@group), class: 'btn btn-success' do 
 icon 'fa fa-plus' 
 t('tasks.new.button') 
 end 
 end 
 if @group 
 if @group.tasks.any? 
  tasks.each_with_index do |task, task_index| 
 form_for [:complete, task.group, task], html: { class: "complete-task-form" } do |form| 
 if @group.present? 
 icon 'fa fa-reorder' 
 end 
 form.check_box :completed, autocomplete: "off" 
 link_to task.name, [task.group, task] 
 if task.duedate 
 icon 'fa fa-calendar' 
 task.duedate.to_s(:date) 
 end 
 if task.person 
 icon 'fa fa-user' 
 task.person.name 
 end 
 if task.comments.any? 
 icon 'fa fa-comment' 
 t("tasks.index.comment_count", count: task.comments.count) 
 end 
 if @logged_in.can_update?(task) 
 link_to edit_group_task_path(task.group, task), class: 'btn bg-gray btn-xs text-yellow' do 
 icon 'fa fa-pencil' 
 end 
 end 
 if @logged_in.can_delete?(task) 
 link_to task, data: { method: 'delete', confirm: t('are_you_sure') },  class: 'btn bg-gray btn-xs text-red' do 
 icon 'fa fa-minus-circle' 
 end 
 end 
 end 
 end 
 
 else 
 t('none') 
 end 
 else 
 @groups.each do |group| 
 group.name 
 link_to group_tasks_path(group), class: "btn btn-primary btn-sm" do 
 t("tasks.go_to_group") 
 icon "fa fa-arrow-circle-right" 
 end 
  tasks.each_with_index do |task, task_index| 
 form_for [:complete, task.group, task], html: { class: "complete-task-form" } do |form| 
 if @group.present? 
 icon 'fa fa-reorder' 
 end 
 form.check_box :completed, autocomplete: "off" 
 link_to task.name, [task.group, task] 
 if task.duedate 
 icon 'fa fa-calendar' 
 task.duedate.to_s(:date) 
 end 
 if task.person 
 icon 'fa fa-user' 
 task.person.name 
 end 
 if task.comments.any? 
 icon 'fa fa-comment' 
 t("tasks.index.comment_count", count: task.comments.count) 
 end 
 if @logged_in.can_update?(task) 
 link_to edit_group_task_path(task.group, task), class: 'btn bg-gray btn-xs text-yellow' do 
 icon 'fa fa-pencil' 
 end 
 end 
 if @logged_in.can_delete?(task) 
 link_to task, data: { method: 'delete', confirm: t('are_you_sure') },  class: 'btn bg-gray btn-xs text-red' do 
 icon 'fa fa-minus-circle' 
 end 
 end 
 end 
 end 
 
 end 
 end 

end

  end

  def show
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('tasks.show.heading', task: @task.name) 
 simple_format @task.name 
 link_to edit_group_task_path(@task.group, @task), class: "btn btn-sm btn-primary" do 
 t("tasks.show.edit") 
 end 
 t("activerecord.attributes.task.description") 
 simple_format @task.description 
 t("activerecord.attributes.task.person") 
 if @task.person 
 link_to @task.person.name, person_path(@task.person) 
 end 
 t("activerecord.attributes.task.duedate") 
 @task.duedate.to_s(:date) if @task.duedate 
 t('Comments') 
  if object.comments.any? 
 object.comments.each do |comment| 
 link_to comment.person do 
 avatar_tag comment.person 
 end 
 link_to comment.person.name, comment.person 
 comment.created_at.to_s(:full) 
 if @logged_in.can_update?(comment) 
 link_to comment_path(comment), class: 'btn btn-xs bg-gray text-red', method: 'delete', data: { confirm: t('are_you_sure') } do 
 icon 'fa fa-trash-o' 
 end 
 end 
 preserve_breaks comment.text 
 end 
 else 
 t('comments.none_yet') 
 end 
 t('comments.add_a_comment') 
 form_for Comment.new, html: {style: 'border:none;'} do |form| 
 hidden_field_tag 'comment[commentable_type]', object.class 
 hidden_field_tag 'comment[commentable_id]', object.id 
 hidden_field_tag :return_to, request.fullpath 
 text_area_tag 'comment[text]', '', rows: 3, cols: 40, id: 'new_comment_textarea', class: 'form-control' 
 form.submit t('comments.save'), class: 'btn btn-success' 
 end 
 

end

  end

  def new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('tasks.new.heading') 
  form_for [@group, @task] do |form| 
 error_messages_for(form) 
 form.hidden_field :group_id 
 form.label :name 
 form.text_field :name, class: 'form-control' 
 form.label :duedate 
 icon 'fa fa-calendar' 
 form.date_field :duedate, class: 'form-control' 
 form.label :person_id 
 form.select :person_id, @group.people.map { |p| [p.name, p.id] }, {include_blank: true}, class: 'form-control' 
 form.label :description 
 form.text_area :description, rows: 5, class: 'form-control' 
 form.button t('tasks.save'), class: 'btn btn-success' 
 end 
 

end

  end
  def create
    if @task.save
      redirect_to group_tasks_path(@group)
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('tasks.new.heading') 
  form_for [@group, @task] do |form| 
 error_messages_for(form) 
 form.hidden_field :group_id 
 form.label :name 
 form.text_field :name, class: 'form-control' 
 form.label :duedate 
 icon 'fa fa-calendar' 
 form.date_field :duedate, class: 'form-control' 
 form.label :person_id 
 form.select :person_id, @group.people.map { |p| [p.name, p.id] }, {include_blank: true}, class: 'form-control' 
 form.label :description 
 form.text_area :description, rows: 5, class: 'form-control' 
 form.button t('tasks.save'), class: 'btn btn-success' 
 end 
 

end

    end
  end

  def edit
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('tasks.edit.heading') 
  form_for [@group, @task] do |form| 
 error_messages_for(form) 
 form.hidden_field :group_id 
 form.label :name 
 form.text_field :name, class: 'form-control' 
 form.label :duedate 
 icon 'fa fa-calendar' 
 form.date_field :duedate, class: 'form-control' 
 form.label :person_id 
 form.select :person_id, @group.people.map { |p| [p.name, p.id] }, {include_blank: true}, class: 'form-control' 
 form.label :description 
 form.text_area :description, rows: 5, class: 'form-control' 
 form.button t('tasks.save'), class: 'btn btn-success' 
 end 
 

end

  end

  def update
    if @task.update_attributes(task_params)
      redirect_to group_task_path(@group, @task)
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('tasks.edit.heading') 
  form_for [@group, @task] do |form| 
 error_messages_for(form) 
 form.hidden_field :group_id 
 form.label :name 
 form.text_field :name, class: 'form-control' 
 form.label :duedate 
 icon 'fa fa-calendar' 
 form.date_field :duedate, class: 'form-control' 
 form.label :person_id 
 form.select :person_id, @group.people.map { |p| [p.name, p.id] }, {include_blank: true}, class: 'form-control' 
 form.label :description 
 form.text_area :description, rows: 5, class: 'form-control' 
 form.button t('tasks.save'), class: 'btn btn-success' 
 end 
 

end

    end
  end

  def destroy
    @task = Task.find(params[:id])
    if @logged_in.can_delete?(@task)
      @task.destroy
      flash[:notice] = t('tasks.deleted')
      redirect_back
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
  end

  def complete
    @task = @group.tasks.find(params[:id])
    @task.update_attribute(:completed, params[:task][:completed])
    render nothing: true
  end

  def update_position
    @task = Task.find(params[:id])
    @task.insert_at(params[:position].to_i) if @task.updatable_by?(@logged_in)
    render nothing: true
  end

  private

  def task_params
    params.require(:task).permit(:person_id, :name, :description, :duedate, :group_id)
  end
end

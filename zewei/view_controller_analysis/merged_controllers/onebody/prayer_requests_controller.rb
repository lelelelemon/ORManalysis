class PrayerRequestsController < ApplicationController

  load_and_authorize_parent :group, optional: true
  load_and_authorize_resource

  def index
    if @logged_in.member_of?(@group)
      if params[:answered]
        @reqs = prayer_requests.where("coalesce(answer, '') != ''").order(created_at: :desc).page(params[:page])
      else
        @reqs = prayer_requests.order(created_at: :desc).page(params[:page])
      end
    else
      render text: t('not_authorized'), layout: true, status: :forbidden
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('prayer_requests.index.heading') 
 link_to new_group_prayer_request_path(@group), class: 'btn btn-success' do 
 icon 'fa fa-plus' 
 t('prayer_requests.new.button') 
 end 
 pagination @reqs 
 @reqs.each do |req| 
 link_to req.created_at.to_s(:date), req 
 t('prayer_requests.by', person: link_to(req.person.try(:name), req.person)).html_safe 
 preserve_breaks req.request 
 if req.answer.present? 
 if req.answered_at 
 t('prayer_requests.answer.on_date', date: req.answered_at.to_s(:date)) 
 else 
 t('prayer_requests.answer.heading') 
 end 
 preserve_breaks req.answer 
 end 
 end 
 pagination @reqs 

end

  end

  def show
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('prayer_requests.show.heading') 
 t('prayer_requests.by', person: link_to(@prayer_request.person.try(:name), @prayer_request.person)).html_safe 
 @prayer_request.request 
 if @prayer_request.answer.present? 
 t('prayer_requests.answer.heading') 
 if @prayer_request.answered_at 
 t('prayer_requests.answer.on_date', date: @prayer_request.answered_at.to_s(:date)) 
 end 
 @prayer_request.answer 
 end 
 if @logged_in.can_update?(@prayer_request) 
 link_to edit_group_prayer_request_path(@prayer_request.group, @prayer_request), class: 'btn btn-info' do 
 icon 'fa fa-pencil' 
 t('prayer_requests.edit.button') 
 end 
 link_to [@prayer_request.group, @prayer_request], method: :delete, data: { confirm: t('are_you_sure') }, class: 'btn bg-gray text-red' do 
 icon 'fa fa-trash-o' 
 t('prayer_requests.delete.button') 
 end 
 end 

end

  end

  def new
    @prayer_request.person = @logged_in
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('prayer_requests.new.heading') 
  form_for [@group, @prayer_request] do |form| 
 error_messages_for(form) 
 form.hidden_field :group_id 
 t('prayer_requests.request.heading') 
 form.label :person_id 
 form.select :person_id, @group.people.map { |p| [p.name, p.id] }, {}, class: 'form-control' 
 form.label :request 
 form.text_area :request, rows: 5, class: 'form-control' 
 t('prayer_requests.answer.heading') 
 t('prayer_requests.answer.description') 
 form.label :answered_at 
 icon 'fa fa-calendar' 
 form.date_field :answered_at, class: 'form-control' 
 form.label :answer 
 form.text_area :answer, rows: 5, class: 'form-control' 
 check_box_tag :send_email 
 t('prayer_requests.send_email') 
 form.button t('prayer_requests.save'), class: 'btn btn-success' 
 end 
 

end

  end

  def create
    if @prayer_request.save
      if params[:send_email]
        @prayer_request.send_group_email
      end
      redirect_to group_prayer_requests_path(@group)
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('prayer_requests.new.heading') 
  form_for [@group, @prayer_request] do |form| 
 error_messages_for(form) 
 form.hidden_field :group_id 
 t('prayer_requests.request.heading') 
 form.label :person_id 
 form.select :person_id, @group.people.map { |p| [p.name, p.id] }, {}, class: 'form-control' 
 form.label :request 
 form.text_area :request, rows: 5, class: 'form-control' 
 t('prayer_requests.answer.heading') 
 t('prayer_requests.answer.description') 
 form.label :answered_at 
 icon 'fa fa-calendar' 
 form.date_field :answered_at, class: 'form-control' 
 form.label :answer 
 form.text_area :answer, rows: 5, class: 'form-control' 
 check_box_tag :send_email 
 t('prayer_requests.send_email') 
 form.button t('prayer_requests.save'), class: 'btn btn-success' 
 end 
 

end

    end
  end

  def edit
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('prayer_requests.edit.heading') 
  form_for [@group, @prayer_request] do |form| 
 error_messages_for(form) 
 form.hidden_field :group_id 
 t('prayer_requests.request.heading') 
 form.label :person_id 
 form.select :person_id, @group.people.map { |p| [p.name, p.id] }, {}, class: 'form-control' 
 form.label :request 
 form.text_area :request, rows: 5, class: 'form-control' 
 t('prayer_requests.answer.heading') 
 t('prayer_requests.answer.description') 
 form.label :answered_at 
 icon 'fa fa-calendar' 
 form.date_field :answered_at, class: 'form-control' 
 form.label :answer 
 form.text_area :answer, rows: 5, class: 'form-control' 
 check_box_tag :send_email 
 t('prayer_requests.send_email') 
 form.button t('prayer_requests.save'), class: 'btn btn-success' 
 end 
 

end

  end

  def update
    if @prayer_request.update_attributes(prayer_request_params)
      if params[:send_email]
        @prayer_request.send_group_email
      end
      redirect_to group_prayer_request_path(@group, @prayer_request)
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('prayer_requests.edit.heading') 
  form_for [@group, @prayer_request] do |form| 
 error_messages_for(form) 
 form.hidden_field :group_id 
 t('prayer_requests.request.heading') 
 form.label :person_id 
 form.select :person_id, @group.people.map { |p| [p.name, p.id] }, {}, class: 'form-control' 
 form.label :request 
 form.text_area :request, rows: 5, class: 'form-control' 
 t('prayer_requests.answer.heading') 
 t('prayer_requests.answer.description') 
 form.label :answered_at 
 icon 'fa fa-calendar' 
 form.date_field :answered_at, class: 'form-control' 
 form.label :answer 
 form.text_area :answer, rows: 5, class: 'form-control' 
 check_box_tag :send_email 
 t('prayer_requests.send_email') 
 form.button t('prayer_requests.save'), class: 'btn btn-success' 
 end 
 

end

    end
  end

  def destroy
    @prayer_request.destroy
    redirect_to group_prayer_requests_path(@group)
  end

  private

  def prayer_request_params
    params.require(:prayer_request).permit(:person_id, :request, :answer, :answered_at)
  end
end

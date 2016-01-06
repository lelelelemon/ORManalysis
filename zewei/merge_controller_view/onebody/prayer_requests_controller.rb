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
  end

  def show
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

  def new
    @prayer_request.person = @logged_in
 @title = t('prayer_requests.new.heading') 
 render partial: 'form' 

  end

  def create
    if @prayer_request.save
      if params[:send_email]
        @prayer_request.send_group_email
      end
      redirect_to group_prayer_requests_path(@group)
    else
      render action: 'new'
    end
  end

  def edit
 @title = t('prayer_requests.edit.heading') 
 render partial: 'form' 

  end

  def update
    if @prayer_request.update_attributes(prayer_request_params)
      if params[:send_email]
        @prayer_request.send_group_email
      end
      redirect_to group_prayer_request_path(@group, @prayer_request)
    else
      render action: 'edit'
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

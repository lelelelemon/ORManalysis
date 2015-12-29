class Administration::Checkin::LabelsController < ApplicationController

  before_filter :only_admins

  def index
    @labels = CheckinLabel.order(:name)
 @title = t('checkin.labels.heading') 
 t('checkin.labels.table.name') 
 t('checkin.labels.table.description') 
 t('checkin.labels.table.updated_at') 
 @labels.each do |label| 
 link_to label.name, edit_administration_checkin_label_path(label) 
 label.description 
 label.updated_at.to_s(:full) 
 link_to edit_administration_checkin_label_path(label), class: 'btn btn-info' do 
 icon 'fa fa-pencil' 
 end 
 link_to administration_checkin_label_path(label), data: { method: 'delete', confirm: t('are_you_sure') }, class: 'btn btn-delete' do 
 icon 'fa fa-trash-o' 
 end 
 end 
 link_to new_administration_checkin_label_path, class: 'btn btn-success' do 
 icon 'fa fa-plus' 
 t('checkin.labels.new.button') 
 end 

  end

  def new
    @label = CheckinLabel.new
 @title = t('checkin.labels.new.heading') 
 render partial: 'form' 

  end

  def edit
    @label = CheckinLabel.find(params[:id])
 @title = t('checkin.labels.edit.heading') 
 render partial: 'form' 

  end

  def create
    @label = CheckinLabel.new(label_params)
    if @label.save
      redirect_to administration_checkin_labels_path, notice: t('changes_saved')
    else
      render action: 'new'
    end
  end

  def update
    @label = CheckinLabel.find(params[:id])
    if @label.update_attributes(label_params)
      redirect_to administration_checkin_labels_path, notice: t('changes_saved')
    else
      render action: 'edit'
    end
  end

  def destroy
    CheckinLabel.find(params[:id]).destroy
    redirect_to administration_checkin_labels_path, notice: t('checkin.labels.delete.notice')
  end

  private

  def label_params
    params.require(:checkin_label).permit(:name, :description, :xml, :xml_file)
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

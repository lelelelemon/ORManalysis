class Administration::Checkin::LabelsController < ApplicationController

  before_filter :only_admins

  def index
    @labels = CheckinLabel.order(:name)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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

  end

  def new
    @label = CheckinLabel.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('checkin.labels.new.heading') 
  form_for @label, url: @label.persisted? ? administration_checkin_label_path(@label) : administration_checkin_labels_path, multipart: true do |form| 
 error_messages_for(form) 
 form.label :name 
 form.text_field :name, class: 'form-control' 
 form.label :description 
 form.text_area :description, class: 'form-control' 
 form.label :xml 
 form.text_area :xml, class: 'form-control', rows: 15 
 form.label :xml_file 
 form.file_field :xml_file 
 form.button t('save'), class: 'btn btn-success' 
 end 
 

end

  end

  def edit
    @label = CheckinLabel.find(params[:id])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('checkin.labels.edit.heading') 
  form_for @label, url: @label.persisted? ? administration_checkin_label_path(@label) : administration_checkin_labels_path, multipart: true do |form| 
 error_messages_for(form) 
 form.label :name 
 form.text_field :name, class: 'form-control' 
 form.label :description 
 form.text_area :description, class: 'form-control' 
 form.label :xml 
 form.text_area :xml, class: 'form-control', rows: 15 
 form.label :xml_file 
 form.file_field :xml_file 
 form.button t('save'), class: 'btn btn-success' 
 end 
 

end

  end

  def create
    @label = CheckinLabel.new(label_params)
    if @label.save
      redirect_to administration_checkin_labels_path, notice: t('changes_saved')
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('checkin.labels.new.heading') 
  form_for @label, url: @label.persisted? ? administration_checkin_label_path(@label) : administration_checkin_labels_path, multipart: true do |form| 
 error_messages_for(form) 
 form.label :name 
 form.text_field :name, class: 'form-control' 
 form.label :description 
 form.text_area :description, class: 'form-control' 
 form.label :xml 
 form.text_area :xml, class: 'form-control', rows: 15 
 form.label :xml_file 
 form.file_field :xml_file 
 form.button t('save'), class: 'btn btn-success' 
 end 
 

end

    end
  end

  def update
    @label = CheckinLabel.find(params[:id])
    if @label.update_attributes(label_params)
      redirect_to administration_checkin_labels_path, notice: t('changes_saved')
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('checkin.labels.edit.heading') 
  form_for @label, url: @label.persisted? ? administration_checkin_label_path(@label) : administration_checkin_labels_path, multipart: true do |form| 
 error_messages_for(form) 
 form.label :name 
 form.text_field :name, class: 'form-control' 
 form.label :description 
 form.text_area :description, class: 'form-control' 
 form.label :xml 
 form.text_area :xml, class: 'form-control', rows: 15 
 form.label :xml_file 
 form.file_field :xml_file 
 form.button t('save'), class: 'btn btn-success' 
 end 
 

end

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

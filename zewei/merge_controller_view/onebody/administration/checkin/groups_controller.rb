class Administration::Checkin::GroupsController < ApplicationController

  before_filter :only_admins

  def index
    @time = CheckinTime.find(params[:time_id]).decorate
    @entries = @time.entries
    @labels = CheckinLabel.all.order(:name)
 @title = t('checkin.groups.index.heading', time: @time.to_s, campus: @time.campus) 
 render partial: 'entries' 
 icon 'fa fa-info-circle' 
 t('checkin.groups.movement_help_html') 
 t('checkin.groups.index.add_group.heading') 
 form_tag groups_path, remote: true, method: 'get', id: 'group-search' do 
 hidden_field_tag :select_group, true 
 hidden_field_tag :include_hidden, true 
 label_tag :name, t('name') 
 text_field_tag :name, '', class: 'form-control' 
 button_tag t('checkin.groups.index.add_group.search'), class: 'btn btn-info' 
 end 
 form_tag administration_checkin_time_groups_path(@time), remote: true do 
 render partial: 'folder_select' 
 button_tag t('checkin.groups.index.add_group.button'), class: 'btn btn-success' 
 end 
 t('none') 
 t('checkin.groups.index.add_folder.heading') 
 form_tag administration_checkin_time_groups_path(@time), remote: true do 
 hidden_field_tag :folder, true 
 label_tag :name, t('checkin.groups.index.add_folder.name') 
 text_field_tag :name, '', class: 'form-control', id: 'folder_name' 
 button_tag t('checkin.groups.index.add_folder.button'), class: 'btn btn-success' 
 end 

  end

  def create
    @time = CheckinTime.find(params[:time_id])
    if params[:folder]
      create_folder
    else
      create_group
    end
    respond_to do |format|
      format.html { redirect_to edit_administration_checkin_time_path(@time) }
      format.js do
        @labels = CheckinLabel.all.order(:name)
        @entries = @time.entries
      end
    end
 escape_javascript render(partial: 'entries') 
 @added.each do |group_time| 
 dom_id(group_time) 
 if group_time.checkin_folder_id 
 dom_id(group_time.checkin_folder) 
 end 
 end 
 escape_javascript render(partial: 'folder_select') 

  end

  def update
    if @group_time = GroupTime.find(params[:id])
      @group_time.attributes = params.permit(:label_id, :print_extra_nametag)
      @group_time.save
    end
 if not @group_time 
 t('There_was_an_error') 
 elsif @group_time.errors.any? 
 escape_javascript @group_time.errors.values.join('; ') 
 else 
 dom_id(@group_time) 
 end 

  end

  def destroy
    @entry = find_entry(params[:id])
    @entry.destroy
    respond_to do |format|
      format.html { redirect_to administration_checkin_time_groups_path(@entry.time) }
      format.js
    end
 if @entry.is_a?(CheckinFolder) 
 @entry.class.name.underscore 
 @entry.id 
 @entry.id 
 else 
 @entry.class.name.underscore 
 @entry.id 
 end 

  end

  def reorder
    @entry = find_entry(params[:id])
    if params[:jump_into]
      find_entry(params[:jump_into]).insert(@entry, params[:direction] == 'up' ? :bottom : :top)
    elsif params[:jump_out]
      @entry.remove_from_checkin_folder(params[:direction] == 'up' ? :above : :below)
    else
      @entry.parent.reorder_entry(@entry, params[:direction], params[:full_stop].present?)
    end
    @time = @entry.time
    respond_to do |format|
      format.html { redirect_to administration_checkin_time_groups_path(@time) }
      format.js do
        @labels = CheckinLabel.all.order(:name)
        @entries = @time.entries
      end
    end
 escape_javascript render(partial: 'entries') 
 dom_id(@entry) 

  end

  private

  def create_folder
    @added = [@time.checkin_folders.create!(name: params[:name])]
  end

  def create_group
    @added = Array(params[:ids]).map do |id|
      group = Group.find(id)
      group.update_attribute(:attendance, true)
      opts = if params[:checkin_folder_id].present?
        { checkin_folder_id: params[:checkin_folder_id] }
      else
        { checkin_time_id: @time.id }
      end
      # NOTE cannot use first_or_create here due to https://github.com/rails/rails/issues/16668
      group.group_times.create(opts) unless group.group_times.where(opts).any?
    end.compact
  end

  def find_entry(id)
    if id.sub!(/group_time_/, '')
      GroupTime.find(id)
    elsif id.sub!(/checkin_folder_/, '')
      CheckinFolder.find(id)
    else
      raise "could not find record by id #{id}"
    end
  end

  def only_admins
    unless @logged_in.admin?(:manage_checkin)
      render text: 'You must be an administrator to use this section.', layout: true, status: 401
      return false
    end
  end

  def feature_enabled?
    unless Setting.get(:features, :checkin)
      render text: 'This feature is unavailable.', layout: true
      false
    end
  end
end

class Administration::Checkin::DashboardsController < ApplicationController

  before_filter :only_admins

  def show
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('checkin.heading') 
 form_tag search_path, :remote => true, :id => 'search-form' do |form| 
 hidden_field_tag :select_family, true 
 label_tag :family_name, t('checkin.search.label') 
 text_field_tag :family_name, '', autocomplete: 'off', class: 'form-control' 
 button_tag class: 'btn btn-info' do 
 icon 'fa fa-search' 
 t('checkin.search.button') 
 end 
 end 
 t('checkin.search.none_found') 
 link_to administration_checkin_root_path, class: 'btn btn-warning btn' do 
 icon 'fa fa-times-circle' 
 t('checkin.search.clear') 
 end 
 render_page_content 'help/checkin' 
 link_to new_checkin_family_path, class: 'btn btn-success' do 
 icon 'fa fa-plus' 
 t('checkin.add_family.button') 
 end 
 if @logged_in.admin?(:manage_attendance) 
 link_to administration_attendance_index_path, class: 'btn btn-info' do 
 icon 'fa fa-bar-chart-o' 
 t('checkin.attendance.button') 
 end 
 end 
 if @logged_in.admin?(:manage_checkin) 
 link_to administration_checkin_cards_path, class: 'btn btn-info' do 
 icon 'fa fa-barcode' 
 t('checkin.assigned_cards.button') 
 end 
 link_to administration_checkin_times_path, class: 'btn btn-warning' do 
 icon 'fa fa-clock-o' 
 t('checkin.times.button') 
 end 
 link_to administration_checkin_labels_path, class: 'btn btn-warning' do 
 icon 'fa fa-square-o' 
 t('checkin.labels.button') 
 end 
 end 
 content_for :js do 
 end 

end

  end

  private

    def only_admins
      unless @logged_in.admin?(:manage_checkin) or @logged_in.admin?(:assign_checkin_cards)
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

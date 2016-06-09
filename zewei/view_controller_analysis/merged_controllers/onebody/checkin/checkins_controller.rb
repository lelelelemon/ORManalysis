class Checkin::CheckinsController < ApplicationController
  before_action :ensure_campus_selection

  layout 'checkin'

  # show UI
  def show
    session[:checkin_printer_id] = params[:printer].presence if params[:printer]
    @checkin = CheckinPresenter.new(session[:checkin_campus])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @title.present? 
 yield(:meta) 
 stylesheet_link_tag 'application' 
 yield(:css) 
 csrf_meta_tags 
  
 yield(:head) 
 @title = t('checkin.interface.heading') 
 content_for :css do 
 stylesheet_link_tag 'checkin-print', media: 'print' 
 end 
 content_for :js do 
 end 
 content_for :js do 
 end 
 javascript_include_tag 'checkin' 
 yield(:js) 
 analytics_js 
 end

end

  end

  # scan barcode
  def create
    if @family = Family.undeleted.by_barcode(params[:barcode]).first
      session[:barcode] = params[:barcode]
      @checkin = CheckinPresenter.new(session[:checkin_campus], @family)
      render json: @checkin
    else
      render json: { error: t('checkin.scan.unknown_card') }
    end
  end

  # complete check-in
  def update
    labels = {}
    params[:people].each do |person_id, times|
      records = AttendanceRecord.check_in(person_id, times, session[:barcode])
      labels[person_id] = AttendanceRecord.labels_for(records)
    end
    render json: {
      labels: labels,
      today: Date.current.to_s(:date),
      community_name: Setting.get(:name, :community)
    }
  end

  private

  def authenticate_user
    authenticate_user_for_checkin
  end

  def ensure_campus_selection
    if params[:campus]
      session[:checkin_campus] = params[:campus]
    elsif not session[:checkin_campus]
      @campuses = CheckinTime.campuses
      if @campuses.none?
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @title.present? 
 yield(:meta) 
 stylesheet_link_tag 'application' 
 yield(:css) 
 csrf_meta_tags 
  
 yield(:head) 
 t('checkin.interface.run_setup.intro') 
 link_to t('checkin.interface.run_setup.button'), administration_checkin_times_path, class: 'btn btn-warning' 
 content_for :js do 
 end 
 javascript_include_tag 'checkin' 
 yield(:js) 
 analytics_js 
 end

end

      elsif @campuses.length == 1
        session[:checkin_campus] = @campuses.first
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @title.present? 
 yield(:meta) 
 stylesheet_link_tag 'application' 
 yield(:css) 
 csrf_meta_tags 
  
 yield(:head) 
 @campuses.each do |campus| 
 link_to campus, { campus: campus }, class: 'btn checkin-btn' 
 end 
 content_for :js do 
 end 
 javascript_include_tag 'checkin' 
 yield(:js) 
 analytics_js 
 end

end

      end
    end
  end

  def feature_enabled?
    unless Setting.get(:features, :checkin)
      render text: 'This feature is unavailable.', layout: true
      false
    end
  end
end

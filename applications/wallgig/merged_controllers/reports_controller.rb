class ReportsController < ApplicationController
  before_action :set_reportable, only: [:new, :create]

  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.all
  end

  # GET /reports/new
  def new
    @report = @reportable.reports.new
    @report.user = current_user
    authorize! :create, @report
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 display_meta_tags site: 'wallgig' 
 stylesheet_link_tag "application", media: "all", "data-turbolinks-track" => true 
 csrf_meta_tags 
 unless content_for?(:hide_navbar) && yield(:hide_navbar) 
 link_to root_path, class: 'navbar-brand' do 
 end 
 link_to 'Collections', collections_path 
 link_to 'Comments', comments_path 
 link_to 'Forums', official_forums_path 
 link_to '#wallgig@irc.rizon.net', irc_url(current_user) 
 if last_deploy_time.present? 
 end 
 if user_signed_in? 
 link_to 'Upload', new_wallpaper_path, class: 'btn btn-primary btn-upload' 
 username_tag current_user 
 link_to current_user do 
 end 
 link_to user_collections_path(current_user) do 
 end 
 link_to user_favourites_path(current_user) do 
 end 
 link_to account_collections_path do 
 end 
 link_to edit_account_profile_path do 
 end 
 link_to edit_account_settings_path do 
 end 
 link_to edit_user_registration_path do 
 end 
 link_to destroy_user_session_path, method: :delete do 
 end 
 else 
 link_to 'Sign Up', new_user_registration_path 
 link_to 'Sign In', new_user_session_path 
 end 
 end 
 yield(:pre_container) 
 if content_for?(:main_container) 
 yield :main_container 
 else 
 
 case @reportable.class.name 
 when 'Comment' 
 link_to_user @reportable.user 
 @reportable.comment 
 else 
 @reportable 
 end 
  simple_form_for([@reportable, @report]) do |f| 
 f.error_notification 
 f.input :description 
 f.button :submit, class: 'btn btn-default' 
 end 
 
 
 end 
 javascript_include_tag "application", "data-turbolinks-track" => true, "data-turbolinks-eval" => false 
 yield :javascript_for_page 
  ENV['SEGMENT_IO_KEY'] 
 if user_signed_in? 
 current_user.id 
 {
  email: current_user.email,
  name: current_user.username
}.to_json.html_safe 
 end 
 
 if user_signed_in? && current_settings.needs_screen_resolution? 
 end 
 flash.each do |type, message| 
 type = :success if type == :notice 
 type = :danger  if type == :alert 
 end 

end

  end

  # POST /reports
  # POST /reports.json
  def create
    @report = @reportable.reports.new(report_params)
    @report.user = current_user
    authorize! :create, @report

    respond_to do |format|
      if @report.save
        format.html { redirect_to root_url, notice: 'Report was successfully created.' }
        format.json { render status: :created }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 display_meta_tags site: 'wallgig' 
 stylesheet_link_tag "application", media: "all", "data-turbolinks-track" => true 
 csrf_meta_tags 
 unless content_for?(:hide_navbar) && yield(:hide_navbar) 
 link_to root_path, class: 'navbar-brand' do 
 end 
 link_to 'Collections', collections_path 
 link_to 'Comments', comments_path 
 link_to 'Forums', official_forums_path 
 link_to '#wallgig@irc.rizon.net', irc_url(current_user) 
 if last_deploy_time.present? 
 end 
 if user_signed_in? 
 link_to 'Upload', new_wallpaper_path, class: 'btn btn-primary btn-upload' 
 username_tag current_user 
 link_to current_user do 
 end 
 link_to user_collections_path(current_user) do 
 end 
 link_to user_favourites_path(current_user) do 
 end 
 link_to account_collections_path do 
 end 
 link_to edit_account_profile_path do 
 end 
 link_to edit_account_settings_path do 
 end 
 link_to edit_user_registration_path do 
 end 
 link_to destroy_user_session_path, method: :delete do 
 end 
 else 
 link_to 'Sign Up', new_user_registration_path 
 link_to 'Sign In', new_user_session_path 
 end 
 end 
 yield(:pre_container) 
 if content_for?(:main_container) 
 yield :main_container 
 else 
 
 case @reportable.class.name 
 when 'Comment' 
 link_to_user @reportable.user 
 @reportable.comment 
 else 
 @reportable 
 end 
  simple_form_for([@reportable, @report]) do |f| 
 f.error_notification 
 f.input :description 
 f.button :submit, class: 'btn btn-default' 
 end 
 
 
 end 
 javascript_include_tag "application", "data-turbolinks-track" => true, "data-turbolinks-eval" => false 
 yield :javascript_for_page 
  ENV['SEGMENT_IO_KEY'] 
 if user_signed_in? 
 current_user.id 
 {
  email: current_user.email,
  name: current_user.username
}.to_json.html_safe 
 end 
 
 if user_signed_in? && current_settings.needs_screen_resolution? 
 end 
 flash.each do |type, message| 
 type = :success if type == :notice 
 type = :danger  if type == :alert 
 end 

end
 }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_reportable
      if params[:wallpaper_id].present?
        @reportable = Wallpaper.find(params[:wallpaper_id])
        authorize! :read, @reportable
      elsif params[:comment_id].present?
        @reportable = Comment.find(params[:comment_id])
        authorize! :read, @reportable
      elsif params[:forum_topic_id].present?
        @reportable = ForumTopic.find(params[:forum_topic_id])
        authorize! :read, @reportable
      end
    end

    def report_params
      params.require(:report).permit(:description)
    end
end

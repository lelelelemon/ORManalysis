class CommentsController < ApplicationController
  before_action :set_parent
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: :create

  # GET /comments
  # GET /parent/1/comments
  # GET /parent/1/comments.json
  def index
    if @parent.present?
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
  
 
 title 'Recent comments' 
 if @comments.any? 
 @comments.each do |comment| 
 case comment.commentable.class.name 
 when 'User' 
 link_to comment.commentable, class: 'pull-left' do 
 image_tag user_avatar_url(comment.commentable, 50), alt: comment.commentable.username, class: 'media-object' 
 end 
 link_to_user comment.commentable 
 when 'Wallpaper' 
 next unless can?(:read, comment.commentable) && comment.commentable.thumbnail_image.present? 
 wallpaper = comment.commentable.decorate 
 link_to wallpaper, title: wallpaper.cached_tag_list, target: '_blank' do 
 image_tag wallpaper.thumbnail_image_url, width: 250, height: 188, class: 'img-wallpaper' 
 end 
 end 
  link_to_user comment.user 
 comment.comment 
 link_to new_comment_report_path(comment) do 
 end 
 
 link_to comment.commentable, class: 'btn btn-default' do 
 end 
 end 
 paginate @comments 
 else 
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

    else
      @comments = Comment.includes(:commentable).latest.page(params[:page])
    end
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
  
 
 title 'Recent comments' 
 if @comments.any? 
 @comments.each do |comment| 
 case comment.commentable.class.name 
 when 'User' 
 link_to comment.commentable, class: 'pull-left' do 
 image_tag user_avatar_url(comment.commentable, 50), alt: comment.commentable.username, class: 'media-object' 
 end 
 link_to_user comment.commentable 
 when 'Wallpaper' 
 next unless can?(:read, comment.commentable) && comment.commentable.thumbnail_image.present? 
 wallpaper = comment.commentable.decorate 
 link_to wallpaper, title: wallpaper.cached_tag_list, target: '_blank' do 
 image_tag wallpaper.thumbnail_image_url, width: 250, height: 188, class: 'img-wallpaper' 
 end 
 end 
  link_to_user comment.user 
 comment.comment 
 link_to new_comment_report_path(comment) do 
 end 
 
 link_to comment.commentable, class: 'btn btn-default' do 
 end 
 end 
 paginate @comments 
 else 
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

  def edit
    authorize! :update, @comment
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
  
 
  simple_form_for([@parent, @comment]) do |f| 
 f.input :comment 
 f.button :submit, class: 'btn btn-primary' 
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

  def update
    authorize! :update, @comment

    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @parent || @comment.commentable, notice: 'Forum topic was successfully updated.' }
        format.json { head :no_content }
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
  
 
  simple_form_for([@parent, @comment]) do |f| 
 f.input :comment 
 f.button :submit, class: 'btn btn-primary' 
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
        format.json { render json: @parent.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /parent/1/comments
  # POST /parent/1/comments.json
  def create
    @comment = @parent.comments.new(comment_params)
    @comment.user = current_user

    authorize! :create, @comment

    # OPTIMIZE
    if @comment.save
      if @parent.is_a?(ForumTopic)
        redirect_to @parent, notice: 'Comment was successfully created.'
      else
        render partial: partial_name, locals: { comment: @comment }
      end
    else
      if request.xhr?
        render json: @comment.errors.full_messages, status: :unprocessable_entity
      else
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
  
 
  simple_form_for([@parent, @comment]) do |f| 
 f.input :comment 
 f.button :submit, class: 'btn btn-primary' 
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
    end
  end

  def destroy
    authorize! :destroy, @comment
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to @comment.commentable, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_parent
    if params[:wallpaper_id].present?
      @parent = Wallpaper.find(params[:wallpaper_id])
      authorize! :read, @parent
    elsif params[:user_id].present?
      @parent = User.find_by(username: params[:user_id])
      authorize! :read, @parent
    elsif params[:forum_topic_id].present?
      @parent = ForumTopic.find(params[:forum_topic_id])
      authorize! :read, @parent
      authorize! :reply, @parent
    end
  end

  def set_comment
    @comment = Comment.find(params[:id])
    authorize! :read, @comment
  end

  def comment_params
    params.require(:comment).permit(:comment)
  end

  def partial_name
    if @parent.is_a?(Wallpaper)
      'wallpaper_comment'
    else
      'comment'
    end
  end
end

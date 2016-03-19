class Api::V1::WallpapersController < Api::V1::BaseController
  before_action :ensure_from_mashape!
  before_action :authenticate_user_from_token!, only: [:create]
  before_action :set_wallpaper, only: [:show]

  def index
    if params[:user_id].present?
      @user = User.find_by(username: params[:user_id])
      authorize! :read, @user
      index_for @user.wallpapers.latest
    else
      index_for Wallpaper.latest
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
 
json.wallpapers do
  json.array! @wallpapers do |wallpaper|
    json.extract! wallpaper, :id
    json.url wallpaper_url(wallpaper)
    json.owner do
      json.extract! wallpaper.user, :id, :username
    end
    json.extract! wallpaper, :purity
    json.image do
      json.thumbnail do
        json.width 250
        json.height 188
        json.url wallpaper.thumbnail_image_url
      end
    end
  end
end

json.pagination do
  json.total_count @wallpapers.total_count
  json.per_page @wallpapers.limit_value
  json.current_page @wallpapers.current_page
  json.total_pages @wallpapers.total_pages
  json.next_url @wallpapers.next_page.present? ? url_for(page: @wallpapers.next_page) : nil
  json.previous_url @wallpapers.prev_page.present? ? url_for(page: @wallpapers.prev_page) : nil
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

  def show
    @wallpaper = @wallpaper.decorate
    respond_with @wallpaper
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
 
json.wallpaper do
  json.extract! @wallpaper, :id
  json.url wallpaper_url(@wallpaper)
  json.owner do
    json.extract! @wallpaper.user, :id, :username
  end
  json.extract! @wallpaper, :purity
  json.image do
    json.file_name @wallpaper.image_name
    json.gravity @wallpaper.image_gravity
    json.original do
      json.width @wallpaper.image_width
      json.height @wallpaper.image_height
      json.url @wallpaper.requested_image_url
    end
    json.thumbnail do
      json.width 250
      json.height 188
      json.url @wallpaper.thumbnail_image_url
    end
  end
  json.tags @wallpaper.tag_list
  json.source @wallpaper.source.presence
  json.extract! @wallpaper, :created_at, :updated_at
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

  def create
    @wallpaper = current_user.wallpapers.new(create_wallpaper_params)
    authorize! :create, @wallpaper

    respond_with @wallpaper do |format|
      if @wallpaper.save
        format.json do
          @wallpaper = @wallpaper.decorate
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
 
json.wallpaper do
  json.extract! @wallpaper, :id
  json.url wallpaper_url(@wallpaper)
  json.owner do
    json.extract! @wallpaper.user, :id, :username
  end
  json.extract! @wallpaper, :purity
  json.image do
    json.file_name @wallpaper.image_name
    json.gravity @wallpaper.image_gravity
    json.original do
      json.width @wallpaper.image_width
      json.height @wallpaper.image_height
      json.url @wallpaper.requested_image_url
    end
    json.thumbnail do
      json.width 250
      json.height 188
      json.url @wallpaper.thumbnail_image_url
    end
  end
  json.tags @wallpaper.tag_list
  json.source @wallpaper.source.presence
  json.extract! @wallpaper, :created_at, :updated_at
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
      else
        format.json { render_json_error(@wallpaper, status: :unprocessable_entity)  }
      end
    end
  end

  private

  def index_for(scope)
    @wallpapers = scope.page(params[:page]).decorate
    respond_with @wallpapers do |format|
      format.json { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 
json.wallpapers do
  json.array! @wallpapers do |wallpaper|
    json.extract! wallpaper, :id
    json.url wallpaper_url(wallpaper)
    json.owner do
      json.extract! wallpaper.user, :id, :username
    end
    json.extract! wallpaper, :purity
    json.image do
      json.thumbnail do
        json.width 250
        json.height 188
        json.url wallpaper.thumbnail_image_url
      end
    end
  end
end

json.pagination do
  json.total_count @wallpapers.total_count
  json.per_page @wallpapers.limit_value
  json.current_page @wallpapers.current_page
  json.total_pages @wallpapers.total_pages
  json.next_url @wallpapers.next_page.present? ? url_for(page: @wallpapers.next_page) : nil
  json.previous_url @wallpapers.prev_page.present? ? url_for(page: @wallpapers.prev_page) : nil
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
    end
  end

  def set_wallpaper
    @wallpaper = Wallpaper.find(params[:id])
    authorize! :read, @wallpaper
  end

  def wallpaper_params
    params.require(:wallpaper).permit(:purity, :image, :image_url, :tag_list, :image_gravity, :source)
  end

  def create_wallpaper_params
    params.permit(:purity, :image, :image_url, :tag_list, :image_gravity, :source)
  end
end

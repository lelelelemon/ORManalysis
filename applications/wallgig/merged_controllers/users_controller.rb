class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :authenticate_user!, only: [:update_screen_resolution]

  impressionist actions: [:show]

  layout 'user_profile'

  # GET /users/1
  # GET /users/1.json
  def show
    wallpapers = @user.wallpapers
                       .accessible_by(current_ability, :read)
                       .latest
                       .limit(6)
    @wallpapers = WallpapersDecorator.new(wallpapers, context: { user: current_user })

    favourite_wallpapers = @user.favourite_wallpapers
                      .accessible_by(current_ability, :read)
                      .latest
                      .limit(10)
    @favourite_wallpapers = WallpapersDecorator.new(favourite_wallpapers, context: { user: current_user })

    # OPTIMIZE
    @collections = @user.collections
                        .includes(:wallpapers)
                        .accessible_by(current_ability, :read)
                        .where({ wallpapers: { purity: 'sfw' }})
                        .where.not({ wallpapers: { id: nil } })
                        .order('collections.updated_at DESC') # FIXME
                        .limit(6)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 myself = user_signed_in? && current_user == @user 
 content_for :pre_container do 
 if can? :update, @user 
 if @user.profile.cover_wallpaper.present? 
 link_to remove_profile_cover_account_profile_path, data: { method: :delete, confirm: 'Are you sure?' } do 
 end 
 else 
 end 
 link_to account_collections_path do 
 end 
 end 
 image_tag user_avatar_url(@user, 100), alt: @user.username, class: 'media-object avatar pull-left', width: 100, height: 100 
 username_tag @user 
 role_name_for @user 
 active_link_to 'Profile', @user, active: [['users'], ['show']], wrap_tag: :li 
 active_link_to 'Wallpapers', wallpapers_path(q: "user:#{@user.username}"), wrap_tag: :li 
 active_link_to 'Collections', user_collections_path(@user), wrap_tag: :li 
 active_link_to 'Favourites', user_favourites_path(@user), wrap_tag: :li 
 end 
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
 
 title @user.username 
 if @collections.any? 
 if @user.collections.size > @collections.size 
 link_to user_collections_path(@user), class: 'btn btn-link pull-right' do 
 end 
 end 
 @collections.size 
  if collections.any? 
 local_assigns[:extra_css_class] 
 collections.each do |collection| 
 next unless can?(:read, collection) 
 # OPTIMIZE 
 wallpapers = collection.wallpapers.accessible_by(current_ability, :read).where.not(thumbnail_image_uid: nil).limit(4) 
 wallpapers = WallpapersDecorator.new(wallpapers, context: { user: current_user }) 
 next if wallpapers.empty? 
 link_to collection, class: 'media-object' do 
 image_tag wallpapers.shift.thumbnail_image_url, width: 250, height: 188 
 wallpapers.each do |wallpaper| 
 image_tag wallpaper.thumbnail_image.thumb('80x80#').url, width: 80, height: 80 
 end 
 (3 - wallpapers.size).times do 
 end 
 end 
 collection.name 
 collection.impressions_count 
 if collection.owner_type == 'User' 
 link_to collection.owner do 
 image_tag user_avatar_url(collection.owner, 20), alt: collection.owner.username 
 username_tag collection.owner 
 end 
 end 
 end 
 if collections.respond_to? :total_pages 
 link_to_next_page collections, 'Next Page', class: 'btn btn-block btn-default btn-lg', params: params 
 end 
 else 
 end 
 
 end 
 if @user.wallpapers.any? 
 if @user.wallpapers.size > @wallpapers.size 
 link_to wallpapers_path(q: "user:#{@user.username}"), class: 'btn btn-link pull-right' do 
 end 
 end 
 @user.wallpapers.size 
  if wallpapers.any? 
 local_assigns[:extra_css_class] 
 wallpapers.each do |wallpaper| 
 next unless can?(:read, wallpaper) && wallpaper.thumbnail_image.present? 
 link_to wallpaper.path_with_resolution, title: wallpaper.cached_tag_list, target: '_blank' do 
 image_tag nil, width: 250, height: 188, class: 'img-wallpaper lazy', data: { src: wallpaper.thumbnail_image_url } 
 end 
 link_to new_wallpaper_report_path(wallpaper), class: 'btn btn-sm btn-report', data: { action: 'report' } do 
 end 
 wallpaper.resolution 
 wallpaper.favourite_button 
 wallpaper.impressions_count 
 end 
 wallpapers.link_to_next_page 
 else 
 end 
 
 end 
 if @favourite_wallpapers.any? 
 if @user.favourite_wallpapers.size > @favourite_wallpapers.size 
 link_to user_favourites_path(@user), class: 'btn btn-link pull-right' do 
 end 
 end 
 @user.favourite_wallpapers.size 
  if wallpapers.any? 
 local_assigns[:extra_css_class] 
 wallpapers.each do |wallpaper| 
 next unless can?(:read, wallpaper) && wallpaper.thumbnail_image.present? 
 link_to wallpaper.path_with_resolution, title: wallpaper.cached_tag_list, target: '_blank' do 
 image_tag nil, width: 250, height: 188, class: 'img-wallpaper lazy', data: { src: wallpaper.thumbnail_image_url } 
 end 
 link_to new_wallpaper_report_path(wallpaper), class: 'btn btn-sm btn-report', data: { action: 'report' } do 
 end 
 wallpaper.resolution 
 wallpaper.favourite_button 
 wallpaper.impressions_count 
 end 
 wallpapers.link_to_next_page 
 else 
 end 
 
 end 
 @user.comments.size 
 simple_form_for :comment, url: user_comments_path(@user), remote: true, data: { provide: 'comments' } do |f| 
 f.input :comment, as: :text, label: false 
 f.submit 'Post', class: 'btn btn-block', data: { disable_with: 'Posting' } 
 end 
 comments = @user.comments.includes(:user).recent 
 ('hide' if comments.empty?) 
 render comments.limit(4) 
 if comments.size > 4 
 link_to 'Load all comments', user_comments_path(@user), class: 'btn btn-block', remote: true, data: { action: 'load-comments' } 
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

  def update_screen_resolution
    width  = params.require(:width)
    height = params.require(:height)
    current_settings.update(screen_width: width, screen_height: height)

    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  private

  def set_user
    @user = User.find_by!(username: params[:id])
    authorize! :read, @user
  end
end

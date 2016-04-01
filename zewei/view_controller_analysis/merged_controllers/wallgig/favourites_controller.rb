class FavouritesController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_owner

  layout false, except: [:index]

  def index
    @wallpapers = set_owner.favourite_wallpapers
                           .accessible_by(current_ability, :read)
                           .page(params[:page])
    @wallpapers = WallpapersDecorator.new(@wallpapers, context: { user: current_user })

    if request.xhr?
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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

    else
      render layout: 'user_profile'
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
  
 
 title [@user.username, 'Favourites'], 'Favourites' 
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

  private

  def set_owner
    if params[:user_id].present?
      @owner = @user = User.find_by!(username: params[:user_id])
      authorize! :read, @owner
    end
  end
end

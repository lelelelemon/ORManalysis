module Account
  class ProfilesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_profile

    def edit
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
 
 simple_form_for @profile, url: account_profile_path, method: :patch do |f| 
 f.error_notification 
 f.input :avatar, as: :file 
 if can? :update_title_and_color, @profile 
 f.input :title 
 f.input :username_color_hex, placeholder: 'e.g. 000000' 
 end 
 f.button :submit, 'Update profile', class: 'btn btn-primary' 
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
      update_params = profile_params
      update_params.merge!(title_and_color_params) if can? :update_title_and_color, @profile

      respond_to do |format|
        if @profile.update(update_params)
          format.html { redirect_to edit_account_profile_url, notice: 'Profile was successfully updated.' }
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
 
 simple_form_for @profile, url: account_profile_path, method: :patch do |f| 
 f.error_notification 
 f.input :avatar, as: :file 
 if can? :update_title_and_color, @profile 
 f.input :title 
 f.input :username_color_hex, placeholder: 'e.g. 000000' 
 end 
 f.button :submit, 'Update profile', class: 'btn btn-primary' 
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
          format.json { render json: @profile.errors, status: :unprocessable_entity }
        end
      end
    end

    def remove_profile_cover
      @profile.cover_wallpaper = nil
      @profile.save

      respond_to do |format|
        format.html { redirect_to current_user, notice: 'Profile cover successfully removed.' }
        format.json { head :no_content }
      end
    end

    private

    def set_profile
      @profile = current_profile
    end

    def profile_params
      params.require(:user_profile).permit(:avatar)
    end

    def title_and_color_params
      params.require(:user_profile).permit(:title, :username_color_hex)
    end
  end
end
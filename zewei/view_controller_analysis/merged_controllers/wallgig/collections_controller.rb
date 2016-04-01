class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show]
  before_action :set_user, if: -> { params[:user_id].present? } # TODO deprecate
  before_action :set_parent
  layout :resolve_layout
  impressionist actions: [:show]

  # GET /collections
  def index
    if @user.present?
      # Viewing user's collections. They are ordered.
      relation = @user.collections.ordered
    else
      relation = Collection.where({ wallpapers: { purity: 'sfw' }})
                           .where.not({ wallpapers: { id: nil } })
    end

    @collections = relation.includes(:wallpapers)
                           .accessible_by(current_ability, :read)
                           .order('collections.updated_at desc')
                           .page(params[:page])

    if request.xhr?
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
  
 
 if @user.present? 
 title [@user.username, 'Collections'], 'Collections' 
 @collections.size 
 else 
 title 'Recent collections' 
 end 
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

  # GET /collections/1
  def show
    wallpapers = @collection.wallpapers
                            .accessible_by(current_ability, :read)
                            .latest
                            .page(params[:page])
    @wallpapers = WallpapersDecorator.new(wallpapers, context: { user: current_user })

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
  
 
 if @collection.owner_type == 'User' 
 title [@collection.owner.username, @collection.name], @collection.name 
 link_to @collection.owner, class: 'pull-left' do 
 image_tag user_avatar_url(@collection.owner, 20), alt: @collection.owner.username, class: 'media-object' 
 end 
 link_to_user @collection.owner 
 end 
 if can? :update, @collection 
 link_to 'Edit collection', edit_account_collection_path(@collection) 
 end 
 pluralize @collection.wallpapers.size, 'wallpaper' 
 pluralize @collection.impressions_count, 'view' 
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

  # TODO deprecate
  def set_user
    @user = User.find_by(username: params[:user_id])
    authorize! :read, @user
  end

  def set_parent
    if params[:user_id].present?
      @parent = User.find_by!(username: params[:user_id])
    elsif params[:group_id].present?
      @parent = @group = Group.friendly.find(params[:group_id])
    end
    authorize! :read, @parent if @parent.present?
  end

  def set_collection
    @collection = Collection.find(params[:id])
    authorize! :read, @collection
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def collection_params
    params.require(:collection).permit(:name, :public)
  end

  def resolve_layout
    if @parent.is_a?(User) || @user.present? # TODO deprecate
      'user_profile'
    elsif @parent.is_a?(Group)
      'group'
    else
      'application'
    end
  end

end

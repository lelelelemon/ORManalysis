class ForumTopicsController < ApplicationController
  MODERATION_ACTIONS = [:pin, :unpin, :lock, :unlock, :hide, :unhide]

  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy].append(MODERATION_ACTIONS)
  before_action :set_and_authorize_parents_and_forum_topic_from_shallow!, except: [:index, :new, :create]
  before_action :set_and_authorize_parents_and_maybe_forum_topic!, only: [:index, :new, :create]

  before_action :ensure_can_moderate!, only: MODERATION_ACTIONS

  layout 'group'

  # GET /forum_topics
  # GET /forum_topics.json
  def index
    @forum_topics = @forum.topics.accessible_by(current_ability, :read).pinned_first
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :pre_container do 
 if can? :join, @group 
 link_to join_group_path(@group), method: :post, class: 'btn btn-lg btn-primary' do 
 end 
 end 
 if can? :leave, @group 
 link_to leave_group_path(@group), class: 'btn btn-lg btn-danger', data: { method: :delete, confirm: 'Are you sure?' } do 
 end 
 end 
 if can? :crud, @group 
 link_to edit_group_path(@group) do 
 end 
 link_to apps_group_path(@group) do 
 end 
 end 
 if true 
 image_tag 'http://placekitten.com/g/100/100', alt: @group.name, class: 'media-object avatar pull-left', width: 100, height: 100 
 end 
 @group.name 
 @group.tagline if @group.tagline.present? 
 active_link_to 'Overview', @group, active: [['groups'], ['show']], wrap_tag: :li 
 if @group.has_forums 
 active_link_to 'Forums', group_forums_path(@group), active: [['forums', 'forum_topics']], wrap_tag: :li 
 end 
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
 
 @forum_topics.each do |forum_topic| 
 forum_topic.forum 
 forum_topic.user 
 forum_topic.title 
 forum_topic.content 
 forum_topic.cooked_content 
 forum_topic.pinned 
 forum_topic.locked 
 forum_topic.hidden 
 link_to 'Show', forum_topic 
 link_to 'Edit', edit_forum_topic_path(forum_topic) 
 link_to 'Destroy', forum_topic, :method => :delete, :data => { :confirm => 'Are you sure?' } 
 end 
 link_to 'New Forum topic', new_forum_topic_path 
 
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

  # GET /forum_topics/1
  # GET /forum_topics/1.json
  def show
    @comments = @forum_topic.comments.page
    @comments = @comments.page(params[:page] || @comments.total_pages)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :pre_container do 
 if can? :join, @group 
 link_to join_group_path(@group), method: :post, class: 'btn btn-lg btn-primary' do 
 end 
 end 
 if can? :leave, @group 
 link_to leave_group_path(@group), class: 'btn btn-lg btn-danger', data: { method: :delete, confirm: 'Are you sure?' } do 
 end 
 end 
 if can? :crud, @group 
 link_to edit_group_path(@group) do 
 end 
 link_to apps_group_path(@group) do 
 end 
 end 
 if true 
 image_tag 'http://placekitten.com/g/100/100', alt: @group.name, class: 'media-object avatar pull-left', width: 100, height: 100 
 end 
 @group.name 
 @group.tagline if @group.tagline.present? 
 active_link_to 'Overview', @group, active: [['groups'], ['show']], wrap_tag: :li 
 if @group.has_forums 
 active_link_to 'Forums', group_forums_path(@group), active: [['forums', 'forum_topics']], wrap_tag: :li 
 end 
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

  # GET /forum_topics/new
  def new
    @forum_topic = @forum.topics.new
    @forum_topic.user = current_user
    authorize! :create, @forum_topic
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :pre_container do 
 if can? :join, @group 
 link_to join_group_path(@group), method: :post, class: 'btn btn-lg btn-primary' do 
 end 
 end 
 if can? :leave, @group 
 link_to leave_group_path(@group), class: 'btn btn-lg btn-danger', data: { method: :delete, confirm: 'Are you sure?' } do 
 end 
 end 
 if can? :crud, @group 
 link_to edit_group_path(@group) do 
 end 
 link_to apps_group_path(@group) do 
 end 
 end 
 if true 
 image_tag 'http://placekitten.com/g/100/100', alt: @group.name, class: 'media-object avatar pull-left', width: 100, height: 100 
 end 
 @group.name 
 @group.tagline if @group.tagline.present? 
 active_link_to 'Overview', @group, active: [['groups'], ['show']], wrap_tag: :li 
 if @group.has_forums 
 active_link_to 'Forums', group_forums_path(@group), active: [['forums', 'forum_topics']], wrap_tag: :li 
 end 
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
 
  simple_form_for(@forum_topic, url: form_url) do |f| 
 f.input :title 
 f.input :content 
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

  # GET /forum_topics/1/edit
  def edit
    authorize! :update, @forum_topic
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :pre_container do 
 if can? :join, @group 
 link_to join_group_path(@group), method: :post, class: 'btn btn-lg btn-primary' do 
 end 
 end 
 if can? :leave, @group 
 link_to leave_group_path(@group), class: 'btn btn-lg btn-danger', data: { method: :delete, confirm: 'Are you sure?' } do 
 end 
 end 
 if can? :crud, @group 
 link_to edit_group_path(@group) do 
 end 
 link_to apps_group_path(@group) do 
 end 
 end 
 if true 
 image_tag 'http://placekitten.com/g/100/100', alt: @group.name, class: 'media-object avatar pull-left', width: 100, height: 100 
 end 
 @group.name 
 @group.tagline if @group.tagline.present? 
 active_link_to 'Overview', @group, active: [['groups'], ['show']], wrap_tag: :li 
 if @group.has_forums 
 active_link_to 'Forums', group_forums_path(@group), active: [['forums', 'forum_topics']], wrap_tag: :li 
 end 
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
 
  simple_form_for(@forum_topic, url: form_url) do |f| 
 f.input :title 
 f.input :content 
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

  # POST /forum_topics
  # POST /forum_topics.json
  def create
    @forum_topic = @forum.topics.new(forum_topic_params)
    @forum_topic.user = current_user
    authorize! :create, @forum_topic

    respond_to do |format|
      if @forum_topic.save
        format.html { redirect_to @forum_topic, notice: 'Forum topic was successfully created.' }
        format.json { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :pre_container do 
 if can? :join, @group 
 link_to join_group_path(@group), method: :post, class: 'btn btn-lg btn-primary' do 
 end 
 end 
 if can? :leave, @group 
 link_to leave_group_path(@group), class: 'btn btn-lg btn-danger', data: { method: :delete, confirm: 'Are you sure?' } do 
 end 
 end 
 if can? :crud, @group 
 link_to edit_group_path(@group) do 
 end 
 link_to apps_group_path(@group) do 
 end 
 end 
 if true 
 image_tag 'http://placekitten.com/g/100/100', alt: @group.name, class: 'media-object avatar pull-left', width: 100, height: 100 
 end 
 @group.name 
 @group.tagline if @group.tagline.present? 
 active_link_to 'Overview', @group, active: [['groups'], ['show']], wrap_tag: :li 
 if @group.has_forums 
 active_link_to 'Forums', group_forums_path(@group), active: [['forums', 'forum_topics']], wrap_tag: :li 
 end 
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
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :pre_container do 
 if can? :join, @group 
 link_to join_group_path(@group), method: :post, class: 'btn btn-lg btn-primary' do 
 end 
 end 
 if can? :leave, @group 
 link_to leave_group_path(@group), class: 'btn btn-lg btn-danger', data: { method: :delete, confirm: 'Are you sure?' } do 
 end 
 end 
 if can? :crud, @group 
 link_to edit_group_path(@group) do 
 end 
 link_to apps_group_path(@group) do 
 end 
 end 
 if true 
 image_tag 'http://placekitten.com/g/100/100', alt: @group.name, class: 'media-object avatar pull-left', width: 100, height: 100 
 end 
 @group.name 
 @group.tagline if @group.tagline.present? 
 active_link_to 'Overview', @group, active: [['groups'], ['show']], wrap_tag: :li 
 if @group.has_forums 
 active_link_to 'Forums', group_forums_path(@group), active: [['forums', 'forum_topics']], wrap_tag: :li 
 end 
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
 
  simple_form_for(@forum_topic, url: form_url) do |f| 
 f.input :title 
 f.input :content 
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
        format.json { render json: @forum_topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /forum_topics/1
  # PATCH/PUT /forum_topics/1.json
  def update
    authorize! :update, @forum_topic

    respond_to do |format|
      if @forum_topic.update(forum_topic_params)
        format.html { redirect_to @forum_topic, notice: 'Forum topic was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :pre_container do 
 if can? :join, @group 
 link_to join_group_path(@group), method: :post, class: 'btn btn-lg btn-primary' do 
 end 
 end 
 if can? :leave, @group 
 link_to leave_group_path(@group), class: 'btn btn-lg btn-danger', data: { method: :delete, confirm: 'Are you sure?' } do 
 end 
 end 
 if can? :crud, @group 
 link_to edit_group_path(@group) do 
 end 
 link_to apps_group_path(@group) do 
 end 
 end 
 if true 
 image_tag 'http://placekitten.com/g/100/100', alt: @group.name, class: 'media-object avatar pull-left', width: 100, height: 100 
 end 
 @group.name 
 @group.tagline if @group.tagline.present? 
 active_link_to 'Overview', @group, active: [['groups'], ['show']], wrap_tag: :li 
 if @group.has_forums 
 active_link_to 'Forums', group_forums_path(@group), active: [['forums', 'forum_topics']], wrap_tag: :li 
 end 
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
 
  simple_form_for(@forum_topic, url: form_url) do |f| 
 f.input :title 
 f.input :content 
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
        format.json { render json: @forum_topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forum_topics/1
  # DELETE /forum_topics/1.json
  def destroy
    authorize! :destroy, @forum_topic

    @forum_topic.destroy
    respond_to do |format|
      format.html { redirect_to [@group, forum] }
      format.json { head :no_content }
    end
  end

  MODERATION_ACTIONS.each do |action|
    define_method action do
      @forum_topic.send("#{action.to_s}!")

      respond_to do |format|
        format.html { redirect_to @forum_topic, notice: "#{action.to_s.capitalize} action performed on topic." }
        format.json { head :no_content }
      end
    end
  end

  private

  def set_and_authorize_parents_and_forum_topic_from_shallow!
    @forum_topic = ForumTopic.find(params[:id])
    authorize! :read, @forum_topic

    @forum = @forum_topic.forum
    authorize! :read, @forum

    @group = @forum.group
    authorize! :read, @group
  end

  def set_and_authorize_parents_and_maybe_forum_topic!
    @group = Group.friendly.find(params[:group_id])
    authorize! :read, @group

    @forum = @group.forums.friendly.find(params[:forum_id])
    authorize! :read, @forum

    if params[:id].present?
      @forum_topic = @forum.topics.find(params[:id])
      authorize! :read, @forum_topic
    end
  end

  def forum_topic_params
    params.require(:forum_topic).permit(:title, :content)
  end

  def forum_topic_moderation_params
    params.require(:forum_topic).permit(:pinned, :locked, :hidden)
  end

  def ensure_can_moderate!
    authorize! :moderate, @forum_topic
  end
end

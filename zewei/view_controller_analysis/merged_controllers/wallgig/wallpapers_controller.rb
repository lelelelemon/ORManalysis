class WallpapersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :set_profile_cover, :toggle_favourite, :collections, :toggle_collect]
  before_action :set_wallpaper, only: [:show, :edit, :update, :destroy, :update_purity, :history, :set_profile_cover, :toggle_favourite, :collections, :toggle_collect]
  before_action :set_available_categories, only: [:new, :edit, :create, :update]

  impressionist actions: [:show]

  helper_method :search_params

  layout 'fullscreen_wallpaper', only: :show

  # GET /wallpapers
  # GET /wallpapers.json
  def index
    search_options = search_params
    search_options[:per_page] = current_settings.per_page

    if search_options[:order] == 'random'
      search_options[:random_seed] = session[:random_seed]
      search_options[:random_seed] = nil if search_options[:page].to_i <= 1
      search_options[:random_seed] ||= Time.now.to_i
      session[:random_seed] = search_options[:random_seed]
    end


    @wallpapers = WallpaperSearch.new(search_options).wallpapers
    @wallpapers = WallpapersDecorator.new(@wallpapers, context: {
      user: current_user,
      search_options: search_options
    })

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
  
 
 content_for :use_full_container, true 
 blank_value = lambda { |_,v| v.blank? } 
 content_for :tags do 
 if @wallpapers.facets.any? 
 # OPTIMIZE 
 terms_to_count = Hash[@wallpapers.facets['tags']['terms'].map { |t| [t['term'], t['count']] }] 
 tags = search_params[:tags] || [] 
 exclude_tags = search_params[:exclude_tags] || [] 
 rendered_terms = [] 
 [tags, exclude_tags, @wallpapers.facets['tags']['terms']].flatten.each do |facet_or_term| 
 term = facet_or_term.try(:[], 'term') || facet_or_term 
 next if rendered_terms.include? term 
 rendered_terms << term 
 if search_params[:exclude_tags].try(:include?, term) 
 link_to wallpapers_path(search_params.merge(exclude_tags: (exclude_tags - [term]), tags: (tags - [term])).reject(&blank_value)), class: 'btn btn-sm btn-danger' do 
 end 
 else 
 link_to wallpapers_path(search_params.merge(exclude_tags: (exclude_tags + [term]), tags: (tags - [term])).reject(&blank_value)), class: 'btn btn-sm btn-default' do 
 end 
 end 
 if search_params[:tags].try(:include?, term) 
 link_to wallpapers_path(search_params.merge(tags: (tags - [term]), exclude_tags: (exclude_tags - [term])).reject(&blank_value)), class: 'btn btn-sm btn-success' do 
 term 
 terms_to_count[term] 
 end 
 else 
 link_to wallpapers_path(search_params.merge(tags: (tags + [term]), exclude_tags: (exclude_tags - [term])).reject(&blank_value)), class: 'btn btn-sm btn-link' do 
 term 
 terms_to_count[term] 
 end 
 end 
 end 
 end 
 end 
 content_for :purity do 
 {'sfw' => 'SFW', 'sketchy' => 'Sketchy', 'nsfw' => 'NSFW'}.each do |value, label| 
 active = (search_params[:purity].blank? && value == 'sfw') || search_params[:purity].include?(value) 
 if active 
 link_to label, wallpapers_path(search_params.merge(purity: (search_params[:purity] - [value])).reject(&blank_value)),                    class: "btn btn-sm btn-block btn- btn-active" 
 else 
 link_to label, wallpapers_path(search_params.merge(purity: (search_params[:purity] + [value])).reject(&blank_value)),                    class: "btn btn-sm btn-block btn-" 
 end 
 end 
 end 
 content_for :colors do 
 colors = search_params[:colors] || [] 
 Colorscore::Palette::DEFAULT.each do |hex| 
 if colors.include?(hex) 
 link_to '', wallpapers_path(search_params.merge(colors: (colors - [hex])).reject(&blank_value)), style: "background-color: \#" 
 else 
 link_to '', wallpapers_path(search_params.merge(colors: (colors + [hex])).reject(&blank_value)), style: "background-color: \#" 
 end 
 end 
 end 
 content_for :screen_resolutions do 
 last_screen_resolution_category = nil 
 ScreenResolution.all.each do |screen_resolution| 
 if last_screen_resolution_category != screen_resolution.category 
 last_screen_resolution_category = screen_resolution.category 
 screen_resolution.category_text 
 end 
 active = [screen_resolution.width.to_s, screen_resolution.height.to_s] == [search_params[:width], search_params[:height]] 
 css_class = active ? 'success' : 'link' 
 if active 
 link_to wallpapers_path(search_params.merge(width: nil, height: nil).reject(&blank_value)), class: "btn btn-xs btn-" do 
 screen_resolution 
 end 
 else 
 link_to wallpapers_path(search_params.merge(width: screen_resolution.width, height: screen_resolution.height).reject(&blank_value)), class: "btn btn-xs btn-" do 
 screen_resolution 
 end 
 end 
 end 
 end 
 content_for :sort_by do 
 {'latest' => 'Latest', 'popular' => 'Popular', 'random' => 'Random'}.each do |value, label| 
 if search_params[:order] == value 
 link_to wallpapers_path(search_params.merge(order: nil).reject(&blank_value)), class: "btn btn-sm btn-block btn-primary" do 
 label 
 end 
 else 
 link_to wallpapers_path(search_params.merge(order: value).reject(&blank_value)), class: "btn btn-sm btn-block" do 
 label 
 end 
 end 
 end 
 end 
 content_for :query_string do 
 form_tag wallpapers_path, method: :get do 
 search_params.reject(&blank_value).each do |k, v| 
 hidden_field_tag k, v 
 end 
 text_field_tag :q, search_params[:q], class: 'form-control input-md', placeholder: 'e.g. width:>1920 height:>1080' 
 submit_tag 'Search', class: 'btn btn-default btn-md' 
 end 
 link_to 'Save settings', save_search_params_wallpapers_path, class: 'btn btn-md btn-info', data: { action: 'save_settings', method: :post, remote: true, type: :json, params: search_params, disable_with: 'Saving&hellip;' } 
 link_to 'Clear settings', save_search_params_wallpapers_path, data: { action: 'save_settings', method: :post, remote: true, type: :json, disable_with: 'Clearing&hellip;' } 
 end 
 yield :tags 
 yield :sort_by 
 yield :purity 
 yield :colors 
 yield :screen_resolutions 
 yield :query_string 
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

  # GET /wallpapers/1
  # GET /wallpapers/1.json
  def show
    if resize_params.present?
      requested_resolution = ScreenResolution.find_by(width: resize_params[:width], height: resize_params[:height])
      redirect_to short_wallpaper_path(@wallpaper) unless @wallpaper.resize_image_to(requested_resolution)
    end

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
  
 
 title ["\#", @wallpaper.cached_tag_list].reject &:blank? 
 description @wallpaper.cached_tag_list 
 keywords @wallpaper.cached_tag_list 
 content_for :wallpaper_sidebar_content do 
 if @wallpaper.user.present? 
 link_to @wallpaper.user, class: 'pull-left' do 
 image_tag user_avatar_url(@wallpaper.user, 30), alt: @wallpaper.user.username, class: 'media-object' 
 end 
 link_to_user @wallpaper.user 
 end 
 time_tag @wallpaper.created_at, @wallpaper.created_at.to_date.to_formatted_s(:long), title: @wallpaper.created_at 
 @wallpaper.impressions_count 
 @wallpaper.likes.size 
 @wallpaper.resolution 
 @wallpaper.purity_text 
 if @wallpaper.source.present? 
 @wallpaper.cooked_source 
 end 
 if user_signed_in? 
 if user_signed_in? && current_user.voted_for?(@wallpaper.object) 
 link_to toggle_favourite_wallpaper_path(@wallpaper), class: 'btn btn-favourite favourited', data: { method: :post, remote: true } do 
 end 
 else 
 link_to toggle_favourite_wallpaper_path(@wallpaper), class: 'btn btn-favourite', data: { method: :post, remote: true } do 
 end 
 end 
 link_to collections_wallpaper_path(@wallpaper), class: 'btn btn-collect', data: { remote: true } do 
 end 
 link_to '#', class: 'btn btn-default dropdown-toggle', data: { toggle: 'dropdown' } do 
 end 
 if user_signed_in? 
 if @wallpaper.sfw? 
 link_to set_profile_cover_wallpaper_path(@wallpaper), data: { method: :post, confirm: 'Are you sure?' } do 
 end 
 end 
 if can? :update, @wallpaper 
 link_to edit_wallpaper_path(@wallpaper) do 
 end 
 end 
 if can? :update, @wallpaper 
 link_to history_wallpaper_path(@wallpaper) do 
 end 
 end 
 if can? :destroy, @wallpaper 
 link_to @wallpaper, data: { method: :delete, confirm: 'Are you sure?' } do 
 end 
 end 
 link_to new_wallpaper_report_path(@wallpaper) do 
 end 
 if current_user.admin? 
 link_to admin_wallpaper_path(@wallpaper) do 
 end 
 end 
 end 
 end 
 if false 
 cache ['show', @wallpaper, 'color_list'] do 
 if @wallpaper.wallpaper_colors.any? 
 @wallpaper.wallpaper_colors.includes(:color).each do |color| 
 link_to '', wallpapers_path(search_params.merge(colors: [color.hex])), style: "background-color: \#" 
 end 
 end 
 end 
 end 
 if false 
 @wallpaper.resolution_select_tag 
 end 
 if false 
 Wallpaper.purity.options.each_entry do |label, value| 
 link_to label, update_purity_wallpaper_path(@wallpaper, value),                      class: "btn btn-sm ladda-button btn-#{value} #{'btn-active' if @wallpaper.purity == value} #{'disabled' if @wallpaper.purity_locked?}",                      data: { :method => :patch,                              :remote => true,                              :type => 'json',                              :style => 'zoom-in',                              :'action' => 'change-purity',                              :'wallpaper-id' => @wallpaper.id,                              :purity => value } 
 end 
 end 
 if user_signed_in? 
 simple_form_for :comment, url: wallpaper_comments_path(@wallpaper), remote: true, data: { provide: 'comments' } do |f| 
 image_tag user_avatar_url(current_user, 30), alt: current_user.username, class: 'media-object' 
 f.input :comment, as: :text, label: false, placeholder: 'Your comment', input_html: {} 
 end 
 comments = @wallpaper.comments.includes(:user).recent 
 ('hide' if comments.empty?) 
  link_to comment.user do 
 image_tag user_avatar_url(comment.user, 30), alt: comment.user.username, class: 'media-object' 
 end 
 time_tag comment.created_at, title: comment.created_at, class: 'pull-right' do 
 time_ago_in_words(comment.created_at) 
 end 
 link_to_user comment.user 
 if user_signed_in? 
 if can? :destroy, comment 
 link_to comment, class: 'destroy-comment', data: { method: :delete, confirm: 'Are you sure?' } do 
 end 
 end 
 if current_user != comment.user 
 link_to reply_comment_path(comment), class: 'reply-comment' do 
 end 
 end 
 end 
 comment.cooked_comment 
 
 if comments.size > 4 
 link_to 'Load all comments', wallpaper_comments_path(@wallpaper), class: 'btn btn-block', remote: true, data: { action: 'load-comments' } 
 end 
 end 
 if @wallpaper.tag_list.any? 
 @wallpaper.tag_list.each do |tag| 
 link_to wallpapers_path(tags: [tag]), class: 'label label-default' do 
 tag 
 end 
 end 
 end 
 end 
 content_for :wallpaper_stage_content do 
 image_tag @wallpaper.requested_image_url, width: @wallpaper.requested_image_width, height: @wallpaper.requested_image_height, class: "img-wallpaper img- state-1" 
 end 
 # OPTIMIZE 
  
 
 end 
 javascript_include_tag "application", "data-turbolinks-track" => true, "data-turbolinks-eval" => false 
  
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

  # GET /wallpapers/new
  def new
    @wallpaper = current_user.wallpapers.new
    authorize! :create, @wallpaper
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
  
 
 title 'New wallpaper' 
  simple_form_for(@wallpaper) do |f| 
 f.error_notification 
 f.input :purity unless @wallpaper.purity_locked? 
 f.input :image, as: :file unless @wallpaper.persisted? 
 f.input :category_id, collection: @available_categories, label_method: :name_for_selects, value_method: :id, include_blank: true, hint: 'Try to set the deepest possible category' 
 f.label :tag_list, label: 'Tags' 
 f.text_field :tag_list, class: 'form-control', autocomplete: 'off', data: { provide: 'tag_editor', search_path: api_v1_tags_path } 
 f.input :source, hint: 'Enter URL or Artist' 
 f.input :image_gravity, label: 'Crop position' 
 f.button :submit, class: 'btn btn-primary btn-lg' 
 end 
 
 link_to 'Cancel', wallpapers_path, class: 'btn btn-link' 
 
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

  # GET /wallpapers/1/edit
  def edit
    authorize! :update, @wallpaper
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
  
 
  simple_form_for(@wallpaper) do |f| 
 f.error_notification 
 f.input :purity unless @wallpaper.purity_locked? 
 f.input :image, as: :file unless @wallpaper.persisted? 
 f.input :category_id, collection: @available_categories, label_method: :name_for_selects, value_method: :id, include_blank: true, hint: 'Try to set the deepest possible category' 
 f.label :tag_list, label: 'Tags' 
 f.text_field :tag_list, class: 'form-control', autocomplete: 'off', data: { provide: 'tag_editor', search_path: api_v1_tags_path } 
 f.input :source, hint: 'Enter URL or Artist' 
 f.input :image_gravity, label: 'Crop position' 
 f.button :submit, class: 'btn btn-primary btn-lg' 
 end 
 
 link_to 'Cancel', @wallpaper, class: 'btn btn-link' 
 
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

  # POST /wallpapers
  # POST /wallpapers.json
  def create
    @wallpaper = current_user.wallpapers.new(wallpaper_params)
    authorize! :create, @wallpaper

    respond_to do |format|
      if @wallpaper.save
        format.html { redirect_to @wallpaper, notice: 'Wallpaper was successfully created.' }
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
  
 
 title ["\#", @wallpaper.cached_tag_list].reject &:blank? 
 description @wallpaper.cached_tag_list 
 keywords @wallpaper.cached_tag_list 
 content_for :wallpaper_sidebar_content do 
 if @wallpaper.user.present? 
 link_to @wallpaper.user, class: 'pull-left' do 
 image_tag user_avatar_url(@wallpaper.user, 30), alt: @wallpaper.user.username, class: 'media-object' 
 end 
 link_to_user @wallpaper.user 
 end 
 time_tag @wallpaper.created_at, @wallpaper.created_at.to_date.to_formatted_s(:long), title: @wallpaper.created_at 
 @wallpaper.impressions_count 
 @wallpaper.likes.size 
 @wallpaper.resolution 
 @wallpaper.purity_text 
 if @wallpaper.source.present? 
 @wallpaper.cooked_source 
 end 
 if user_signed_in? 
 if user_signed_in? && current_user.voted_for?(@wallpaper.object) 
 link_to toggle_favourite_wallpaper_path(@wallpaper), class: 'btn btn-favourite favourited', data: { method: :post, remote: true } do 
 end 
 else 
 link_to toggle_favourite_wallpaper_path(@wallpaper), class: 'btn btn-favourite', data: { method: :post, remote: true } do 
 end 
 end 
 link_to collections_wallpaper_path(@wallpaper), class: 'btn btn-collect', data: { remote: true } do 
 end 
 link_to '#', class: 'btn btn-default dropdown-toggle', data: { toggle: 'dropdown' } do 
 end 
 if user_signed_in? 
 if @wallpaper.sfw? 
 link_to set_profile_cover_wallpaper_path(@wallpaper), data: { method: :post, confirm: 'Are you sure?' } do 
 end 
 end 
 if can? :update, @wallpaper 
 link_to edit_wallpaper_path(@wallpaper) do 
 end 
 end 
 if can? :update, @wallpaper 
 link_to history_wallpaper_path(@wallpaper) do 
 end 
 end 
 if can? :destroy, @wallpaper 
 link_to @wallpaper, data: { method: :delete, confirm: 'Are you sure?' } do 
 end 
 end 
 link_to new_wallpaper_report_path(@wallpaper) do 
 end 
 if current_user.admin? 
 link_to admin_wallpaper_path(@wallpaper) do 
 end 
 end 
 end 
 end 
 if false 
 cache ['show', @wallpaper, 'color_list'] do 
 if @wallpaper.wallpaper_colors.any? 
 @wallpaper.wallpaper_colors.includes(:color).each do |color| 
 link_to '', wallpapers_path(search_params.merge(colors: [color.hex])), style: "background-color: \#" 
 end 
 end 
 end 
 end 
 if false 
 @wallpaper.resolution_select_tag 
 end 
 if false 
 Wallpaper.purity.options.each_entry do |label, value| 
 link_to label, update_purity_wallpaper_path(@wallpaper, value),                      class: "btn btn-sm ladda-button btn-#{value} #{'btn-active' if @wallpaper.purity == value} #{'disabled' if @wallpaper.purity_locked?}",                      data: { :method => :patch,                              :remote => true,                              :type => 'json',                              :style => 'zoom-in',                              :'action' => 'change-purity',                              :'wallpaper-id' => @wallpaper.id,                              :purity => value } 
 end 
 end 
 if user_signed_in? 
 simple_form_for :comment, url: wallpaper_comments_path(@wallpaper), remote: true, data: { provide: 'comments' } do |f| 
 image_tag user_avatar_url(current_user, 30), alt: current_user.username, class: 'media-object' 
 f.input :comment, as: :text, label: false, placeholder: 'Your comment', input_html: {} 
 end 
 comments = @wallpaper.comments.includes(:user).recent 
 ('hide' if comments.empty?) 
  link_to comment.user do 
 image_tag user_avatar_url(comment.user, 30), alt: comment.user.username, class: 'media-object' 
 end 
 time_tag comment.created_at, title: comment.created_at, class: 'pull-right' do 
 time_ago_in_words(comment.created_at) 
 end 
 link_to_user comment.user 
 if user_signed_in? 
 if can? :destroy, comment 
 link_to comment, class: 'destroy-comment', data: { method: :delete, confirm: 'Are you sure?' } do 
 end 
 end 
 if current_user != comment.user 
 link_to reply_comment_path(comment), class: 'reply-comment' do 
 end 
 end 
 end 
 comment.cooked_comment 
 
 if comments.size > 4 
 link_to 'Load all comments', wallpaper_comments_path(@wallpaper), class: 'btn btn-block', remote: true, data: { action: 'load-comments' } 
 end 
 end 
 if @wallpaper.tag_list.any? 
 @wallpaper.tag_list.each do |tag| 
 link_to wallpapers_path(tags: [tag]), class: 'label label-default' do 
 tag 
 end 
 end 
 end 
 end 
 content_for :wallpaper_stage_content do 
 image_tag @wallpaper.requested_image_url, width: @wallpaper.requested_image_width, height: @wallpaper.requested_image_height, class: "img-wallpaper img- state-1" 
 end 
 # OPTIMIZE 
  
 
 end 
 javascript_include_tag "application", "data-turbolinks-track" => true, "data-turbolinks-eval" => false 
  
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
  
 
 title 'New wallpaper' 
  simple_form_for(@wallpaper) do |f| 
 f.error_notification 
 f.input :purity unless @wallpaper.purity_locked? 
 f.input :image, as: :file unless @wallpaper.persisted? 
 f.input :category_id, collection: @available_categories, label_method: :name_for_selects, value_method: :id, include_blank: true, hint: 'Try to set the deepest possible category' 
 f.label :tag_list, label: 'Tags' 
 f.text_field :tag_list, class: 'form-control', autocomplete: 'off', data: { provide: 'tag_editor', search_path: api_v1_tags_path } 
 f.input :source, hint: 'Enter URL or Artist' 
 f.input :image_gravity, label: 'Crop position' 
 f.button :submit, class: 'btn btn-primary btn-lg' 
 end 
 
 link_to 'Cancel', wallpapers_path, class: 'btn btn-link' 
 
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
        format.json { render json: @wallpaper.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wallpapers/1
  # PATCH/PUT /wallpapers/1.json
  def update
    authorize! :update, @wallpaper

    respond_to do |format|
      if @wallpaper.update(update_wallpaper_params)
        format.html { redirect_to @wallpaper, notice: 'Wallpaper was successfully updated.' }
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
  
 
  simple_form_for(@wallpaper) do |f| 
 f.error_notification 
 f.input :purity unless @wallpaper.purity_locked? 
 f.input :image, as: :file unless @wallpaper.persisted? 
 f.input :category_id, collection: @available_categories, label_method: :name_for_selects, value_method: :id, include_blank: true, hint: 'Try to set the deepest possible category' 
 f.label :tag_list, label: 'Tags' 
 f.text_field :tag_list, class: 'form-control', autocomplete: 'off', data: { provide: 'tag_editor', search_path: api_v1_tags_path } 
 f.input :source, hint: 'Enter URL or Artist' 
 f.input :image_gravity, label: 'Crop position' 
 f.button :submit, class: 'btn btn-primary btn-lg' 
 end 
 
 link_to 'Cancel', @wallpaper, class: 'btn btn-link' 
 
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
        format.json { render json: @wallpaper.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wallpapers/1
  # DELETE /wallpapers/1.json
  def destroy
    authorize! :destroy, @wallpaper
    @wallpaper.destroy

    respond_to do |format|
      format.html { redirect_to wallpapers_url }
      format.json { head :no_content }
    end
  end

  # PATCH /wallpapers/1/update_purity
  # PATCH /wallpapers/1/update_purity.js
  def update_purity
    authorize! :update_purity, @wallpaper
    @wallpaper.purity = params[:purity]
    @wallpaper.save!

    respond_to do |format|
      format.html { redirect_to @wallpaper, notice: 'Wallpaper purity was successfully updated.' }
      format.json
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
  
 
json.extract! @wallpaper, :id, :purity 
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

  # GET /wallpapers/1/history
  def history
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
  
 
 @wallpaper.versions.order(created_at: :desc).each do |version| 
 wallpaper = version.reify 
 user = User.where(id: version.whodunnit).first 
 version.index 
 if user.present? 
 link_to user.username, user 
 end 
 version.created_at 
 version.event.humanize 
 auto_link wallpaper.try(:source) 
 wallpaper.try(:purity_text) 
 wallpaper.try(:cached_tag_list) 
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

  # POST /wallpapers/save_search_params
  # POST /wallpapers/save_search_params.json
  def save_search_params
    session[:search_params] = search_params(false).except(:page).to_hash

    respond_to do |format|
      format.html { redirect_to :back, notice: 'Search settings successfully saved.' }
      format.json { head :no_content }
    end
  end

  def set_profile_cover
    if @wallpaper.sfw?
      current_profile.cover_wallpaper = @wallpaper
      current_profile.save!
      redirect_to current_user, notice: 'Profile cover was successfully changed.'
    else
      redirect_to current_user, alert: 'Only SFW wallpapers can be set as profile cover.'
    end
  end

  def toggle_favourite
    if current_user.voted_for?(@wallpaper)
      @wallpaper.unliked_by current_user
      @fav_status = false
    else
      @wallpaper.liked_by current_user
      @fav_status = true
    end

    respond_to do |format|
      format.json
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
  
 
json.id @wallpaper.id
json.fav_count @wallpaper.likes.size
json.fav_status @fav_status 
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

  def collections
    @collections = current_user.collections.ordered
    @collections = WallpaperCollectionStatus.new(@collections, @wallpaper).collections

    respond_to do |format|
      format.json
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
  
 
json.toggle_collect_url toggle_collect_wallpaper_path(@wallpaper)
json.collections @collections do |collection|
  json.extract! collection, :id, :name, :public, :collect_status
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

  def toggle_collect
    @collection = current_user.collections.find(collection_params[:id])

    if @collection.collected?(@wallpaper)
      @collection.uncollect(@wallpaper)
      @collect_status = false
    else
      @collection.collect(@wallpaper)
      @collect_status = true
    end

    respond_to do |format|
      format.json
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
  
 
json.extract! @collection, :id
json.collect_status @collect_status 
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

  def set_wallpaper
    @wallpaper = Wallpaper.find(params[:id])
    authorize! :read, @wallpaper
  end

  def set_available_categories
    @available_categories = Category.arrange_as_array order: :name
  end

  def wallpaper_params
    params.require(:wallpaper).permit(:purity, :image, :tag_list, :image_gravity, :source, :category_id)
  end

  def update_wallpaper_params_with_purity
    params.require(:wallpaper).permit(:tag_list, :image_gravity, :source, :purity, :category_id)
  end

  def update_wallpaper_params_without_purity
    update_wallpaper_params_with_purity.except(:purity)
  end

  def update_wallpaper_params
    if can? :update_purity, @wallpaper
      update_wallpaper_params_with_purity
    else
      update_wallpaper_params_without_purity
    end
  end

  def search_params(load_session = true)
    params.permit(:q, :page, :width, :height, :order, purity: [], tags: [], exclude_tags: [], colors: []).tap do |p|
      p.reverse_merge! session[:search_params] if load_session && p.blank? && session[:search_params].present?

      # default values
      p[:order]  ||= 'latest'
      p[:purity] ||= current_purities
    end
  end

  def resize_params
    params.permit(:width, :height)
  end

  def collection_params
    params.require(:collection).permit(:id)
  end
end

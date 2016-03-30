# encoding: utf-8

require "digest/sha1"

class PostsController < ApplicationController
  include DrawingsController

  caches_page :count

  requires_authentication except: [:count]
  requires_user except: [:count, :since, :search]
  protect_from_forgery except: [:drawing]

  before_action :find_discussion, except: [:search]
  before_action :verify_viewable, except: [:search, :count, :since]
  before_action :find_post, only: [:show, :edit, :update, :destroy]
  before_action :verify_editable, only: [:edit, :update, :destroy]
  before_action :require_and_set_search_query, only: [:search]
  before_action :verify_postable, only: [:create, :drawing]

  after_action :mark_exchange_viewed, only: [:since]
  after_action :mark_conversation_viewed, only: [:since]
  # after_action :notify_mentioned, only: [:create]

  respond_to :html, :mobile, :json

  def count
    @count = @exchange.posts_count
    respond_to do |format|
      format.json do
        render json: { posts_count: @count }.to_json
      end
    end
  end

  def since
    @posts = @exchange.posts.limit(200).offset(params[:index]).for_view
    if request.xhr?
      render layout: false
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 [@page_title,Sugar.config.forum_name].compact.join(' - ') 
 stylesheet_link_tag "application" 
 if current_user? && current_user.mobile_stylesheet_url? 
 stylesheet_link_tag current_user.mobile_stylesheet_url 
 else 
 stylesheet_link_tag @theme.mobile_stylesheet_path 
 end 
 icon_tags 
 csrf_meta_tag 
 link_to "", "#", class: (current_user? && current_user.unread_conversations? ? 'new toggle-navigation' : 'toggle-navigation') 
 if @page_title 
 link_to "#{Sugar.config.forum_short_name}:", discussions_path 
 @page_title 
 else 
 link_to "#{Sugar.config.forum_short_name}", discussions_path 
 end 
 if current_user? || Sugar.public_browsing? 
 link_to "Discussions", discussions_path 
 if current_user? 
 link_to "Popular", popular_discussions_path 
 link_to "Following", following_discussions_path 
 link_to "Favorites", favorites_discussions_path 
 if current_user.unread_conversations? 
 link_to "Conversations", conversations_path 
 else 
 link_to "Conversations", conversations_path 
 end 
 end 
 link_to "Users", users_path 
 if current_user? 
 link_to "New discussion", new_discussion_path 
 if @exchange && !@exchange.new_record? && @exchange.editable_by?(current_user) 
 link_to "Edit discussion", edit_discussion_path(@exchange) 
 end 
 link_to "Log out", logout_users_path, confirm: "Are you sure you want to log out?" 
 end 
 form_tag((@search_path || search_path), method: 'get') do 
 text_field_tag 'q', @search_query, class: :query 
 select_tag 'search_mode', options_for_select(
            search_mode_options,
            @search_path || search_path
          ) 
 submit_tag "Go", name: nil 
 end 
 end 
 if flash[:notice] 
 raw flash[:notice] 
 end 
  
  # Options
  discussion         ||= false
  functions          ||= false
  permalink          ||= false
  post_distance      ||= false
  title              ||= false
  new_posts_notifier ||= false
  no_pagination      ||= false
  no_container       ||= false

  previous_post = nil
  pagination_params ||= {}

 render(partial: 'components/pagination', locals: { p: posts, anchor: :start, pagination_params: pagination_params }) unless no_pagination 
 unless no_container 
 end 
 posts.each do |post| 
 if posts.kind_of?(Paginatable::ClassMethods::WithContext) && posts.context? && posts.to_a.index(post) == 0 
 end 
 
  # Options
  posts              ||= false
  discussion         ||= false
  functions          ||= false
  permalink          ||= false
  post_distance      ||= false
  title              ||= false
  preview            ||= false

  previous_post      ||= nil

 if post_distance && previous_post 
 if (post.created_at - previous_post.created_at) >= 12.hours 
 distance_of_time_in_words(post.created_at, previous_post.created_at) 
 elsif (previous_post.created_at - post.created_at) >= 12.hours 
 distance_of_time_in_words(post.created_at, previous_post.created_at) 
 end 
 end 
 post.user.id 
 " me_post" if post.me_post? 
 post.user.id 
 post.exchange_id 
 post.exchange.type 
 post.id 
 post.id 
 if title 
 if post.exchange.labels? 
 post.exchange.labels.join(',') 
 end 
 link_to post.exchange.title, polymorphic_path(post.exchange, page: post.page, anchor: "post-#{post.id}") 
 profile_link(post.exchange.poster) 
 time_tag post.exchange.last_post_at, class: 'relative' 
 post.exchange.posts_count 
 end 
 if functions 
 end 
 if post.me_post? 
 avatar_image_tag(post.user) 
 post.id 
 format_post post.body, post.user 
 if preview 
 else 
 if permalink 
 link_to(polymorphic_path((discussion||post.exchange), page: post_page(post), anchor: "post-#{post.id}"), title: "Permalink to this post", class: "permalink") do 
 time_tag post.created_at, class: 'relative date' 
 end 
 else 
 time_tag post.created_at, class: 'relative date' 
 end 
 end 
 else 
 avatar_image_tag(post.user) 
 profile_link(post.user) 
 if preview 
 else 
 if permalink 
 link_to(polymorphic_path((discussion||post.exchange), page: post_page(post), anchor: "post-#{post.id}"), title: "Permalink to this post", class: "permalink") do 
 time_tag post.created_at, class: 'relative date' 
 end 
 else 
 time_tag post.created_at, class: 'relative date' 
 end 
 end 
 post.id 
 format_post(post.body_html, post.user) 
 if post.edited? 
 time_tag post.edited_at, class: 'relative' 
 end 
 end 
 
 previous_post = post 
 if posts.kind_of?(Paginatable::ClassMethods::WithContext) && posts.context? && posts.to_a.index(post) == (posts.context-1) 
 end 
 end 
 unless no_container 
 end 
 if new_posts_notifier 
 end 
 render(partial: 'components/pagination', locals: { p: posts, anchor: :start, pagination_params: pagination_params }) unless no_pagination 
 
 link_to "Discussions", discussions_path 
 if current_user? 
 link_to "Following", following_discussions_path 
 link_to "Favorites", favorites_discussions_path 
 end 
 link_to "Regular site", {mobile_format: 'html'}, class: 'regular_site' 
 javascript_include_tag "mobile" 
 frontend_configuration.to_json.html_safe 
 if @posts && @posts.any? 
 end 
 if Sugar.config.google_analytics 
 Sugar.config.google_analytics 
 end 

end

  end

  def search
    @search_path = search_posts_path
    @posts = Post.search_results(
      search_query,
      user: current_user,
      page: params[:page]
    )
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 [@page_title,Sugar.config.forum_name].compact.join(' - ') 
 stylesheet_link_tag "application" 
 if current_user? && current_user.mobile_stylesheet_url? 
 stylesheet_link_tag current_user.mobile_stylesheet_url 
 else 
 stylesheet_link_tag @theme.mobile_stylesheet_path 
 end 
 icon_tags 
 csrf_meta_tag 
 link_to "", "#", class: (current_user? && current_user.unread_conversations? ? 'new toggle-navigation' : 'toggle-navigation') 
 if @page_title 
 link_to "#{Sugar.config.forum_short_name}:", discussions_path 
 @page_title 
 else 
 link_to "#{Sugar.config.forum_short_name}", discussions_path 
 end 
 if current_user? || Sugar.public_browsing? 
 link_to "Discussions", discussions_path 
 if current_user? 
 link_to "Popular", popular_discussions_path 
 link_to "Following", following_discussions_path 
 link_to "Favorites", favorites_discussions_path 
 if current_user.unread_conversations? 
 link_to "Conversations", conversations_path 
 else 
 link_to "Conversations", conversations_path 
 end 
 end 
 link_to "Users", users_path 
 if current_user? 
 link_to "New discussion", new_discussion_path 
 if @exchange && !@exchange.new_record? && @exchange.editable_by?(current_user) 
 link_to "Edit discussion", edit_discussion_path(@exchange) 
 end 
 link_to "Log out", logout_users_path, confirm: "Are you sure you want to log out?" 
 end 
 form_tag((@search_path || search_path), method: 'get') do 
 text_field_tag 'q', @search_query, class: :query 
 select_tag 'search_mode', options_for_select(
            search_mode_options,
            @search_path || search_path
          ) 
 submit_tag "Go", name: nil 
 end 
 end 
 if flash[:notice] 
 raw flash[:notice] 
 end 
 
  @page_title = "Posts Search"
  add_body_class "search", "search_posts"

 content_for :sidebar do 
  'current' if params[:controller] == 'discussions' && params[:action] == "index" 
 link_to "Everything", discussions_path 
 Discussion.viewable_by(current_user).count 
 if current_user? 
 if current_user.following_count > 0 
 'current' if params[:controller] == 'discussions' && params[:action] == "following" 
 link_to "Followed", following_discussions_path 
 current_user.following_count 
 end 
 if current_user.favorites_count > 0 
 'current' if params[:controller] == 'discussions' && params[:action] == "favorites" 
 link_to "Favorites", favorites_discussions_path 
 current_user.favorites_count 
 end 
 if current_user.hidden_count > 0 
 'current' if params[:controller] == 'discussions' && params[:action] == "hidden" 
 link_to "Hidden", hidden_discussions_path 
 current_user.hidden_count 
 end 
 end 
 'current' if params[:controller] == 'discussions' && params[:action] == "popular" 
 link_to "Popular", popular_discussions_path 
 if current_user? 
 link_to "Start a new discussion", new_discussion_path, class: 'create button' 
 end 
 if current_user? && (current_user.admin? || current_user.moderator?) 
 if current_user.admin? 
 link_to "Forum configuration", admin_configuration_path 
 end 
 end 

 end 
 @search_query 
  
 if @posts && @posts.length > 0 
 
  # Options
  discussion         ||= false
  functions          ||= false
  permalink          ||= false
  post_distance      ||= false
  title              ||= false
  new_posts_notifier ||= false
  no_pagination      ||= false
  no_container       ||= false

  previous_post = nil
  pagination_params ||= {}

 render(partial: 'components/pagination', locals: { p: posts, anchor: :start, pagination_params: pagination_params }) unless no_pagination 
 unless no_container 
 end 
 posts.each do |post| 
 if posts.kind_of?(Paginatable::ClassMethods::WithContext) && posts.context? && posts.to_a.index(post) == 0 
 end 
 
  # Options
  posts              ||= false
  discussion         ||= false
  functions          ||= false
  permalink          ||= false
  post_distance      ||= false
  title              ||= false
  preview            ||= false

  previous_post      ||= nil

 if post_distance && previous_post 
 if (post.created_at - previous_post.created_at) >= 12.hours 
 distance_of_time_in_words(post.created_at, previous_post.created_at) 
 elsif (previous_post.created_at - post.created_at) >= 12.hours 
 distance_of_time_in_words(post.created_at, previous_post.created_at) 
 end 
 end 
 post.user.id 
 " me_post" if post.me_post? 
 post.user.id 
 post.exchange_id 
 post.exchange.type 
 post.id 
 post.id 
 if title 
 if post.exchange.labels? 
 post.exchange.labels.join(',') 
 end 
 link_to post.exchange.title, polymorphic_path(post.exchange, page: post.page, anchor: "post-#{post.id}") 
 profile_link(post.exchange.poster) 
 time_tag post.exchange.last_post_at, class: 'relative' 
 post.exchange.posts_count 
 end 
 if functions 
 end 
 if post.me_post? 
 avatar_image_tag(post.user) 
 post.id 
 format_post post.body, post.user 
 if preview 
 else 
 if permalink 
 link_to(polymorphic_path((discussion||post.exchange), page: post_page(post), anchor: "post-#{post.id}"), title: "Permalink to this post", class: "permalink") do 
 time_tag post.created_at, class: 'relative date' 
 end 
 else 
 time_tag post.created_at, class: 'relative date' 
 end 
 end 
 else 
 avatar_image_tag(post.user) 
 profile_link(post.user) 
 if preview 
 else 
 if permalink 
 link_to(polymorphic_path((discussion||post.exchange), page: post_page(post), anchor: "post-#{post.id}"), title: "Permalink to this post", class: "permalink") do 
 time_tag post.created_at, class: 'relative date' 
 end 
 else 
 time_tag post.created_at, class: 'relative date' 
 end 
 end 
 post.id 
 format_post(post.body_html, post.user) 
 if post.edited? 
 time_tag post.edited_at, class: 'relative' 
 end 
 end 
 
 previous_post = post 
 if posts.kind_of?(Paginatable::ClassMethods::WithContext) && posts.context? && posts.to_a.index(post) == (posts.context-1) 
 end 
 end 
 unless no_container 
 end 
 if new_posts_notifier 
 end 
 render(partial: 'components/pagination', locals: { p: posts, anchor: :start, pagination_params: pagination_params }) unless no_pagination 
 
 else 
 end 
 link_to "Discussions", discussions_path 
 if current_user? 
 link_to "Following", following_discussions_path 
 link_to "Favorites", favorites_discussions_path 
 end 
 link_to "Regular site", {mobile_format: 'html'}, class: 'regular_site' 
 javascript_include_tag "mobile" 
 frontend_configuration.to_json.html_safe 
 if @posts && @posts.any? 
 end 
 if Sugar.config.google_analytics 
 Sugar.config.google_analytics 
 end 

end

  end

  def create
    create_post(post_params.merge(user: current_user))
  end

  def update
    @post.update_attributes(post_params.merge(edited_at: Time.now))
    respond_with(
      @post,
      location: polymorphic_url(
        @exchange,
        page: @post.page,
        anchor: "post-#{@post.id}"
      )
    )
  end

  def preview
    @post = @exchange.posts.new(post_params.merge(user: current_user))
    @post.fetch_images
    if request.xhr?
      render layout: false
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 [@page_title,Sugar.config.forum_name].compact.join(' - ') 
 stylesheet_link_tag "application" 
 if current_user? && current_user.mobile_stylesheet_url? 
 stylesheet_link_tag current_user.mobile_stylesheet_url 
 else 
 stylesheet_link_tag @theme.mobile_stylesheet_path 
 end 
 icon_tags 
 csrf_meta_tag 
 link_to "", "#", class: (current_user? && current_user.unread_conversations? ? 'new toggle-navigation' : 'toggle-navigation') 
 if @page_title 
 link_to "#{Sugar.config.forum_short_name}:", discussions_path 
 @page_title 
 else 
 link_to "#{Sugar.config.forum_short_name}", discussions_path 
 end 
 if current_user? || Sugar.public_browsing? 
 link_to "Discussions", discussions_path 
 if current_user? 
 link_to "Popular", popular_discussions_path 
 link_to "Following", following_discussions_path 
 link_to "Favorites", favorites_discussions_path 
 if current_user.unread_conversations? 
 link_to "Conversations", conversations_path 
 else 
 link_to "Conversations", conversations_path 
 end 
 end 
 link_to "Users", users_path 
 if current_user? 
 link_to "New discussion", new_discussion_path 
 if @exchange && !@exchange.new_record? && @exchange.editable_by?(current_user) 
 link_to "Edit discussion", edit_discussion_path(@exchange) 
 end 
 link_to "Log out", logout_users_path, confirm: "Are you sure you want to log out?" 
 end 
 form_tag((@search_path || search_path), method: 'get') do 
 text_field_tag 'q', @search_query, class: :query 
 select_tag 'search_mode', options_for_select(
            search_mode_options,
            @search_path || search_path
          ) 
 submit_tag "Go", name: nil 
 end 
 end 
 if flash[:notice] 
 raw flash[:notice] 
 end 
  
  # Options
  posts              ||= false
  discussion         ||= false
  functions          ||= false
  permalink          ||= false
  post_distance      ||= false
  title              ||= false
  preview            ||= false

  previous_post      ||= nil

 if post_distance && previous_post 
 if (post.created_at - previous_post.created_at) >= 12.hours 
 distance_of_time_in_words(post.created_at, previous_post.created_at) 
 elsif (previous_post.created_at - post.created_at) >= 12.hours 
 distance_of_time_in_words(post.created_at, previous_post.created_at) 
 end 
 end 
 post.user.id 
 " me_post" if post.me_post? 
 post.user.id 
 post.exchange_id 
 post.exchange.type 
 post.id 
 post.id 
 if title 
 if post.exchange.labels? 
 post.exchange.labels.join(',') 
 end 
 link_to post.exchange.title, polymorphic_path(post.exchange, page: post.page, anchor: "post-#{post.id}") 
 profile_link(post.exchange.poster) 
 time_tag post.exchange.last_post_at, class: 'relative' 
 post.exchange.posts_count 
 end 
 if functions 
 end 
 if post.me_post? 
 avatar_image_tag(post.user) 
 post.id 
 format_post post.body, post.user 
 if preview 
 else 
 if permalink 
 link_to(polymorphic_path((discussion||post.exchange), page: post_page(post), anchor: "post-#{post.id}"), title: "Permalink to this post", class: "permalink") do 
 time_tag post.created_at, class: 'relative date' 
 end 
 else 
 time_tag post.created_at, class: 'relative date' 
 end 
 end 
 else 
 avatar_image_tag(post.user) 
 profile_link(post.user) 
 if preview 
 else 
 if permalink 
 link_to(polymorphic_path((discussion||post.exchange), page: post_page(post), anchor: "post-#{post.id}"), title: "Permalink to this post", class: "permalink") do 
 time_tag post.created_at, class: 'relative date' 
 end 
 else 
 time_tag post.created_at, class: 'relative date' 
 end 
 end 
 post.id 
 format_post(post.body_html, post.user) 
 if post.edited? 
 time_tag post.edited_at, class: 'relative' 
 end 
 end 
 
 link_to "Discussions", discussions_path 
 if current_user? 
 link_to "Following", following_discussions_path 
 link_to "Favorites", favorites_discussions_path 
 end 
 link_to "Regular site", {mobile_format: 'html'}, class: 'regular_site' 
 javascript_include_tag "mobile" 
 frontend_configuration.to_json.html_safe 
 if @posts && @posts.any? 
 end 
 if Sugar.config.google_analytics 
 Sugar.config.google_analytics 
 end 

end

  end

  def edit
    if request.xhr?
      render layout: false
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 [@page_title,Sugar.config.forum_name].compact.join(' - ') 
 stylesheet_link_tag "application" 
 if current_user? && current_user.mobile_stylesheet_url? 
 stylesheet_link_tag current_user.mobile_stylesheet_url 
 else 
 stylesheet_link_tag @theme.mobile_stylesheet_path 
 end 
 icon_tags 
 csrf_meta_tag 
 link_to "", "#", class: (current_user? && current_user.unread_conversations? ? 'new toggle-navigation' : 'toggle-navigation') 
 if @page_title 
 link_to "#{Sugar.config.forum_short_name}:", discussions_path 
 @page_title 
 else 
 link_to "#{Sugar.config.forum_short_name}", discussions_path 
 end 
 if current_user? || Sugar.public_browsing? 
 link_to "Discussions", discussions_path 
 if current_user? 
 link_to "Popular", popular_discussions_path 
 link_to "Following", following_discussions_path 
 link_to "Favorites", favorites_discussions_path 
 if current_user.unread_conversations? 
 link_to "Conversations", conversations_path 
 else 
 link_to "Conversations", conversations_path 
 end 
 end 
 link_to "Users", users_path 
 if current_user? 
 link_to "New discussion", new_discussion_path 
 if @exchange && !@exchange.new_record? && @exchange.editable_by?(current_user) 
 link_to "Edit discussion", edit_discussion_path(@exchange) 
 end 
 link_to "Log out", logout_users_path, confirm: "Are you sure you want to log out?" 
 end 
 form_tag((@search_path || search_path), method: 'get') do 
 text_field_tag 'q', @search_query, class: :query 
 select_tag 'search_mode', options_for_select(
            search_mode_options,
            @search_path || search_path
          ) 
 submit_tag "Go", name: nil 
 end 
 end 
 if flash[:notice] 
 raw flash[:notice] 
 end 
 
  @page_title = "Edit post"

 form_for([@exchange, @post]) do |f| 
 f.hidden_field(:format, class: "format") 
 f.text_area(
        :body,
        id:                    "compose-body",
        class:                 "rich",
        "data-format-binding"  => ".format",
        "data-formats"         => "markdown html"
      ) 
 submit_tag "Post" 
 end 
 link_to "Discussions", discussions_path 
 if current_user? 
 link_to "Following", following_discussions_path 
 link_to "Favorites", favorites_discussions_path 
 end 
 link_to "Regular site", {mobile_format: 'html'}, class: 'regular_site' 
 javascript_include_tag "mobile" 
 frontend_configuration.to_json.html_safe 
 if @posts && @posts.any? 
 end 
 if Sugar.config.google_analytics 
 Sugar.config.google_analytics 
 end 

end

  end

  private

  def create_post(create_params)
    @post = @exchange.posts.create(create_params)
    @exchange.reload

    exchange_url = polymorphic_url(
      @exchange,
      page: @exchange.last_page,
      anchor: "post-#{@post.id}"
    )

    # if @exchange.is_a?(Conversation)
    #   ConversationNotifier.new(@post, exchange_url).deliver_later
    # end

    respond_with(@post, location: exchange_url)
  end

  def find_discussion
    @exchange = nil
    if params[:discussion_id]
      @exchange ||= Discussion.find(params[:discussion_id])
    end
    if params[:conversation_id]
      @exchange ||= Conversation.find(params[:conversation_id])
    end
    @exchange ||= Exchange.find(params[:exchange_id])
  end

  def find_post
    @post = Post.find(params[:id])
  end

  def mark_conversation_viewed
    if @exchange.is_a?(Conversation)
      current_user.mark_conversation_viewed(@exchange)
    end
  end

  def mark_exchange_viewed
    if current_user? && @posts.any?
      current_user.mark_exchange_viewed(
        @exchange,
        @posts.last,
        (params[:index].to_i + @posts.length)
      )
    end
  end

  def notify_mentioned
    # if @post.valid? && @post.mentions_users?
    #   @post.mentioned_users.each do |mentioned_user|
    #     logger.info "Mentions: #{mentioned_user.username}"
    #   end
    # end
  end

  def post_params
    params.require(:post).permit(:body, :format)
  end

  def search_query
    params[:query] || params[:q]
  end

  def require_and_set_search_query
    unless @search_query = search_query
      flash[:notice] = "No query specified!"
      redirect_to root_url
    end
  end

  def verify_editable
    unless @post.editable_by?(current_user)
      flash[:notice] = "You don't have permission to edit that post!"
      redirect_to polymorphic_url(@exchange, page: @exchange.last_page)
      return
    end
  end

  def verify_postable
    unless @exchange.postable_by?(current_user)
      flash[:notice] = "This discussion is closed, " +
        "you don't have permission to post here"
      redirect_to polymorphic_url(@exchange, page: @exchange.last_page)
    end
  end

  def verify_viewable
    unless @exchange && @exchange.viewable_by?(current_user)
      flash[:notice] = "You don't have permission to view that discussion!"
      redirect_to root_url
      return
    end
  end
end

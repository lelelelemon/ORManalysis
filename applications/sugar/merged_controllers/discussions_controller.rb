# encoding: utf-8

class DiscussionsController < ApplicationController
  include ExchangesController

  requires_authentication
  requires_user except: [:index, :search, :search_posts, :show]

  before_action :find_exchange, except: [
    :index, :new, :create, :popular, :search, :favorites, :following, :hidden
  ]
  before_action :verify_editable, only: [:edit, :update, :destroy]
  before_action :require_and_set_search_query, only: [:search, :search_posts]

  def index
    if current_user?
      @exchanges = current_user.
        unhidden_discussions.
        viewable_by(current_user).
        page(params[:page]).
        for_view
    else
      @exchanges = Discussion.
        viewable_by(nil).
        page(params[:page]).
        for_view
    end
    respond_with_exchanges(@exchanges)
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
 
  add_body_class "discussions all_discussions"
  @page_title = "All Discussions"

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
 link_to "All discussions", discussions_path 
 
  no_exchanges ||= "No discussions here yet. " + link_to("Create the first!", new_discussion_path)
  pagination_params ||= {}

 if exchanges.any? 
 @exchanges.each do |d| 
 exchange_classes(exchanges, d).flatten.compact.join(' ') 
 if new_posts?(d) 
 new_posts_count(d) 
 end 
 if d.labels? 
 d.labels.join(',') 
 end 
 link_to d.title, last_viewed_page_path(d) 
 if d.kind_of?(Conversation) 

            other_participants = d.participants.reject{|p| p == current_user}
          
 if other_participants.length == 0 
 elsif other_participants.length > 2 
 other_participants.length 
 else 
 safe_join other_participants.map{|p| profile_link(p)}, ', ' 
 end 
 else 
 d.poster.username 
 end 
 d.posts_count 
 d.last_poster.username 
 time_tag d.last_post_at, class: 'relative' 
 end 
 
  anchor ||= nil
  pagination_params ||= {}

  # Solr results have offset, while ARel results need offset_value
  offset = p.respond_to?(:offset_value) ? p.offset_value : p.offset


 if p.total_pages > 1 
 if p.previous_page 
 link_to({page: p.previous_page, anchor: anchor}.merge(pagination_params), class: 'prev_page_link') do 
 end 
 else 
 end 
 if np = nearest_pages(p) 
 if np.first > 1 
 if p.current_page == 1 
 else 
 link_to("1", {page: 1, anchor: anchor}.merge(pagination_params), class: 'first_page_link') 
 end 
 end 
 if np.first > 2 
 end 
 np.each do |np| 
 if p.current_page == np 
 np 
 else 
 link_to(np, {page: np, anchor: anchor}.merge(pagination_params), class: 'number_page_link') 
 end 
 end 
 if np.last < (p.total_pages - 1) 
 end 
 if np.last < p.total_pages 
 if p.current_page == p.total_pages 
 p.total_pages 
 else 
 link_to(p.total_pages, {page: p.total_pages, anchor: anchor}.merge(pagination_params), class: 'last_page_link') 
 end 
 end 
 end 
 if p.next_page 
 link_to({page: p.next_page, anchor: anchor}.merge(pagination_params), class: 'next_page_link') do 
 end 
 else 
 end 
 end 
 offset + 1 
 offset + p.length 
 p.total_count 
 
 else 
 no_exchanges 
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

  def popular
    @days = params[:days].to_i
    unless (1..180).include?(@days)
      redirect_to popular_discussions_url(days: 7)
      return
    end
    @exchanges = Discussion.viewable_by(current_user).
      popular_in_the_last(@days.days).
      page(params[:page])
    respond_with_exchanges(@exchanges)
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
 
  add_body_class "discussions popular_discussions"
  @page_title = "Popular Discussions"

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
 link_to "Popular discussions", popular_discussions_path 
 "last #{@days > 1 ? "#{@days} days" : "day"}"
 
  no_exchanges ||= "No discussions here yet. " + link_to("Create the first!", new_discussion_path)
  pagination_params ||= {}

 if exchanges.any? 
 @exchanges.each do |d| 
 exchange_classes(exchanges, d).flatten.compact.join(' ') 
 if new_posts?(d) 
 new_posts_count(d) 
 end 
 if d.labels? 
 d.labels.join(',') 
 end 
 link_to d.title, last_viewed_page_path(d) 
 if d.kind_of?(Conversation) 

            other_participants = d.participants.reject{|p| p == current_user}
          
 if other_participants.length == 0 
 elsif other_participants.length > 2 
 other_participants.length 
 else 
 safe_join other_participants.map{|p| profile_link(p)}, ', ' 
 end 
 else 
 d.poster.username 
 end 
 d.posts_count 
 d.last_poster.username 
 time_tag d.last_post_at, class: 'relative' 
 end 
 
  anchor ||= nil
  pagination_params ||= {}

  # Solr results have offset, while ARel results need offset_value
  offset = p.respond_to?(:offset_value) ? p.offset_value : p.offset


 if p.total_pages > 1 
 if p.previous_page 
 link_to({page: p.previous_page, anchor: anchor}.merge(pagination_params), class: 'prev_page_link') do 
 end 
 else 
 end 
 if np = nearest_pages(p) 
 if np.first > 1 
 if p.current_page == 1 
 else 
 link_to("1", {page: 1, anchor: anchor}.merge(pagination_params), class: 'first_page_link') 
 end 
 end 
 if np.first > 2 
 end 
 np.each do |np| 
 if p.current_page == np 
 np 
 else 
 link_to(np, {page: np, anchor: anchor}.merge(pagination_params), class: 'number_page_link') 
 end 
 end 
 if np.last < (p.total_pages - 1) 
 end 
 if np.last < p.total_pages 
 if p.current_page == p.total_pages 
 p.total_pages 
 else 
 link_to(p.total_pages, {page: p.total_pages, anchor: anchor}.merge(pagination_params), class: 'last_page_link') 
 end 
 end 
 end 
 if p.next_page 
 link_to({page: p.next_page, anchor: anchor}.merge(pagination_params), class: 'next_page_link') do 
 end 
 else 
 end 
 end 
 offset + 1 
 offset + p.length 
 p.total_count 
 
 else 
 no_exchanges 
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

  def search
    search = Discussion.search_results(
      search_query,
      user: current_user,
      page: params[:page]
    )
    @exchanges = search.results

    respond_to do |format|
      format.any(:html, :mobile) do
        @search_path = search_path
        respond_with_exchanges(@exchanges)
      end
      format.json do
        respond_with @exchanges, meta: {
          total: search.total
        }
      end
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
 
  @page_title = "Title Search"
  add_body_class "search", "search_discussions"

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
  
 if @exchanges && @exchanges.length > 0 
 
  no_exchanges ||= "No discussions here yet. " + link_to("Create the first!", new_discussion_path)
  pagination_params ||= {}

 if exchanges.any? 
 @exchanges.each do |d| 
 exchange_classes(exchanges, d).flatten.compact.join(' ') 
 if new_posts?(d) 
 new_posts_count(d) 
 end 
 if d.labels? 
 d.labels.join(',') 
 end 
 link_to d.title, last_viewed_page_path(d) 
 if d.kind_of?(Conversation) 

            other_participants = d.participants.reject{|p| p == current_user}
          
 if other_participants.length == 0 
 elsif other_participants.length > 2 
 other_participants.length 
 else 
 safe_join other_participants.map{|p| profile_link(p)}, ', ' 
 end 
 else 
 d.poster.username 
 end 
 d.posts_count 
 d.last_poster.username 
 time_tag d.last_post_at, class: 'relative' 
 end 
 
  anchor ||= nil
  pagination_params ||= {}

  # Solr results have offset, while ARel results need offset_value
  offset = p.respond_to?(:offset_value) ? p.offset_value : p.offset


 if p.total_pages > 1 
 if p.previous_page 
 link_to({page: p.previous_page, anchor: anchor}.merge(pagination_params), class: 'prev_page_link') do 
 end 
 else 
 end 
 if np = nearest_pages(p) 
 if np.first > 1 
 if p.current_page == 1 
 else 
 link_to("1", {page: 1, anchor: anchor}.merge(pagination_params), class: 'first_page_link') 
 end 
 end 
 if np.first > 2 
 end 
 np.each do |np| 
 if p.current_page == np 
 np 
 else 
 link_to(np, {page: np, anchor: anchor}.merge(pagination_params), class: 'number_page_link') 
 end 
 end 
 if np.last < (p.total_pages - 1) 
 end 
 if np.last < p.total_pages 
 if p.current_page == p.total_pages 
 p.total_pages 
 else 
 link_to(p.total_pages, {page: p.total_pages, anchor: anchor}.merge(pagination_params), class: 'last_page_link') 
 end 
 end 
 end 
 if p.next_page 
 link_to({page: p.next_page, anchor: anchor}.merge(pagination_params), class: 'next_page_link') do 
 end 
 else 
 end 
 end 
 offset + 1 
 offset + p.length 
 p.total_count 
 
 else 
 no_exchanges 
 end 
 
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

  def favorites
    @section = :favorites
    @exchanges = current_user.
      favorite_discussions.
      viewable_by(current_user).
      page(params[:page]).
      for_view
    respond_with_exchanges(@exchanges)
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
 
  add_body_class "discussions favorite_discussions"
  @page_title = "Favorite Discussions"

 
  no_exchanges ||= "No discussions here yet. " + link_to("Create the first!", new_discussion_path)
  pagination_params ||= {}

 if exchanges.any? 
 @exchanges.each do |d| 
 exchange_classes(exchanges, d).flatten.compact.join(' ') 
 if new_posts?(d) 
 new_posts_count(d) 
 end 
 if d.labels? 
 d.labels.join(',') 
 end 
 link_to d.title, last_viewed_page_path(d) 
 if d.kind_of?(Conversation) 

            other_participants = d.participants.reject{|p| p == current_user}
          
 if other_participants.length == 0 
 elsif other_participants.length > 2 
 other_participants.length 
 else 
 safe_join other_participants.map{|p| profile_link(p)}, ', ' 
 end 
 else 
 d.poster.username 
 end 
 d.posts_count 
 d.last_poster.username 
 time_tag d.last_post_at, class: 'relative' 
 end 
 
  anchor ||= nil
  pagination_params ||= {}

  # Solr results have offset, while ARel results need offset_value
  offset = p.respond_to?(:offset_value) ? p.offset_value : p.offset


 if p.total_pages > 1 
 if p.previous_page 
 link_to({page: p.previous_page, anchor: anchor}.merge(pagination_params), class: 'prev_page_link') do 
 end 
 else 
 end 
 if np = nearest_pages(p) 
 if np.first > 1 
 if p.current_page == 1 
 else 
 link_to("1", {page: 1, anchor: anchor}.merge(pagination_params), class: 'first_page_link') 
 end 
 end 
 if np.first > 2 
 end 
 np.each do |np| 
 if p.current_page == np 
 np 
 else 
 link_to(np, {page: np, anchor: anchor}.merge(pagination_params), class: 'number_page_link') 
 end 
 end 
 if np.last < (p.total_pages - 1) 
 end 
 if np.last < p.total_pages 
 if p.current_page == p.total_pages 
 p.total_pages 
 else 
 link_to(p.total_pages, {page: p.total_pages, anchor: anchor}.merge(pagination_params), class: 'last_page_link') 
 end 
 end 
 end 
 if p.next_page 
 link_to({page: p.next_page, anchor: anchor}.merge(pagination_params), class: 'next_page_link') do 
 end 
 else 
 end 
 end 
 offset + 1 
 offset + p.length 
 p.total_count 
 
 else 
 no_exchanges 
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

  def following
    @section = :following
    @exchanges = current_user.
      followed_discussions.
      viewable_by(current_user).
      page(params[:page]).
      for_view
    respond_with_exchanges(@exchanges)
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
 
  add_body_class "discussions followed_discussions"
  @page_title = "Followed Discussions"

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
 link_to "Followed Discussions", following_discussions_path 
 
  no_exchanges ||= "No discussions here yet. " + link_to("Create the first!", new_discussion_path)
  pagination_params ||= {}

 if exchanges.any? 
 @exchanges.each do |d| 
 exchange_classes(exchanges, d).flatten.compact.join(' ') 
 if new_posts?(d) 
 new_posts_count(d) 
 end 
 if d.labels? 
 d.labels.join(',') 
 end 
 link_to d.title, last_viewed_page_path(d) 
 if d.kind_of?(Conversation) 

            other_participants = d.participants.reject{|p| p == current_user}
          
 if other_participants.length == 0 
 elsif other_participants.length > 2 
 other_participants.length 
 else 
 safe_join other_participants.map{|p| profile_link(p)}, ', ' 
 end 
 else 
 d.poster.username 
 end 
 d.posts_count 
 d.last_poster.username 
 time_tag d.last_post_at, class: 'relative' 
 end 
 
  anchor ||= nil
  pagination_params ||= {}

  # Solr results have offset, while ARel results need offset_value
  offset = p.respond_to?(:offset_value) ? p.offset_value : p.offset


 if p.total_pages > 1 
 if p.previous_page 
 link_to({page: p.previous_page, anchor: anchor}.merge(pagination_params), class: 'prev_page_link') do 
 end 
 else 
 end 
 if np = nearest_pages(p) 
 if np.first > 1 
 if p.current_page == 1 
 else 
 link_to("1", {page: 1, anchor: anchor}.merge(pagination_params), class: 'first_page_link') 
 end 
 end 
 if np.first > 2 
 end 
 np.each do |np| 
 if p.current_page == np 
 np 
 else 
 link_to(np, {page: np, anchor: anchor}.merge(pagination_params), class: 'number_page_link') 
 end 
 end 
 if np.last < (p.total_pages - 1) 
 end 
 if np.last < p.total_pages 
 if p.current_page == p.total_pages 
 p.total_pages 
 else 
 link_to(p.total_pages, {page: p.total_pages, anchor: anchor}.merge(pagination_params), class: 'last_page_link') 
 end 
 end 
 end 
 if p.next_page 
 link_to({page: p.next_page, anchor: anchor}.merge(pagination_params), class: 'next_page_link') do 
 end 
 else 
 end 
 end 
 offset + 1 
 offset + p.length 
 p.total_count 
 
 else 
 no_exchanges 
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

  def hidden
    @exchanges = current_user.
      hidden_discussions.
      viewable_by(current_user).
      page(params[:page]).
      for_view
    respond_with_exchanges(@exchanges)
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
 
  add_body_class "discussions hidden_discussions"
  @page_title = "Hidden Discussions"

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
 link_to "Hidden Discussions", hidden_discussions_path 
 
  no_exchanges ||= "No discussions here yet. " + link_to("Create the first!", new_discussion_path)
  pagination_params ||= {}

 if exchanges.any? 
 @exchanges.each do |d| 
 exchange_classes(exchanges, d).flatten.compact.join(' ') 
 if new_posts?(d) 
 new_posts_count(d) 
 end 
 if d.labels? 
 d.labels.join(',') 
 end 
 link_to d.title, last_viewed_page_path(d) 
 if d.kind_of?(Conversation) 

            other_participants = d.participants.reject{|p| p == current_user}
          
 if other_participants.length == 0 
 elsif other_participants.length > 2 
 other_participants.length 
 else 
 safe_join other_participants.map{|p| profile_link(p)}, ', ' 
 end 
 else 
 d.poster.username 
 end 
 d.posts_count 
 d.last_poster.username 
 time_tag d.last_post_at, class: 'relative' 
 end 
 
  anchor ||= nil
  pagination_params ||= {}

  # Solr results have offset, while ARel results need offset_value
  offset = p.respond_to?(:offset_value) ? p.offset_value : p.offset


 if p.total_pages > 1 
 if p.previous_page 
 link_to({page: p.previous_page, anchor: anchor}.merge(pagination_params), class: 'prev_page_link') do 
 end 
 else 
 end 
 if np = nearest_pages(p) 
 if np.first > 1 
 if p.current_page == 1 
 else 
 link_to("1", {page: 1, anchor: anchor}.merge(pagination_params), class: 'first_page_link') 
 end 
 end 
 if np.first > 2 
 end 
 np.each do |np| 
 if p.current_page == np 
 np 
 else 
 link_to(np, {page: np, anchor: anchor}.merge(pagination_params), class: 'number_page_link') 
 end 
 end 
 if np.last < (p.total_pages - 1) 
 end 
 if np.last < p.total_pages 
 if p.current_page == p.total_pages 
 p.total_pages 
 else 
 link_to(p.total_pages, {page: p.total_pages, anchor: anchor}.merge(pagination_params), class: 'last_page_link') 
 end 
 end 
 end 
 if p.next_page 
 link_to({page: p.next_page, anchor: anchor}.merge(pagination_params), class: 'next_page_link') do 
 end 
 else 
 end 
 end 
 offset + 1 
 offset + p.length 
 p.total_count 
 
 else 
 no_exchanges 
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

  def show
    super
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
 
  add_body_class "discussion", "discussion_by_user#{@exchange.poster_id}", @exchange.labels.map(&:downcase)
  add_body_class 'last_page' if @posts.last_page?
  @page_title = @exchange.title
  previous_post = nil

 if current_user? 
 if @exchange.editable_by?(current_user) 
 link_to "Edit", [:edit, @exchange], class: :edit 
 end 
 if current_user.hidden?(@exchange) 
 link_to "Unhide", unhide_discussion_path(@exchange, page: @posts.current_page) 
 else 
 link_to "Hide", hide_discussion_path(@exchange, page: @posts.current_page) 
 end 
 if current_user.following?(@exchange) 
 link_to "Stop following", unfollow_discussion_path(@exchange, page: @posts.current_page) 
 else 
 link_to "Follow", follow_discussion_path(@exchange, page: @posts.current_page) 
 end 
 if current_user.favorite?(@exchange) 
 link_to "Remove Favorite", unfavorite_discussion_path(@exchange, page: @posts.current_page) 
 else 
 link_to "Favorite", favorite_discussion_path(@exchange, page: @posts.current_page) 
 end 
 end 
 if @exchange.labels? 
 @exchange.labels.join(",") 
 end 
 link_to @exchange.title, @exchange, id: 'discussionLink'  
 cache [@exchange, @page] do 
 @exchange.id 
 @exchange.posts_count 
 @exchange.class 
 
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
 
 end 
 link_to "Back to discussions", discussions_path, id: 'back_link' 
 if current_user? && current_user.following?(@exchange) 
 link_to "Back to followed", following_discussions_path 
 end 
 link_to "Top of page", "#top" 
 if @exchange.postable_by?(current_user) 
  form_for([exchange, exchange.posts.new], html: {class: (posts.last_page? ? 'livePost' : nil), "data-preview-url" => polymorphic_path([:preview, exchange, :posts])}) do |f| 
 f.hidden_field(:format, class: "format") 
 f.text_area(
          :body,
          id:                    "compose-body",
          class:                 "rich",
          "data-format-binding"  => ".format",
          "data-formats"         => "markdown html",
          "data-remember-format" => "true"
        ) 
 end 
 napkin_vars = "service=" + polymorphic_path([:drawing, exchange, :posts]) 
 napkin_vars 
 napkin_vars 
 
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

  def new
    @exchange = Discussion.new
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
 
  add_body_class "new_discussion discussion_form"
  @page_title = "New #{@exchange.class.to_s.downcase}"
  if @recipient
    @page_title += " with #{@recipient.username}"
  end

 if @exchange.kind_of?(Conversation) 
 link_to "Conversations", conversations_path 
 if @recipient 
 link_to "New conversation with #{@recipient.username}", new_conversation_with_path(username: @recipient.username) 
 else 
 link_to "New", new_conversation_path 
 end 
 else 
 link_to "Discussions", discussions_path 
 link_to "New", new_discussion_path 
 end 
 form_for @exchange, builder: Sugar::FormBuilder do |f| 
  f.hidden_field :type 
 f.hidden_field(:format, class: "format") 
 if @recipient 
 hidden_field_tag :recipient_id, @recipient.id 
 end 
 f.labelled_text_field :title, class: "text title" 
 f.labelled_text_area :body, id: "compose-body", class: "rich", "data-format-binding" => ".format", "data-formats" => "markdown html", "data-remember-format" => @exchange.new_record? 
 f.labelled_check_box :nsfw 
 if @exchange.closeable_by?(current_user) 
 f.labelled_check_box :closed 
 end 
 if @exchange.kind_of?(Discussion) && current_user.moderator? 
 f.labelled_check_box :sticky 
 end 
 if @exchange.kind_of?(Discussion) && current_user.trusted? 
 f.labelled_check_box :trusted 
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

  def create
    @exchange = Discussion.create(exchange_params.merge(poster: current_user))
    if @exchange.valid?
      redirect_to @exchange
    else
      flash.now[:notice] = "Could not save your discussion! " +
        "Please make sure all required fields are filled in."
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
 
  add_body_class "new_discussion discussion_form"
  @page_title = "New #{@exchange.class.to_s.downcase}"
  if @recipient
    @page_title += " with #{@recipient.username}"
  end

 if @exchange.kind_of?(Conversation) 
 link_to "Conversations", conversations_path 
 if @recipient 
 link_to "New conversation with #{@recipient.username}", new_conversation_with_path(username: @recipient.username) 
 else 
 link_to "New", new_conversation_path 
 end 
 else 
 link_to "Discussions", discussions_path 
 link_to "New", new_discussion_path 
 end 
 form_for @exchange, builder: Sugar::FormBuilder do |f| 
  f.hidden_field :type 
 f.hidden_field(:format, class: "format") 
 if @recipient 
 hidden_field_tag :recipient_id, @recipient.id 
 end 
 f.labelled_text_field :title, class: "text title" 
 f.labelled_text_area :body, id: "compose-body", class: "rich", "data-format-binding" => ".format", "data-formats" => "markdown html", "data-remember-format" => @exchange.new_record? 
 f.labelled_check_box :nsfw 
 if @exchange.closeable_by?(current_user) 
 f.labelled_check_box :closed 
 end 
 if @exchange.kind_of?(Discussion) && current_user.moderator? 
 f.labelled_check_box :sticky 
 end 
 if @exchange.kind_of?(Discussion) && current_user.trusted? 
 f.labelled_check_box :trusted 
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
  end

  def edit
    super
  end

  def update
    super
  end

  def follow
    DiscussionRelationship.define(current_user, @exchange, following: true)
    redirect_to discussion_url(@exchange, page: params[:page])
  end

  def unfollow
    DiscussionRelationship.define(current_user, @exchange, following: false)
    redirect_to discussions_url
  end

  def favorite
    DiscussionRelationship.define(current_user, @exchange, favorite: true)
    redirect_to discussion_url(@exchange, page: params[:page])
  end

  def unfavorite
    DiscussionRelationship.define(current_user, @exchange, favorite: false)
    redirect_to discussions_url
  end

  def hide
    DiscussionRelationship.define(current_user, @exchange, hidden: true)
    redirect_to discussions_url
  end

  def unhide
    DiscussionRelationship.define(current_user, @exchange, hidden: false)
    redirect_to discussion_url(@exchange, page: params[:page])
  end

  private

  def exchange_params
    discussion_params = params.require(:discussion)
    if current_user.moderator?
      discussion_params.permit(
        :title, :body, :format, :nsfw, :closed, :trusted, :sticky
      )
    elsif current_user.trusted?
      discussion_params.permit(
        :title, :body, :format, :nsfw, :closed, :trusted
      )
    else
      discussion_params.permit(
        :title, :body, :format, :nsfw, :closed
      )
    end
  end

  def find_exchange
    @exchange = Exchange.find(params[:id])

    unless @exchange.is_a?(Discussion)
      redirect_to @exchange
      return
    end

    unless @exchange.viewable_by?(current_user)
      render_error 403
      return
    end
  end
end

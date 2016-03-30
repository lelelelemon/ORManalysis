# encoding: utf-8

require "open-uri"

class UsersController < ApplicationController
  requires_authentication except: [
    :login, :authenticate, :logout, :new, :create
  ]
  requires_user only: [:edit, :update, :update_openid]
  requires_user_admin only: [:grant_invite, :revoke_invites]

  include CreateUserController
  include LoginUsersController
  include OpenidUserController
  include UsersListController

  before_action :load_user,
                only: [
                  :show, :edit,
                  :update, :destroy,
                  :participated, :discussions,
                  :posts, :update_openid,
                  :grant_invite, :revoke_invites,
                  :stats
                ]

  before_action :detect_edit_page, only: [:edit, :update]
  before_action :verify_editable,  only: [:edit, :update, :update_openid]

  respond_to :html, :mobile, :xml, :json

  def show
    respond_with(@user) do |format|
      format.html do
        @posts = @user.
          discussion_posts.
          viewable_by(current_user).
          limit(15).
          page(params[:page]).
          for_view_with_exchange.
          reverse_order
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
 
  add_body_class "user_profile"
  @page_title = "#{@user.username}"

 if current_user? 
 if @user == current_user 
 link_to "Edit your profile", edit_user_path(id: @user.username) 
 elsif current_user.user_admin? 
 link_to "Edit", edit_user_path(id: @user.username) 
 end 
 unless @user == current_user 
 link_to "Start a conversation", new_conversation_with_path(username: @user.username) 
 end 
 end 
 link_to "Users", users_path 
 profile_link(@user) 
 avatar_image_tag @user 
 profile_link(@user, @user.username, class: 'username') 
 if @user.realname? || @user.location? 
 if @user.realname? 
 h @user.realname 
 end 
 if @user.location? 
 h @user.location 
 end 
 end 
 if @user.website? 
 pretty_link(@user.website) 
 end 
 if @user.previous_usernames.any? 
 @user.previous_usernames.uniq.each do |username| 
 username 
 end 
 end 
 if @user.description? 
 render_post @user.description 
 end 
 if !Sugar.config.signups_allowed && current_user? && current_user.user_admin? && !@user.user_admin? 
 @user.available_invites 
 link_to "Grant one", grant_invite_user_path(id: @user.username), method: :post 
 link_to "revoke all", revoke_invites_user_path(id: @user.username), confirm: 'Are you sure you want to revoke all invites?', method: :post 
 end 
 if @user.discussions.viewable_by(current_user).any? 
 link_to "View discussions", discussions_user_path(id: @user.username) 
 @user.discussions.viewable_by(current_user).count 
 end 
 if @user.participated_discussions.viewable_by(current_user).any? 
 link_to "View participated discussions", participated_user_path(id: @user.username) 
 @user.participated_discussions.viewable_by(current_user).count 
 end 
 if @user.discussion_posts.viewable_by(current_user).any? 
 link_to "View posts", posts_user_path(id: @user.username) 
 @user.discussion_posts.viewable_by(current_user).count 
 end 
 unless !current_user? || @user == current_user 
 link_to "Start a conversation with #{@user.username}", new_conversation_with_path(username: @user.username) 
 end 
 if @user.birthday? 
 @user.birthday.strftime("%b %d") 
 end 
 time_tag @user.created_at, class: 'relative' 
 if @user.inviter 
 profile_link(@user.inviter) 
 end 
 @user.online? ? "<strong>Online now</strong>".html_safe : time_tag(@user.last_active, class: 'relative') 
 if @user.banned? 
 @user.username 
 elsif @user.admin? 
 @user.username 
 end 
 if @user.gtalk? 
 link_to @user.gtalk, "gtalk:chat?jid=#{CGI.escape(@user.gtalk)}" 
 end 
 if @user.msn? 
 @user.msn 
 end 
 if @user.aim? 
 link_to @user.aim, "aim:GoIM?screenname=#{CGI.escape(@user.aim)}" 
 end 
 if @user.instagram? 
 @user.instagram 
 end 
 if @user.twitter? 
 link_to "@#{@user.twitter}", "http://twitter.com/#{@user.twitter}", class: 'username' 
 end 
 if @user.gamertag? || @user.sony? || @user.nintendo? || @user.steam? || @user.battlenet 
 if @user.gamertag? 
 @user.gamertag 
 end 
 if @user.sony? 
 @user.sony 
 @user.sony 
 end 
 if @user.nintendo? 
 @user.nintendo 
 @user.nintendo 
 end 
 if @user.steam? 
 @user.steam 
 @user.steam 
 end 
 if @user.steam? 
 @user.battlenet 
 end 
 end 
 if @user.flickr? 
 link_to "Photos on Flickr", "http://www.flickr.com/photos/#{@user.flickr}", id: 'flickrProfileURL' 
 end 
 if @user.last_fm? 
 link_to @user.last_fm, "http://www.last.fm/user/#{@user.last_fm}" 
 @user.last_fm 
 @user.last_fm 
 @user.last_fm 
 end 
 if @user.invitees.count > 0 
 @user.username 
 @user.invitees.count 
 @user.invitees.each do |invitee| 
 profile_link(invitee) 
 time_tag invitee.created_at, class: 'relative' 
 end 
 end 
 if @posts && @posts.length > 0 
 cache [@user, 'profile/posts', current_user.try(&:trusted?)] do 
 
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
 elsif current_user? && @user == current_user 
 Sugar.config.forum_name 
 link_to "check out some discussions", discussions_path 
 link_to "edit your profile", edit_user_path(id: @user.username) 
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

  def discussions
    @discussions = @user.
      discussions.
      viewable_by(current_user).
      page(params[:page]).
      for_view
    respond_with_exchanges(@discussions)
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
 
  add_body_class "created_by discussions"
  @page_title = "#{@user.username}'s Discussions"

 link_to "New Discussion +", new_discussion_path, class: :create 
 link_to "Users", users_path 
 profile_link(@user) 
 link_to "Discussions", discussions_user_path(id: @user.username) 
 
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

  def participated
    @section = :participated if @user == current_user
    @discussions = @user.
      participated_discussions.
      viewable_by(current_user).
      page(params[:page]).
      for_view
    respond_with_exchanges(@discussions)
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
 
  add_body_class "participated discussions"
  @page_title = "#{@user.username}'s Participated Discussions"

 
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

  def posts
    @posts = @user.
      discussion_posts.
      viewable_by(current_user).
      page(params[:page]).
      for_view_with_exchange.
      reverse_order
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
 
  add_body_class "posts"
  @page_title = "#{@user.username}'s Posts"

 link_to "Users", users_path 
 profile_link(@user) 
 link_to "Posts", posts_user_path(id: @user.username) 
 if @posts 
 
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

  def stats
    @posts_per_week = Post.find_by_sql(
      "SELECT COUNT(*) AS post_count, YEAR(created_at) AS year, " +
        "WEEK(created_at) AS week " +
        "FROM posts " +
        "WHERE user_id = #{@user.id} " +
        "GROUP BY YEAR(created_at), WEEK(created_at);"
    )
    @max_posts_per_week = @posts_per_week.map { |p| p.post_count.to_i }.max
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
 
  add_body_class "stats"
  @page_title = "#{@user.username}'s Statistics"

 link_to "Users", users_path 
 profile_link(@user) 
 link_to "Statistics", stats_user_path(id: @user.username) 
 image_tag "http://chart.apis.google.com/chart?cht=lc&chd=t:#{@posts_per_week.map{|p| p.post_count}.join(',')}&chds=0,#{@max_posts_per_week}&chs=800x200&chxt=y&chxr=0,0,#{@max_posts_per_week}" 
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
 
  add_body_class "edit_user_profile"
  @page_title = t('user.edit.edit_profile')
  @google_maps_api = true

 link_to "Users", users_path 
 profile_link(@user) 
 link_to "Edit", edit_user_path(id: @user.username) 
 ' active' if @page == 'info' 
 link_to t('user.edit.tabs.info'), edit_user_page_path(@user.username, 'info') 
 ' active' if @page == 'services' 
 link_to t('user.edit.tabs.services'), edit_user_page_path(@user.username, 'services') 
 ' active' if @page == 'location' 
 link_to t('user.edit.tabs.location'), edit_user_page_path(@user.username, 'location') 
 ' active' if @page == 'settings' 
 link_to t('user.edit.tabs.settings'), edit_user_page_path(@user.username, 'settings') 
 if current_user == @user 
 ' active' if @page == 'temporary_ban' 
 link_to t('user.edit.tabs.temporary_ban'), edit_user_page_path(@user.username, 'temporary_ban') 
 end 
 if current_user.user_admin? 
 ' active' if @page == 'admin' 
 link_to t('user.edit.tabs.admin'), edit_user_page_path(@user.username, 'admin') 
 end 
 form_for @user, builder: Sugar::FormBuilder, multipart: true do |f| 
 hidden_field_tag :page, @page 
 render partial: "edit_#{@page}", locals: {f: f} 
 t('save') 
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

  def update
    respond_with(@user) do |format|
      if @user.update_attributes(user_params)
        if @user == current_user
          current_user.reload
        end
        format.any(:html, :mobile) do
          unless initiate_openid_on_update
            flash[:notice] = "Your changes were saved!"
            redirect_to edit_user_page_url(id: @user.username, page: @page)
          end
        end
      else
        flash.now[:notice] = "Couldn't save your changes, " +
          "did you fill in all required fields?"
        format.any(:html, :mobile) { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 
  add_body_class "edit_user_profile"
  @page_title = t('user.edit.edit_profile')
  @google_maps_api = true

 link_to "Users", users_path 
 profile_link(@user) 
 link_to "Edit", edit_user_path(id: @user.username) 
 ' active' if @page == 'info' 
 link_to t('user.edit.tabs.info'), edit_user_page_path(@user.username, 'info') 
 ' active' if @page == 'services' 
 link_to t('user.edit.tabs.services'), edit_user_page_path(@user.username, 'services') 
 ' active' if @page == 'location' 
 link_to t('user.edit.tabs.location'), edit_user_page_path(@user.username, 'location') 
 ' active' if @page == 'settings' 
 link_to t('user.edit.tabs.settings'), edit_user_page_path(@user.username, 'settings') 
 if current_user == @user 
 ' active' if @page == 'temporary_ban' 
 link_to t('user.edit.tabs.temporary_ban'), edit_user_page_path(@user.username, 'temporary_ban') 
 end 
 if current_user.user_admin? 
 ' active' if @page == 'admin' 
 link_to t('user.edit.tabs.admin'), edit_user_page_path(@user.username, 'admin') 
 end 
 form_for @user, builder: Sugar::FormBuilder, multipart: true do |f| 
 hidden_field_tag :page, @page 
 render partial: "edit_#{@page}", locals: {f: f} 
 t('save') 
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
 }
      end
    end
  end

  def grant_invite
    @user.grant_invite!
    flash[:notice] = "#{@user.username} has been granted one invite."
    redirect_to user_profile_url(id: @user.username)
  end

  def revoke_invites
    @user.revoke_invite!(:all)
    flash[:notice] = "#{@user.username} has been revoked of all invites."
    redirect_to user_profile_url(id: @user.username)
  end

  private

  def load_user
    @user = User.find_by_username(params[:id]) || User.find(params[:id])
  end

  def detect_edit_page
    pages = %w{admin info location services settings temporary_ban}
    @page = params[:page] if pages.include?(params[:page])
    @page ||= "info"
  end

  def verify_editable
    return unless verify_user(
      user: @user,
      user_admin: true,
      redirect: user_profile_url(@user.username)
    )
  end

  def allowed_params
    allowed = [
      :aim, :birthday, :description, :email,
      :facebook_uid, :flickr, :gamertag, :gtalk, :instagram,
      :last_fm, :latitude, :location, :longitude, :mobile_stylesheet_url,
      :mobile_theme, :msn, :notify_on_message, :realname,
      :stylesheet_url, :theme, :time_zone, :twitter, :website,
      :password, :confirm_password, :banned_until, :preferred_format,
      :sony, :nintendo, :steam, :battlenet,
      avatar_attributes: [:file]
    ]
    if current_user?
      if current_user.user_admin?
        allowed += [
          :username, :banned, :user_admin, :moderator,
          :trusted, :available_invites, :status
        ]
      end
      if current_user.admin?
        allowed += [:admin]
      end
    end
    allowed
  end

  def user_params
    params.require(:user).permit(*allowed_params)
  end
end

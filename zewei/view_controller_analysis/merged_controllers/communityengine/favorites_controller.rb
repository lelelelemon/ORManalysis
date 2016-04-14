class FavoritesController < BaseController
  before_action :login_required, :only => [:destroy]
  before_action :find_user, :only => [:show, :index]

  cache_sweeper :favorite_sweeper, :only => [:create, :destroy]

  def create
    @favoritable = params[:favoritable_type].classify.constantize.find(params[:favoritable_id])
    @favorite = Favorite.new(:ip_address => request.remote_ip, :favoritable => @favoritable )
    @favorite.user = current_user || nil
    @favorite.save

    respond_to do |format|
      format.js
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 csrf_meta_tag 
 page_title 
 if @meta 
 @meta.each do |key| 
 key[1] 
 key[0] 
 end 
 end 
 if @rss_title && @rss_url 
 auto_discovery_link_tag(:rss, @rss_url, {:title => @rss_title}) 
 end 
  stylesheet_link_tag 'community_engine' 
 if forum_page? 
 unless @feed_icons.blank? 
 @feed_icons.each do |feed| 
 auto_discovery_link_tag :rss, feed[:url], :title => "Subscribe to ''" 
 end 
 end 
 end 
 yield :head_css 
 
 unless configatron.auth_providers.facebook.key.blank? 
  
 end 
  # .navbar-toggle is used as the toggle for when the responsive design gets narrow and the navbar goes away 
 link_to configatron.community_name, home_path, :class => 'navbar-brand' 
  if params[:controller] == 'categories' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 if Category.all.any? 
 categories_path 
 :categories.l 
 for category in Category.order('name') 
 link_to category.name, category 
 end 
 end 
 
  if current_page?(site_clippings_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :clippings.l, site_clippings_path 
 
  if params[:controller] == 'events' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :events.l, events_path 
 
  if params[:controller] == 'forums' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :forums.l, forums_path 
 
  if current_page?(popular_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :popular.l, popular_path 
 
  if current_page?(users_path) || (params[:controller] == 'users' && !@user.nil? && @user != current_user) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :people.l, users_path 
 
 if @header_tabs.any? 
 for tab in @header_tabs 
 link_to tab.name, tab.url 
 end 
 end 
  if logged_in? 
 if current_user.unread_messages? 
 if params[:controller] == 'messages' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 user_messages_path(current_user) 
 current_user.unread_message_count 
 fa_icon "envelope inverse" 
 end 
 end 
 
  if logged_in? 
 if !current_page?(users_path) && (params[:controller] == 'users' && !@user.nil? && @user == current_user) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 dashboard_user_path(current_user) 
 :logged_in.l + ' ' + current_user.login 
 if current_user.admin? 
 link_to :admin_dashboard.l, admin_dashboard_path 
 end 
 link_to :edit_profile.l, edit_user_path(current_user) 
 link_to :edit_account.l, edit_account_user_path(current_user) 
 link_to :manage_posts.l, manage_user_posts_path(current_user) 
 link_to :inbox.l, user_messages_path(current_user) 
 link_to :my_profile.l, user_path(current_user) 
 link_to :my_blog.l, user_posts_path(current_user) 
 link_to :photo_manager.l, user_photo_manager_index_path(current_user) 
 link_to :my_clippings.l, user_clippings_path(current_user) 
 link_to :my_friends.l, accepted_user_friendships_path(current_user) 
 link_to :log_out.l, logout_path 
 else 
 link_to(:log_in.l, login_path) 
 link_to(:sign_up.l, signup_path) 
 end 
 
 
 render_jumbotron 
 container_title 
  [:notice, :error, :alert].each do |level| 
 unless flash[level].blank? 
 content_tag :p, flash[level] 
 end 
 end 
 
 if @favorite.new_record? 
 @favorite.errors.full_messages.join(', ').html_safe 
 else 
 case @favorite.favoritable.class.to_s.tableize 
 when 'clippings' 
  if favorite = clipping.has_been_favorited_by(current_user, request.remote_ip) 
 link_to favorite_path('clipping', clipping.id, favorite.id), :method => :delete, :class => 'act-via-ajax', :id => 'favorite-clipping-'+clipping.id.to_s if logged_in? do 
 fa_icon("heart") 
 clipping.favorited_count.to_s 
 :in_your_favorites.l 
 end 
 else 
 link_to favorites_path('clipping', clipping.id), :method => :post, :class => 'act-via-ajax', :id => 'favorite-clipping-'+clipping.id.to_s do 
 fa_icon("heart") 
 clipping.favorited_count.to_s 
 end 
 end 
 
 when 'posts' 
 render :partial => 'posts/meta', :locals => {:post => @favorite.favoritable} 
 end 
 end 
  render_widgets 
 
 if show_footer_content? 
 image_tag 'spinner.gif', :plugin => 'community_engine' 
 :loading_recent_content.l 
 end 
  :home.l 
 if !logged_in? 
 link_to :log_in.l, login_path 
 else 
 :log_out.l 
 end 
 Page.all.each do |page| 
 if (logged_in? ) 
 link_to page.title, pages_path(page) 
 end 
 end 
 if @rss_title && @rss_url 
 link_to :rss.l, @rss_url, {:title => @rss_title} 
 end 
 
 :community_tagline.l 
  javascript_include_tag 'community_engine' 
 tiny_mce_init_if_needed 
 if show_footer_content? 
 end 
 
 yield :end_javascript 

end

  end

  def destroy
    @favorite = current_user.favorites.find(params[:id])
    @favorite.destroy

    respond_to do |format|
      format.js
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 csrf_meta_tag 
 page_title 
 if @meta 
 @meta.each do |key| 
 key[1] 
 key[0] 
 end 
 end 
 if @rss_title && @rss_url 
 auto_discovery_link_tag(:rss, @rss_url, {:title => @rss_title}) 
 end 
  stylesheet_link_tag 'community_engine' 
 if forum_page? 
 unless @feed_icons.blank? 
 @feed_icons.each do |feed| 
 auto_discovery_link_tag :rss, feed[:url], :title => "Subscribe to ''" 
 end 
 end 
 end 
 yield :head_css 
 
 unless configatron.auth_providers.facebook.key.blank? 
  
 end 
  # .navbar-toggle is used as the toggle for when the responsive design gets narrow and the navbar goes away 
 link_to configatron.community_name, home_path, :class => 'navbar-brand' 
  if params[:controller] == 'categories' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 if Category.all.any? 
 categories_path 
 :categories.l 
 for category in Category.order('name') 
 link_to category.name, category 
 end 
 end 
 
  if current_page?(site_clippings_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :clippings.l, site_clippings_path 
 
  if params[:controller] == 'events' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :events.l, events_path 
 
  if params[:controller] == 'forums' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :forums.l, forums_path 
 
  if current_page?(popular_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :popular.l, popular_path 
 
  if current_page?(users_path) || (params[:controller] == 'users' && !@user.nil? && @user != current_user) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :people.l, users_path 
 
 if @header_tabs.any? 
 for tab in @header_tabs 
 link_to tab.name, tab.url 
 end 
 end 
  if logged_in? 
 if current_user.unread_messages? 
 if params[:controller] == 'messages' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 user_messages_path(current_user) 
 current_user.unread_message_count 
 fa_icon "envelope inverse" 
 end 
 end 
 
  if logged_in? 
 if !current_page?(users_path) && (params[:controller] == 'users' && !@user.nil? && @user == current_user) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 dashboard_user_path(current_user) 
 :logged_in.l + ' ' + current_user.login 
 if current_user.admin? 
 link_to :admin_dashboard.l, admin_dashboard_path 
 end 
 link_to :edit_profile.l, edit_user_path(current_user) 
 link_to :edit_account.l, edit_account_user_path(current_user) 
 link_to :manage_posts.l, manage_user_posts_path(current_user) 
 link_to :inbox.l, user_messages_path(current_user) 
 link_to :my_profile.l, user_path(current_user) 
 link_to :my_blog.l, user_posts_path(current_user) 
 link_to :photo_manager.l, user_photo_manager_index_path(current_user) 
 link_to :my_clippings.l, user_clippings_path(current_user) 
 link_to :my_friends.l, accepted_user_friendships_path(current_user) 
 link_to :log_out.l, logout_path 
 else 
 link_to(:log_in.l, login_path) 
 link_to(:sign_up.l, signup_path) 
 end 
 
 
 render_jumbotron 
 container_title 
  [:notice, :error, :alert].each do |level| 
 unless flash[level].blank? 
 content_tag :p, flash[level] 
 end 
 end 
 
 case @favorite.favoritable.class.to_s.tableize 
 when 'clippings' 
  if favorite = clipping.has_been_favorited_by(current_user, request.remote_ip) 
 link_to favorite_path('clipping', clipping.id, favorite.id), :method => :delete, :class => 'act-via-ajax', :id => 'favorite-clipping-'+clipping.id.to_s if logged_in? do 
 fa_icon("heart") 
 clipping.favorited_count.to_s 
 :in_your_favorites.l 
 end 
 else 
 link_to favorites_path('clipping', clipping.id), :method => :post, :class => 'act-via-ajax', :id => 'favorite-clipping-'+clipping.id.to_s do 
 fa_icon("heart") 
 clipping.favorited_count.to_s 
 end 
 end 
 
 when 'posts' 
 render :partial => 'posts/meta', :locals => {:post => @favorite.favoritable} 
 end 
  render_widgets 
 
 if show_footer_content? 
 image_tag 'spinner.gif', :plugin => 'community_engine' 
 :loading_recent_content.l 
 end 
  :home.l 
 if !logged_in? 
 link_to :log_in.l, login_path 
 else 
 :log_out.l 
 end 
 Page.all.each do |page| 
 if (logged_in? ) 
 link_to page.title, pages_path(page) 
 end 
 end 
 if @rss_title && @rss_url 
 link_to :rss.l, @rss_url, {:title => @rss_title} 
 end 
 
 :community_tagline.l 
  javascript_include_tag 'community_engine' 
 tiny_mce_init_if_needed 
 if show_footer_content? 
 end 
 
 yield :end_javascript 

end

  end

  def show
    @favorite = @user.favorites.find(params[:id])
  end

  def index
    @favorites = Favorite.recent.by_user(@user).page(params[:page])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 csrf_meta_tag 
 page_title 
 if @meta 
 @meta.each do |key| 
 key[1] 
 key[0] 
 end 
 end 
 if @rss_title && @rss_url 
 auto_discovery_link_tag(:rss, @rss_url, {:title => @rss_title}) 
 end 
  stylesheet_link_tag 'community_engine' 
 if forum_page? 
 unless @feed_icons.blank? 
 @feed_icons.each do |feed| 
 auto_discovery_link_tag :rss, feed[:url], :title => "Subscribe to ''" 
 end 
 end 
 end 
 yield :head_css 
 
 unless configatron.auth_providers.facebook.key.blank? 
  
 end 
  # .navbar-toggle is used as the toggle for when the responsive design gets narrow and the navbar goes away 
 link_to configatron.community_name, home_path, :class => 'navbar-brand' 
  if params[:controller] == 'categories' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 if Category.all.any? 
 categories_path 
 :categories.l 
 for category in Category.order('name') 
 link_to category.name, category 
 end 
 end 
 
  if current_page?(site_clippings_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :clippings.l, site_clippings_path 
 
  if params[:controller] == 'events' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :events.l, events_path 
 
  if params[:controller] == 'forums' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :forums.l, forums_path 
 
  if current_page?(popular_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :popular.l, popular_path 
 
  if current_page?(users_path) || (params[:controller] == 'users' && !@user.nil? && @user != current_user) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :people.l, users_path 
 
 if @header_tabs.any? 
 for tab in @header_tabs 
 link_to tab.name, tab.url 
 end 
 end 
  if logged_in? 
 if current_user.unread_messages? 
 if params[:controller] == 'messages' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 user_messages_path(current_user) 
 current_user.unread_message_count 
 fa_icon "envelope inverse" 
 end 
 end 
 
  if logged_in? 
 if !current_page?(users_path) && (params[:controller] == 'users' && !@user.nil? && @user == current_user) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 dashboard_user_path(current_user) 
 :logged_in.l + ' ' + current_user.login 
 if current_user.admin? 
 link_to :admin_dashboard.l, admin_dashboard_path 
 end 
 link_to :edit_profile.l, edit_user_path(current_user) 
 link_to :edit_account.l, edit_account_user_path(current_user) 
 link_to :manage_posts.l, manage_user_posts_path(current_user) 
 link_to :inbox.l, user_messages_path(current_user) 
 link_to :my_profile.l, user_path(current_user) 
 link_to :my_blog.l, user_posts_path(current_user) 
 link_to :photo_manager.l, user_photo_manager_index_path(current_user) 
 link_to :my_clippings.l, user_clippings_path(current_user) 
 link_to :my_friends.l, accepted_user_friendships_path(current_user) 
 link_to :log_out.l, logout_path 
 else 
 link_to(:log_in.l, login_path) 
 link_to(:sign_up.l, signup_path) 
 end 
 
 
 render_jumbotron 
 container_title 
  [:notice, :error, :alert].each do |level| 
 unless flash[level].blank? 
 content_tag :p, flash[level] 
 end 
 end 
 
 @page_title = "'s "+:favorites.l 
 @favorites.each do |f| 
  case favorite.favoritable.class.to_s.tableize 
 when 'clippings' 
   if favorite = clipping.has_been_favorited_by(current_user, request.remote_ip) 
 link_to favorite_path('clipping', clipping.id, favorite.id), :method => :delete, :class => 'act-via-ajax', :id => 'favorite-clipping-'+clipping.id.to_s if logged_in? do 
 fa_icon("heart") 
 clipping.favorited_count.to_s 
 :in_your_favorites.l 
 end 
 else 
 link_to favorites_path('clipping', clipping.id), :method => :post, :class => 'act-via-ajax', :id => 'favorite-clipping-'+clipping.id.to_s do 
 fa_icon("heart") 
 clipping.favorited_count.to_s 
 end 
 end 
 
 h(truncate_words(clipping.description)) 
 link_to image_tag( clipping.image_uri(:medium)), user_clipping_url(clipping.user, clipping), :class => 'thumbnail' 
 if clipping.user = current_user 
 link_to :show.l, [current_user, clipping], :class => 'btn btn-xs btn-default' 
 link_to :edit.l, edit_user_clipping_path(current_user, clipping), :class => 'btn btn-xs btn-warning' 
 link_to :delete.l, [current_user, clipping], :method => 'delete', data: { confirm: :are_you_sure.l }, :class => 'btn btn-xs btn-danger' 
 end 
 
 when 'posts' 
  link_to post.title, user_post_path(post.user, post) 
 link_to :by.l(:login => post.user.login), user_path(post.user) 
 link_to image_tag(post.image_for_excerpt), user_post_path(post.user, post) 
 truncate_words(post.post, 7, '...' ) 
 link_to :more.l, user_post_path(post.user, post) 
 
 end 
 
 end 
 paginate @favorites, :theme => 'bootstrap' 
  render_widgets 
 
 if show_footer_content? 
 image_tag 'spinner.gif', :plugin => 'community_engine' 
 :loading_recent_content.l 
 end 
  :home.l 
 if !logged_in? 
 link_to :log_in.l, login_path 
 else 
 :log_out.l 
 end 
 Page.all.each do |page| 
 if (logged_in? ) 
 link_to page.title, pages_path(page) 
 end 
 end 
 if @rss_title && @rss_url 
 link_to :rss.l, @rss_url, {:title => @rss_title} 
 end 
 
 :community_tagline.l 
  javascript_include_tag 'community_engine' 
 tiny_mce_init_if_needed 
 if show_footer_content? 
 end 
 
 yield :end_javascript 

end

  end


end

class ForumsController < BaseController
  before_action :admin_required, :except => [:index, :show]

  uses_tiny_mce do    
    {:options => configatron.default_mce_options}
  end
  
  def index
    @forums = Forum.order("position")
    respond_to do |format|
      format.html
      format.xml { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 
 @meta = {} 
 @section = 'forums' 
 @page_title = :forums.l 
 link_to :recent_posts.l, recent_forum_posts_path 
 recent_forum_posts_path(:format => 'rss') 
 fa_icon "rss" 
 number_with_delimiter(Topic.count) 
 "," 
 number_with_delimiter(SbPost.count) 
 "," 
 number_with_delimiter(User.where("sb_posts_count>0").count) 
 :voices.l 
 :forum.l 
 :last_post.l 
 if admin? 
 :actions.l 
 end 
 for forum in @forums do 
 link_to h(forum.name), forum_path(forum), :class => "title" 
 raw forum.description_html 
 unless forum.topics_count.zero? 
 number_with_delimiter(forum.topics_count) 
 :topics.l 
 number_with_delimiter(forum.sb_posts_count) 
 :posts.l 
 end 
 if recent_forum_activity(forum) 
 fa_icon "fire inverse" 
 end 
 if forum.sb_posts.last 
 time_ago_in_words(forum.sb_posts.last.created_at) 
 if forum.sb_posts.last.user 
 :by.l :login => forum.sb_posts.last.user.display_name 
 end 
 link_to :view.l, forum_topic_path(:forum_id => forum, :id => forum.sb_posts.last.topic_id, :page => forum.sb_posts.last.topic.last_page, :anchor => forum.sb_posts.last.dom_id) 
 end 
 if admin? 
 link_to :show.l, forum_path(forum), :class => 'btn btn-default' 
 link_to :edit.l, edit_forum_path(forum), :class => 'btn btn-warning' 
 link_to :delete.l, forum_path(forum), :method => 'delete', data: { confirm: :are_you_sure.l }, :class => 'btn btn-danger' 
 end 
 end 
 if admin? 
 link_to :new_forum.l, new_forum_path, :class => 'btn btn-success' 
 end 
 online_users = User.currently_online 
 unless online_users.empty? 
 unless online_users.empty? 
 :users_online.l 
 online_users.map{ |u| link_to u.login, user_path(u) }.join(", ").html_safe 
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
 }
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
 
 @meta = {} 
 @section = 'forums' 
 @page_title = :forums.l 
 link_to :recent_posts.l, recent_forum_posts_path 
 recent_forum_posts_path(:format => 'rss') 
 fa_icon "rss" 
 number_with_delimiter(Topic.count) 
 "," 
 number_with_delimiter(SbPost.count) 
 "," 
 number_with_delimiter(User.where("sb_posts_count>0").count) 
 :voices.l 
 :forum.l 
 :last_post.l 
 if admin? 
 :actions.l 
 end 
 for forum in @forums do 
 link_to h(forum.name), forum_path(forum), :class => "title" 
 raw forum.description_html 
 unless forum.topics_count.zero? 
 number_with_delimiter(forum.topics_count) 
 :topics.l 
 number_with_delimiter(forum.sb_posts_count) 
 :posts.l 
 end 
 if recent_forum_activity(forum) 
 fa_icon "fire inverse" 
 end 
 if forum.sb_posts.last 
 time_ago_in_words(forum.sb_posts.last.created_at) 
 if forum.sb_posts.last.user 
 :by.l :login => forum.sb_posts.last.user.display_name 
 end 
 link_to :view.l, forum_topic_path(:forum_id => forum, :id => forum.sb_posts.last.topic_id, :page => forum.sb_posts.last.topic.last_page, :anchor => forum.sb_posts.last.dom_id) 
 end 
 if admin? 
 link_to :show.l, forum_path(forum), :class => 'btn btn-default' 
 link_to :edit.l, edit_forum_path(forum), :class => 'btn btn-warning' 
 link_to :delete.l, forum_path(forum), :method => 'delete', data: { confirm: :are_you_sure.l }, :class => 'btn btn-danger' 
 end 
 end 
 if admin? 
 link_to :new_forum.l, new_forum_path, :class => 'btn btn-success' 
 end 
 online_users = User.currently_online 
 unless online_users.empty? 
 unless online_users.empty? 
 :users_online.l 
 online_users.map{ |u| link_to u.login, user_path(u) }.join(", ").html_safe 
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

  def show
    @forum = Forum.find(params[:id])
    respond_to do |format|
      format.html do
        # keep track of when we last viewed this forum for activity indicators
        (session[:forums] ||= {})[@forum.id] = Time.now.utc if logged_in?

        @topics = @forum.topics.includes(:replied_by_user).order('sticky DESC, replied_at DESC').page(params[:page]).per(20)
      end
      
      format.xml do
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
 
 @meta = {} 
 @section = 'forums' 
 @page_title = @forum.name 
 if admin? 
 link_to :back.l, forums_path, :class => 'btn btn-default' 
 link_to :edit.l, edit_forum_path(@forum), :class => 'btn btn-warning' 
 link_to :delete.l, forum_path(@forum), :method => 'delete', data: { confirm: :are_you_sure.l }, :class => 'btn btn-danger' 
 end 
 unless @forum.description.blank? 
 @forum.description_html.html_safe 
 end 
 forum_sb_posts_path(@forum, :format => :rss) 
 fa_icon "rss" 
 pluralize @forum.topics_count, :topic.l 
 pluralize @forum.sb_posts_count, :post.l 
 if @forum.moderators.any? 
 :moderators.l 
 @forum.moderators.each do |user| 
 link_to user.display_name, user_path(user) 
 end 
 end 
 unless @topics.empty? 
 :topics.l 
 :posts.l 
 :view_count.l 
 :last_post.l 
 for topic in @topics 
 icon, color, post = icon_and_color_and_post_for topic 
 if recent_topic_activity(topic) 
 fa_icon "fire inverse" 
 end 
 if topic.sticky? 
 link_to h(topic.title), forum_topic_path(@forum, topic), :class => "entry-title", :rel => "bookmark" 
 fa_icon "thumb-tack fw" 
 else 
 link_to h(topic.title), forum_topic_path(@forum, topic), :class => "entry-title", :rel => "bookmark" 
 end 
 if topic.paged? 
 link_to :last.l, forum_topic_path(:forum_id => @forum, :id => topic, :page => topic.last_page) 
 end 
 if topic.locked? 
 fa_icon "lock fw" 
 end 
 topic.sb_posts_count 
 number_with_delimiter(topic.views) 
 end 
 end 
 time_ago_in_words(topic.replied_at) 
 :by.l :login => topic.replied_by_user.display_name 
 link_to :view.l, forum_topic_path(:forum_id => @forum, :id => topic, :page => topic.last_page, :anchor => "posts-") 
 paginate @topics, :theme => 'bootstrap' 
 if logged_in? 
 link_to fa_icon('plus', :text => :post_a_new_topic.l.downcase.capitalize), new_forum_topic_path(@forum) 
 else 
 link_to fa_icon('plus', :text => :log_in_to_create_a_new_topic.l.downcase.capitalize), new_forum_topic_path(@forum) 
 end 
 if @topics.size < 10 
 @related = Post.limit(10).tagged_with(@forum.tag_list, :any => true) 
 unless @related.empty? 
 :this_forum_is_still_getting_started.l 
 :comments.l 
 :view_count.l 
 :author.l 
 @related.each do |post| 
  fa_icon "comment" 
 link_to h(post.title), user_post_path(post.user, post), :class => "entry-title", :rel => "bookmark", :target => '_blank' 
 post.comments.count 
 number_with_delimiter(post.view_count) 
 h(post.user.display_name) 
 
 end 
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
 
 @meta = {} 
 @section = 'forums' 
 @page_title = @forum.name 
 if admin? 
 link_to :back.l, forums_path, :class => 'btn btn-default' 
 link_to :edit.l, edit_forum_path(@forum), :class => 'btn btn-warning' 
 link_to :delete.l, forum_path(@forum), :method => 'delete', data: { confirm: :are_you_sure.l }, :class => 'btn btn-danger' 
 end 
 unless @forum.description.blank? 
 @forum.description_html.html_safe 
 end 
 forum_sb_posts_path(@forum, :format => :rss) 
 fa_icon "rss" 
 pluralize @forum.topics_count, :topic.l 
 pluralize @forum.sb_posts_count, :post.l 
 if @forum.moderators.any? 
 :moderators.l 
 @forum.moderators.each do |user| 
 link_to user.display_name, user_path(user) 
 end 
 end 
 unless @topics.empty? 
 :topics.l 
 :posts.l 
 :view_count.l 
 :last_post.l 
 for topic in @topics 
 icon, color, post = icon_and_color_and_post_for topic 
 if recent_topic_activity(topic) 
 fa_icon "fire inverse" 
 end 
 if topic.sticky? 
 link_to h(topic.title), forum_topic_path(@forum, topic), :class => "entry-title", :rel => "bookmark" 
 fa_icon "thumb-tack fw" 
 else 
 link_to h(topic.title), forum_topic_path(@forum, topic), :class => "entry-title", :rel => "bookmark" 
 end 
 if topic.paged? 
 link_to :last.l, forum_topic_path(:forum_id => @forum, :id => topic, :page => topic.last_page) 
 end 
 if topic.locked? 
 fa_icon "lock fw" 
 end 
 topic.sb_posts_count 
 number_with_delimiter(topic.views) 
 end 
 end 
 time_ago_in_words(topic.replied_at) 
 :by.l :login => topic.replied_by_user.display_name 
 link_to :view.l, forum_topic_path(:forum_id => @forum, :id => topic, :page => topic.last_page, :anchor => "posts-") 
 paginate @topics, :theme => 'bootstrap' 
 if logged_in? 
 link_to fa_icon('plus', :text => :post_a_new_topic.l.downcase.capitalize), new_forum_topic_path(@forum) 
 else 
 link_to fa_icon('plus', :text => :log_in_to_create_a_new_topic.l.downcase.capitalize), new_forum_topic_path(@forum) 
 end 
 if @topics.size < 10 
 @related = Post.limit(10).tagged_with(@forum.tag_list, :any => true) 
 unless @related.empty? 
 :this_forum_is_still_getting_started.l 
 :comments.l 
 :view_count.l 
 :author.l 
 @related.each do |post| 
  fa_icon "comment" 
 link_to h(post.title), user_post_path(post.user, post), :class => "entry-title", :rel => "bookmark", :target => '_blank' 
 post.comments.count 
 number_with_delimiter(post.view_count) 
 h(post.user.display_name) 
 
 end 
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

  def new
    @forum = Forum.new
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
 
 @page_title = :new_forum.l 
 link_to :back.l, forums_path, :class => 'btn btn-default' 
  bootstrap_form_for @forum, :layout => :horizontal do |f| 
 f.text_field :name 
 f.number_field :position 
 f.text_field :tag_list, :autocomplete => "off", :help => :optional_keywords_describing_this_forum_separated_by_commas.l 
  
 f.text_area :description, :rows => 7, :class => "rich_text_editor" 
 f.form_group :submit_group do 
 f.primary :save.l 
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
 
 tag_auto_complete_field 'forum_tag_list', {} 

end

  end
  
  def create
    @forum = Forum.new(forum_params)
    @forum.tag_list = params[:tag_list] || ''
    @forum.save!
    respond_to do |format|
      format.html { redirect_to forums_path }
      format.xml  { head :created, :location => forum_url(:id => @forum, :format => :xml) }
    end
  end

  def edit
    @forum = Forum.find(params[:id])
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
 
 @page_title = :edit_forum.l 
 link_to :back.l, forums_path, :class => 'btn btn-default' 
 link_to :show.l, forum_path(@forum), :class => 'btn btn-primary' 
 link_to :delete.l, forum_path(@forum), :method => 'delete', data: { confirm: :are_you_sure.l }, :class => 'btn btn-danger' 
  bootstrap_form_for @forum, :layout => :horizontal do |f| 
 f.text_field :name 
 f.number_field :position 
 f.text_field :tag_list, :autocomplete => "off", :help => :optional_keywords_describing_this_forum_separated_by_commas.l 
  
 f.text_area :description, :rows => 7, :class => "rich_text_editor" 
 f.form_group :submit_group do 
 f.primary :save.l 
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
 
 tag_auto_complete_field 'forum_tag_list', {} 

end

  end

  def update
    @forum = Forum.find(params[:id])
    @forum.tag_list = params[:tag_list] || ''
    @forum.update_attributes!(forum_params)
    respond_to do |format|
      format.html { redirect_to forums_path }
      format.xml  { head 200 }
    end
  end
  
  def destroy
    @forum = Forum.find(params[:id])
    @forum.destroy
    respond_to do |format|
      format.html { redirect_to forums_path }
      format.xml  { head 200 }
    end
  end
  
  private

  def forum_params
    params[:forum].permit(:name, :position, :description)
  end
    
end

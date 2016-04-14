class AlbumsController < BaseController
  include Viewable
  before_action :login_required, :except => [:show]
  before_action :find_user, :only => [:new, :edit, :index]
  before_action :require_current_user, :only => [:new, :edit, :update, :destroy, :create]

  uses_tiny_mce do
    {:only => [:show], :options => configatron.simple_mce_options}
  end


  # GET /albums/1
  # GET /albums/1.xml
  def show
    @album = Album.find(params[:id])
    update_view_count(@album) if current_user && current_user.id != @album.user_id
    @album_photos = @album.photos.page(params[:page]).per(10)
   
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 
 @page_title = @album.title 
  widget do 
 :author.l 
 link_to tag(:img, :src => user.avatar_photo_url(:medium), "alt"=>"", :class => "img-responsive"), user_path(user), :title => "'s"+ :profile.l 
 link_to user.login, user_path(user), :class => 'url' 
 if user.featured_writer? 
 :featured_writer.l 
 end 
 if user.description 
 truncate_words( user.description, 12, '...') 
 end 
 :member_since.l+" " 
 if user.posts.count == 1 
 link_to :singular_posts.l(:count => user.posts.count), user_posts_path(user) 
 else 
 link_to :plural_posts.l(:count => user.posts.count), user_posts_path(user) 
 end 
 link_to fa_icon('rss', :text => :rss_feed.l), user_posts_path(user, :format => :rss) 
 end 
 
 if @album.user == current_user 
 link_to :back.l, user_photo_manager_index_path(@album.user), :class => 'btn btn-default' 
 link_to :edit.l, edit_user_album_path(@album.user,@album), :class => 'btn btn-warning' 
 link_to :add_photos.l, new_user_album_photo_path(@album.user,@album), :class => 'btn btn-primary' 
 link_to :delete.l, user_album_path(@album.user,@album), data: { confirm: :delete_album_and_photos.l }, :method => :delete, :class => 'btn btn-danger' 
 end 
 h @album.description 
 :photos_of_this_album.l 
 @album_photos.each do |photo| 
 link_to image_tag(photo.photo.url(:thumb)), user_photo_path(photo.user, photo), :class => 'thumbnail' 
 end 
 paginate @album_photos, :theme => 'bootstrap' 
 box :id => 'comments' do 
 :album_comments.l 
 :add_your_comment.l 
  if logged_in? || configatron.allow_anonymous_commenting 
 bootstrap_form_for(:comment, :url => commentable_comments_path(commentable.class.to_s.tableize, commentable), :remote => true, :layout => :horizontal, :html => {:id => 'comment'}) do |f| 
 f.text_area :comment, :rows => 5, :style => 'width: 99%', :class => "rich_text_editor", :help => :comment_character_limit.l 
 if !logged_in? && configatron.recaptcha_pub_key && configatron.recaptcha_priv_key 
 f.text_field :author_name 
 f.text_field :author_email, :required => true 
 f.form_group do 
 f.check_box :notify_by_email, :label => :notify_me_of_follow_ups_via_email.l 
 if commentable.respond_to?(:send_comment_notifications?) && !commentable.send_comment_notifications? 
 :comment_notifications_off.l 
 end 
 end 
 f.text_field :author_url, :label => :comment_web_site_label.l 
 f.form_group do 
 recaptcha_tags :ajax => true 
 end 
 end 
 f.form_group :submit_group do 
 f.primary :add_comment.l, data: { disable_with: "Please wait..." } 
 end 
 end 
 else 
 link_to :log_in_to_leave_a_comment.l, new_commentable_comment_path(commentable.class, commentable.id), :class => 'btn btn-primary' 
 link_to :create_an_account.l, signup_path, :class => 'btn btn-primary' 
 end 
 
  if comment.pending? 
 end 
 if comment.user 
 link_to image_tag(comment.user.avatar_photo_url(:medium), :alt => comment.user.login, :class => "img-responsive"), user_path(comment.user), :rel => 'bookmark', :title => :users_profile.l(:user => comment.user.login), :class => 'list-group-item' 
 user_path(comment.user) 
 fa_icon "hand-o-right fw", :text => comment.user.login 
 commentable_url(comment) 
 fa_icon "calendar" 
 I18n.l(comment.created_at, :format => :short_literal_date) 
 if logged_in? && (current_user.admin? ) 
 link_to fa_icon("pencil-square-o fw", :text => :edit.l), edit_commentable_comment_path(comment.commentable_type, comment.commentable_id, comment), :class => 'edit-via-ajax list-group-item' 
 end 
 if ( comment.can_be_deleted_by(current_user) ) 
 link_to fa_icon("trash-o fw", :text => :delete.l), commentable_comment_path(comment.commentable_type, comment.commentable_id, comment), :method => :delete, 'data-confirm' => :are_you_sure_you_want_to_permanently_delete_this_comment.l, :remote => true, :class => "list-group-item" 
 end 
 comment.comment.html_safe 
 else 
 image_tag(configatron.photo.missing_thumb, :height => '50', :width => '50', :class => "img-responsive") 
 if comment.author_url.blank? 
 h comment.username 
 else 
 link_to fa_icon('hand-o-right', :text => h(comment.username)), h(comment.author_url) 
 end 
 commentable_url(comment) 
 fa_icon "calendar fw" 
 I18n.l(comment.created_at, :format => :short_literal_date) 
 if logged_in? && (current_user.admin? ) 
 link_to fa_icon("pencil-square-o fw", :text => :edit.l), edit_commentable_comment_path(comment.commentable_type, comment.commentable_id, comment), :class => 'edit-via-ajax list-group-item' 
 end 
 if ( comment.can_be_deleted_by(current_user) ) 
 link_to fa_icon("trash-o fw", :text => :delete.l), commentable_comment_path(comment.commentable_type, comment.commentable_id, comment), :method => :delete, 'data-confirm' => :are_you_sure_you_want_to_permanently_delete_this_comment.l, :remote => true, :class => "list-group-item" 
 end 
 comment.comment.html_safe 
 end 
 
 more_comments_links(@album) 
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
 
 @page_title = @album.title 
  widget do 
 :author.l 
 link_to tag(:img, :src => user.avatar_photo_url(:medium), "alt"=>"", :class => "img-responsive"), user_path(user), :title => "'s"+ :profile.l 
 link_to user.login, user_path(user), :class => 'url' 
 if user.featured_writer? 
 :featured_writer.l 
 end 
 if user.description 
 truncate_words( user.description, 12, '...') 
 end 
 :member_since.l+" " 
 if user.posts.count == 1 
 link_to :singular_posts.l(:count => user.posts.count), user_posts_path(user) 
 else 
 link_to :plural_posts.l(:count => user.posts.count), user_posts_path(user) 
 end 
 link_to fa_icon('rss', :text => :rss_feed.l), user_posts_path(user, :format => :rss) 
 end 
 
 if @album.user == current_user 
 link_to :back.l, user_photo_manager_index_path(@album.user), :class => 'btn btn-default' 
 link_to :edit.l, edit_user_album_path(@album.user,@album), :class => 'btn btn-warning' 
 link_to :add_photos.l, new_user_album_photo_path(@album.user,@album), :class => 'btn btn-primary' 
 link_to :delete.l, user_album_path(@album.user,@album), data: { confirm: :delete_album_and_photos.l }, :method => :delete, :class => 'btn btn-danger' 
 end 
 h @album.description 
 :photos_of_this_album.l 
 @album_photos.each do |photo| 
 link_to image_tag(photo.photo.url(:thumb)), user_photo_path(photo.user, photo), :class => 'thumbnail' 
 end 
 paginate @album_photos, :theme => 'bootstrap' 
 box :id => 'comments' do 
 :album_comments.l 
 :add_your_comment.l 
  if logged_in? || configatron.allow_anonymous_commenting 
 bootstrap_form_for(:comment, :url => commentable_comments_path(commentable.class.to_s.tableize, commentable), :remote => true, :layout => :horizontal, :html => {:id => 'comment'}) do |f| 
 f.text_area :comment, :rows => 5, :style => 'width: 99%', :class => "rich_text_editor", :help => :comment_character_limit.l 
 if !logged_in? && configatron.recaptcha_pub_key && configatron.recaptcha_priv_key 
 f.text_field :author_name 
 f.text_field :author_email, :required => true 
 f.form_group do 
 f.check_box :notify_by_email, :label => :notify_me_of_follow_ups_via_email.l 
 if commentable.respond_to?(:send_comment_notifications?) && !commentable.send_comment_notifications? 
 :comment_notifications_off.l 
 end 
 end 
 f.text_field :author_url, :label => :comment_web_site_label.l 
 f.form_group do 
 recaptcha_tags :ajax => true 
 end 
 end 
 f.form_group :submit_group do 
 f.primary :add_comment.l, data: { disable_with: "Please wait..." } 
 end 
 end 
 else 
 link_to :log_in_to_leave_a_comment.l, new_commentable_comment_path(commentable.class, commentable.id), :class => 'btn btn-primary' 
 link_to :create_an_account.l, signup_path, :class => 'btn btn-primary' 
 end 
 
  if comment.pending? 
 end 
 if comment.user 
 link_to image_tag(comment.user.avatar_photo_url(:medium), :alt => comment.user.login, :class => "img-responsive"), user_path(comment.user), :rel => 'bookmark', :title => :users_profile.l(:user => comment.user.login), :class => 'list-group-item' 
 user_path(comment.user) 
 fa_icon "hand-o-right fw", :text => comment.user.login 
 commentable_url(comment) 
 fa_icon "calendar" 
 I18n.l(comment.created_at, :format => :short_literal_date) 
 if logged_in? && (current_user.admin? ) 
 link_to fa_icon("pencil-square-o fw", :text => :edit.l), edit_commentable_comment_path(comment.commentable_type, comment.commentable_id, comment), :class => 'edit-via-ajax list-group-item' 
 end 
 if ( comment.can_be_deleted_by(current_user) ) 
 link_to fa_icon("trash-o fw", :text => :delete.l), commentable_comment_path(comment.commentable_type, comment.commentable_id, comment), :method => :delete, 'data-confirm' => :are_you_sure_you_want_to_permanently_delete_this_comment.l, :remote => true, :class => "list-group-item" 
 end 
 comment.comment.html_safe 
 else 
 image_tag(configatron.photo.missing_thumb, :height => '50', :width => '50', :class => "img-responsive") 
 if comment.author_url.blank? 
 h comment.username 
 else 
 link_to fa_icon('hand-o-right', :text => h(comment.username)), h(comment.author_url) 
 end 
 commentable_url(comment) 
 fa_icon "calendar fw" 
 I18n.l(comment.created_at, :format => :short_literal_date) 
 if logged_in? && (current_user.admin? ) 
 link_to fa_icon("pencil-square-o fw", :text => :edit.l), edit_commentable_comment_path(comment.commentable_type, comment.commentable_id, comment), :class => 'edit-via-ajax list-group-item' 
 end 
 if ( comment.can_be_deleted_by(current_user) ) 
 link_to fa_icon("trash-o fw", :text => :delete.l), commentable_comment_path(comment.commentable_type, comment.commentable_id, comment), :method => :delete, 'data-confirm' => :are_you_sure_you_want_to_permanently_delete_this_comment.l, :remote => true, :class => "list-group-item" 
 end 
 comment.comment.html_safe 
 end 
 
 more_comments_links(@album) 
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
  


  # GET /albums/new
  # GET /albums/new.xml
  def new
    @album = Album.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 
 @page_title= :new_album.l 
 widget do 
 :album_tip.l :community_name => configatron.community_name 
 end 
 link_to :back.l, user_photo_manager_index_path(current_user), :class => 'btn btn-default' 
 'Album Details' 
  if @album.new_record? 
 url = user_albums_path(@user) 
 object = @album 
 button1 = :create_and_add_photos.l 
 button2 = :create_album.l 
 else 
 url = user_album_path(@user, @album) 
 object = [@user, @album] 
 button1 = :edit_and_add_photos.l 
 button2 = :edit_album.l 
 end 
 bootstrap_form_for object, :url => url, :layout => :horizontal do |f| 
 f.text_field :title 
 f.text_area :description 
 hidden_field_tag :go_to 
 f.primary button2, :onclick => "Form.getInputs(this.form, null, 'go_to')[0].value = 'only_create'" 
 f.primary button1 
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
 
 @page_title= :new_album.l 
 widget do 
 :album_tip.l :community_name => configatron.community_name 
 end 
 link_to :back.l, user_photo_manager_index_path(current_user), :class => 'btn btn-default' 
 'Album Details' 
  if @album.new_record? 
 url = user_albums_path(@user) 
 object = @album 
 button1 = :create_and_add_photos.l 
 button2 = :create_album.l 
 else 
 url = user_album_path(@user, @album) 
 object = [@user, @album] 
 button1 = :edit_and_add_photos.l 
 button2 = :edit_album.l 
 end 
 bootstrap_form_for object, :url => url, :layout => :horizontal do |f| 
 f.text_field :title 
 f.text_area :description 
 hidden_field_tag :go_to 
 f.primary button2, :onclick => "Form.getInputs(this.form, null, 'go_to')[0].value = 'only_create'" 
 f.primary button1 
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

  # GET /albums/1/edit
  def edit
    @album = Album.find(params[:id])
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
 
 @page_title = :edit_album.l 
 widget do 
 :album_tip.l :community_name => configatron.community_name 
 end 
 link_to :back.l, user_photo_manager_index_path(current_user), :class => 'btn btn-default' 
 link_to :show.l, user_album_path(current_user, @album), :class => 'btn btn-primary' 
 link_to :add_photos.l, new_user_album_photo_path(@album.user,@album), :class => 'btn btn-primary' 
 link_to :delete.l, user_album_path(current_user, @album), :method => 'delete', data: { confirm: :are_you_sure.l }, :class => 'btn btn-danger' 
 "Album Details" 
  if @album.new_record? 
 url = user_albums_path(@user) 
 object = @album 
 button1 = :create_and_add_photos.l 
 button2 = :create_album.l 
 else 
 url = user_album_path(@user, @album) 
 object = [@user, @album] 
 button1 = :edit_and_add_photos.l 
 button2 = :edit_album.l 
 end 
 bootstrap_form_for object, :url => url, :layout => :horizontal do |f| 
 f.text_field :title 
 f.text_area :description 
 hidden_field_tag :go_to 
 f.primary button2, :onclick => "Form.getInputs(this.form, null, 'go_to')[0].value = 'only_create'" 
 f.primary button1 
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

  # POST /albums
  # POST /albums.xml
  def create
    @album = Album.new(album_params)
    @album.user_id = current_user.id
    
    respond_to do |format|
      if @album.save
        if params[:go_to] == 'only_create'
          flash[:notice] = :album_was_successfully_created.l 
          format.html { redirect_to(user_photo_manager_index_path(current_user)) }       
        else
          format.html { redirect_to(new_user_album_photo_path(current_user, @album)) }
        end
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 
 @page_title= :new_album.l 
 widget do 
 :album_tip.l :community_name => configatron.community_name 
 end 
 link_to :back.l, user_photo_manager_index_path(current_user), :class => 'btn btn-default' 
 'Album Details' 
  if @album.new_record? 
 url = user_albums_path(@user) 
 object = @album 
 button1 = :create_and_add_photos.l 
 button2 = :create_album.l 
 else 
 url = user_album_path(@user, @album) 
 object = [@user, @album] 
 button1 = :edit_and_add_photos.l 
 button2 = :edit_album.l 
 end 
 bootstrap_form_for object, :url => url, :layout => :horizontal do |f| 
 f.text_field :title 
 f.text_area :description 
 hidden_field_tag :go_to 
 f.primary button2, :onclick => "Form.getInputs(this.form, null, 'go_to')[0].value = 'only_create'" 
 f.primary button1 
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
    end
  end

  # patch /albums/1
  # patch /albums/1.xml
  def update
    @album = Album.find(params[:id])

    respond_to do |format|
      if @album.update_attributes(album_params)
        if params[:go_to] == 'only_create'
          flash[:notice] = :album_updated.l
          format.html { redirect_to(user_album_path(current_user, @album)) }
        else
          format.html { redirect_to(new_user_album_photo_path(current_user, @album)) }
        end
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 
 @page_title = :edit_album.l 
 widget do 
 :album_tip.l :community_name => configatron.community_name 
 end 
 link_to :back.l, user_photo_manager_index_path(current_user), :class => 'btn btn-default' 
 link_to :show.l, user_album_path(current_user, @album), :class => 'btn btn-primary' 
 link_to :add_photos.l, new_user_album_photo_path(@album.user,@album), :class => 'btn btn-primary' 
 link_to :delete.l, user_album_path(current_user, @album), :method => 'delete', data: { confirm: :are_you_sure.l }, :class => 'btn btn-danger' 
 "Album Details" 
  if @album.new_record? 
 url = user_albums_path(@user) 
 object = @album 
 button1 = :create_and_add_photos.l 
 button2 = :create_album.l 
 else 
 url = user_album_path(@user, @album) 
 object = [@user, @album] 
 button1 = :edit_and_add_photos.l 
 button2 = :edit_album.l 
 end 
 bootstrap_form_for object, :url => url, :layout => :horizontal do |f| 
 f.text_field :title 
 f.text_area :description 
 hidden_field_tag :go_to 
 f.primary button2, :onclick => "Form.getInputs(this.form, null, 'go_to')[0].value = 'only_create'" 
 f.primary button1 
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
        format.xml  { render :xml => @album.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.xml
  def destroy  
    @album = Album.find(params[:id])
    @album.destroy

    respond_to do |format|
      format.html { redirect_to user_photo_manager_index_path(current_user) }
      format.xml  { head :ok }
    end
  end
  
  def add_photos
    @album = Album.find(params[:id])
  end
  
  def photos_added
    @album = Album.find(params[:id])
    @album.photo_ids = params[:album][:photos_ids].uniq
    redirect_to user_albums_path(current_user)
    flash[:notice] = :album_added_photos.l
  end

  private

  def album_params
    params[:album].permit(:title, :description)
  end
  
end

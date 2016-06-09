class ChannelsController < ApplicationController
  include ApplicationHelper
  
  before_filter :site_authenticate, :except => [:index, :show, :show_by_token_access]
  before_filter :set_user, :except => [:show_by_token_access]
  before_filter :verify_current_user_is_not_blocked, :only => [:index]
  before_filter :set_channel, :only => [:edit, :destroy, :show, :update]
  before_filter :verify_user_owns_channel, :only => [:destroy, :edit, :update]
  before_filter :set_featured_videos, :only => [:edit, :edit_featured_videos, :index, :show]
  before_filter :verify_user_can_access_channel, :only => [:show]
  
  # GET /:username/channels/:id-slug-name-goes-here/edit
  def edit
    @subscribers = @channel.subscribers_as_people.paginate(:page => params[:page], :per_page => 100)
    
    respond_to do |format|
      params[:page].to_i > 1 ? format.js : format.html
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if we_should_show_og_tags && !@video.blank? 
 # Facebook OpenGraph protocol for embedding our video link back to Brevidy 
 public_video_url(:public_token => @video.public_token) 
 @video.title 
 @video.description 
 @video.get_thumbnail_url(@video.selected_thumbnail) 
 public_video_url(:public_token => @video.public_token) 
 else 
 # Standard meta tags 
 end 
 browser_title 
 # Logged In CSS 
 # Site-wide JS 
 javascript_include_tag "https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" 
 javascript_include_tag "player/player.js" 
 javascript_include_tag "http://html5shiv.googlecode.com/svn/trunk/html5.js" 
 # Fav Icon and CSRF meta tag 
 favicon_link_tag 
 csrf_meta_tag 
 get_background_for_user 
 # Top navigation header 
  link_to(image_tag("brevidy_rgb_white.png", :size => "135x35", :alt => "Brevidy - The Soul of Video"), signed_in? ? user_stream_path(current_user) : :root, :class => "brand") 
 video_search_path 
 if signed_in? 
 link_to("Explore", explore_path) 
 link_to("Upload", new_user_video_path(current_user)) 
 link_to("Share a Link", user_share_dialog_path(current_user), :remote => true, "data-method" => "GET") 
 link_to("Invite", user_invitations_path(current_user)) 
 end 
 if signed_in? 
 link_to(user_path(current_user), :class => "dropdown-toggle") do 
 image_tag("", :alt => "", :size => "35x35") 
 current_user.username 
 end 
 link_to("My Channels", user_channels_path(current_user)) 
 link_to("Account Settings", user_account_path(current_user)) 
 link_to("Find People", find_people_path) 
 link_to("Help", "http://getsatisfaction.com/brevidy", :target => "_blank") 
 link_to("Logout", logout_path, :remote => true, "data-method" => "DELETE") 
 else 
 link_to("Explore", explore_path) 
 link_to("Sign up", signup_path) 
 link_to("Login", login_path) 
 end 
 
 # Main container 
 # Lower navigation 
 unless @page_has_infinite_scrolling 
  succeed "  " do 
 link_to("FAQ", faq_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Blog", "http://blog.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Status", "http://status.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Contact", contact_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Terms", tos_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Privacy", privacy_path, :class => "inlinelink") 
 end 
 
 end 
 # GetSatisfaction Feedback Widget & Google Analytics 
  # Google Analytics 
 # GetSatisfaction Code 
 # AddThis script 
 
 # Scroll back to top 

end

  end
  
  # GET /:username/edit_featured_videos
  def edit_featured_videos
    # Do a quick security check to verify user
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if we_should_show_og_tags && !@video.blank? 
 # Facebook OpenGraph protocol for embedding our video link back to Brevidy 
 public_video_url(:public_token => @video.public_token) 
 @video.title 
 @video.description 
 @video.get_thumbnail_url(@video.selected_thumbnail) 
 public_video_url(:public_token => @video.public_token) 
 else 
 # Standard meta tags 
 end 
 browser_title 
 # Logged In CSS 
 # Site-wide JS 
 javascript_include_tag "https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" 
 javascript_include_tag "player/player.js" 
 javascript_include_tag "http://html5shiv.googlecode.com/svn/trunk/html5.js" 
 # Fav Icon and CSRF meta tag 
 favicon_link_tag 
 csrf_meta_tag 
 get_background_for_user 
 # Top navigation header 
  link_to(image_tag("brevidy_rgb_white.png", :size => "135x35", :alt => "Brevidy - The Soul of Video"), signed_in? ? user_stream_path(current_user) : :root, :class => "brand") 
 video_search_path 
 if signed_in? 
 link_to("Explore", explore_path) 
 link_to("Upload", new_user_video_path(current_user)) 
 link_to("Share a Link", user_share_dialog_path(current_user), :remote => true, "data-method" => "GET") 
 link_to("Invite", user_invitations_path(current_user)) 
 end 
 if signed_in? 
 link_to(user_path(current_user), :class => "dropdown-toggle") do 
 image_tag("", :alt => "", :size => "35x35") 
 current_user.username 
 end 
 link_to("My Channels", user_channels_path(current_user)) 
 link_to("Account Settings", user_account_path(current_user)) 
 link_to("Find People", find_people_path) 
 link_to("Help", "http://getsatisfaction.com/brevidy", :target => "_blank") 
 link_to("Logout", logout_path, :remote => true, "data-method" => "DELETE") 
 else 
 link_to("Explore", explore_path) 
 link_to("Sign up", signup_path) 
 link_to("Login", login_path) 
 end 
 
 # Main container 
 # Dark Content Wrapper 
 # Main (White) Content Wrapper 
 link_to "Go back", :back 
 image_tag("okayguy.png", :alt => "Okay", :size => "256x275") 
 # Lower navigation 
 unless @page_has_infinite_scrolling 
  succeed "  " do 
 link_to("FAQ", faq_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Blog", "http://blog.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Status", "http://status.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Contact", contact_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Terms", tos_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Privacy", privacy_path, :class => "inlinelink") 
 end 
 
 end 
 # GetSatisfaction Feedback Widget & Google Analytics 
  # Google Analytics 
 # GetSatisfaction Code 
 # AddThis script 
 
 # Scroll back to top 

end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if we_should_show_og_tags && !@video.blank? 
 # Facebook OpenGraph protocol for embedding our video link back to Brevidy 
 public_video_url(:public_token => @video.public_token) 
 @video.title 
 @video.description 
 @video.get_thumbnail_url(@video.selected_thumbnail) 
 public_video_url(:public_token => @video.public_token) 
 else 
 # Standard meta tags 
 end 
 browser_title 
 # Logged In CSS 
 # Site-wide JS 
 javascript_include_tag "https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" 
 javascript_include_tag "player/player.js" 
 javascript_include_tag "http://html5shiv.googlecode.com/svn/trunk/html5.js" 
 # Fav Icon and CSRF meta tag 
 favicon_link_tag 
 csrf_meta_tag 
 get_background_for_user 
 # Top navigation header 
  link_to(image_tag("brevidy_rgb_white.png", :size => "135x35", :alt => "Brevidy - The Soul of Video"), signed_in? ? user_stream_path(current_user) : :root, :class => "brand") 
 video_search_path 
 if signed_in? 
 link_to("Explore", explore_path) 
 link_to("Upload", new_user_video_path(current_user)) 
 link_to("Share a Link", user_share_dialog_path(current_user), :remote => true, "data-method" => "GET") 
 link_to("Invite", user_invitations_path(current_user)) 
 end 
 if signed_in? 
 link_to(user_path(current_user), :class => "dropdown-toggle") do 
 image_tag("", :alt => "", :size => "35x35") 
 current_user.username 
 end 
 link_to("My Channels", user_channels_path(current_user)) 
 link_to("Account Settings", user_account_path(current_user)) 
 link_to("Find People", find_people_path) 
 link_to("Help", "http://getsatisfaction.com/brevidy", :target => "_blank") 
 link_to("Logout", logout_path, :remote => true, "data-method" => "DELETE") 
 else 
 link_to("Explore", explore_path) 
 link_to("Sign up", signup_path) 
 link_to("Login", login_path) 
 end 
 
 # Main container 
  link_to(user_update_featured_videos_path(current_user, :video_id => featured_video.id), :class => "move-video-to-top",                                                "data-video-id" => "", :remote => true, :method => "PUT") do 
 image_tag("up_arrow.png", :size => "20x10", :alt => "Move to Top") 
 end 
 image_tag(featured_video.get_thumbnail_url(featured_video.selected_thumbnail), :alt => featured_video.title, :size => "190x102") 
 featured_video.title 
 
 # Lower navigation 
 unless @page_has_infinite_scrolling 
  succeed "  " do 
 link_to("FAQ", faq_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Blog", "http://blog.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Status", "http://status.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Contact", contact_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Terms", tos_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Privacy", privacy_path, :class => "inlinelink") 
 end 
 
 end 
 # GetSatisfaction Feedback Widget & Google Analytics 
  # Google Analytics 
 # GetSatisfaction Code 
 # AddThis script 
 
 # Scroll back to top 

end

end
  
  # DELETE /:username/channels/:id-slug-name-goes-here
  def destroy
    if @channel.featured?
      render :json => {:error => "You cannot delete your featured channel."}, :status => :unauthorized
    else
      @channel.destroy and redirect_to user_channels_path(current_user)
    end
  end
  
  # GET /:username/channels
  def index  
    @channels = @user.channels.paginate(:page => params[:page], :per_page => 9, :order => 'created_at DESC')
    
    respond_to do |format|
      params[:page].to_i > 1 ? format.js : format.html
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if we_should_show_og_tags && !@video.blank? 
 # Facebook OpenGraph protocol for embedding our video link back to Brevidy 
 public_video_url(:public_token => @video.public_token) 
 @video.title 
 @video.description 
 @video.get_thumbnail_url(@video.selected_thumbnail) 
 public_video_url(:public_token => @video.public_token) 
 else 
 # Standard meta tags 
 end 
 browser_title 
 # Logged In CSS 
 # Site-wide JS 
 javascript_include_tag "https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" 
 javascript_include_tag "player/player.js" 
 javascript_include_tag "http://html5shiv.googlecode.com/svn/trunk/html5.js" 
 # Fav Icon and CSRF meta tag 
 favicon_link_tag 
 csrf_meta_tag 
 get_background_for_user 
 # Top navigation header 
  link_to(image_tag("brevidy_rgb_white.png", :size => "135x35", :alt => "Brevidy - The Soul of Video"), signed_in? ? user_stream_path(current_user) : :root, :class => "brand") 
 video_search_path 
 if signed_in? 
 link_to("Explore", explore_path) 
 link_to("Upload", new_user_video_path(current_user)) 
 link_to("Share a Link", user_share_dialog_path(current_user), :remote => true, "data-method" => "GET") 
 link_to("Invite", user_invitations_path(current_user)) 
 end 
 if signed_in? 
 link_to(user_path(current_user), :class => "dropdown-toggle") do 
 image_tag("", :alt => "", :size => "35x35") 
 current_user.username 
 end 
 link_to("My Channels", user_channels_path(current_user)) 
 link_to("Account Settings", user_account_path(current_user)) 
 link_to("Find People", find_people_path) 
 link_to("Help", "http://getsatisfaction.com/brevidy", :target => "_blank") 
 link_to("Logout", logout_path, :remote => true, "data-method" => "DELETE") 
 else 
 link_to("Explore", explore_path) 
 link_to("Sign up", signup_path) 
 link_to("Login", login_path) 
 end 
 
 # Main container 
  # For the "content_for" blocks, you must key off the channel ID 
 # otherwise it will keep appending data to a regular symbol like :channel_view 
 # so by the time you get to the 2nd or 3rd channel, you will have 2 or 3 sets 
 # of channel data attached to the "content_for" store 
 channel_owner = get_object_owner(channel) 
 content_for "channel_view_" do 
 if controller.controller_name == 'subscriptions' && controller.action_name == 'subscriptions' 
 link_to(user_path(channel_owner)) do 
 image_tag("",          :alt => "",          :size => "35x35") 
 end 
 link_to(user_channel_path(channel_owner, channel), :class => "lighten-to-blue") do 
 link_to(user_path(channel_owner), :class => "lighten-to-blue") do 
 end 
 if channel.featured? 
 image_tag("featured_star.png", :alt => "Featured Channel", :size => "16x16") 
 elsif channel.private? 
 image_tag("private_small.png", :alt => "Private Channel", :size => "16x16") 
 else 
 image_tag("public.png", :alt => "Public Channel", :size => "16x16") 
 end 
 link_to(user_channel_path(channel_owner, channel), :class => "lighten-to-blue") do 
 end 
 # Thumbnail view 
 link_to(user_channel_path(channel_owner, channel), :class => "channel-thumbnail-area") do 
 most_recent_videos = channel.videos_for_preview 
 most_recent_videos.each do |v| 
 image_tag(v.get_thumbnail_url(v.selected_thumbnail), :alt => v.title, :size => "190x102") 
 end 
 end 
 end 
 content_for "private_channel_message_" do 
 if controller.controller_name == 'subscriptions' && controller.action_name == 'subscriptions' 
 link_to(user_path(channel_owner)) do 
 image_tag("",          :alt => "",          :size => "35x35") 
 end 
 link_to(user_path(channel_owner), :class => "lighten-to-blue") do 
 end 
 else 
 image_tag("private_small.png", :alt => "Private Channel", :size => "16x16") 
 end 
  image_tag("private_large.png", :alt => "This channel is private", :size => "117x110") 
 
 end 
 channel.id 
 # Channel Content Area 
 if current_user_owns?(channel) 
 content_for "channel_view_" 
 elsif channel.private? 
 if current_user.blank? 
 content_for "private_channel_message_" 
 else 
 if current_user.is_subscribed_to?(channel) 
 content_for "channel_view_" 
 else 
 content_for "private_channel_message_" 
 end 
 end 
 else 
 content_for "channel_view_" 
 end 
 if current_user_owns?(channel) 
 link_to("Manage Channel", edit_user_channel_path(channel_owner, channel), :class => "btn xlarge") 
 else 
 if current_user.blank? 
 link_to("Login to Subscribe", root_path, :class => "btn xlarge") 
 else 
 if current_user.is_subscribed_to?(channel) 
  link_to("Subscribed", user_channel_unsubscribe_path(get_object_owner(channel), channel, :ref => button_size), :class => "unsubscribe btn success ", :remote => true, :method => "DELETE") 
 
 else 
 if channel.private? 
  link_text = is_private ? "Request Access" : "Subscribe" 
 link_to(link_text, user_channel_subscribe_path(get_object_owner(channel), channel, :ref => button_size), :class => "subscribe btn ", :remote => true, :method => "POST") 
 
 else 
  link_text = is_private ? "Request Access" : "Subscribe" 
 link_to(link_text, user_channel_subscribe_path(get_object_owner(channel), channel, :ref => button_size), :class => "subscribe btn ", :remote => true, :method => "POST") 
 
 end 
 end 
 end 
 end
 end
 end 
 
 # Lower navigation 
 unless @page_has_infinite_scrolling 
  succeed "  " do 
 link_to("FAQ", faq_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Blog", "http://blog.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Status", "http://status.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Contact", contact_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Terms", tos_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Privacy", privacy_path, :class => "inlinelink") 
 end 
 
 end 
 # GetSatisfaction Feedback Widget & Google Analytics 
  # Google Analytics 
 # GetSatisfaction Code 
 # AddThis script 
 
 # Scroll back to top 

end

  end
  
  # GET /:username/channels/:id-slug-name-goes-here
  def show    
    if current_user.blank? || !current_user?(@user)
      # Only show videos that are in a :ready state
      @videos ||= @channel.videos.joins(:video_graph).where(:video_graphs => { :status => VideoGraph.get_status_number(:ready) }).
                           paginate(:page => params[:page], :per_page => 10, :order => 'created_at DESC')
    else    
      # Show all videos except ones that are uploading
      @videos ||= @channel.videos.joins(:video_graph).where(:video_graphs => { :status => Video.statuses_to_show_to_current_user }).
                           paginate(:page => params[:page], :per_page => 10, :order => 'created_at DESC')
    end
      
    respond_to do |format|
      params[:page].to_i > 1 ? format.js : format.html
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if we_should_show_og_tags && !@video.blank? 
 # Facebook OpenGraph protocol for embedding our video link back to Brevidy 
 public_video_url(:public_token => @video.public_token) 
 @video.title 
 @video.description 
 @video.get_thumbnail_url(@video.selected_thumbnail) 
 public_video_url(:public_token => @video.public_token) 
 else 
 # Standard meta tags 
 end 
 browser_title 
 # Logged In CSS 
 # Site-wide JS 
 javascript_include_tag "https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" 
 javascript_include_tag "player/player.js" 
 javascript_include_tag "http://html5shiv.googlecode.com/svn/trunk/html5.js" 
 # Fav Icon and CSRF meta tag 
 favicon_link_tag 
 csrf_meta_tag 
 get_background_for_user 
 # Top navigation header 
  link_to(image_tag("brevidy_rgb_white.png", :size => "135x35", :alt => "Brevidy - The Soul of Video"), signed_in? ? user_stream_path(current_user) : :root, :class => "brand") 
 video_search_path 
 if signed_in? 
 link_to("Explore", explore_path) 
 link_to("Upload", new_user_video_path(current_user)) 
 link_to("Share a Link", user_share_dialog_path(current_user), :remote => true, "data-method" => "GET") 
 link_to("Invite", user_invitations_path(current_user)) 
 end 
 if signed_in? 
 link_to(user_path(current_user), :class => "dropdown-toggle") do 
 image_tag("", :alt => "", :size => "35x35") 
 current_user.username 
 end 
 link_to("My Channels", user_channels_path(current_user)) 
 link_to("Account Settings", user_account_path(current_user)) 
 link_to("Find People", find_people_path) 
 link_to("Help", "http://getsatisfaction.com/brevidy", :target => "_blank") 
 link_to("Logout", logout_path, :remote => true, "data-method" => "DELETE") 
 else 
 link_to("Explore", explore_path) 
 link_to("Sign up", signup_path) 
 link_to("Login", login_path) 
 end 
 
 # Main container 
 # User Banner Image 
  if @user.banner_image_id == 0 
 # The user has uploaded a banner or they are using the default 
 image_tag("", :alt => "", :size => "850x315") 
 else 
 # The user has chosen a banner from the gallery 
 image_tag("", :alt => "", :size => "850x315") 
 end 
 if current_user?(@user) 
 link_to("Change Banner Image", user_edit_banner_path(current_user), :class => "small primary btn") 
 end 
 
 # Middle User Info Section 
  link_to(user_path(@user)) do 
 image_tag("",          :alt => "",          :class => "thumbnail",          :size => "150x150") 
 end 
 @user.name 
 @user.location 
 @user.bio 
 unless @user.website.blank? 
 link_to(@user.website, "", :target => "_blank") 
 end 
 if !current_user?(@user) 
 link_to(user_channels_path(@user), :class => "small subscribe-with-icon btn") do 
 image_tag("add_icon.png", :size => "16x16") 
 end 
 end 
 image_tag("banner_corners.png", :size => "875x15", :alt => "") 
 
 # Dark Content Wrapper 
  image_tag("featured_star.png", :alt => "Featured", :size => "16x16") 
 if @user.blank? 
 else 
 link_to("Featured Videos", user_channel_path(@user, @user.featured_channel), :class => "white-to-blue") 
 end 
 if current_user?(@user) 
 link_to(user_edit_featured_videos_path(@user)) do 
 image_tag("edit_order.png", :alt => "Edit Order", :size => "13x13") 
 end 
 end 
 if @latest_featured_videos.empty? 
 if @user.blank? 
 else 
 end 
 else 
  featured_video.id 
 link_to(user_video_path(get_object_owner(featured_video), featured_video)) do 
 image_tag(featured_video.get_thumbnail_url(featured_video.selected_thumbnail), :size => "190x102", :alt => featured_video.title, :class => "featured-popover", :title => featured_video.title, "data-content" => featured_video.description.blank? ? "No description given" : truncate(featured_video.description, :length => 150)) 
 image_tag("play_small.png", :alt => "Play", :size => "45x34") 
 end 
 
 end 
 
 # Main (White) Content Wrapper 
  viewing_someone_else = (current_user.blank? || !current_user?(@user)) 
 unless viewing_someone_else 
 link_to("Stream", user_stream_path(@user), :class => "lighten-to-blue") 
 end 
 unless viewing_someone_else 
 unseen_notifications_count ||= @user.notifications_count 
 if unseen_notifications_count != 0 
 end 
 link_to("Latest Activity", user_latest_activity_path(@user), :class => "lighten-to-blue") 
 end 
 link_to(viewing_someone_else ? "Channels" : "My Channels", user_channels_path(@user), :class => "dropdown-toggle lighten-to-blue") 
 @user.channels.limit(5).each do |c| 
 link_to(user_channel_path(@user, c)) do 
 if c.featured? 
 image_tag("featured_star.png", :alt => "Featured Channel", :size => "13x13") 
 elsif c.private? 
 image_tag("private_small.png", :alt => "Private Channel", :size => "13x13") 
 else 
 image_tag("public.png", :alt => "Public Channel", :size => "13x13") 
 end 
 c.title 
 end 
 end 
 link_to("View All () Channels", user_channels_path(@user)) 
 link_to(viewing_someone_else ? "Videos" : "My Videos", user_path(@user), :class => "lighten-to-blue") 
 link_to("About", user_about_path(@user), :class => "lighten-to-blue") 
 
 if current_user_owns?(@channel) 
 link_to(edit_user_channel_path(@user, @channel), :class => "small btn") do 
 image_tag("edit_icon.png", :size => "11x11") 
 end 
 else 
 if current_user.blank? 
 link_to("Login to Subscribe", root_path, :class => "btn small") 
 else 
 if current_user.is_subscribed_to?(@channel) 
  link_to("Subscribed", user_channel_unsubscribe_path(get_object_owner(channel), channel, :ref => button_size), :class => "unsubscribe btn success ", :remote => true, :method => "DELETE") 
 
 else 
 if @channel.private? 
  link_text = is_private ? "Request Access" : "Subscribe" 
 link_to(link_text, user_channel_subscribe_path(get_object_owner(channel), channel, :ref => button_size), :class => "subscribe btn ", :remote => true, :method => "POST") 
 
 else 
  link_text = is_private ? "Request Access" : "Subscribe" 
 link_to(link_text, user_channel_subscribe_path(get_object_owner(channel), channel, :ref => button_size), :class => "subscribe btn ", :remote => true, :method => "POST") 
 
 end 
 end 
 end 
 end 
 if current_user_owns?(@channel) and @channel.private? 
  public_channel_url(:public_token => channel.public_token) 
 
 end 
 if @viewing_via_token_access 
 end 
 if @videos.blank? 
 else 
  # Initialize some objects for each video 
 # such as badges, comments, tags, etc. 
 video_owner ||= get_object_owner(video) 
 comments ||= video.comments 
 tags ||= video.tags 
 badges_count ||= video.badges.count 
 unique_badge_types_and_counts ||= video.unique_badge_types_and_counts 
 # checks that the video isn't processing so we will 
 # allow the user to interact with it (play it, badge it, etc.) 
 video_is_clickable ||= video.is_status?(VideoGraph::READY) 
 # checks whether we should expand the video or not 
 expand_the_video = defined?(expand_video) ? expand_video : false 
 # Checks if the video is a YouTube/Vimeo player 
 video_is_not_remote ||= video.remote_video_id.blank? 
 link_to(user_path(video_owner)) do 
 image_tag("", :alt => "", :size => "50x50") 
 end 
 video.title 
 link_to(video_owner.name, user_path(video_owner)) 
 link_to(video.channel.title, user_channel_path(video_owner, video.channel)) 
 begin 
 if video_is_not_remote 
 via_user = video.video_graph.get_user_who_uploaded_this 
 unless via_user.blank? || (video_owner.id == via_user.id) 
 end 
 end 
 rescue 
 end 
 # Settings drop down menu 
 link_to("Flag Video", user_video_flag_dialog_path(video_owner, video), :remote => true, "data-method" => "GET") 
 if current_user_owns?(video) 
 link_to("Edit Video", edit_user_video_path(video_owner, video)) 
 link_to("Delete Video", user_video_path(video_owner, video), :class => "delete-video", "data-video-id" => "") 
 end 
 if expand_the_video 
  if defined?(individual_player) 
 ze_autostart = false 
 ze_page_type = "individual" 
 else 
 ze_autostart = true 
 ze_page_type = "regular" 
 end 
 # Checks if the video is a YouTube/Vimeo player 
 video_is_not_remote ||= video.remote_video_id.blank? 
 if video_is_not_remote 
 else 
 # Video is remote (YouTube, Vimeo, etc.) so let's embed it 
 end 
 
 else 
 # Player code will be AJAX'ed in here 
 end 
 path_to_this = @viewing_via_token_access ? user_video_embed_code_path(video_owner, video, :channel_token => video.channel.public_token) : user_video_embed_code_path(video_owner, video) 
 image_tag(video_is_clickable ? video.get_thumbnail_url(video.selected_thumbnail) : "processing.png", :alt => video.title, :size => "250x134") 
 if video_is_clickable 
 image_tag("play.png", :alt => "Play", :size => "60x45") 
 end 
 if video_is_clickable 
 if badges_count == 0 
 if signed_in? 
 end 
 else 
 unique_badge_types_and_counts[:badge_sets].first(5).each do |icon, count| 
  icon.badge_type 
 if count.to_i > 9999 
 else 
 number_with_delimiter(count, :delimiter => ',') 
 end 
 
 end 
 render :partial => "badges/view_all_badges.html",                       :locals => { :badges_count => badges_count, :video_owner => video_owner, :video => video } 
 end 
 end 
 if video.description.blank? 
 else 
 simple_format(auto_link(h(video.description), :html => { :target => "_blank" }), {}, :sanitize => false) 
 end 
 if video_is_clickable 
 if current_user_owns?(video) || !video.channel.private? 
 if current_user.blank? 
 link_to(login_path, :class => "show-msg-modal", "data-modal-title" => "Please login or sign up", "data-modal-message" => "You must <a href=''>Login</a> or <a href=''>Sign up</a> before you can add a video to a channel.") do 
 image_tag("add_to_channel.png", :alt => "Channel Icon", :size => "13x13", :class => "control-icon") 
 end 
 else 
 link_to(user_add_to_channel_dialog_path(current_user, :video_id => video.id), :class => "add-to-channel-link", "data-video-id" => "", :remote => true, "data-method" => "GET") do 
 image_tag("add_to_channel.png", :alt => "Channel Icon", :size => "13x13", :class => "control-icon") 
 end 
 end 
 end 
 image_tag("badge_it.png", :alt => "Badge Icon", :size => "13x13", :class => "control-icon") 
 image_tag("comment.png", :alt => "Comment Icon", :size => "13x13", :class => "control-icon") 
 if current_user_owns?(video) || !video.channel.private? 
 image_tag("share.png", :alt => "Share Icon", :size => "13x13", :class => "control-icon") 
 end 
 image_tag("tags.png", :alt => "Tags Icon", :size => "13x13", :class => "control-icon") 
 image_tag("ajax.gif", :size => "16x16") 
 # ----------- 
 # BADGES AREA 
 # ----------- 
 # Render all of the active badges to choose from 
 render :partial => "badges/give_badges.html", :collection => get_all_active_badges,                   :locals => { :video => video,                                :video_owner => video_owner,                                :all_badge_types => unique_badge_types_and_counts[:all_badge_types] } 
 # ------------- 
 # COMMENTS AREA 
 # ------------- 
 if current_user.blank? && comments.blank? 
 else 
 if comments.size > 3 
 # Hide everything except the latest 3 comments 
 render :partial => "comments/comment.html",                  :collection => comments[-comments.size..-4],                  :locals => { :video => video, :video_owner => video_owner, :hidden_comment => true } 
 # Show only the latest 3 comments in ASC order 
 render :partial => "comments/comment.html", :collection => comments[-3..-1],                  :locals => { :video => video, :video_owner => video_owner, :hidden_comment => false } 
 else 
 render :partial => "comments/comment.html", :collection => comments,                  :locals => { :video => video, :video_owner => video_owner, :hidden_comment => false } 
 end 
 end 
 unless current_user.blank? 
 form_tag(user_video_comments_path(video_owner, video), :method => "POST", :remote => true, :class => "post-new-comment", "data-video-id" => "") do 
 if @viewing_via_token_access 
 end 
 text_area_tag(:content, nil, :autocomplete => :off, "data-video-id" => "", :placeholder => "Write a comment") 
 end 
 end 
 # ---------- 
 # SHARE AREA 
 # ---------- 
 if current_user_owns?(video) || !video.channel.private? 
 # the user owns the video or the channel holding the video is public 
 public_url_to_this_video = public_video_url(:public_token => video.public_token) 
 true 
 public_url_to_this_video 
 true 
 form_tag(user_video_share_via_email_path(video_owner, video), :class => "share-via-email", :remote => true, :method => "POST") do 
 end 
 end 
 # --------- 
 # TAGS AREA 
 # --------- 
 if tags.blank? 
 if current_user_owns?(video) 
 link_to("Give it some", edit_user_video_path(video_owner, video)) 
 end 
 else 
 tags.each do |t| 
 link_to(t.content, video_search_path(:tag => t.content)) 
 if current_user_owns?(video) 
 link_to("x", user_video_tag_path(video_owner, video, t), :class => "tooltip remove-tag",                      :method => "DELETE", :remote => true, :title => "Remove tag", "data-video-id" => "") 
 end 
 end 
 end 
 end 
 
 end 
 # Lower navigation 
 unless @page_has_infinite_scrolling 
  succeed "  " do 
 link_to("FAQ", faq_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Blog", "http://blog.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Status", "http://status.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Contact", contact_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Terms", tos_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Privacy", privacy_path, :class => "inlinelink") 
 end 
 
 end 
 # GetSatisfaction Feedback Widget & Google Analytics 
  # Google Analytics 
 # GetSatisfaction Code 
 # AddThis script 
 
 # Scroll back to top 

end

  end
  
  # GET /c/:public_token
  def show_by_token_access
    if params[:public_token]
      # Only accept the first 50 characters as the public token
      @channel ||= Channel.where('public_token = ?', params[:public_token].strip.first(50)).first
      
      if @channel
        @viewing_via_token_access = true
        @user = get_object_owner(@channel)
        @latest_featured_videos = @user.featured_videos.limit(4)
        # Only show videos that are in a :ready state
        @videos ||= @channel.videos.joins(:video_graph).where(:video_graphs => { :status => VideoGraph.get_status_number(:ready) }).
                             paginate(:page => params[:page], :per_page => 10, :order => 'created_at DESC')
                           
        respond_to do |format|
          params[:page].to_i > 1 ? format.js { render 'channels/show.js' } : format.html { render 'channels/show.html' }
        end
      else
        # show an error page if we couldn't find the channel
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if we_should_show_og_tags && !@video.blank? 
 # Facebook OpenGraph protocol for embedding our video link back to Brevidy 
 public_video_url(:public_token => @video.public_token) 
 @video.title 
 @video.description 
 @video.get_thumbnail_url(@video.selected_thumbnail) 
 public_video_url(:public_token => @video.public_token) 
 else 
 # Standard meta tags 
 end 
 browser_title 
 # Logged In CSS 
 # Site-wide JS 
 javascript_include_tag "https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" 
 javascript_include_tag "player/player.js" 
 javascript_include_tag "http://html5shiv.googlecode.com/svn/trunk/html5.js" 
 # Fav Icon and CSRF meta tag 
 favicon_link_tag 
 csrf_meta_tag 
 get_background_for_user 
 # Top navigation header 
  link_to(image_tag("brevidy_rgb_white.png", :size => "135x35", :alt => "Brevidy - The Soul of Video"), signed_in? ? user_stream_path(current_user) : :root, :class => "brand") 
 video_search_path 
 if signed_in? 
 link_to("Explore", explore_path) 
 link_to("Upload", new_user_video_path(current_user)) 
 link_to("Share a Link", user_share_dialog_path(current_user), :remote => true, "data-method" => "GET") 
 link_to("Invite", user_invitations_path(current_user)) 
 end 
 if signed_in? 
 link_to(user_path(current_user), :class => "dropdown-toggle") do 
 image_tag("", :alt => "", :size => "35x35") 
 current_user.username 
 end 
 link_to("My Channels", user_channels_path(current_user)) 
 link_to("Account Settings", user_account_path(current_user)) 
 link_to("Find People", find_people_path) 
 link_to("Help", "http://getsatisfaction.com/brevidy", :target => "_blank") 
 link_to("Logout", logout_path, :remote => true, "data-method" => "DELETE") 
 else 
 link_to("Explore", explore_path) 
 link_to("Sign up", signup_path) 
 link_to("Login", login_path) 
 end 
 
 # Main container 
 # Dark Content Wrapper 
 # Main (White) Content Wrapper 
 link_to "Go back", :back 
 image_tag("okayguy.png", :alt => "Okay", :size => "256x275") 
 # Lower navigation 
 unless @page_has_infinite_scrolling 
  succeed "  " do 
 link_to("FAQ", faq_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Blog", "http://blog.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Status", "http://status.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Contact", contact_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Terms", tos_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Privacy", privacy_path, :class => "inlinelink") 
 end 
 
 end 
 # GetSatisfaction Feedback Widget & Google Analytics 
  # Google Analytics 
 # GetSatisfaction Code 
 # AddThis script 
 
 # Scroll back to top 

end

      end
    else
      # no public token passed in
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if we_should_show_og_tags && !@video.blank? 
 # Facebook OpenGraph protocol for embedding our video link back to Brevidy 
 public_video_url(:public_token => @video.public_token) 
 @video.title 
 @video.description 
 @video.get_thumbnail_url(@video.selected_thumbnail) 
 public_video_url(:public_token => @video.public_token) 
 else 
 # Standard meta tags 
 end 
 browser_title 
 # Logged In CSS 
 # Site-wide JS 
 javascript_include_tag "https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" 
 javascript_include_tag "player/player.js" 
 javascript_include_tag "http://html5shiv.googlecode.com/svn/trunk/html5.js" 
 # Fav Icon and CSRF meta tag 
 favicon_link_tag 
 csrf_meta_tag 
 get_background_for_user 
 # Top navigation header 
  link_to(image_tag("brevidy_rgb_white.png", :size => "135x35", :alt => "Brevidy - The Soul of Video"), signed_in? ? user_stream_path(current_user) : :root, :class => "brand") 
 video_search_path 
 if signed_in? 
 link_to("Explore", explore_path) 
 link_to("Upload", new_user_video_path(current_user)) 
 link_to("Share a Link", user_share_dialog_path(current_user), :remote => true, "data-method" => "GET") 
 link_to("Invite", user_invitations_path(current_user)) 
 end 
 if signed_in? 
 link_to(user_path(current_user), :class => "dropdown-toggle") do 
 image_tag("", :alt => "", :size => "35x35") 
 current_user.username 
 end 
 link_to("My Channels", user_channels_path(current_user)) 
 link_to("Account Settings", user_account_path(current_user)) 
 link_to("Find People", find_people_path) 
 link_to("Help", "http://getsatisfaction.com/brevidy", :target => "_blank") 
 link_to("Logout", logout_path, :remote => true, "data-method" => "DELETE") 
 else 
 link_to("Explore", explore_path) 
 link_to("Sign up", signup_path) 
 link_to("Login", login_path) 
 end 
 
 # Main container 
 # Dark Content Wrapper 
 # Main (White) Content Wrapper 
 link_to "Go back", :back 
 image_tag("okayguy.png", :alt => "Okay", :size => "256x275") 
 # Lower navigation 
 unless @page_has_infinite_scrolling 
  succeed "  " do 
 link_to("FAQ", faq_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Blog", "http://blog.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Status", "http://status.brevidy.com", :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Contact", contact_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Terms", tos_path, :class => "inlinelink") 
 end 
 succeed "  " do 
 link_to("Privacy", privacy_path, :class => "inlinelink") 
 end 
 
 end 
 # GetSatisfaction Feedback Widget & Google Analytics 
  # Google Analytics 
 # GetSatisfaction Code 
 # AddThis script 
 
 # Scroll back to top 

end

    end
  end
  
  # PUT /:username/channels/:id-slug-name-goes-here/update
  def update
    # Update privacy params
    if params[:privacy]
      @channel.private = params[:privacy]
      send_back_link = true
    end
    
    # Update name
    if params[:title]
      @channel.title = params[:title]
    end
    
    if @channel.save
      if send_back_link
        render :json => { :new_link => user_channel_url(@user, @channel, :privacy => @channel.private? ? "false" : "true") }, 
               :status => :accepted
      else
        render :nothing => true, :status => :accepted
      end
    else
      render :json => { :error => get_errors_for_class(@channel).to_sentence }, 
             :status => :unprocessable_entity
    end
  end
  
  # PUT /:username/update_featured_videos
  def update_featured_videos
    @video ||= current_user.videos.find_by_id(params[:video_id])
    if @video
      if @video == current_user.featured_videos.first
        render :json => { :error => "That video is already at the top of your featured videos list :)" }, 
               :status => :unprocessable_entity
      else
        @video.featured_at = Time.now
        @video.save
        render :json => { :featured_video => render_to_string( :partial => 'shared/featured_video.html',
                                                               :locals => { :featured_video => @video }) }, 
               :status => :accepted
      end
    else
      render :json => { :error => "Either that video does not exist or you do not have permission to move it." }, 
             :status => :unprocessable_entity
    end
  end
  
end
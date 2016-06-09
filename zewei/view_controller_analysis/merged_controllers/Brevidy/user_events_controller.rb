class UserEventsController < ApplicationController  
  before_filter :set_user, :verify_user_owns_page, :set_featured_videos
  
  # GET /:username/latest_activity
  def show
    @browser_title ||= "Latest Activity"
    # return all user events other than video plays
    @user_events = @user.notifications_to_show_user.paginate(:page => params[:page], :per_page => 25, :order => 'created_at DESC')
    
    # mark all user events for the current user as "seen"
    UserEvent.where(:user_id => current_user.id, :seen_by_user => false).update_all(:seen_by_user => true) unless current_user.notifications_count == 0
    
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
 
 if @user_events.empty? 
 else 
 @user_events.each do |user_event| 
 # Render the content based on event type (badge, comment, etc) 
 render_content_for_event(user_event) 
 end 
 will_paginate @user_events 
  @page_has_infinite_scrolling = true 
 
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

end
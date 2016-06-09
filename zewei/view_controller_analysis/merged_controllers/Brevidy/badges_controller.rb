class BadgesController < ApplicationController
  include ApplicationHelper

  before_filter :site_authenticate, :except => [:badges_dialog, :index]
  before_filter :set_user, :set_browser_title
  before_filter :verify_current_user_is_not_blocked, :only => [:index]
  before_filter :set_video, :except => [:index]
  before_filter :verify_user_can_access_channel_or_video, :only => [:badges_dialog, :create, :destroy]
  before_filter :set_featured_videos, :only => [:index]

  # GET /:username/videos/:video_id/badges
  def badges_dialog
    @badges ||= @video.badges.all
    
    respond_to do |format|
      format.js # badges_dialog.js.haml
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

  # GET /:username/badges 
  def index
    @badges ||= sort_badges_by_count_for_user(get_all_active_badges, @user)
    
    respond_to do |format|
      format.html # index.html.haml
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
 
 @badges.each do |b| 
 end 
 # Tell the page to scroll down to the content wrapper upon page load 
  
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

  # POST /:username/videos/:video_id/badges
  def create
    new_badge ||= @video.badge_it(current_user, params[:badge_type])
    if new_badge.errors.any?
      render :json => { :error => get_errors_for_class(new_badge).to_sentence }, 
             :status => :unprocessable_entity
    else
      video_owner ||= get_object_owner(@video)
      total_video_badges ||= @video.badges.count
      @viewing_via_token_access = (params[:channel_token] == @video.channel.public_token)
      render :json => { :html => 
                          render_to_string( :partial => 'badges/badge.html',
                                            :locals => { :icon => new_badge,
                                                         :count => @video.badges_count_for_type(params[:badge_type]) } ),
                        :unbadge =>
                          render_to_string( :partial => 'badges/unbadge.html',
                                            :locals => { :badge => new_badge,
                                                         :video => @video,
                                                         :video_owner => video_owner,
                                                         :icon => Icon.find_by_id(params[:badge_type]) } ),
                        :view_all_badges_link =>
                          render_to_string( :partial => 'badges/view_all_badges.html',
                                            :locals => { :badges_count => total_video_badges, 
                                                         :video_owner => video_owner, 
                                                         :video => @video } ),
                        :total_video_badges => total_video_badges,
                        :video_id => @video.id },
             :status => :created
    end
  end
  
  # DELETE /:username/videos/:video_id/badges/:id
  def destroy
    badge ||= @video.badges.find_by_id(params[:id])
    if badge
      # badge exists, so destroy it if user owns it
      if badge.badge_from == current_user.id
        video_owner ||= get_object_owner(@video)
        # cache old badge
        old_badge = badge
        
        if badge.destroy
          badges_count ||= @video.badges.count
          icon ||= Icon.find_by_id(badge.badge_type)
          
          render :json => { :badges_path => user_video_badges_dialog_path(video_owner, @video),
                            :this_badge_count => @video.badges_count_for_type(old_badge.badge_type),
                            :total_video_badges => badges_count,
                            :video_id => @video.id,
                            :badge_name => icon.name,
                            :give_a_badge => 
                              render_to_string( :partial => 'badges/give_a_badge.html', 
                                                :locals => { :video => @video,
                                                             :video_owner => video_owner,
                                                             :icon => icon } ),
                            :view_all_badges_link =>
                              render_to_string( :partial => 'badges/view_all_badges.html',
                                                :locals => { :badges_count => badges_count, 
                                                             :video_owner => video_owner, 
                                                             :video => @video } ) },
                 :status => :ok
        else
          render :json => { :error => "There was an error removing your badge." }, 
                 :status => :unprocessable_entity
        end
      else
        render :json => { :error => "You do not own that badge so you cannot remove it." }, 
               :status => :unauthorized
      end
    else
      render :nothing => true, :status => :not_found
    end
  end
  
  private
    # Sets a browser title for all actions
    def set_browser_title
      @browser_title ||= @user.name unless @user.blank?
    end
end

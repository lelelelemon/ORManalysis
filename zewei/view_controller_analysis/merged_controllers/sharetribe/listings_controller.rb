# rubocop:disable ClassLength
class ListingsController < ApplicationController
  class ListingDeleted < StandardError; end

  include PeopleHelper

  # Skip auth token check as current jQuery doesn't provide it automatically
  skip_before_filter :verify_authenticity_token, :only => [:close, :update, :follow, :unfollow]

  before_filter :only => [ :edit, :edit_form_content, :update, :close, :follow, :unfollow ] do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_view_this_content")
  end

  before_filter :only => [ :new, :new_form_content, :create ] do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_create_new_listing", :sign_up_link => view_context.link_to(t("layouts.notifications.create_one_here"), sign_up_path)).html_safe
  end

  before_filter :save_current_path, :only => :show
  before_filter :ensure_authorized_to_view, :only => [ :show, :follow, :unfollow ]

  before_filter :only => [ :close ] do |controller|
    controller.ensure_current_user_is_listing_author t("layouts.notifications.only_listing_author_can_close_a_listing")
  end

  before_filter :only => [ :edit, :edit_form_content, :update ] do |controller|
    controller.ensure_current_user_is_listing_author t("layouts.notifications.only_listing_author_can_edit_a_listing")
  end

  before_filter :ensure_is_admin, :only => [ :move_to_top, :show_in_updates_email ]

  before_filter :is_authorized_to_post, :only => [ :new, :create ]

  def index
    @selected_tribe_navi_tab = "home"

    respond_to do |format|
      # Keep format.html at top, as order is important for HTTP_ACCEPT headers with '*/*'
      format.html do
        if request.xhr? && params[:person_id] # AJAX request to load on person's listings for profile view
          @person = Person.find(params[:person_id])
          PersonViewUtils.ensure_person_belongs_to_community!(@person, @current_community)

          # Returns the listings for one person formatted for profile page view
          per_page = params[:per_page] || 1000 # the point is to show all here by default
          includes = [:author, :listing_images]
          include_closed = @person == @current_user && params[:show_closed]
          search = {
            author_id: @person.id,
            include_closed: include_closed,
            page: 1,
            per_page: per_page
          }

          listings = ListingIndexService::API::Api.listings.search(community_id: @current_community.id, search: search, includes: includes).and_then { |res|
            Result::Success.new(
              ListingIndexViewUtils.to_struct(
              result: res,
              includes: includes,
              page: search[:page],
              per_page: search[:per_page]
            ))
          }.data

          ruby_code_from_view.ruby_code_from_view do |rb_from_view|
   if APP_CONFIG.use_kissmetrics 
 "_kms('//i.kissmetrics.com/i.js');_kms('#{APP_CONFIG.kissmetrics_url}');" 
 if @current_user 
 "_kmq.push(['identify', '#{@current_user.id}']);" 
 end 
 if @current_community 
 "_kmq.push(['set', {}]);" 
 else 
 "_kmq.push(['set', {'SiteName' : 'dashboard'}]);" 
 end 
 end 
 
 content_for :head 
  
 
  link_to t("homepage.index.post_new_listing"), new_listing_path, :class => "new-listing-link", :id => "new-listing-link" 
 Maybe(@current_user).each do |user| 
 conversations = @current_community.conversations.for_person(user) 
 unread_count = MarketplaceService::Inbox::Query.notification_count(user.id, @current_community.id) 
  image_tag user.image.url(:thumb), alt: '', class: 'header-user-avatar' 
 user.name(@current_community) 
 icon_tag("dropdown", ["icon-dropdown"]) 
 
  link_to person_inbox_path(@current_user) do 
 icon_tag("mail", ["icon-with-text"]) 
 t("layouts.conversations.messages") 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 link_to person_path(user) do 
 icon_tag("user", ["icon-with-text"]) 
 t("header.profile") 
 end 
 link_to person_settings_path(user) do 
 icon_tag("settings", ["icon-with-text"]) 
 t("layouts.logged_in.settings") 
 end 
 link_to logout_path do 
 icon_tag("logout", ["icon-with-text"]) 
 t("layouts.logged_in.logout") 
 end 
 
  link_to person_inbox_path(user), title: t("layouts.conversations.messages"), :id => "inbox-link", :class => "header-text-link header-hover header-inbox-link" do 
 icon_tag("mail", ["header-inbox"]) 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 
 end 
 with_available_locales do |locales| 
 get_full_locale_name(I18n.locale).to_s 
 icon_tag("dropdown", ["icon-dropdown"]) 
  
 end 
 unless @current_user 
 link_to sign_up_path, class: "header-text-link header-hover" do 
 t("header.signup") 
 end 
 link_to login_path, class: "header-text-link header-hover", id: "header-login-link" do 
 t("header.login") 
 end 
 end 
 icon_tag("rows", ["header-menu-icon"]) 
 t("header.menu") 
  link_to "/" do 
 icon_tag("home", ["icon-with-text"]) 
 t("header.home") 
 end 
 link_to new_listing_path, :class => "hidden-tablet" do 
 icon_tag("new_listing", ["icon-with-text"]) 
 t("homepage.index.post_new_listing") 
 end 
 link_to about_infos_path do 
 icon_tag("information", ["icon-with-text"]) 
 t("header.about") 
 end 
 link_to new_user_feedback_path do 
 icon_tag("feedback", ["icon-with-text"]) 
 t("header.contact_us") 
 end 
 with_invite_link do 
 link_to new_invitation_path do 
 icon_tag("invite", ["icon-with-text"]) 
 t("header.invite") 
 end 
 end 
 Maybe(@current_community).menu_links.each do |menu_links| 
 menu_links.each do |menu_link| 
 link_to menu_link.url(I18n.locale), :target => "_blank" do 
 icon_tag("redirect", ["icon-with-text"]) 
 menu_link.title(I18n.locale) 
 end 
 end 
 end 
 if @current_user && @current_community && @current_user.has_admin_rights_in?(@current_community) 
 link_to edit_details_admin_community_path(@current_community) do 
 icon_tag("admin", ["icon-with-text"]) 
 t("layouts.logged_in.admin") 
 end 
 end 
 with_available_locales do |locales| 
 t("layouts.global-header.select_language") 
  
 end 
 
 link_to @homepage_path, :class => "header-logo", :id => "header-logo" do 
 end 
 
 if display_expiration_notice? 
  content_for :javascript do 
 end 
 t("expiration.title") 
 t("expiration.sub_title_new") 
 external_plan_service_login_url 
 t("expiration.link_to_external_service") 
 t("expiration.need_more_info") 
 t("expiration.contact_us") 
 
 end 
 content_for(:page_content) do 
 with_big_cover_photo do 
 yield :title_header 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 yield :title_header 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 icon_class 
 flash[announcement] 
 end 
 end 
 
   link_to(listing_path(listing.url), :class => "#{modifier_class} fluid-thumbnail-grid-image-item-link") do 
 with_first_listing_image(listing) do |first_image_url| 
 image_tag first_image_url, {} 
 end 
 listing.title 
 if listing.price 
 humanized_money_with_symbol(listing.price).upcase 
 price_unit = price_quantity_slash_unit(listing) 
 if !price_unit.blank? 
 price_text = " " + price_unit 
 price_text 
 price_text 
 end 
 else 
 shape_name(listing) 
 end 
 end 
 
 
 if listings.total_entries > limit 
 if current_user?(@person) && params[:show_closed] 
 link_to t("people.show.show_all_listings"), "#", :data => { :url => person_listings_url(@person, :show_closed => true) } 
 else 
 link_to t("people.show.show_all_open_listings"), "#", :data => { :url => person_listings_url(@person) } 
 end 
 end 
 end 
 if params[:controller] == "homepage" && params[:action] == "index" 
 params.except("action", "controller", "q", "view", "utf8").each do |param, value| 
 unless param.match(/^filter_option/) || param.match(/^checkbox_filter_option/) || param.match(/^nf_/) || param.match(/^price_/) 
 hidden_field_tag param, value 
 end 
 end 
 hidden_field_tag "view", @view_type 
 content_for(:page_content) 
 else 
 content_for(:page_content) 
 end 
  if (APP_CONFIG.use_google_analytics) 
 "_gaq.push(['_setAccount', '#{APP_CONFIG.google_analytics_key}']);" 
 "_gaq.push(['_setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 if @current_community && @current_community.google_analytics_key 
 "_gaq.push(['b._setAccount', '#{@current_community.google_analytics_key}']);" 
 "_gaq.push(['b._setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{Maybe(@current_community.name(I18n.locale)).gsub("'","").or_else("")}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{@current_community.domain}']);" 
 end 
 end 
 
 content_for(:location_search) 
  
 javascript_include_tag 'application' 
 if @analytics_event 
 end 
 if Rails.env.test? 
 end 
 content_for :extra_javascript 
  t('error_pages.no_javascript.javascript_is_disabled_in_your_browser') 
 t('error_pages.no_javascript.kassi_does_not_currently_work_without_javascript') 
 

end

        else
          redirect_to root
        end
      end

      format.atom do
        page =  params[:page] || 1
        per_page = params[:per_page] || 50

        all_shapes = get_shapes()
        all_processes = get_processes()
        direction_map = ListingShapeHelper.shape_direction_map(all_shapes, all_processes)

        if params[:share_type].present?
          direction = params[:share_type]

          params[:listing_shapes] = {
            id: all_shapes.select { |shape|
              direction_map[shape[:id]] == direction
            }.map { |shape| shape[:id] }
          }
        end
        search_res = @current_community.private ? Result::Success.new({count: 0, listings: []}) : ListingIndexService::API::Api.listings.search(
                     community_id: @current_community.id,
                     search: {
                       listing_shapes: params[:listing_shapes],
                       page: page,
                       per_page: per_page
                     },
                     includes: [:listing_images, :author, :location])

        listings = search_res.data[:listings]

        title = build_title(params)
        updated = listings.first.present? ? listings.first[:updated_at] : Time.now

        render layout: false,
               locals: { listings: listings,
                         title: title,
                         updated: updated,

                         # deprecated
                         direction_map: direction_map
                       }
      end
    end
  end

  def listing_bubble
    if params[:id]
      @listing = Listing.find(params[:id])
      if @listing.visible_to?(@current_user, @current_community)
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
   if APP_CONFIG.use_kissmetrics 
 "_kms('//i.kissmetrics.com/i.js');_kms('#{APP_CONFIG.kissmetrics_url}');" 
 if @current_user 
 "_kmq.push(['identify', '#{@current_user.id}']);" 
 end 
 if @current_community 
 "_kmq.push(['set', {}]);" 
 else 
 "_kmq.push(['set', {'SiteName' : 'dashboard'}]);" 
 end 
 end 
 
 content_for :head 
  
 
  link_to t("homepage.index.post_new_listing"), new_listing_path, :class => "new-listing-link", :id => "new-listing-link" 
 Maybe(@current_user).each do |user| 
 conversations = @current_community.conversations.for_person(user) 
 unread_count = MarketplaceService::Inbox::Query.notification_count(user.id, @current_community.id) 
  image_tag user.image.url(:thumb), alt: '', class: 'header-user-avatar' 
 user.name(@current_community) 
 icon_tag("dropdown", ["icon-dropdown"]) 
 
  link_to person_inbox_path(@current_user) do 
 icon_tag("mail", ["icon-with-text"]) 
 t("layouts.conversations.messages") 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 link_to person_path(user) do 
 icon_tag("user", ["icon-with-text"]) 
 t("header.profile") 
 end 
 link_to person_settings_path(user) do 
 icon_tag("settings", ["icon-with-text"]) 
 t("layouts.logged_in.settings") 
 end 
 link_to logout_path do 
 icon_tag("logout", ["icon-with-text"]) 
 t("layouts.logged_in.logout") 
 end 
 
  link_to person_inbox_path(user), title: t("layouts.conversations.messages"), :id => "inbox-link", :class => "header-text-link header-hover header-inbox-link" do 
 icon_tag("mail", ["header-inbox"]) 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 
 end 
 with_available_locales do |locales| 
 get_full_locale_name(I18n.locale).to_s 
 icon_tag("dropdown", ["icon-dropdown"]) 
  
 end 
 unless @current_user 
 link_to sign_up_path, class: "header-text-link header-hover" do 
 t("header.signup") 
 end 
 link_to login_path, class: "header-text-link header-hover", id: "header-login-link" do 
 t("header.login") 
 end 
 end 
 icon_tag("rows", ["header-menu-icon"]) 
 t("header.menu") 
  link_to "/" do 
 icon_tag("home", ["icon-with-text"]) 
 t("header.home") 
 end 
 link_to new_listing_path, :class => "hidden-tablet" do 
 icon_tag("new_listing", ["icon-with-text"]) 
 t("homepage.index.post_new_listing") 
 end 
 link_to about_infos_path do 
 icon_tag("information", ["icon-with-text"]) 
 t("header.about") 
 end 
 link_to new_user_feedback_path do 
 icon_tag("feedback", ["icon-with-text"]) 
 t("header.contact_us") 
 end 
 with_invite_link do 
 link_to new_invitation_path do 
 icon_tag("invite", ["icon-with-text"]) 
 t("header.invite") 
 end 
 end 
 Maybe(@current_community).menu_links.each do |menu_links| 
 menu_links.each do |menu_link| 
 link_to menu_link.url(I18n.locale), :target => "_blank" do 
 icon_tag("redirect", ["icon-with-text"]) 
 menu_link.title(I18n.locale) 
 end 
 end 
 end 
 if @current_user && @current_community && @current_user.has_admin_rights_in?(@current_community) 
 link_to edit_details_admin_community_path(@current_community) do 
 icon_tag("admin", ["icon-with-text"]) 
 t("layouts.logged_in.admin") 
 end 
 end 
 with_available_locales do |locales| 
 t("layouts.global-header.select_language") 
  
 end 
 
 link_to @homepage_path, :class => "header-logo", :id => "header-logo" do 
 end 
 
 if display_expiration_notice? 
  content_for :javascript do 
 end 
 t("expiration.title") 
 t("expiration.sub_title_new") 
 external_plan_service_login_url 
 t("expiration.link_to_external_service") 
 t("expiration.need_more_info") 
 t("expiration.contact_us") 
 
 end 
 content_for(:page_content) do 
 with_big_cover_photo do 
 yield :title_header 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 yield :title_header 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 icon_class 
 flash[announcement] 
 end 
 end 
 
 if listing.has_image? 
 link_to(image_tag(listing.listing_images.first.image.url(:small_3x2), :alt => listed_listing_title(listing)), listing) 
 end 
 listing_path(listing) 
 listing.title 
 small_avatar_thumb(listing.author) 
 author_link(listing) 
 price_as_text(listing) 
 if listing.price 
 humanized_money_with_symbol(listing.price).upcase 
 unless listing.quantity.blank? 
 "/ #{listing.quantity}" 
 end 
 end 
 end 
 if params[:controller] == "homepage" && params[:action] == "index" 
 params.except("action", "controller", "q", "view", "utf8").each do |param, value| 
 unless param.match(/^filter_option/) || param.match(/^checkbox_filter_option/) || param.match(/^nf_/) || param.match(/^price_/) 
 hidden_field_tag param, value 
 end 
 end 
 hidden_field_tag "view", @view_type 
 content_for(:page_content) 
 else 
 content_for(:page_content) 
 end 
  if (APP_CONFIG.use_google_analytics) 
 "_gaq.push(['_setAccount', '#{APP_CONFIG.google_analytics_key}']);" 
 "_gaq.push(['_setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 if @current_community && @current_community.google_analytics_key 
 "_gaq.push(['b._setAccount', '#{@current_community.google_analytics_key}']);" 
 "_gaq.push(['b._setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{Maybe(@current_community.name(I18n.locale)).gsub("'","").or_else("")}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{@current_community.domain}']);" 
 end 
 end 
 
 content_for(:location_search) 
  
 javascript_include_tag 'application' 
 if @analytics_event 
 end 
 if Rails.env.test? 
 end 
 content_for :extra_javascript 
  t('error_pages.no_javascript.javascript_is_disabled_in_your_browser') 
 t('error_pages.no_javascript.kassi_does_not_currently_work_without_javascript') 
 

end

      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
   if APP_CONFIG.use_kissmetrics 
 "_kms('//i.kissmetrics.com/i.js');_kms('#{APP_CONFIG.kissmetrics_url}');" 
 if @current_user 
 "_kmq.push(['identify', '#{@current_user.id}']);" 
 end 
 if @current_community 
 "_kmq.push(['set', {}]);" 
 else 
 "_kmq.push(['set', {'SiteName' : 'dashboard'}]);" 
 end 
 end 
 
 content_for :head 
  
 
  link_to t("homepage.index.post_new_listing"), new_listing_path, :class => "new-listing-link", :id => "new-listing-link" 
 Maybe(@current_user).each do |user| 
 conversations = @current_community.conversations.for_person(user) 
 unread_count = MarketplaceService::Inbox::Query.notification_count(user.id, @current_community.id) 
  image_tag user.image.url(:thumb), alt: '', class: 'header-user-avatar' 
 user.name(@current_community) 
 icon_tag("dropdown", ["icon-dropdown"]) 
 
  link_to person_inbox_path(@current_user) do 
 icon_tag("mail", ["icon-with-text"]) 
 t("layouts.conversations.messages") 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 link_to person_path(user) do 
 icon_tag("user", ["icon-with-text"]) 
 t("header.profile") 
 end 
 link_to person_settings_path(user) do 
 icon_tag("settings", ["icon-with-text"]) 
 t("layouts.logged_in.settings") 
 end 
 link_to logout_path do 
 icon_tag("logout", ["icon-with-text"]) 
 t("layouts.logged_in.logout") 
 end 
 
  link_to person_inbox_path(user), title: t("layouts.conversations.messages"), :id => "inbox-link", :class => "header-text-link header-hover header-inbox-link" do 
 icon_tag("mail", ["header-inbox"]) 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 
 end 
 with_available_locales do |locales| 
 get_full_locale_name(I18n.locale).to_s 
 icon_tag("dropdown", ["icon-dropdown"]) 
  
 end 
 unless @current_user 
 link_to sign_up_path, class: "header-text-link header-hover" do 
 t("header.signup") 
 end 
 link_to login_path, class: "header-text-link header-hover", id: "header-login-link" do 
 t("header.login") 
 end 
 end 
 icon_tag("rows", ["header-menu-icon"]) 
 t("header.menu") 
  link_to "/" do 
 icon_tag("home", ["icon-with-text"]) 
 t("header.home") 
 end 
 link_to new_listing_path, :class => "hidden-tablet" do 
 icon_tag("new_listing", ["icon-with-text"]) 
 t("homepage.index.post_new_listing") 
 end 
 link_to about_infos_path do 
 icon_tag("information", ["icon-with-text"]) 
 t("header.about") 
 end 
 link_to new_user_feedback_path do 
 icon_tag("feedback", ["icon-with-text"]) 
 t("header.contact_us") 
 end 
 with_invite_link do 
 link_to new_invitation_path do 
 icon_tag("invite", ["icon-with-text"]) 
 t("header.invite") 
 end 
 end 
 Maybe(@current_community).menu_links.each do |menu_links| 
 menu_links.each do |menu_link| 
 link_to menu_link.url(I18n.locale), :target => "_blank" do 
 icon_tag("redirect", ["icon-with-text"]) 
 menu_link.title(I18n.locale) 
 end 
 end 
 end 
 if @current_user && @current_community && @current_user.has_admin_rights_in?(@current_community) 
 link_to edit_details_admin_community_path(@current_community) do 
 icon_tag("admin", ["icon-with-text"]) 
 t("layouts.logged_in.admin") 
 end 
 end 
 with_available_locales do |locales| 
 t("layouts.global-header.select_language") 
  
 end 
 
 link_to @homepage_path, :class => "header-logo", :id => "header-logo" do 
 end 
 
 if display_expiration_notice? 
  content_for :javascript do 
 end 
 t("expiration.title") 
 t("expiration.sub_title_new") 
 external_plan_service_login_url 
 t("expiration.link_to_external_service") 
 t("expiration.need_more_info") 
 t("expiration.contact_us") 
 
 end 
 content_for(:page_content) do 
 with_big_cover_photo do 
 yield :title_header 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 yield :title_header 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 icon_class 
 flash[announcement] 
 end 
 end 
 
 t(".listing_not_visible") 
 end 
 if params[:controller] == "homepage" && params[:action] == "index" 
 params.except("action", "controller", "q", "view", "utf8").each do |param, value| 
 unless param.match(/^filter_option/) || param.match(/^checkbox_filter_option/) || param.match(/^nf_/) || param.match(/^price_/) 
 hidden_field_tag param, value 
 end 
 end 
 hidden_field_tag "view", @view_type 
 content_for(:page_content) 
 else 
 content_for(:page_content) 
 end 
  if (APP_CONFIG.use_google_analytics) 
 "_gaq.push(['_setAccount', '#{APP_CONFIG.google_analytics_key}']);" 
 "_gaq.push(['_setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 if @current_community && @current_community.google_analytics_key 
 "_gaq.push(['b._setAccount', '#{@current_community.google_analytics_key}']);" 
 "_gaq.push(['b._setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{Maybe(@current_community.name(I18n.locale)).gsub("'","").or_else("")}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{@current_community.domain}']);" 
 end 
 end 
 
 content_for(:location_search) 
  
 javascript_include_tag 'application' 
 if @analytics_event 
 end 
 if Rails.env.test? 
 end 
 content_for :extra_javascript 
  t('error_pages.no_javascript.javascript_is_disabled_in_your_browser') 
 t('error_pages.no_javascript.kassi_does_not_currently_work_without_javascript') 
 

end

      end
    end
  end

  # "2,3,4, 563" => [2, 3, 4, 563]
  def numbers_str_to_array(str)
    str.split(",").map { |num| num.to_i }
  end

  # Used to show multiple listings in one bubble
  def listing_bubble_multiple
    ids = numbers_str_to_array(params[:ids])

    if @current_user || !@current_community.private?
      @listings = @current_community.listings.where(listings: {id: ids}).order("listings.created_at DESC")
    else
      @listings = []
    end

    if @listings.size > 0
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
   if APP_CONFIG.use_kissmetrics 
 "_kms('//i.kissmetrics.com/i.js');_kms('#{APP_CONFIG.kissmetrics_url}');" 
 if @current_user 
 "_kmq.push(['identify', '#{@current_user.id}']);" 
 end 
 if @current_community 
 "_kmq.push(['set', {}]);" 
 else 
 "_kmq.push(['set', {'SiteName' : 'dashboard'}]);" 
 end 
 end 
 
 content_for :head 
  
 
  link_to t("homepage.index.post_new_listing"), new_listing_path, :class => "new-listing-link", :id => "new-listing-link" 
 Maybe(@current_user).each do |user| 
 conversations = @current_community.conversations.for_person(user) 
 unread_count = MarketplaceService::Inbox::Query.notification_count(user.id, @current_community.id) 
  image_tag user.image.url(:thumb), alt: '', class: 'header-user-avatar' 
 user.name(@current_community) 
 icon_tag("dropdown", ["icon-dropdown"]) 
 
  link_to person_inbox_path(@current_user) do 
 icon_tag("mail", ["icon-with-text"]) 
 t("layouts.conversations.messages") 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 link_to person_path(user) do 
 icon_tag("user", ["icon-with-text"]) 
 t("header.profile") 
 end 
 link_to person_settings_path(user) do 
 icon_tag("settings", ["icon-with-text"]) 
 t("layouts.logged_in.settings") 
 end 
 link_to logout_path do 
 icon_tag("logout", ["icon-with-text"]) 
 t("layouts.logged_in.logout") 
 end 
 
  link_to person_inbox_path(user), title: t("layouts.conversations.messages"), :id => "inbox-link", :class => "header-text-link header-hover header-inbox-link" do 
 icon_tag("mail", ["header-inbox"]) 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 
 end 
 with_available_locales do |locales| 
 get_full_locale_name(I18n.locale).to_s 
 icon_tag("dropdown", ["icon-dropdown"]) 
  
 end 
 unless @current_user 
 link_to sign_up_path, class: "header-text-link header-hover" do 
 t("header.signup") 
 end 
 link_to login_path, class: "header-text-link header-hover", id: "header-login-link" do 
 t("header.login") 
 end 
 end 
 icon_tag("rows", ["header-menu-icon"]) 
 t("header.menu") 
  link_to "/" do 
 icon_tag("home", ["icon-with-text"]) 
 t("header.home") 
 end 
 link_to new_listing_path, :class => "hidden-tablet" do 
 icon_tag("new_listing", ["icon-with-text"]) 
 t("homepage.index.post_new_listing") 
 end 
 link_to about_infos_path do 
 icon_tag("information", ["icon-with-text"]) 
 t("header.about") 
 end 
 link_to new_user_feedback_path do 
 icon_tag("feedback", ["icon-with-text"]) 
 t("header.contact_us") 
 end 
 with_invite_link do 
 link_to new_invitation_path do 
 icon_tag("invite", ["icon-with-text"]) 
 t("header.invite") 
 end 
 end 
 Maybe(@current_community).menu_links.each do |menu_links| 
 menu_links.each do |menu_link| 
 link_to menu_link.url(I18n.locale), :target => "_blank" do 
 icon_tag("redirect", ["icon-with-text"]) 
 menu_link.title(I18n.locale) 
 end 
 end 
 end 
 if @current_user && @current_community && @current_user.has_admin_rights_in?(@current_community) 
 link_to edit_details_admin_community_path(@current_community) do 
 icon_tag("admin", ["icon-with-text"]) 
 t("layouts.logged_in.admin") 
 end 
 end 
 with_available_locales do |locales| 
 t("layouts.global-header.select_language") 
  
 end 
 
 link_to @homepage_path, :class => "header-logo", :id => "header-logo" do 
 end 
 
 if display_expiration_notice? 
  content_for :javascript do 
 end 
 t("expiration.title") 
 t("expiration.sub_title_new") 
 external_plan_service_login_url 
 t("expiration.link_to_external_service") 
 t("expiration.need_more_info") 
 t("expiration.contact_us") 
 
 end 
 content_for(:page_content) do 
 with_big_cover_photo do 
 yield :title_header 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 yield :title_header 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 icon_class 
 flash[announcement] 
 end 
 end 
 
 "1" 
 "2" 
  if listing.has_image? 
 link_to(image_tag(listing.listing_images.first.image.url(:small_3x2), :alt => listed_listing_title(listing)), listing) 
 end 
 listing_path(listing) 
 listing.title 
 small_avatar_thumb(listing.author) 
 author_link(listing) 
 price_as_text(listing) 
 if listing.price 
 humanized_money_with_symbol(listing.price).upcase 
 unless listing.quantity.blank? 
 "/ #{listing.quantity}" 
 end 
 end 
 
 end 
 if params[:controller] == "homepage" && params[:action] == "index" 
 params.except("action", "controller", "q", "view", "utf8").each do |param, value| 
 unless param.match(/^filter_option/) || param.match(/^checkbox_filter_option/) || param.match(/^nf_/) || param.match(/^price_/) 
 hidden_field_tag param, value 
 end 
 end 
 hidden_field_tag "view", @view_type 
 content_for(:page_content) 
 else 
 content_for(:page_content) 
 end 
  if (APP_CONFIG.use_google_analytics) 
 "_gaq.push(['_setAccount', '#{APP_CONFIG.google_analytics_key}']);" 
 "_gaq.push(['_setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 if @current_community && @current_community.google_analytics_key 
 "_gaq.push(['b._setAccount', '#{@current_community.google_analytics_key}']);" 
 "_gaq.push(['b._setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{Maybe(@current_community.name(I18n.locale)).gsub("'","").or_else("")}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{@current_community.domain}']);" 
 end 
 end 
 
 content_for(:location_search) 
  
 javascript_include_tag 'application' 
 if @analytics_event 
 end 
 if Rails.env.test? 
 end 
 content_for :extra_javascript 
  t('error_pages.no_javascript.javascript_is_disabled_in_your_browser') 
 t('error_pages.no_javascript.kassi_does_not_currently_work_without_javascript') 
 

end

    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
   if APP_CONFIG.use_kissmetrics 
 "_kms('//i.kissmetrics.com/i.js');_kms('#{APP_CONFIG.kissmetrics_url}');" 
 if @current_user 
 "_kmq.push(['identify', '#{@current_user.id}']);" 
 end 
 if @current_community 
 "_kmq.push(['set', {}]);" 
 else 
 "_kmq.push(['set', {'SiteName' : 'dashboard'}]);" 
 end 
 end 
 
 content_for :head 
  
 
  link_to t("homepage.index.post_new_listing"), new_listing_path, :class => "new-listing-link", :id => "new-listing-link" 
 Maybe(@current_user).each do |user| 
 conversations = @current_community.conversations.for_person(user) 
 unread_count = MarketplaceService::Inbox::Query.notification_count(user.id, @current_community.id) 
  image_tag user.image.url(:thumb), alt: '', class: 'header-user-avatar' 
 user.name(@current_community) 
 icon_tag("dropdown", ["icon-dropdown"]) 
 
  link_to person_inbox_path(@current_user) do 
 icon_tag("mail", ["icon-with-text"]) 
 t("layouts.conversations.messages") 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 link_to person_path(user) do 
 icon_tag("user", ["icon-with-text"]) 
 t("header.profile") 
 end 
 link_to person_settings_path(user) do 
 icon_tag("settings", ["icon-with-text"]) 
 t("layouts.logged_in.settings") 
 end 
 link_to logout_path do 
 icon_tag("logout", ["icon-with-text"]) 
 t("layouts.logged_in.logout") 
 end 
 
  link_to person_inbox_path(user), title: t("layouts.conversations.messages"), :id => "inbox-link", :class => "header-text-link header-hover header-inbox-link" do 
 icon_tag("mail", ["header-inbox"]) 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 
 end 
 with_available_locales do |locales| 
 get_full_locale_name(I18n.locale).to_s 
 icon_tag("dropdown", ["icon-dropdown"]) 
  
 end 
 unless @current_user 
 link_to sign_up_path, class: "header-text-link header-hover" do 
 t("header.signup") 
 end 
 link_to login_path, class: "header-text-link header-hover", id: "header-login-link" do 
 t("header.login") 
 end 
 end 
 icon_tag("rows", ["header-menu-icon"]) 
 t("header.menu") 
  link_to "/" do 
 icon_tag("home", ["icon-with-text"]) 
 t("header.home") 
 end 
 link_to new_listing_path, :class => "hidden-tablet" do 
 icon_tag("new_listing", ["icon-with-text"]) 
 t("homepage.index.post_new_listing") 
 end 
 link_to about_infos_path do 
 icon_tag("information", ["icon-with-text"]) 
 t("header.about") 
 end 
 link_to new_user_feedback_path do 
 icon_tag("feedback", ["icon-with-text"]) 
 t("header.contact_us") 
 end 
 with_invite_link do 
 link_to new_invitation_path do 
 icon_tag("invite", ["icon-with-text"]) 
 t("header.invite") 
 end 
 end 
 Maybe(@current_community).menu_links.each do |menu_links| 
 menu_links.each do |menu_link| 
 link_to menu_link.url(I18n.locale), :target => "_blank" do 
 icon_tag("redirect", ["icon-with-text"]) 
 menu_link.title(I18n.locale) 
 end 
 end 
 end 
 if @current_user && @current_community && @current_user.has_admin_rights_in?(@current_community) 
 link_to edit_details_admin_community_path(@current_community) do 
 icon_tag("admin", ["icon-with-text"]) 
 t("layouts.logged_in.admin") 
 end 
 end 
 with_available_locales do |locales| 
 t("layouts.global-header.select_language") 
  
 end 
 
 link_to @homepage_path, :class => "header-logo", :id => "header-logo" do 
 end 
 
 if display_expiration_notice? 
  content_for :javascript do 
 end 
 t("expiration.title") 
 t("expiration.sub_title_new") 
 external_plan_service_login_url 
 t("expiration.link_to_external_service") 
 t("expiration.need_more_info") 
 t("expiration.contact_us") 
 
 end 
 content_for(:page_content) do 
 with_big_cover_photo do 
 yield :title_header 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 yield :title_header 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 icon_class 
 flash[announcement] 
 end 
 end 
 
 t(".listing_not_visible") 
 end 
 if params[:controller] == "homepage" && params[:action] == "index" 
 params.except("action", "controller", "q", "view", "utf8").each do |param, value| 
 unless param.match(/^filter_option/) || param.match(/^checkbox_filter_option/) || param.match(/^nf_/) || param.match(/^price_/) 
 hidden_field_tag param, value 
 end 
 end 
 hidden_field_tag "view", @view_type 
 content_for(:page_content) 
 else 
 content_for(:page_content) 
 end 
  if (APP_CONFIG.use_google_analytics) 
 "_gaq.push(['_setAccount', '#{APP_CONFIG.google_analytics_key}']);" 
 "_gaq.push(['_setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 if @current_community && @current_community.google_analytics_key 
 "_gaq.push(['b._setAccount', '#{@current_community.google_analytics_key}']);" 
 "_gaq.push(['b._setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{Maybe(@current_community.name(I18n.locale)).gsub("'","").or_else("")}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{@current_community.domain}']);" 
 end 
 end 
 
 content_for(:location_search) 
  
 javascript_include_tag 'application' 
 if @analytics_event 
 end 
 if Rails.env.test? 
 end 
 content_for :extra_javascript 
  t('error_pages.no_javascript.javascript_is_disabled_in_your_browser') 
 t('error_pages.no_javascript.kassi_does_not_currently_work_without_javascript') 
 

end

    end
  end

  def show
    @selected_tribe_navi_tab = "home"

    @current_image = if params[:image]
      @listing.image_by_id(params[:image])
    else
      @listing.listing_images.first
    end

    @prev_image_id, @next_image_id = if @current_image
      @listing.prev_and_next_image_ids_by_id(@current_image.id)
    else
      [nil, nil]
    end

    payment_gateway = MarketplaceService::Community::Query.payment_type(@current_community.id)
    process = get_transaction_process(community_id: @current_community.id, transaction_process_id: @listing.transaction_process_id)
    form_path = new_transaction_path(listing_id: @listing.id)
    community_country_code = LocalizationUtils.valid_country_code(@current_community.country)

    delivery_opts = delivery_config(@listing.require_shipping_address, @listing.pickup_enabled, @listing.shipping_price, @listing.shipping_price_additional, @listing.currency)

    render locals: {
             form_path: form_path,
             payment_gateway: payment_gateway,
             # TODO I guess we should not need to know the process in order to show the listing
             process: process,
             delivery_opts: delivery_opts,
             listing_unit_type: @listing.unit_type,
             country_code: community_country_code
           }
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
   if APP_CONFIG.use_kissmetrics 
 "_kms('//i.kissmetrics.com/i.js');_kms('#{APP_CONFIG.kissmetrics_url}');" 
 if @current_user 
 "_kmq.push(['identify', '#{@current_user.id}']);" 
 end 
 if @current_community 
 "_kmq.push(['set', {}]);" 
 else 
 "_kmq.push(['set', {'SiteName' : 'dashboard'}]);" 
 end 
 end 
 
 content_for :head 
  
 
  link_to t("homepage.index.post_new_listing"), new_listing_path, :class => "new-listing-link", :id => "new-listing-link" 
 Maybe(@current_user).each do |user| 
 conversations = @current_community.conversations.for_person(user) 
 unread_count = MarketplaceService::Inbox::Query.notification_count(user.id, @current_community.id) 
  image_tag user.image.url(:thumb), alt: '', class: 'header-user-avatar' 
 user.name(@current_community) 
 icon_tag("dropdown", ["icon-dropdown"]) 
 
  link_to person_inbox_path(@current_user) do 
 icon_tag("mail", ["icon-with-text"]) 
 t("layouts.conversations.messages") 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 link_to person_path(user) do 
 icon_tag("user", ["icon-with-text"]) 
 t("header.profile") 
 end 
 link_to person_settings_path(user) do 
 icon_tag("settings", ["icon-with-text"]) 
 t("layouts.logged_in.settings") 
 end 
 link_to logout_path do 
 icon_tag("logout", ["icon-with-text"]) 
 t("layouts.logged_in.logout") 
 end 
 
  link_to person_inbox_path(user), title: t("layouts.conversations.messages"), :id => "inbox-link", :class => "header-text-link header-hover header-inbox-link" do 
 icon_tag("mail", ["header-inbox"]) 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 
 end 
 with_available_locales do |locales| 
 get_full_locale_name(I18n.locale).to_s 
 icon_tag("dropdown", ["icon-dropdown"]) 
  
 end 
 unless @current_user 
 link_to sign_up_path, class: "header-text-link header-hover" do 
 t("header.signup") 
 end 
 link_to login_path, class: "header-text-link header-hover", id: "header-login-link" do 
 t("header.login") 
 end 
 end 
 icon_tag("rows", ["header-menu-icon"]) 
 t("header.menu") 
  link_to "/" do 
 icon_tag("home", ["icon-with-text"]) 
 t("header.home") 
 end 
 link_to new_listing_path, :class => "hidden-tablet" do 
 icon_tag("new_listing", ["icon-with-text"]) 
 t("homepage.index.post_new_listing") 
 end 
 link_to about_infos_path do 
 icon_tag("information", ["icon-with-text"]) 
 t("header.about") 
 end 
 link_to new_user_feedback_path do 
 icon_tag("feedback", ["icon-with-text"]) 
 t("header.contact_us") 
 end 
 with_invite_link do 
 link_to new_invitation_path do 
 icon_tag("invite", ["icon-with-text"]) 
 t("header.invite") 
 end 
 end 
 Maybe(@current_community).menu_links.each do |menu_links| 
 menu_links.each do |menu_link| 
 link_to menu_link.url(I18n.locale), :target => "_blank" do 
 icon_tag("redirect", ["icon-with-text"]) 
 menu_link.title(I18n.locale) 
 end 
 end 
 end 
 if @current_user && @current_community && @current_user.has_admin_rights_in?(@current_community) 
 link_to edit_details_admin_community_path(@current_community) do 
 icon_tag("admin", ["icon-with-text"]) 
 t("layouts.logged_in.admin") 
 end 
 end 
 with_available_locales do |locales| 
 t("layouts.global-header.select_language") 
  
 end 
 
 link_to @homepage_path, :class => "header-logo", :id => "header-logo" do 
 end 
 
 if display_expiration_notice? 
  content_for :javascript do 
 end 
 t("expiration.title") 
 t("expiration.sub_title_new") 
 external_plan_service_login_url 
 t("expiration.link_to_external_service") 
 t("expiration.need_more_info") 
 t("expiration.contact_us") 
 
 end 
 content_for(:page_content) do 
 with_big_cover_photo do 
 @listing.title 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 @listing.title 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 icon_class 
 flash[announcement] 
 end 
 end 
 
 content_for :javascript do 
 end 
 content_for :extra_javascript do 
 javascript_include_tag "https://maps.google.com/maps/api/js?sensor=true" 
 end 
 content_for :title, raw(@listing.title) 
 content_for :meta_author, @listing.author.name(@current_community) 
 content_for :meta_description, StringUtils.first_words(@listing.description, 15) 
 content_for :meta_image, @listing.listing_images.first.image.url(:medium) if !@listing.listing_images.empty? 
 dimensions = @listing.listing_images.first.get_dimensions_for_style(:medium) if !@listing.listing_images.empty? 
 content_for :meta_image_width, dimensions[:width].to_s if !@listing.listing_images.empty? 
 content_for :meta_image_height, dimensions[:height].to_s if !@listing.listing_images.empty? 
 content_for :keywords, StringUtils.keywords(@listing.title) 
  
 with_image_frame(@listing) do |reason, listing_images| 
 if reason == :images_ok 
 if @prev_image_id && @next_image_id 
 link_to params.merge(image: @prev_image_id), class: "listing-image-navi listing-image-navi-left", id: "listing-image-navi-left" do 
 icon_tag("directleft", ["navigate-icon-fix", "listing-image-navi-arrow"]) 
 end 
 link_to params.merge(image: @next_image_id), class: "listing-image-navi listing-image-navi-right", id: "listing-image-navi-right" do 
 icon_tag("directright", ["navigate-icon-fix", "listing-image-navi-arrow"]) 
 end 
 end 
 content_for :extra_javascript do 
 end 
 else 
 if reason == :images_processing 
 t("listings.show.processing_uploaded_image") 
 else 
 t(".no_description") 
 end 
 end 
 end 
 if @listing.description && !@listing.description.blank? 
 text_with_line_breaks do 
 @listing.description 
 end 
 end 
 @listing.custom_field_values.each do |custom_field_value| 
 custom_field_value.with_type do |question_type| 
 render :partial => "listings/custom_field_partials/#{question_type}", :locals => { :custom_field_value => custom_field_value } 
 end 
 end 
 if @current_community.show_listing_publishing_date? 
 icon_tag("calendar", ["icon-part"]) 
 t(".listing_created_at") 
 l @listing.created_at, :format => :short_date 
 end 
 if !@current_community.private? 
 facebook_like(current_user?(@listing.author)) 
 link_to("", "https://twitter.com/share", :class => "twitter-share-button", "data" => {count: "horizontal", via: (@current_community.twitter_handle ), text: @listing.title }) 
 content_for :extra_javascript do 
 end 
 end 
 unless (@listing.closed? && !current_user?(@listing.author)) || !@current_community.listing_comments_in_use 
 icon_tag("chat_bubble", ["icon-with_text"]) 
 t(".comments") 
 "(#{@listing.comments_count})" 
  if @current_user 
 if @current_user.is_following?(@listing ) 
 link_to t(".unfollow"), unfollow_listing_path(@listing ), :class => "unfollow_listing", :method => :delete, :remote => :true 
 else 
 link_to t(".follow"), follow_listing_path(@listing ), :class => "follow_listing", :method => :post, :remote => :true 
 end 
 end 
 
  small_avatar_thumb(comment.author) 
 link_to_unless comment.author.deleted?, PersonViewUtils.person_display_name(comment.author, @current_community), comment.author 
 time_ago(comment.created_at) 
 if @current_user && (current_user?(comment.author) || @current_user.has_admin_rights_in?(@current_community)) 
 link_to t('listings.comment.delete'), listing_comment_path(:listing_id => comment.listing.id, :id => comment.id), {method: :delete, confirm: t('listings.comment.are_you_sure'), :remote => :true} 
 end 
 text_with_line_breaks do 
 comment.content 
 end 
 
  if @listing.closed? 
 t(".you_cannot_send_a_new_comment_because_listing_is_closed") 
 elsif logged_in? 
 form_for Comment.new, :url => listing_comments_path(:listing_id => @listing.id.to_s) do |f| 
 f.text_area :content, :class => "listing_comment_content_text_area", :placeholder => t(".ask_a_question") 
 check_box_tag "comment[author_follow_status]", "true", :checked => true 
 label_tag "comment_author_follow_status", t(".subscribe_to_comments"), :class => "comment_checkbox_label" 
 f.hidden_field :listing_id, :value => @listing.id.to_s 
 f.hidden_field :author_id, :value => @current_user.id 
 f.hidden_field :community_id, :value => @current_community.id 
 f.button t(".send_comment"), :id => "send_comment_button" 
 end 
 else 
 t(".you_must") 
 link_to t(".log_in"), login_path 
 t(".to_send_a_comment") 
 end 
 
 end 
 if @listing.price 
 humanized_money_with_symbol(@listing.price).upcase 
 with_quantity_and_vat_text(@current_community, @listing) do |text| 
 text 
 end 
 end 
  is_author = current_user?(@listing.author) 
 is_marketplace_admin = Maybe(@current_user).has_admin_rights_in?(@current_community).or_else(false) 
 is_authorized = is_author || is_marketplace_admin 
 if @listing.closed? 
 icon_tag("lock", ["icon-part"]) 
 t("listings.reply_link.listing_closed") 
 if is_authorized 
 edit_listing_path(@listing) 
 icon_tag("unlock", ["icon-part"]) 
 t("listings.edit_links.reopen_listing") 
 end 
 else 
 if is_author 
  if delivery_opts.present? 
 if is_author 
 t("listings.show.delivery") 
 delivery_opts.each do |opts| 
 opts[:price_info] 
 end 
 else 
 t("listings.show.delivery") 
 if delivery_opts.count == 1 
 t("listings.show.#{delivery_opts.first[:name]}_no_price") 
 if (delivery_opts.first[:name] == :shipping) 
 price_tag = "<span class=\"delivery-price-value\" data-shipping-price=\"#{delivery_opts.first[:price].cents}\" data-per-additional=\"#{Maybe(delivery_opts).first[:shipping_price_additional].cents.or_else(0)}\">#{humanized_money(delivery_opts.first[:price])}</span>" 
 symbol = delivery_opts.first[:price].currency.symbol 
 price_tag_with_currency = delivery_opts.first[:price].currency.symbol_first ? "(+#{symbol}#{price_tag})" : "(+#{price_tag} #{symbol})" 
 price_tag_with_currency.html_safe 
 end 
 else 
 delivery_opts.each do |opts| 
 radio_button_tag(:delivery, opts[:name], opts[:default]) 
 label_tag("delivery_#{opts[:name]}", class: "delivery-label shipping-options-label") do 
 t("listings.show.#{opts[:name]}_no_price") 
 if (opts[:name] == :shipping) 
 price_tag = "<span class=\"delivery-price-value\" data-shipping-price=\"#{opts[:price].cents}\" data-per-additional=\"#{Maybe(opts)[:shipping_price_additional].cents.or_else(0)}\">#{humanized_money(opts[:price])}</span>" 
 symbol = opts[:price].currency.symbol 
 price_tag_with_currency = opts[:price].currency.symbol_first ? "(+#{symbol}#{price_tag})" : "(+#{price_tag} #{symbol})" 
 price_tag_with_currency.html_safe 
 end 
 end 
 end 
 end 
 end 
 end 
 
 else 
 form_tag form_path, :method => :get, :id => "booking-dates" do 
 # Currently we show the selectors only for preauth process. 
 # However, there has been a plan to introduce these in other 
 # Processes (free) as well - rap1ds, 2.6.2015 
 if process != :postpay 
 if @listing.unit_type == :day 
 days = [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday] 
 months = [:january, :february, :march, :april, :may, :june, :july, :august, :september, :october, :november, :december] 
 translated_days = days.map {}.to_json 
 translated_days_short = days.map {}.to_json 
 translated_days_min = days.map {}.to_json 
 translated_months = months.map {}.to_json 
 translated_months_short = months.map {}.to_json 
 content_for :extra_javascript do 
 end 
 label_tag t(".booking_from") 
 label_tag t(".booking_to") 
 elsif listing_unit_type.present? 
 delivery_type = delivery_opts.length > 0 ? delivery_opts.first[:name].to_s : "" 
 shipping_price_additional = delivery_opts.length > 0 ? delivery_opts.first[:shipping_price_additional] : nil 
 content_for :extra_javascript do 
 end 
 ListingViewUtils.translate_quantity(@listing.unit_type, @listing.unit_selector_tr_key) 
 t("listings.quantity_placeholder") 
 end 
 end 
  if delivery_opts.present? 
 if is_author 
 t("listings.show.delivery") 
 delivery_opts.each do |opts| 
 opts[:price_info] 
 end 
 else 
 t("listings.show.delivery") 
 if delivery_opts.count == 1 
 t("listings.show.#{delivery_opts.first[:name]}_no_price") 
 if (delivery_opts.first[:name] == :shipping) 
 price_tag = "<span class=\"delivery-price-value\" data-shipping-price=\"#{delivery_opts.first[:price].cents}\" data-per-additional=\"#{Maybe(delivery_opts).first[:shipping_price_additional].cents.or_else(0)}\">#{humanized_money(delivery_opts.first[:price])}</span>" 
 symbol = delivery_opts.first[:price].currency.symbol 
 price_tag_with_currency = delivery_opts.first[:price].currency.symbol_first ? "(+#{symbol}#{price_tag})" : "(+#{price_tag} #{symbol})" 
 price_tag_with_currency.html_safe 
 end 
 else 
 delivery_opts.each do |opts| 
 radio_button_tag(:delivery, opts[:name], opts[:default]) 
 label_tag("delivery_#{opts[:name]}", class: "delivery-label shipping-options-label") do 
 t("listings.show.#{opts[:name]}_no_price") 
 if (opts[:name] == :shipping) 
 price_tag = "<span class=\"delivery-price-value\" data-shipping-price=\"#{opts[:price].cents}\" data-per-additional=\"#{Maybe(opts)[:shipping_price_additional].cents.or_else(0)}\">#{humanized_money(opts[:price])}</span>" 
 symbol = opts[:price].currency.symbol 
 price_tag_with_currency = opts[:price].currency.symbol_first ? "(+#{symbol}#{price_tag})" : "(+#{price_tag} #{symbol})" 
 price_tag_with_currency.html_safe 
 end 
 end 
 end 
 end 
 end 
 end 
 
 hidden_field_tag(:listing_id, @listing.id) 
 action_button_label(@listing) 
 end 
 if payment_gateway == :paypal && process != :none 
  how_paypal_works_link = PaypalCountryHelper.popup_link(country_code) 
 image_tag "https://www.paypalobjects.com/webstatic/en_US/i/buttons/cc-badges-ppmcvdam.png", style: "max-width: 100%" 
 how_paypal_works_link 
 t("listings.listing_actions.how_paypal_works") 
 t("listings.listing_actions.payment_help") 
 content_for :extra_javascript do 
 end 
 
 end 
 end 
 if is_authorized 
 edit_listing_path(@listing) 
 icon_tag("edit", ["icon-part"]) 
 t("listings.edit_links.edit_listing") 
 icon_tag("lock", ["icon-part"]) 
 t("listings.edit_links.close_listing") 
 if is_marketplace_admin 
 link_to move_to_top_person_listing_path(@current_user, @listing), data: { method: "put" } do 
 icon_tag("star", ["icon-part"]) 
 t("listings.edit_links.move_to_top") 
 end 
 link_to show_in_updates_email_person_listing_path(@current_user, @listing), data: { method: "put", remote: "true" }, :id => "add-to-updates-email"  do 
 icon_tag("mail", ["icon-part"]) 
 t("listings.edit_links.show_in_updates_email") 
 end 
 end 
 end 
 end 
 
 medium_avatar_thumb(@listing.author, {:class => "listing-author-avatar-image"}) 
 link_to @listing.author.name(@current_community), @listing.author, :id => "listing-author-link", :class => "listing-author-name-link", :title => "#{@listing.author.name(@current_community)}" 
 if @listing.author != @current_user 
 contact_to_listing_path(:listing_id => @listing.id.to_s) 
 t(".contact") 
 end 
 if @current_community.testimonials_in_use && @listing.author.received_testimonials.size > 0 
 icon_class("testimonial") 
 if @listing.author.received_testimonials.size > 0 
 @listing.author.feedback_positive_percentage.to_s + "%" 
 t("people.show.positive") 
 "(#{@listing.author.received_positive_testimonials.size}/#{@listing.author.received_testimonials.size})" 
 else 
 t(".no_reviews") 
 end 
 t(".feedback") 
 end 
 if @listing.origin_loc && @listing.origin_loc.address != "" 
  content_for :extra_javascript do 
 end 
 icon_tag("external_link", ["icon-part"]) 
 t("listings.map.open_in_google_maps") 
 
  fields_for :origin_loc do |loc| 
 loc.hidden_field :address, :value => origin_loc.address 
 loc.hidden_field :google_address, :value => origin_loc.google_address 
 loc.hidden_field :latitude, :value => origin_loc.latitude 
 loc.hidden_field :longitude, :value => origin_loc.longitude 
 loc.hidden_field :location_type, :value => origin_loc.location_type 
 end 
 
 end 
 end 
 if params[:controller] == "homepage" && params[:action] == "index" 
 params.except("action", "controller", "q", "view", "utf8").each do |param, value| 
 unless param.match(/^filter_option/) || param.match(/^checkbox_filter_option/) || param.match(/^nf_/) || param.match(/^price_/) 
 hidden_field_tag param, value 
 end 
 end 
 hidden_field_tag "view", @view_type 
 content_for(:page_content) 
 else 
 content_for(:page_content) 
 end 
  if (APP_CONFIG.use_google_analytics) 
 "_gaq.push(['_setAccount', '#{APP_CONFIG.google_analytics_key}']);" 
 "_gaq.push(['_setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 if @current_community && @current_community.google_analytics_key 
 "_gaq.push(['b._setAccount', '#{@current_community.google_analytics_key}']);" 
 "_gaq.push(['b._setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{Maybe(@current_community.name(I18n.locale)).gsub("'","").or_else("")}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{@current_community.domain}']);" 
 end 
 end 
 
 content_for(:location_search) 
  
 javascript_include_tag 'application' 
 if @analytics_event 
 end 
 if Rails.env.test? 
 end 
 content_for :extra_javascript 
  t('error_pages.no_javascript.javascript_is_disabled_in_your_browser') 
 t('error_pages.no_javascript.kassi_does_not_currently_work_without_javascript') 
 

end

  end

  def new
    category_tree = CategoryViewUtils.category_tree(
      categories: ListingService::API::Api.categories.get_all(community_id: @current_community.id)[:data],
      shapes: get_shapes,
      locale: I18n.locale,
      all_locales: @current_community.locales
    )

    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
   if APP_CONFIG.use_kissmetrics 
 "_kms('//i.kissmetrics.com/i.js');_kms('#{APP_CONFIG.kissmetrics_url}');" 
 if @current_user 
 "_kmq.push(['identify', '#{@current_user.id}']);" 
 end 
 if @current_community 
 "_kmq.push(['set', {}]);" 
 else 
 "_kmq.push(['set', {'SiteName' : 'dashboard'}]);" 
 end 
 end 
 
 content_for :head 
  
 
  link_to t("homepage.index.post_new_listing"), new_listing_path, :class => "new-listing-link", :id => "new-listing-link" 
 Maybe(@current_user).each do |user| 
 conversations = @current_community.conversations.for_person(user) 
 unread_count = MarketplaceService::Inbox::Query.notification_count(user.id, @current_community.id) 
  image_tag user.image.url(:thumb), alt: '', class: 'header-user-avatar' 
 user.name(@current_community) 
 icon_tag("dropdown", ["icon-dropdown"]) 
 
  link_to person_inbox_path(@current_user) do 
 icon_tag("mail", ["icon-with-text"]) 
 t("layouts.conversations.messages") 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 link_to person_path(user) do 
 icon_tag("user", ["icon-with-text"]) 
 t("header.profile") 
 end 
 link_to person_settings_path(user) do 
 icon_tag("settings", ["icon-with-text"]) 
 t("layouts.logged_in.settings") 
 end 
 link_to logout_path do 
 icon_tag("logout", ["icon-with-text"]) 
 t("layouts.logged_in.logout") 
 end 
 
  link_to person_inbox_path(user), title: t("layouts.conversations.messages"), :id => "inbox-link", :class => "header-text-link header-hover header-inbox-link" do 
 icon_tag("mail", ["header-inbox"]) 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 
 end 
 with_available_locales do |locales| 
 get_full_locale_name(I18n.locale).to_s 
 icon_tag("dropdown", ["icon-dropdown"]) 
  
 end 
 unless @current_user 
 link_to sign_up_path, class: "header-text-link header-hover" do 
 t("header.signup") 
 end 
 link_to login_path, class: "header-text-link header-hover", id: "header-login-link" do 
 t("header.login") 
 end 
 end 
 icon_tag("rows", ["header-menu-icon"]) 
 t("header.menu") 
  link_to "/" do 
 icon_tag("home", ["icon-with-text"]) 
 t("header.home") 
 end 
 link_to new_listing_path, :class => "hidden-tablet" do 
 icon_tag("new_listing", ["icon-with-text"]) 
 t("homepage.index.post_new_listing") 
 end 
 link_to about_infos_path do 
 icon_tag("information", ["icon-with-text"]) 
 t("header.about") 
 end 
 link_to new_user_feedback_path do 
 icon_tag("feedback", ["icon-with-text"]) 
 t("header.contact_us") 
 end 
 with_invite_link do 
 link_to new_invitation_path do 
 icon_tag("invite", ["icon-with-text"]) 
 t("header.invite") 
 end 
 end 
 Maybe(@current_community).menu_links.each do |menu_links| 
 menu_links.each do |menu_link| 
 link_to menu_link.url(I18n.locale), :target => "_blank" do 
 icon_tag("redirect", ["icon-with-text"]) 
 menu_link.title(I18n.locale) 
 end 
 end 
 end 
 if @current_user && @current_community && @current_user.has_admin_rights_in?(@current_community) 
 link_to edit_details_admin_community_path(@current_community) do 
 icon_tag("admin", ["icon-with-text"]) 
 t("layouts.logged_in.admin") 
 end 
 end 
 with_available_locales do |locales| 
 t("layouts.global-header.select_language") 
  
 end 
 
 link_to @homepage_path, :class => "header-logo", :id => "header-logo" do 
 end 
 
 if display_expiration_notice? 
  content_for :javascript do 
 end 
 t("expiration.title") 
 t("expiration.sub_title_new") 
 external_plan_service_login_url 
 t("expiration.link_to_external_service") 
 t("expiration.need_more_info") 
 t("expiration.contact_us") 
 
 end 
 content_for(:page_content) do 
 with_big_cover_photo do 
 t("listings.new.post_a_new_listing") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("listings.new.post_a_new_listing") 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 icon_class 
 flash[announcement] 
 end 
 end 
 
 content_for :extra_javascript do 
 end 
 content_for :extra_javascript do 
 javascript_include_tag "https://maps.google.com/maps/api/js?sensor=true" 
 end 
  
 if categories.size > 1 
 categories.each do |value| 
 t(".selected_category", :category => value.display_name(I18n.locale)) 
 end 
 end 
 if subcategories.size > 1 
 subcategories.each do |value| 
 t(".selected_subcategory", :subcategory => value.display_name(I18n.locale)) 
 end 
 end 
 if shapes.size > 1 
 shapes.each do |value| 
 t(".selected_transaction_type", :transaction_type => t(value[:name_tr_key])) 
 end 
 end 
 if categories.size > 1 
 categories.each do |value| 
 value.display_name(I18n.locale) 
 end 
 end 
 if subcategories.size > 1 
 subcategories.each do |value| 
 value.display_name(I18n.locale) 
 end 
 end 
 if shapes.size > 1 
 shapes.each do |value| 
 t(value[:name_tr_key]) 
 end 
 end 
 end 
 if params[:controller] == "homepage" && params[:action] == "index" 
 params.except("action", "controller", "q", "view", "utf8").each do |param, value| 
 unless param.match(/^filter_option/) || param.match(/^checkbox_filter_option/) || param.match(/^nf_/) || param.match(/^price_/) 
 hidden_field_tag param, value 
 end 
 end 
 hidden_field_tag "view", @view_type 
 content_for(:page_content) 
 else 
 content_for(:page_content) 
 end 
  if (APP_CONFIG.use_google_analytics) 
 "_gaq.push(['_setAccount', '#{APP_CONFIG.google_analytics_key}']);" 
 "_gaq.push(['_setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 if @current_community && @current_community.google_analytics_key 
 "_gaq.push(['b._setAccount', '#{@current_community.google_analytics_key}']);" 
 "_gaq.push(['b._setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{Maybe(@current_community.name(I18n.locale)).gsub("'","").or_else("")}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{@current_community.domain}']);" 
 end 
 end 
 
 content_for(:location_search) 
  
 javascript_include_tag 'application' 
 if @analytics_event 
 end 
 if Rails.env.test? 
 end 
 content_for :extra_javascript 
  t('error_pages.no_javascript.javascript_is_disabled_in_your_browser') 
 t('error_pages.no_javascript.kassi_does_not_currently_work_without_javascript') 
 

end

ruby_code_from_view.ruby_code_from_view do |rb_from_view|
   if APP_CONFIG.use_kissmetrics 
 "_kms('//i.kissmetrics.com/i.js');_kms('#{APP_CONFIG.kissmetrics_url}');" 
 if @current_user 
 "_kmq.push(['identify', '#{@current_user.id}']);" 
 end 
 if @current_community 
 "_kmq.push(['set', {}]);" 
 else 
 "_kmq.push(['set', {'SiteName' : 'dashboard'}]);" 
 end 
 end 
 
 content_for :head 
  
 
  link_to t("homepage.index.post_new_listing"), new_listing_path, :class => "new-listing-link", :id => "new-listing-link" 
 Maybe(@current_user).each do |user| 
 conversations = @current_community.conversations.for_person(user) 
 unread_count = MarketplaceService::Inbox::Query.notification_count(user.id, @current_community.id) 
  image_tag user.image.url(:thumb), alt: '', class: 'header-user-avatar' 
 user.name(@current_community) 
 icon_tag("dropdown", ["icon-dropdown"]) 
 
  link_to person_inbox_path(@current_user) do 
 icon_tag("mail", ["icon-with-text"]) 
 t("layouts.conversations.messages") 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 link_to person_path(user) do 
 icon_tag("user", ["icon-with-text"]) 
 t("header.profile") 
 end 
 link_to person_settings_path(user) do 
 icon_tag("settings", ["icon-with-text"]) 
 t("layouts.logged_in.settings") 
 end 
 link_to logout_path do 
 icon_tag("logout", ["icon-with-text"]) 
 t("layouts.logged_in.logout") 
 end 
 
  link_to person_inbox_path(user), title: t("layouts.conversations.messages"), :id => "inbox-link", :class => "header-text-link header-hover header-inbox-link" do 
 icon_tag("mail", ["header-inbox"]) 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 
 end 
 with_available_locales do |locales| 
 get_full_locale_name(I18n.locale).to_s 
 icon_tag("dropdown", ["icon-dropdown"]) 
  
 end 
 unless @current_user 
 link_to sign_up_path, class: "header-text-link header-hover" do 
 t("header.signup") 
 end 
 link_to login_path, class: "header-text-link header-hover", id: "header-login-link" do 
 t("header.login") 
 end 
 end 
 icon_tag("rows", ["header-menu-icon"]) 
 t("header.menu") 
  link_to "/" do 
 icon_tag("home", ["icon-with-text"]) 
 t("header.home") 
 end 
 link_to new_listing_path, :class => "hidden-tablet" do 
 icon_tag("new_listing", ["icon-with-text"]) 
 t("homepage.index.post_new_listing") 
 end 
 link_to about_infos_path do 
 icon_tag("information", ["icon-with-text"]) 
 t("header.about") 
 end 
 link_to new_user_feedback_path do 
 icon_tag("feedback", ["icon-with-text"]) 
 t("header.contact_us") 
 end 
 with_invite_link do 
 link_to new_invitation_path do 
 icon_tag("invite", ["icon-with-text"]) 
 t("header.invite") 
 end 
 end 
 Maybe(@current_community).menu_links.each do |menu_links| 
 menu_links.each do |menu_link| 
 link_to menu_link.url(I18n.locale), :target => "_blank" do 
 icon_tag("redirect", ["icon-with-text"]) 
 menu_link.title(I18n.locale) 
 end 
 end 
 end 
 if @current_user && @current_community && @current_user.has_admin_rights_in?(@current_community) 
 link_to edit_details_admin_community_path(@current_community) do 
 icon_tag("admin", ["icon-with-text"]) 
 t("layouts.logged_in.admin") 
 end 
 end 
 with_available_locales do |locales| 
 t("layouts.global-header.select_language") 
  
 end 
 
 link_to @homepage_path, :class => "header-logo", :id => "header-logo" do 
 end 
 
 if display_expiration_notice? 
  content_for :javascript do 
 end 
 t("expiration.title") 
 t("expiration.sub_title_new") 
 external_plan_service_login_url 
 t("expiration.link_to_external_service") 
 t("expiration.need_more_info") 
 t("expiration.contact_us") 
 
 end 
 content_for(:page_content) do 
 with_big_cover_photo do 
 t("listings.new.post_a_new_listing") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("listings.new.post_a_new_listing") 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 icon_class 
 flash[announcement] 
 end 
 end 
 
 content_for :extra_javascript do 
 end 
 content_for :extra_javascript do 
 javascript_include_tag "https://maps.google.com/maps/api/js?sensor=true" 
 end 
  
 if categories.size > 1 
 categories.each do |value| 
 t(".selected_category", :category => value.display_name(I18n.locale)) 
 end 
 end 
 if subcategories.size > 1 
 subcategories.each do |value| 
 t(".selected_subcategory", :subcategory => value.display_name(I18n.locale)) 
 end 
 end 
 if shapes.size > 1 
 shapes.each do |value| 
 t(".selected_transaction_type", :transaction_type => t(value[:name_tr_key])) 
 end 
 end 
 if categories.size > 1 
 categories.each do |value| 
 value.display_name(I18n.locale) 
 end 
 end 
 if subcategories.size > 1 
 subcategories.each do |value| 
 value.display_name(I18n.locale) 
 end 
 end 
 if shapes.size > 1 
 shapes.each do |value| 
 t(value[:name_tr_key]) 
 end 
 end 
 end 
 if params[:controller] == "homepage" && params[:action] == "index" 
 params.except("action", "controller", "q", "view", "utf8").each do |param, value| 
 unless param.match(/^filter_option/) || param.match(/^checkbox_filter_option/) || param.match(/^nf_/) || param.match(/^price_/) 
 hidden_field_tag param, value 
 end 
 end 
 hidden_field_tag "view", @view_type 
 content_for(:page_content) 
 else 
 content_for(:page_content) 
 end 
  if (APP_CONFIG.use_google_analytics) 
 "_gaq.push(['_setAccount', '#{APP_CONFIG.google_analytics_key}']);" 
 "_gaq.push(['_setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 if @current_community && @current_community.google_analytics_key 
 "_gaq.push(['b._setAccount', '#{@current_community.google_analytics_key}']);" 
 "_gaq.push(['b._setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{Maybe(@current_community.name(I18n.locale)).gsub("'","").or_else("")}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{@current_community.domain}']);" 
 end 
 end 
 
 content_for(:location_search) 
  
 javascript_include_tag 'application' 
 if @analytics_event 
 end 
 if Rails.env.test? 
 end 
 content_for :extra_javascript 
  t('error_pages.no_javascript.javascript_is_disabled_in_your_browser') 
 t('error_pages.no_javascript.kassi_does_not_currently_work_without_javascript') 
 

end

  end

  def new_form_content
    return redirect_to action: :new unless request.xhr?

    @listing = Listing.new

    if (@current_user.location != nil)
      temp = @current_user.location
      temp.location_type = "origin_loc"
      @listing.build_origin_loc(temp.attributes)
    else
      @listing.build_origin_loc(:location_type => "origin_loc")
    end

    form_content
  end

  def edit_form_content
    return redirect_to action: :edit unless request.xhr?

    if !@listing.origin_loc
        @listing.build_origin_loc(:location_type => "origin_loc")
    end

    form_content
  end

  def create
    params[:listing].delete("origin_loc_attributes") if params[:listing][:origin_loc_attributes][:address].blank?

    shape = get_shape(Maybe(params)[:listing][:listing_shape_id].to_i.or_else(nil))

    listing_params = ListingFormViewUtils.filter(params[:listing], shape)
    listing_unit = Maybe(params)[:listing][:unit].map { |u| ListingViewUtils::Unit.deserialize(u) }.or_else(nil)
    listing_params = ListingFormViewUtils.filter_additional_shipping(listing_params, listing_unit)
    validation_result = ListingFormViewUtils.validate(listing_params, shape, listing_unit)

    unless validation_result.success
      flash[:error] = t("listings.error.something_went_wrong", error_code: validation_result.data.join(', '))
      return redirect_to new_listing_path
    end

    listing_params = normalize_price_params(listing_params)
    m_unit = select_unit(listing_unit, shape)

    listing_params = create_listing_params(listing_params).merge(
        community_id: @current_community.id,
        listing_shape_id: shape[:id],
        transaction_process_id: shape[:transaction_process_id],
        shape_name_tr_key: shape[:name_tr_key],
        action_button_tr_key: shape[:action_button_tr_key],
    ).merge(unit_to_listing_opts(m_unit)).except(:unit)

    @listing = Listing.new(listing_params)

    ActiveRecord::Base.transaction do
      @listing.author = @current_user

      if @listing.save
        upsert_field_values!(@listing, params[:custom_fields])

        listing_image_ids =
          if params[:listing_images]
            params[:listing_images].collect { |h| h[:id] }.select { |id| id.present? }
          else
            logger.error("Listing images array is missing", nil, {params: params})
            []
          end

        ListingImage.where(id: listing_image_ids, author_id: @current_user.id).update_all(listing_id: @listing.id)

        Delayed::Job.enqueue(ListingCreatedJob.new(@listing.id, @current_community.id))
        if @current_community.follow_in_use?
          Delayed::Job.enqueue(NotifyFollowersJob.new(@listing.id, @current_community.id), :run_at => NotifyFollowersJob::DELAY.from_now)
        end

        flash[:notice] = t(
          "layouts.notifications.listing_created_successfully",
          :new_listing_link => view_context.link_to(t("layouts.notifications.create_new_listing"),new_listing_path)
        ).html_safe
        redirect_to @listing, status: 303 and return
      else
        logger.error("Errors in creating listing: #{@listing.errors.full_messages.inspect}")
        flash[:error] = t(
          "layouts.notifications.listing_could_not_be_saved",
          :contact_admin_link => view_context.link_to(t("layouts.notifications.contact_admin_link_text"), new_user_feedback_path, :class => "flash-error-link")
        ).html_safe
        redirect_to new_listing_path and return
      end
    end
  end

  def edit
    @selected_tribe_navi_tab = "home"
    if !@listing.origin_loc
        @listing.build_origin_loc(:location_type => "origin_loc")
    end

    @custom_field_questions = @listing.category.custom_fields.find_all_by_community_id(@current_community.id)
    @numeric_field_ids = numeric_field_ids(@custom_field_questions)

    shape = select_shape(get_shapes, @listing.listing_shape_id)

    if shape
      @listing.listing_shape_id = shape[:id]
    end

    category_tree = CategoryViewUtils.category_tree(
      categories: ListingService::API::Api.categories.get_all(community_id: @current_community.id)[:data],
      shapes: get_shapes,
      locale: I18n.locale,
      all_locales: @current_community.locales
    )

    category_id, subcategory_id =
      if @listing.category.parent_id
        [@listing.category.parent_id, @listing.category.id]
      else
        [@listing.category.id, nil]
      end

    render locals: {
             category_tree: category_tree,
             categories: @current_community.top_level_categories,
             subcategories: @current_community.subcategories,
             shapes: get_shapes,
             category_id: category_id,
             subcategory_id: subcategory_id,
             shape_id: @listing.listing_shape_id,
             form_content: form_locals(shape)
           }
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
   if APP_CONFIG.use_kissmetrics 
 "_kms('//i.kissmetrics.com/i.js');_kms('#{APP_CONFIG.kissmetrics_url}');" 
 if @current_user 
 "_kmq.push(['identify', '#{@current_user.id}']);" 
 end 
 if @current_community 
 "_kmq.push(['set', {}]);" 
 else 
 "_kmq.push(['set', {'SiteName' : 'dashboard'}]);" 
 end 
 end 
 
 content_for :head 
  
 
  link_to t("homepage.index.post_new_listing"), new_listing_path, :class => "new-listing-link", :id => "new-listing-link" 
 Maybe(@current_user).each do |user| 
 conversations = @current_community.conversations.for_person(user) 
 unread_count = MarketplaceService::Inbox::Query.notification_count(user.id, @current_community.id) 
  image_tag user.image.url(:thumb), alt: '', class: 'header-user-avatar' 
 user.name(@current_community) 
 icon_tag("dropdown", ["icon-dropdown"]) 
 
  link_to person_inbox_path(@current_user) do 
 icon_tag("mail", ["icon-with-text"]) 
 t("layouts.conversations.messages") 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 link_to person_path(user) do 
 icon_tag("user", ["icon-with-text"]) 
 t("header.profile") 
 end 
 link_to person_settings_path(user) do 
 icon_tag("settings", ["icon-with-text"]) 
 t("layouts.logged_in.settings") 
 end 
 link_to logout_path do 
 icon_tag("logout", ["icon-with-text"]) 
 t("layouts.logged_in.logout") 
 end 
 
  link_to person_inbox_path(user), title: t("layouts.conversations.messages"), :id => "inbox-link", :class => "header-text-link header-hover header-inbox-link" do 
 icon_tag("mail", ["header-inbox"]) 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 
 end 
 with_available_locales do |locales| 
 get_full_locale_name(I18n.locale).to_s 
 icon_tag("dropdown", ["icon-dropdown"]) 
  
 end 
 unless @current_user 
 link_to sign_up_path, class: "header-text-link header-hover" do 
 t("header.signup") 
 end 
 link_to login_path, class: "header-text-link header-hover", id: "header-login-link" do 
 t("header.login") 
 end 
 end 
 icon_tag("rows", ["header-menu-icon"]) 
 t("header.menu") 
  link_to "/" do 
 icon_tag("home", ["icon-with-text"]) 
 t("header.home") 
 end 
 link_to new_listing_path, :class => "hidden-tablet" do 
 icon_tag("new_listing", ["icon-with-text"]) 
 t("homepage.index.post_new_listing") 
 end 
 link_to about_infos_path do 
 icon_tag("information", ["icon-with-text"]) 
 t("header.about") 
 end 
 link_to new_user_feedback_path do 
 icon_tag("feedback", ["icon-with-text"]) 
 t("header.contact_us") 
 end 
 with_invite_link do 
 link_to new_invitation_path do 
 icon_tag("invite", ["icon-with-text"]) 
 t("header.invite") 
 end 
 end 
 Maybe(@current_community).menu_links.each do |menu_links| 
 menu_links.each do |menu_link| 
 link_to menu_link.url(I18n.locale), :target => "_blank" do 
 icon_tag("redirect", ["icon-with-text"]) 
 menu_link.title(I18n.locale) 
 end 
 end 
 end 
 if @current_user && @current_community && @current_user.has_admin_rights_in?(@current_community) 
 link_to edit_details_admin_community_path(@current_community) do 
 icon_tag("admin", ["icon-with-text"]) 
 t("layouts.logged_in.admin") 
 end 
 end 
 with_available_locales do |locales| 
 t("layouts.global-header.select_language") 
  
 end 
 
 link_to @homepage_path, :class => "header-logo", :id => "header-logo" do 
 end 
 
 if display_expiration_notice? 
  content_for :javascript do 
 end 
 t("expiration.title") 
 t("expiration.sub_title_new") 
 external_plan_service_login_url 
 t("expiration.link_to_external_service") 
 t("expiration.need_more_info") 
 t("expiration.contact_us") 
 
 end 
 content_for(:page_content) do 
 with_big_cover_photo do 
 t(".edit_listing") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t(".edit_listing") 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 icon_class 
 flash[announcement] 
 end 
 end 
 
  
 content_for :extra_javascript do 
 end 
 content_for :extra_javascript do 
 javascript_include_tag "https://maps.google.com/maps/api/js?sensor=true" 
 end 
 if categories.size > 1 
 categories.each do |value| 
 t("listings.new.selected_category", :category => value.display_name(I18n.locale)) 
 end 
 end 
 if subcategories.size > 1 
 subcategories.each do |value| 
 t("listings.new.selected_subcategory", :subcategory => value.display_name(I18n.locale)) 
 end 
 end 
 if shapes.size > 1 
 shapes.each do |value| 
 t("listings.new.selected_transaction_type", :transaction_type => t(value[:name_tr_key])) 
 end 
 end 
 if categories.size > 1 
 categories.each do |value| 
 value.display_name(I18n.locale) 
 end 
 end 
 if subcategories.size > 1 
 subcategories.each do |value| 
 value.display_name(I18n.locale) 
 end 
 end 
 if shapes.size > 1 
 shapes.each do |value| 
 t(value[:name_tr_key]) 
 end 
 end 
 if form_content 
   valid_until_msg = t('error_messages.listings.valid_until') 
 js_t ["listings.form.images.processing", "listings.form.images.this_may_take_a_while", "listings.form.images.percentage_loaded", "listings.form.images.uploading_failed", "listings.form.images.file_too_large", "listings.form.images.image_processing_failed", "listings.form.images.accepted_formats", "listings.form.images.loading_image", "listings.form.images.select_file", "listings.form.images.removing", "listings.form.images.add_more"], run_js_immediately 
 content_for :listing_js do 
 end 
 if run_js_immediately 
 yield :listing_js 
 else 
 content_for :extra_javascript do 
 yield :listing_js 
 end 
 end 
 
 form_for @listing, :html => {:multipart => true} do |form| 
  form.label :title, t(".listing_title") + "*", :class => "input" 
 form.text_field(:title, :class => "title_text_field", :maxlength => "60") 
 
  if shape[:price_enabled] 
 form.label :price, t(".price") 
 form.text_field :price, :class => "price-field", :maxlength => "10", :placeholder => "0", :value => (@listing.price ? @listing.price.to_s: 0) 
  if @current_community.available_currencies 
 currencies = @current_community.available_currencies.gsub(" ","").split(",") 
 if currencies.size > 1 
 form.select :currency, currencies, { :selected => (@listing.currency ) } 
 else 
 Money.new(1, currencies[0]).symbol 
 form.hidden_field :currency, :value => currencies[0] 
 end 
 else 
 form.select :currency, major_currencies(Money::Currency.table), { :selected => (@listing.currency ) } 
 end 
 
 if unit_options.empty? 
 elsif unit_options.length == 1 
 unit_option = unit_options.first 
 t(".per") 
 unit_option[:display] 
 hidden_field_tag("listing[unit]", unit_option[:value]) 
 else 
 t(".per") 
 unit_options.each do |unit_option| 
 unit_option[:display] 
 end 
 end 
 paypal_fee_info_link = capture do 
 t(".paypal_fee_info_link_text") 
 end 
 t(".price_excludes_vat", :vat => @current_community.vat) if @current_community.vat 
 if !seller_commission_in_use && payment_gateway == :paypal 
 t(".no_service_fee_you_will_get_paypal_text", :paypal_fee_info_link => paypal_fee_info_link).html_safe 
 elsif seller_commission_in_use 
 content_for :seller_commission_js do 
 end 
 if run_js_immediately 
 yield :seller_commission_js 
 else 
 content_for :extra_javascript do 
 yield :seller_commission_js 
 end 
 end 
 if payment_gateway == :paypal 
 t(".after_service_fee_you_will_get_paypal_text", :sum_with_currency => '<span id="fee_display"></span>', :paypal_fee_info_link => paypal_fee_info_link).html_safe 
 elsif @current_community.vat 
 t(".after_service_fee_you_will_get_vat", :sum_with_currency => '<span id="fee_display"></span>').html_safe 
 else 
 t(".after_service_fee_you_will_get", :sum_with_currency => '<span id="fee_display"></span>').html_safe 
 end 
 end 
 end 
 if payment_gateway == :paypal 
 render layout: "layouts/lightbox", locals: { id: "paypal_fee_info_content"} do 
 t("common.paypal_fee_info.title") 
 text_with_line_breaks_html_safe do 
 link_to_paypal = link_to(t("common.paypal_fee_info.link_to_paypal_text"), paypal_fees_url, target: "_blank") 
 if shape[:shipping_enabled] 
 t("common.paypal_fee_info.body_with_shipping_text", link_to_paypal: link_to_paypal).html_safe 
 else 
 t("common.paypal_fee_info.body_text", link_to_paypal: link_to_paypal).html_safe 
 end 
 end 
 end 
 if run_js_immediately 
 else 
 content_for :extra_javascript do 
 end 
 end 
 end 
 
  if shape[:shipping_enabled] 
 field_set_tag t("listings.form.price.delivery"), class: "delivery-title" do 
 check_box_tag "listing[delivery_methods][]", "shipping", shipping_enabled, id: "shipping-checkbox", class: "delivery-method-checkbox required" 
 label_tag "shipping-checkbox", t("listings.form.price.shipping"), class: "shipping-options-label" 
 form.label :shipping_price, t("listings.form.price.shipping_price"), class: "shipping-options-label" 
  if @current_community.available_currencies 
 currencies = @current_community.available_currencies.gsub(" ","").split(",") 
 if currencies.size > 1 
 form.select :currency, currencies, { :selected => (@listing.currency ) } 
 else 
 Money.new(1, currencies[0]).symbol 
 form.hidden_field :currency, :value => currencies[0] 
 end 
 else 
 form.select :currency, major_currencies(Money::Currency.table), { :selected => (@listing.currency ) } 
 end 
 
 form.text_field :shipping_price, class: "price-field delivery-price-field", maxlength: 10, placeholder: 0, value: shipping_price 
 form.label :shipping_price_additional, t("listings.form.price.shipping_price_additional"), class: "shipping-options-label" 
  if @current_community.available_currencies 
 currencies = @current_community.available_currencies.gsub(" ","").split(",") 
 if currencies.size > 1 
 form.select :currency, currencies, { :selected => (@listing.currency ) } 
 else 
 Money.new(1, currencies[0]).symbol 
 form.hidden_field :currency, :value => currencies[0] 
 end 
 else 
 form.select :currency, major_currencies(Money::Currency.table), { :selected => (@listing.currency ) } 
 end 
 
 form.text_field :shipping_price_additional, class: "price-field delivery-price-field", maxlength: 10, placeholder: 0, value: shipping_price_additional 
 check_box_tag "listing[delivery_methods][]", "pickup", pickup_enabled, id: "pickup-checkbox", class: "delivery-method-checkbox required" 
 label_tag "pickup-checkbox", t("listings.form.price.pickup"), class: "shipping-options-label" 
 end 
 end 
 
  form.label :description, t('.detailed_description'), :class => "input" 
 form.text_area(:description, :maxlength => "5000", :class => "listing_description_textarea") 
 
  if custom_fields && custom_fields.count > 0 
 custom_fields.each do |custom_field| 
 custom_field.with_type do |field_type| 
 label "custom_fields", "#{custom_field.id}".to_sym, "#{custom_field.name(I18n.locale)}#{custom_field.required ? '*' : ''}" 
 render :partial => "listings/form/custom_field_partials/#{field_type}", :locals => { :custom_field => custom_field, :custom_field_value => listing.answer_for(custom_field) } 
 end 
 end 
 end 
 
  unless @current_community.hide_expiration_date 
 form.label :valid_until, t('.valid_until') + "*", :class => "inline" 
 t('common.what_is_this') 
 date_select(:listing, :valid_until, {:start_year => Time.now.year, :end_year => Time.now.year + 1, :default => 3.months.from_now}, :class => "listing_date_select") 
 end 
 
  required = Maybe(@current_community).listing_location_required.or_else { false } 
 title = t(".location") + (required ? "*" : "") 
 required_class = (required ? "required" : "") 
 form.label :origin, title, :class => "input" 
 form.text_field :origin, :class => "text_field #{required_class}", :onkeyup => "timed_input(this)", :value => (origin_loc ? origin_loc.address : nil) 
 form.fields_for :origin_loc do |loc| 
 loc.hidden_field :address, :value => origin_loc.address 
 loc.hidden_field :google_address, :value => origin_loc.google_address 
 loc.hidden_field :latitude, :value => origin_loc.latitude 
 loc.hidden_field :longitude, :value => origin_loc.longitude 
 loc.hidden_field :location_type, :value => origin_loc.location_type 
 end 
 
  content_for :map_js do 
 end 
 if run_js_immediately 
 yield :map_js 
 else 
 content_for :extra_javascript do 
 yield :map_js 
 end 
 end 
 
  form.label :image, t('.image'), :class => "input" 
  icon_tag("information") 
 text 
 
 icon_class("loading") 
 t("listings.form.images.image_uploading_in_progress") 
 icon_class("check") 
 t("listings.form.images.processing_takes_a_while") 
 icon_tag("cross", ["icon-fix"]) 
 
  form.hidden_field(:category_id, :value => @listing.category_id) 
 form.hidden_field(:listing_shape_id, :value => @listing.listing_shape_id) 
 form.button t(".save_listing"), :class => "send_button" 
 
 end 
  render :layout => "layouts/lightbox", locals: {id: field, field: field} do 
 t("listings.help_texts.#{field}_title") 
 text_with_line_breaks do 
 render :partial => "listings/help_texts/#{field}" 
 end 
 end 
 
 
 end 
 end 
 if params[:controller] == "homepage" && params[:action] == "index" 
 params.except("action", "controller", "q", "view", "utf8").each do |param, value| 
 unless param.match(/^filter_option/) || param.match(/^checkbox_filter_option/) || param.match(/^nf_/) || param.match(/^price_/) 
 hidden_field_tag param, value 
 end 
 end 
 hidden_field_tag "view", @view_type 
 content_for(:page_content) 
 else 
 content_for(:page_content) 
 end 
  if (APP_CONFIG.use_google_analytics) 
 "_gaq.push(['_setAccount', '#{APP_CONFIG.google_analytics_key}']);" 
 "_gaq.push(['_setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 if @current_community && @current_community.google_analytics_key 
 "_gaq.push(['b._setAccount', '#{@current_community.google_analytics_key}']);" 
 "_gaq.push(['b._setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{Maybe(@current_community.name(I18n.locale)).gsub("'","").or_else("")}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{@current_community.domain}']);" 
 end 
 end 
 
 content_for(:location_search) 
  
 javascript_include_tag 'application' 
 if @analytics_event 
 end 
 if Rails.env.test? 
 end 
 content_for :extra_javascript 
  t('error_pages.no_javascript.javascript_is_disabled_in_your_browser') 
 t('error_pages.no_javascript.kassi_does_not_currently_work_without_javascript') 
 

end

  end

  def update
    if (params[:listing][:origin] && (params[:listing][:origin_loc_attributes][:address].empty? || params[:listing][:origin].blank?))
      params[:listing].delete("origin_loc_attributes")
      if @listing.origin_loc
        @listing.origin_loc.delete
      end
    end

    shape = get_shape(params[:listing][:listing_shape_id])

    listing_params = ListingFormViewUtils.filter(params[:listing], shape)
    listing_unit = Maybe(params)[:listing][:unit].map { |u| ListingViewUtils::Unit.deserialize(u) }.or_else(nil)
    listing_params = ListingFormViewUtils.filter_additional_shipping(listing_params, listing_unit)
    validation_result = ListingFormViewUtils.validate(listing_params, shape, listing_unit)

    unless validation_result.success
      flash[:error] = t("listings.error.something_went_wrong", error_code: validation_result.data.join(', '))
      return redirect_to edit_listing_path
    end

    listing_params = normalize_price_params(listing_params)
    m_unit = select_unit(listing_unit, shape)

    open_params = @listing.closed? ? {open: true} : {}

    listing_params = create_listing_params(listing_params).merge(
      transaction_process_id: shape[:transaction_process_id],
      shape_name_tr_key: shape[:name_tr_key],
      action_button_tr_key: shape[:action_button_tr_key],
      last_modified: DateTime.now
    ).merge(open_params).merge(unit_to_listing_opts(m_unit)).except(:unit)

    update_successful = @listing.update_fields(listing_params)

    upsert_field_values!(@listing, params[:custom_fields])

    if update_successful
      @listing.location.update_attributes(params[:location]) if @listing.location
      flash[:notice] = t("layouts.notifications.listing_updated_successfully")
      Delayed::Job.enqueue(ListingUpdatedJob.new(@listing.id, @current_community.id))
      redirect_to @listing
    else
      logger.error("Errors in editing listing: #{@listing.errors.full_messages.inspect}")
      flash[:error] = t("layouts.notifications.listing_could_not_be_saved", :contact_admin_link => view_context.link_to(t("layouts.notifications.contact_admin_link_text"), new_user_feedback_path, :class => "flash-error-link")).html_safe
      redirect_to edit_listing_path(@listing)
    end
  end

  def close
    process = get_transaction_process(community_id: @current_community.id, transaction_process_id: @listing.transaction_process_id)

    payment_gateway = MarketplaceService::Community::Query.payment_type(@current_community.id)
    community_country_code = LocalizationUtils.valid_country_code(@current_community.country)

    @listing.update_attribute(:open, false)
    respond_to do |format|
      format.html {
        redirect_to @listing
      }
      format.js {
        render :layout => false, locals: {payment_gateway: payment_gateway, process: process, country_code: community_country_code }
      }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
   if APP_CONFIG.use_kissmetrics 
 "_kms('//i.kissmetrics.com/i.js');_kms('#{APP_CONFIG.kissmetrics_url}');" 
 if @current_user 
 "_kmq.push(['identify', '#{@current_user.id}']);" 
 end 
 if @current_community 
 "_kmq.push(['set', {}]);" 
 else 
 "_kmq.push(['set', {'SiteName' : 'dashboard'}]);" 
 end 
 end 
 
 content_for :head 
  
 
  link_to t("homepage.index.post_new_listing"), new_listing_path, :class => "new-listing-link", :id => "new-listing-link" 
 Maybe(@current_user).each do |user| 
 conversations = @current_community.conversations.for_person(user) 
 unread_count = MarketplaceService::Inbox::Query.notification_count(user.id, @current_community.id) 
  image_tag user.image.url(:thumb), alt: '', class: 'header-user-avatar' 
 user.name(@current_community) 
 icon_tag("dropdown", ["icon-dropdown"]) 
 
  link_to person_inbox_path(@current_user) do 
 icon_tag("mail", ["icon-with-text"]) 
 t("layouts.conversations.messages") 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 link_to person_path(user) do 
 icon_tag("user", ["icon-with-text"]) 
 t("header.profile") 
 end 
 link_to person_settings_path(user) do 
 icon_tag("settings", ["icon-with-text"]) 
 t("layouts.logged_in.settings") 
 end 
 link_to logout_path do 
 icon_tag("logout", ["icon-with-text"]) 
 t("layouts.logged_in.logout") 
 end 
 
  link_to person_inbox_path(user), title: t("layouts.conversations.messages"), :id => "inbox-link", :class => "header-text-link header-hover header-inbox-link" do 
 icon_tag("mail", ["header-inbox"]) 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 
 end 
 with_available_locales do |locales| 
 get_full_locale_name(I18n.locale).to_s 
 icon_tag("dropdown", ["icon-dropdown"]) 
  
 end 
 unless @current_user 
 link_to sign_up_path, class: "header-text-link header-hover" do 
 t("header.signup") 
 end 
 link_to login_path, class: "header-text-link header-hover", id: "header-login-link" do 
 t("header.login") 
 end 
 end 
 icon_tag("rows", ["header-menu-icon"]) 
 t("header.menu") 
  link_to "/" do 
 icon_tag("home", ["icon-with-text"]) 
 t("header.home") 
 end 
 link_to new_listing_path, :class => "hidden-tablet" do 
 icon_tag("new_listing", ["icon-with-text"]) 
 t("homepage.index.post_new_listing") 
 end 
 link_to about_infos_path do 
 icon_tag("information", ["icon-with-text"]) 
 t("header.about") 
 end 
 link_to new_user_feedback_path do 
 icon_tag("feedback", ["icon-with-text"]) 
 t("header.contact_us") 
 end 
 with_invite_link do 
 link_to new_invitation_path do 
 icon_tag("invite", ["icon-with-text"]) 
 t("header.invite") 
 end 
 end 
 Maybe(@current_community).menu_links.each do |menu_links| 
 menu_links.each do |menu_link| 
 link_to menu_link.url(I18n.locale), :target => "_blank" do 
 icon_tag("redirect", ["icon-with-text"]) 
 menu_link.title(I18n.locale) 
 end 
 end 
 end 
 if @current_user && @current_community && @current_user.has_admin_rights_in?(@current_community) 
 link_to edit_details_admin_community_path(@current_community) do 
 icon_tag("admin", ["icon-with-text"]) 
 t("layouts.logged_in.admin") 
 end 
 end 
 with_available_locales do |locales| 
 t("layouts.global-header.select_language") 
  
 end 
 
 link_to @homepage_path, :class => "header-logo", :id => "header-logo" do 
 end 
 
 if display_expiration_notice? 
  content_for :javascript do 
 end 
 t("expiration.title") 
 t("expiration.sub_title_new") 
 external_plan_service_login_url 
 t("expiration.link_to_external_service") 
 t("expiration.need_more_info") 
 t("expiration.contact_us") 
 
 end 
 content_for(:page_content) do 
 with_big_cover_photo do 
 yield :title_header 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 yield :title_header 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 icon_class 
 flash[announcement] 
 end 
 end 
 
 escape_javascript(render(:partial => 'listings/listing_actions', locals: { form_path: nil, payment_gateway: payment_gateway, process: process, country_code: country_code})) 
 @listing.id.to_s 
 escape_javascript(render(:partial => 'listings/edit_profile_listing_links', :locals => { :listing => @listing })) 
 escape_javascript(render(:partial => 'listings/comment_form')) 
 end 
 if params[:controller] == "homepage" && params[:action] == "index" 
 params.except("action", "controller", "q", "view", "utf8").each do |param, value| 
 unless param.match(/^filter_option/) || param.match(/^checkbox_filter_option/) || param.match(/^nf_/) || param.match(/^price_/) 
 hidden_field_tag param, value 
 end 
 end 
 hidden_field_tag "view", @view_type 
 content_for(:page_content) 
 else 
 content_for(:page_content) 
 end 
  if (APP_CONFIG.use_google_analytics) 
 "_gaq.push(['_setAccount', '#{APP_CONFIG.google_analytics_key}']);" 
 "_gaq.push(['_setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 if @current_community && @current_community.google_analytics_key 
 "_gaq.push(['b._setAccount', '#{@current_community.google_analytics_key}']);" 
 "_gaq.push(['b._setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{Maybe(@current_community.name(I18n.locale)).gsub("'","").or_else("")}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{@current_community.domain}']);" 
 end 
 end 
 
 content_for(:location_search) 
  
 javascript_include_tag 'application' 
 if @analytics_event 
 end 
 if Rails.env.test? 
 end 
 content_for :extra_javascript 
  t('error_pages.no_javascript.javascript_is_disabled_in_your_browser') 
 t('error_pages.no_javascript.kassi_does_not_currently_work_without_javascript') 
 

end

  end

  def move_to_top
    @listing = @current_community.listings.find(params[:id])

    # Listings are sorted by `sort_date`, so change it to now.
    if @listing.update_attribute(:sort_date, Time.now)
      redirect_to homepage_index_path
    else
      flash[:warning] = "An error occured while trying to move the listing to the top of the homepage"
      logger.error("An error occured while trying to move the listing (id=#{Maybe(@listing).id.or_else('No id available')}) to the top of the homepage")
      redirect_to @listing
    end
  end

  def show_in_updates_email
    @listing = @current_community.listings.find(params[:id])

    # Listings are sorted by `created_at`, so change it to now.
    if @listing.update_attribute(:updates_email_at, Time.now)
      render :nothing => true, :status => 200
    else
      logger.error("An error occured while trying to move the listing (id=#{Maybe(@listing).id.or_else('No id available')}) to the top of the homepage")
      render :nothing => true, :status => 500
    end
  end

  def ensure_current_user_is_listing_author(error_message)
    @listing = Listing.find(params[:id])
    return if current_user?(@listing.author) || @current_user.has_admin_rights_in?(@current_community)
    flash[:error] = error_message
    redirect_to @listing and return
  end

  def follow
    change_follow_status("follow")
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
   if APP_CONFIG.use_kissmetrics 
 "_kms('//i.kissmetrics.com/i.js');_kms('#{APP_CONFIG.kissmetrics_url}');" 
 if @current_user 
 "_kmq.push(['identify', '#{@current_user.id}']);" 
 end 
 if @current_community 
 "_kmq.push(['set', {}]);" 
 else 
 "_kmq.push(['set', {'SiteName' : 'dashboard'}]);" 
 end 
 end 
 
 content_for :head 
  
 
  link_to t("homepage.index.post_new_listing"), new_listing_path, :class => "new-listing-link", :id => "new-listing-link" 
 Maybe(@current_user).each do |user| 
 conversations = @current_community.conversations.for_person(user) 
 unread_count = MarketplaceService::Inbox::Query.notification_count(user.id, @current_community.id) 
  image_tag user.image.url(:thumb), alt: '', class: 'header-user-avatar' 
 user.name(@current_community) 
 icon_tag("dropdown", ["icon-dropdown"]) 
 
  link_to person_inbox_path(@current_user) do 
 icon_tag("mail", ["icon-with-text"]) 
 t("layouts.conversations.messages") 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 link_to person_path(user) do 
 icon_tag("user", ["icon-with-text"]) 
 t("header.profile") 
 end 
 link_to person_settings_path(user) do 
 icon_tag("settings", ["icon-with-text"]) 
 t("layouts.logged_in.settings") 
 end 
 link_to logout_path do 
 icon_tag("logout", ["icon-with-text"]) 
 t("layouts.logged_in.logout") 
 end 
 
  link_to person_inbox_path(user), title: t("layouts.conversations.messages"), :id => "inbox-link", :class => "header-text-link header-hover header-inbox-link" do 
 icon_tag("mail", ["header-inbox"]) 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 
 end 
 with_available_locales do |locales| 
 get_full_locale_name(I18n.locale).to_s 
 icon_tag("dropdown", ["icon-dropdown"]) 
  
 end 
 unless @current_user 
 link_to sign_up_path, class: "header-text-link header-hover" do 
 t("header.signup") 
 end 
 link_to login_path, class: "header-text-link header-hover", id: "header-login-link" do 
 t("header.login") 
 end 
 end 
 icon_tag("rows", ["header-menu-icon"]) 
 t("header.menu") 
  link_to "/" do 
 icon_tag("home", ["icon-with-text"]) 
 t("header.home") 
 end 
 link_to new_listing_path, :class => "hidden-tablet" do 
 icon_tag("new_listing", ["icon-with-text"]) 
 t("homepage.index.post_new_listing") 
 end 
 link_to about_infos_path do 
 icon_tag("information", ["icon-with-text"]) 
 t("header.about") 
 end 
 link_to new_user_feedback_path do 
 icon_tag("feedback", ["icon-with-text"]) 
 t("header.contact_us") 
 end 
 with_invite_link do 
 link_to new_invitation_path do 
 icon_tag("invite", ["icon-with-text"]) 
 t("header.invite") 
 end 
 end 
 Maybe(@current_community).menu_links.each do |menu_links| 
 menu_links.each do |menu_link| 
 link_to menu_link.url(I18n.locale), :target => "_blank" do 
 icon_tag("redirect", ["icon-with-text"]) 
 menu_link.title(I18n.locale) 
 end 
 end 
 end 
 if @current_user && @current_community && @current_user.has_admin_rights_in?(@current_community) 
 link_to edit_details_admin_community_path(@current_community) do 
 icon_tag("admin", ["icon-with-text"]) 
 t("layouts.logged_in.admin") 
 end 
 end 
 with_available_locales do |locales| 
 t("layouts.global-header.select_language") 
  
 end 
 
 link_to @homepage_path, :class => "header-logo", :id => "header-logo" do 
 end 
 
 if display_expiration_notice? 
  content_for :javascript do 
 end 
 t("expiration.title") 
 t("expiration.sub_title_new") 
 external_plan_service_login_url 
 t("expiration.link_to_external_service") 
 t("expiration.need_more_info") 
 t("expiration.contact_us") 
 
 end 
 content_for(:page_content) do 
 with_big_cover_photo do 
 yield :title_header 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 yield :title_header 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 icon_class 
 flash[announcement] 
 end 
 end 
 
 escape_javascript(render(:partial => 'listings/follow_links')) 
 end 
 if params[:controller] == "homepage" && params[:action] == "index" 
 params.except("action", "controller", "q", "view", "utf8").each do |param, value| 
 unless param.match(/^filter_option/) || param.match(/^checkbox_filter_option/) || param.match(/^nf_/) || param.match(/^price_/) 
 hidden_field_tag param, value 
 end 
 end 
 hidden_field_tag "view", @view_type 
 content_for(:page_content) 
 else 
 content_for(:page_content) 
 end 
  if (APP_CONFIG.use_google_analytics) 
 "_gaq.push(['_setAccount', '#{APP_CONFIG.google_analytics_key}']);" 
 "_gaq.push(['_setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 if @current_community && @current_community.google_analytics_key 
 "_gaq.push(['b._setAccount', '#{@current_community.google_analytics_key}']);" 
 "_gaq.push(['b._setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{Maybe(@current_community.name(I18n.locale)).gsub("'","").or_else("")}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{@current_community.domain}']);" 
 end 
 end 
 
 content_for(:location_search) 
  
 javascript_include_tag 'application' 
 if @analytics_event 
 end 
 if Rails.env.test? 
 end 
 content_for :extra_javascript 
  t('error_pages.no_javascript.javascript_is_disabled_in_your_browser') 
 t('error_pages.no_javascript.kassi_does_not_currently_work_without_javascript') 
 

end

  end

  def unfollow
    change_follow_status("unfollow")
  end

  def verification_required

ruby_code_from_view.ruby_code_from_view do |rb_from_view|
   if APP_CONFIG.use_kissmetrics 
 "_kms('//i.kissmetrics.com/i.js');_kms('#{APP_CONFIG.kissmetrics_url}');" 
 if @current_user 
 "_kmq.push(['identify', '#{@current_user.id}']);" 
 end 
 if @current_community 
 "_kmq.push(['set', {}]);" 
 else 
 "_kmq.push(['set', {'SiteName' : 'dashboard'}]);" 
 end 
 end 
 
 content_for :head 
  
 
  link_to t("homepage.index.post_new_listing"), new_listing_path, :class => "new-listing-link", :id => "new-listing-link" 
 Maybe(@current_user).each do |user| 
 conversations = @current_community.conversations.for_person(user) 
 unread_count = MarketplaceService::Inbox::Query.notification_count(user.id, @current_community.id) 
  image_tag user.image.url(:thumb), alt: '', class: 'header-user-avatar' 
 user.name(@current_community) 
 icon_tag("dropdown", ["icon-dropdown"]) 
 
  link_to person_inbox_path(@current_user) do 
 icon_tag("mail", ["icon-with-text"]) 
 t("layouts.conversations.messages") 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 link_to person_path(user) do 
 icon_tag("user", ["icon-with-text"]) 
 t("header.profile") 
 end 
 link_to person_settings_path(user) do 
 icon_tag("settings", ["icon-with-text"]) 
 t("layouts.logged_in.settings") 
 end 
 link_to logout_path do 
 icon_tag("logout", ["icon-with-text"]) 
 t("layouts.logged_in.logout") 
 end 
 
  link_to person_inbox_path(user), title: t("layouts.conversations.messages"), :id => "inbox-link", :class => "header-text-link header-hover header-inbox-link" do 
 icon_tag("mail", ["header-inbox"]) 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 
 end 
 with_available_locales do |locales| 
 get_full_locale_name(I18n.locale).to_s 
 icon_tag("dropdown", ["icon-dropdown"]) 
  
 end 
 unless @current_user 
 link_to sign_up_path, class: "header-text-link header-hover" do 
 t("header.signup") 
 end 
 link_to login_path, class: "header-text-link header-hover", id: "header-login-link" do 
 t("header.login") 
 end 
 end 
 icon_tag("rows", ["header-menu-icon"]) 
 t("header.menu") 
  link_to "/" do 
 icon_tag("home", ["icon-with-text"]) 
 t("header.home") 
 end 
 link_to new_listing_path, :class => "hidden-tablet" do 
 icon_tag("new_listing", ["icon-with-text"]) 
 t("homepage.index.post_new_listing") 
 end 
 link_to about_infos_path do 
 icon_tag("information", ["icon-with-text"]) 
 t("header.about") 
 end 
 link_to new_user_feedback_path do 
 icon_tag("feedback", ["icon-with-text"]) 
 t("header.contact_us") 
 end 
 with_invite_link do 
 link_to new_invitation_path do 
 icon_tag("invite", ["icon-with-text"]) 
 t("header.invite") 
 end 
 end 
 Maybe(@current_community).menu_links.each do |menu_links| 
 menu_links.each do |menu_link| 
 link_to menu_link.url(I18n.locale), :target => "_blank" do 
 icon_tag("redirect", ["icon-with-text"]) 
 menu_link.title(I18n.locale) 
 end 
 end 
 end 
 if @current_user && @current_community && @current_user.has_admin_rights_in?(@current_community) 
 link_to edit_details_admin_community_path(@current_community) do 
 icon_tag("admin", ["icon-with-text"]) 
 t("layouts.logged_in.admin") 
 end 
 end 
 with_available_locales do |locales| 
 t("layouts.global-header.select_language") 
  
 end 
 
 link_to @homepage_path, :class => "header-logo", :id => "header-logo" do 
 end 
 
 if display_expiration_notice? 
  content_for :javascript do 
 end 
 t("expiration.title") 
 t("expiration.sub_title_new") 
 external_plan_service_login_url 
 t("expiration.link_to_external_service") 
 t("expiration.need_more_info") 
 t("expiration.contact_us") 
 
 end 
 content_for(:page_content) do 
 with_big_cover_photo do 
 t("listings.verification_required.verification_required") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("listings.verification_required.verification_required") 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 icon_class 
 flash[announcement] 
 end 
 end 
 
  
 if @community_customization && @community_customization.verification_to_post_listings_info_content 
 @community_customization.verification_to_post_listings_info_content.html_safe 
 else 
 t("admin.communities.edit_details.verification_to_post_listings_info_content_default", :contact_admin_link => link_to(t("admin.communities.edit_details.contact_admin_link_text"), new_user_feedback_path)).html_safe 
 end 
 end 
 if params[:controller] == "homepage" && params[:action] == "index" 
 params.except("action", "controller", "q", "view", "utf8").each do |param, value| 
 unless param.match(/^filter_option/) || param.match(/^checkbox_filter_option/) || param.match(/^nf_/) || param.match(/^price_/) 
 hidden_field_tag param, value 
 end 
 end 
 hidden_field_tag "view", @view_type 
 content_for(:page_content) 
 else 
 content_for(:page_content) 
 end 
  if (APP_CONFIG.use_google_analytics) 
 "_gaq.push(['_setAccount', '#{APP_CONFIG.google_analytics_key}']);" 
 "_gaq.push(['_setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 if @current_community && @current_community.google_analytics_key 
 "_gaq.push(['b._setAccount', '#{@current_community.google_analytics_key}']);" 
 "_gaq.push(['b._setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{Maybe(@current_community.name(I18n.locale)).gsub("'","").or_else("")}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{@current_community.domain}']);" 
 end 
 end 
 
 content_for(:location_search) 
  
 javascript_include_tag 'application' 
 if @analytics_event 
 end 
 if Rails.env.test? 
 end 
 content_for :extra_javascript 
  t('error_pages.no_javascript.javascript_is_disabled_in_your_browser') 
 t('error_pages.no_javascript.kassi_does_not_currently_work_without_javascript') 
 

end

  end

  private

  def select_shape(shapes, id)
    if shapes.size == 1
      shapes.first
    else
      shapes.find { |shape| shape[:id] == id }
    end
  end

  def form_locals(shape)
    if shape
      process = get_transaction_process(community_id: @current_community.id, transaction_process_id: shape[:transaction_process_id])
      unit_options = ListingViewUtils.unit_options(shape[:units], unit_from_listing(@listing))

      shipping_price_additional =
        if @listing.shipping_price_additional
          @listing.shipping_price_additional.to_s
        elsif @listing.shipping_price
          @listing.shipping_price.to_s
        else
          0
        end

      community_country_code = LocalizationUtils.valid_country_code(@current_community.country)

      commission(@current_community, process).merge({
        shape: shape,
        unit_options: unit_options,
        shipping_price: Maybe(@listing).shipping_price.or_else(0).to_s,
        shipping_enabled: @listing.require_shipping_address?,
        pickup_enabled: @listing.pickup_enabled?,
        shipping_price_additional: shipping_price_additional,
        always_show_additional_shipping_price: shape[:units].length == 1 && shape[:units].first[:kind] == :quantity,
        paypal_fees_url: PaypalCountryHelper.fee_link(community_country_code)
      })
    else
      nil
    end
  end

  def form_content
    @listing.category = @current_community.categories.find(params[:subcategory].blank? ? params[:category] : params[:subcategory])
    @custom_field_questions = @listing.category.custom_fields
    @numeric_field_ids = numeric_field_ids(@custom_field_questions)

    shape = get_shape(Maybe(params)[:listing_shape].to_i.or_else(nil))
    process = get_transaction_process(community_id: @current_community.id, transaction_process_id: shape[:transaction_process_id])

    # PaymentRegistrationGuard needs this to be set before posting
    @listing.transaction_process_id = shape[:transaction_process_id]
    @listing.listing_shape_id = shape[:id]

    payment_type = MarketplaceService::Community::Query.payment_type(@current_community.id)
    allow_posting, error_msg = payment_setup_status(
                     community: @current_community,
                     user: @current_user,
                     listing: @listing,
                     payment_type: payment_type,
                     process: process)

    if allow_posting
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
   if APP_CONFIG.use_kissmetrics 
 "_kms('//i.kissmetrics.com/i.js');_kms('#{APP_CONFIG.kissmetrics_url}');" 
 if @current_user 
 "_kmq.push(['identify', '#{@current_user.id}']);" 
 end 
 if @current_community 
 "_kmq.push(['set', {}]);" 
 else 
 "_kmq.push(['set', {'SiteName' : 'dashboard'}]);" 
 end 
 end 
 
 content_for :head 
  
 
  link_to t("homepage.index.post_new_listing"), new_listing_path, :class => "new-listing-link", :id => "new-listing-link" 
 Maybe(@current_user).each do |user| 
 conversations = @current_community.conversations.for_person(user) 
 unread_count = MarketplaceService::Inbox::Query.notification_count(user.id, @current_community.id) 
  image_tag user.image.url(:thumb), alt: '', class: 'header-user-avatar' 
 user.name(@current_community) 
 icon_tag("dropdown", ["icon-dropdown"]) 
 
  link_to person_inbox_path(@current_user) do 
 icon_tag("mail", ["icon-with-text"]) 
 t("layouts.conversations.messages") 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 link_to person_path(user) do 
 icon_tag("user", ["icon-with-text"]) 
 t("header.profile") 
 end 
 link_to person_settings_path(user) do 
 icon_tag("settings", ["icon-with-text"]) 
 t("layouts.logged_in.settings") 
 end 
 link_to logout_path do 
 icon_tag("logout", ["icon-with-text"]) 
 t("layouts.logged_in.logout") 
 end 
 
  link_to person_inbox_path(user), title: t("layouts.conversations.messages"), :id => "inbox-link", :class => "header-text-link header-hover header-inbox-link" do 
 icon_tag("mail", ["header-inbox"]) 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 
 end 
 with_available_locales do |locales| 
 get_full_locale_name(I18n.locale).to_s 
 icon_tag("dropdown", ["icon-dropdown"]) 
  
 end 
 unless @current_user 
 link_to sign_up_path, class: "header-text-link header-hover" do 
 t("header.signup") 
 end 
 link_to login_path, class: "header-text-link header-hover", id: "header-login-link" do 
 t("header.login") 
 end 
 end 
 icon_tag("rows", ["header-menu-icon"]) 
 t("header.menu") 
  link_to "/" do 
 icon_tag("home", ["icon-with-text"]) 
 t("header.home") 
 end 
 link_to new_listing_path, :class => "hidden-tablet" do 
 icon_tag("new_listing", ["icon-with-text"]) 
 t("homepage.index.post_new_listing") 
 end 
 link_to about_infos_path do 
 icon_tag("information", ["icon-with-text"]) 
 t("header.about") 
 end 
 link_to new_user_feedback_path do 
 icon_tag("feedback", ["icon-with-text"]) 
 t("header.contact_us") 
 end 
 with_invite_link do 
 link_to new_invitation_path do 
 icon_tag("invite", ["icon-with-text"]) 
 t("header.invite") 
 end 
 end 
 Maybe(@current_community).menu_links.each do |menu_links| 
 menu_links.each do |menu_link| 
 link_to menu_link.url(I18n.locale), :target => "_blank" do 
 icon_tag("redirect", ["icon-with-text"]) 
 menu_link.title(I18n.locale) 
 end 
 end 
 end 
 if @current_user && @current_community && @current_user.has_admin_rights_in?(@current_community) 
 link_to edit_details_admin_community_path(@current_community) do 
 icon_tag("admin", ["icon-with-text"]) 
 t("layouts.logged_in.admin") 
 end 
 end 
 with_available_locales do |locales| 
 t("layouts.global-header.select_language") 
  
 end 
 
 link_to @homepage_path, :class => "header-logo", :id => "header-logo" do 
 end 
 
 if display_expiration_notice? 
  content_for :javascript do 
 end 
 t("expiration.title") 
 t("expiration.sub_title_new") 
 external_plan_service_login_url 
 t("expiration.link_to_external_service") 
 t("expiration.need_more_info") 
 t("expiration.contact_us") 
 
 end 
 content_for(:page_content) do 
 with_big_cover_photo do 
 yield :title_header 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 yield :title_header 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 icon_class 
 flash[announcement] 
 end 
 end 
 
  valid_until_msg = t('error_messages.listings.valid_until') 
 js_t ["listings.form.images.processing", "listings.form.images.this_may_take_a_while", "listings.form.images.percentage_loaded", "listings.form.images.uploading_failed", "listings.form.images.file_too_large", "listings.form.images.image_processing_failed", "listings.form.images.accepted_formats", "listings.form.images.loading_image", "listings.form.images.select_file", "listings.form.images.removing", "listings.form.images.add_more"], run_js_immediately 
 content_for :listing_js do 
 end 
 if run_js_immediately 
 yield :listing_js 
 else 
 content_for :extra_javascript do 
 yield :listing_js 
 end 
 end 
 
 form_for @listing, :html => {:multipart => true} do |form| 
  form.label :title, t(".listing_title") + "*", :class => "input" 
 form.text_field(:title, :class => "title_text_field", :maxlength => "60") 
 
  if shape[:price_enabled] 
 form.label :price, t(".price") 
 form.text_field :price, :class => "price-field", :maxlength => "10", :placeholder => "0", :value => (@listing.price ? @listing.price.to_s: 0) 
  if @current_community.available_currencies 
 currencies = @current_community.available_currencies.gsub(" ","").split(",") 
 if currencies.size > 1 
 form.select :currency, currencies, { :selected => (@listing.currency ) } 
 else 
 Money.new(1, currencies[0]).symbol 
 form.hidden_field :currency, :value => currencies[0] 
 end 
 else 
 form.select :currency, major_currencies(Money::Currency.table), { :selected => (@listing.currency ) } 
 end 
 
 if unit_options.empty? 
 elsif unit_options.length == 1 
 unit_option = unit_options.first 
 t(".per") 
 unit_option[:display] 
 hidden_field_tag("listing[unit]", unit_option[:value]) 
 else 
 t(".per") 
 unit_options.each do |unit_option| 
 unit_option[:display] 
 end 
 end 
 paypal_fee_info_link = capture do 
 t(".paypal_fee_info_link_text") 
 end 
 t(".price_excludes_vat", :vat => @current_community.vat) if @current_community.vat 
 if !seller_commission_in_use && payment_gateway == :paypal 
 t(".no_service_fee_you_will_get_paypal_text", :paypal_fee_info_link => paypal_fee_info_link).html_safe 
 elsif seller_commission_in_use 
 content_for :seller_commission_js do 
 end 
 if run_js_immediately 
 yield :seller_commission_js 
 else 
 content_for :extra_javascript do 
 yield :seller_commission_js 
 end 
 end 
 if payment_gateway == :paypal 
 t(".after_service_fee_you_will_get_paypal_text", :sum_with_currency => '<span id="fee_display"></span>', :paypal_fee_info_link => paypal_fee_info_link).html_safe 
 elsif @current_community.vat 
 t(".after_service_fee_you_will_get_vat", :sum_with_currency => '<span id="fee_display"></span>').html_safe 
 else 
 t(".after_service_fee_you_will_get", :sum_with_currency => '<span id="fee_display"></span>').html_safe 
 end 
 end 
 end 
 if payment_gateway == :paypal 
 render layout: "layouts/lightbox", locals: { id: "paypal_fee_info_content"} do 
 t("common.paypal_fee_info.title") 
 text_with_line_breaks_html_safe do 
 link_to_paypal = link_to(t("common.paypal_fee_info.link_to_paypal_text"), paypal_fees_url, target: "_blank") 
 if shape[:shipping_enabled] 
 t("common.paypal_fee_info.body_with_shipping_text", link_to_paypal: link_to_paypal).html_safe 
 else 
 t("common.paypal_fee_info.body_text", link_to_paypal: link_to_paypal).html_safe 
 end 
 end 
 end 
 if run_js_immediately 
 else 
 content_for :extra_javascript do 
 end 
 end 
 end 
 
  if shape[:shipping_enabled] 
 field_set_tag t("listings.form.price.delivery"), class: "delivery-title" do 
 check_box_tag "listing[delivery_methods][]", "shipping", shipping_enabled, id: "shipping-checkbox", class: "delivery-method-checkbox required" 
 label_tag "shipping-checkbox", t("listings.form.price.shipping"), class: "shipping-options-label" 
 form.label :shipping_price, t("listings.form.price.shipping_price"), class: "shipping-options-label" 
  if @current_community.available_currencies 
 currencies = @current_community.available_currencies.gsub(" ","").split(",") 
 if currencies.size > 1 
 form.select :currency, currencies, { :selected => (@listing.currency ) } 
 else 
 Money.new(1, currencies[0]).symbol 
 form.hidden_field :currency, :value => currencies[0] 
 end 
 else 
 form.select :currency, major_currencies(Money::Currency.table), { :selected => (@listing.currency ) } 
 end 
 
 form.text_field :shipping_price, class: "price-field delivery-price-field", maxlength: 10, placeholder: 0, value: shipping_price 
 form.label :shipping_price_additional, t("listings.form.price.shipping_price_additional"), class: "shipping-options-label" 
  if @current_community.available_currencies 
 currencies = @current_community.available_currencies.gsub(" ","").split(",") 
 if currencies.size > 1 
 form.select :currency, currencies, { :selected => (@listing.currency ) } 
 else 
 Money.new(1, currencies[0]).symbol 
 form.hidden_field :currency, :value => currencies[0] 
 end 
 else 
 form.select :currency, major_currencies(Money::Currency.table), { :selected => (@listing.currency ) } 
 end 
 
 form.text_field :shipping_price_additional, class: "price-field delivery-price-field", maxlength: 10, placeholder: 0, value: shipping_price_additional 
 check_box_tag "listing[delivery_methods][]", "pickup", pickup_enabled, id: "pickup-checkbox", class: "delivery-method-checkbox required" 
 label_tag "pickup-checkbox", t("listings.form.price.pickup"), class: "shipping-options-label" 
 end 
 end 
 
  form.label :description, t('.detailed_description'), :class => "input" 
 form.text_area(:description, :maxlength => "5000", :class => "listing_description_textarea") 
 
  if custom_fields && custom_fields.count > 0 
 custom_fields.each do |custom_field| 
 custom_field.with_type do |field_type| 
 label "custom_fields", "#{custom_field.id}".to_sym, "#{custom_field.name(I18n.locale)}#{custom_field.required ? '*' : ''}" 
 render :partial => "listings/form/custom_field_partials/#{field_type}", :locals => { :custom_field => custom_field, :custom_field_value => listing.answer_for(custom_field) } 
 end 
 end 
 end 
 
  unless @current_community.hide_expiration_date 
 form.label :valid_until, t('.valid_until') + "*", :class => "inline" 
 t('common.what_is_this') 
 date_select(:listing, :valid_until, {:start_year => Time.now.year, :end_year => Time.now.year + 1, :default => 3.months.from_now}, :class => "listing_date_select") 
 end 
 
  required = Maybe(@current_community).listing_location_required.or_else { false } 
 title = t(".location") + (required ? "*" : "") 
 required_class = (required ? "required" : "") 
 form.label :origin, title, :class => "input" 
 form.text_field :origin, :class => "text_field #{required_class}", :onkeyup => "timed_input(this)", :value => (origin_loc ? origin_loc.address : nil) 
 form.fields_for :origin_loc do |loc| 
 loc.hidden_field :address, :value => origin_loc.address 
 loc.hidden_field :google_address, :value => origin_loc.google_address 
 loc.hidden_field :latitude, :value => origin_loc.latitude 
 loc.hidden_field :longitude, :value => origin_loc.longitude 
 loc.hidden_field :location_type, :value => origin_loc.location_type 
 end 
 
  content_for :map_js do 
 end 
 if run_js_immediately 
 yield :map_js 
 else 
 content_for :extra_javascript do 
 yield :map_js 
 end 
 end 
 
  form.label :image, t('.image'), :class => "input" 
  icon_tag("information") 
 text 
 
 icon_class("loading") 
 t("listings.form.images.image_uploading_in_progress") 
 icon_class("check") 
 t("listings.form.images.processing_takes_a_while") 
 icon_tag("cross", ["icon-fix"]) 
 
  form.hidden_field(:category_id, :value => @listing.category_id) 
 form.hidden_field(:listing_shape_id, :value => @listing.listing_shape_id) 
 form.button t(".save_listing"), :class => "send_button" 
 
 end 
  render :layout => "layouts/lightbox", locals: {id: field, field: field} do 
 t("listings.help_texts.#{field}_title") 
 text_with_line_breaks do 
 render :partial => "listings/help_texts/#{field}" 
 end 
 end 
 
 end 
 if params[:controller] == "homepage" && params[:action] == "index" 
 params.except("action", "controller", "q", "view", "utf8").each do |param, value| 
 unless param.match(/^filter_option/) || param.match(/^checkbox_filter_option/) || param.match(/^nf_/) || param.match(/^price_/) 
 hidden_field_tag param, value 
 end 
 end 
 hidden_field_tag "view", @view_type 
 content_for(:page_content) 
 else 
 content_for(:page_content) 
 end 
  if (APP_CONFIG.use_google_analytics) 
 "_gaq.push(['_setAccount', '#{APP_CONFIG.google_analytics_key}']);" 
 "_gaq.push(['_setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 if @current_community && @current_community.google_analytics_key 
 "_gaq.push(['b._setAccount', '#{@current_community.google_analytics_key}']);" 
 "_gaq.push(['b._setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{Maybe(@current_community.name(I18n.locale)).gsub("'","").or_else("")}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{@current_community.domain}']);" 
 end 
 end 
 
 content_for(:location_search) 
  
 javascript_include_tag 'application' 
 if @analytics_event 
 end 
 if Rails.env.test? 
 end 
 content_for :extra_javascript 
  t('error_pages.no_javascript.javascript_is_disabled_in_your_browser') 
 t('error_pages.no_javascript.kassi_does_not_currently_work_without_javascript') 
 

end

    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
   if APP_CONFIG.use_kissmetrics 
 "_kms('//i.kissmetrics.com/i.js');_kms('#{APP_CONFIG.kissmetrics_url}');" 
 if @current_user 
 "_kmq.push(['identify', '#{@current_user.id}']);" 
 end 
 if @current_community 
 "_kmq.push(['set', {}]);" 
 else 
 "_kmq.push(['set', {'SiteName' : 'dashboard'}]);" 
 end 
 end 
 
 content_for :head 
  
 
  link_to t("homepage.index.post_new_listing"), new_listing_path, :class => "new-listing-link", :id => "new-listing-link" 
 Maybe(@current_user).each do |user| 
 conversations = @current_community.conversations.for_person(user) 
 unread_count = MarketplaceService::Inbox::Query.notification_count(user.id, @current_community.id) 
  image_tag user.image.url(:thumb), alt: '', class: 'header-user-avatar' 
 user.name(@current_community) 
 icon_tag("dropdown", ["icon-dropdown"]) 
 
  link_to person_inbox_path(@current_user) do 
 icon_tag("mail", ["icon-with-text"]) 
 t("layouts.conversations.messages") 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 link_to person_path(user) do 
 icon_tag("user", ["icon-with-text"]) 
 t("header.profile") 
 end 
 link_to person_settings_path(user) do 
 icon_tag("settings", ["icon-with-text"]) 
 t("layouts.logged_in.settings") 
 end 
 link_to logout_path do 
 icon_tag("logout", ["icon-with-text"]) 
 t("layouts.logged_in.logout") 
 end 
 
  link_to person_inbox_path(user), title: t("layouts.conversations.messages"), :id => "inbox-link", :class => "header-text-link header-hover header-inbox-link" do 
 icon_tag("mail", ["header-inbox"]) 
 if unread_count > 0 
 get_badge_class(unread_count) 
 unread_count 
 end 
 end 
 
 end 
 with_available_locales do |locales| 
 get_full_locale_name(I18n.locale).to_s 
 icon_tag("dropdown", ["icon-dropdown"]) 
  
 end 
 unless @current_user 
 link_to sign_up_path, class: "header-text-link header-hover" do 
 t("header.signup") 
 end 
 link_to login_path, class: "header-text-link header-hover", id: "header-login-link" do 
 t("header.login") 
 end 
 end 
 icon_tag("rows", ["header-menu-icon"]) 
 t("header.menu") 
  link_to "/" do 
 icon_tag("home", ["icon-with-text"]) 
 t("header.home") 
 end 
 link_to new_listing_path, :class => "hidden-tablet" do 
 icon_tag("new_listing", ["icon-with-text"]) 
 t("homepage.index.post_new_listing") 
 end 
 link_to about_infos_path do 
 icon_tag("information", ["icon-with-text"]) 
 t("header.about") 
 end 
 link_to new_user_feedback_path do 
 icon_tag("feedback", ["icon-with-text"]) 
 t("header.contact_us") 
 end 
 with_invite_link do 
 link_to new_invitation_path do 
 icon_tag("invite", ["icon-with-text"]) 
 t("header.invite") 
 end 
 end 
 Maybe(@current_community).menu_links.each do |menu_links| 
 menu_links.each do |menu_link| 
 link_to menu_link.url(I18n.locale), :target => "_blank" do 
 icon_tag("redirect", ["icon-with-text"]) 
 menu_link.title(I18n.locale) 
 end 
 end 
 end 
 if @current_user && @current_community && @current_user.has_admin_rights_in?(@current_community) 
 link_to edit_details_admin_community_path(@current_community) do 
 icon_tag("admin", ["icon-with-text"]) 
 t("layouts.logged_in.admin") 
 end 
 end 
 with_available_locales do |locales| 
 t("layouts.global-header.select_language") 
  
 end 
 
 link_to @homepage_path, :class => "header-logo", :id => "header-logo" do 
 end 
 
 if display_expiration_notice? 
  content_for :javascript do 
 end 
 t("expiration.title") 
 t("expiration.sub_title_new") 
 external_plan_service_login_url 
 t("expiration.link_to_external_service") 
 t("expiration.need_more_info") 
 t("expiration.contact_us") 
 
 end 
 content_for(:page_content) do 
 with_big_cover_photo do 
 yield :title_header 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 yield :title_header 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 icon_class 
 flash[announcement] 
 end 
 end 
 
 error_msg 
 end 
 if params[:controller] == "homepage" && params[:action] == "index" 
 params.except("action", "controller", "q", "view", "utf8").each do |param, value| 
 unless param.match(/^filter_option/) || param.match(/^checkbox_filter_option/) || param.match(/^nf_/) || param.match(/^price_/) 
 hidden_field_tag param, value 
 end 
 end 
 hidden_field_tag "view", @view_type 
 content_for(:page_content) 
 else 
 content_for(:page_content) 
 end 
  if (APP_CONFIG.use_google_analytics) 
 "_gaq.push(['_setAccount', '#{APP_CONFIG.google_analytics_key}']);" 
 "_gaq.push(['_setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 if @current_community && @current_community.google_analytics_key 
 "_gaq.push(['b._setAccount', '#{@current_community.google_analytics_key}']);" 
 "_gaq.push(['b._setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{Maybe(@current_community.name(I18n.locale)).gsub("'","").or_else("")}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{@current_community.domain}']);" 
 end 
 end 
 
 content_for(:location_search) 
  
 javascript_include_tag 'application' 
 if @analytics_event 
 end 
 if Rails.env.test? 
 end 
 content_for :extra_javascript 
  t('error_pages.no_javascript.javascript_is_disabled_in_your_browser') 
 t('error_pages.no_javascript.kassi_does_not_currently_work_without_javascript') 
 

end

    end
  end

  def select_unit(listing_unit, shape)
    m_unit = Maybe(shape)[:units].map { |units|
      units.length == 1 ? units.first : units.find { |u| u == listing_unit }
    }
  end

  def unit_to_listing_opts(m_unit)
    m_unit.map { |unit|
      {
        unit_type: unit[:type],
        quantity_selector: unit[:quantity_selector],
        unit_tr_key: unit[:name_tr_key],
        unit_selector_tr_key: unit[:selector_tr_key]
      }
    }.or_else({
        unit_type: nil,
        quantity_selector: nil,
        unit_tr_key: nil,
        unit_selector_tr_key: nil
    })
  end

  def unit_from_listing(listing)
    HashUtils.compact({
      type: Maybe(listing.unit_type).to_sym.or_else(nil),
      quantity_selector: Maybe(listing.quantity_selector).to_sym.or_else(nil),
      unit_tr_key: listing.unit_tr_key,
      unit_selector_tr_key: listing.unit_selector_tr_key
    })
  end

  def build_title(params)
    category = Category.find_by_id(params["category"])
    category_label = (category.present? ? "(" + localized_category_label(category) + ")" : "")

    if ["request","offer"].include? params['share_type']
      listing_type_label = t("listings.index.#{params['share_type']+"s"}")
    else
      listing_type_label = t("listings.index.listings")
    end

    t("listings.index.feed_title",
      :optional_category => category_label,
      :community_name => @current_community.name_with_separator(I18n.locale),
      :listing_type => listing_type_label)
  end

  def commission(community, process)
    payment_type = MarketplaceService::Community::Query.payment_type(community.id)
    payment_settings = TransactionService::API::Api.settings.get_active(community_id: community.id).maybe
    currency = community.default_currency

    case [payment_type, process]
    when matches([__, :none])
      {seller_commission_in_use: false,
       payment_gateway: nil,
       minimum_commission: Money.new(0, currency),
       commission_from_seller: 0,
       minimum_price_cents: 0}
    when matches([:paypal])
      p_set = Maybe(payment_settings_api.get_active(community_id: community.id))
        .select {|res| res[:success]}
        .map {|res| res[:data]}
        .or_else({})

      {seller_commission_in_use: payment_settings[:commission_type].or_else(:none) != :none,
       payment_gateway: payment_type,
       minimum_commission: Money.new(p_set[:minimum_transaction_fee_cents], currency),
       commission_from_seller: p_set[:commission_from_seller],
       minimum_price_cents: p_set[:minimum_price_cents]}
    else
      {seller_commission_in_use: !!community.commission_from_seller,
       payment_gateway: payment_type,
       minimum_commission: Money.new(0, currency),
       commission_from_seller: community.commission_from_seller,
       minimum_price_cents: community.absolute_minimum_price(currency).cents}
    end
  end

  def paypal_minimum_commissions_api
    PaypalService::API::Api.minimum_commissions_api
  end

  def payment_settings_api
    TransactionService::API::Api.settings
  end

  # Ensure that only users with appropriate visibility settings can view the listing
  def ensure_authorized_to_view
    # If listing is not found (in this community) the find method
    # will throw ActiveRecord::NotFound exception, which is handled
    # correctly in production environment (404 page)
    @listing = @current_community.listings.find(params[:id])

    raise ListingDeleted if @listing.deleted?

    unless @listing.visible_to?(@current_user, @current_community) || (@current_user && @current_user.has_admin_rights_in?(@current_community))
      if @current_user
        if @listing.closed?
          flash[:error] = t("layouts.notifications.listing_closed")
        else
          flash[:error] = t("layouts.notifications.you_are_not_authorized_to_view_this_content")
        end
        redirect_to root and return
      else
        session[:return_to] = request.fullpath
        flash[:warning] = t("layouts.notifications.you_must_log_in_to_view_this_content")
        redirect_to login_path and return
      end
    end
  end

  def change_follow_status(status)
    status.eql?("follow") ? @current_user.follow(@listing) : @current_user.unfollow(@listing)
    respond_to do |format|
      format.html {
        redirect_to @listing
      }
      format.js {
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 escape_javascript(render(:partial => 'listings/follow_links')) 

end

      }
    end
  end

  def custom_field_value_factory(listing_id, custom_field_id, answer_value)
    question = CustomField.find(custom_field_id)

    answer = question.with_type do |question_type|
      case question_type
      when :dropdown
        option_id = answer_value.to_i
        answer = DropdownFieldValue.new
        answer.custom_field_option_selections = [CustomFieldOptionSelection.new(:custom_field_value => answer, :custom_field_option_id => answer_value)]
        answer
      when :text
        answer = TextFieldValue.new
        answer.text_value = answer_value
        answer
      when :numeric
        answer = NumericFieldValue.new
        answer.numeric_value = ParamsService.parse_float(answer_value)
        answer
      when :checkbox
        answer = CheckboxFieldValue.new
        answer.custom_field_option_selections = answer_value.map { |value| CustomFieldOptionSelection.new(:custom_field_value => answer, :custom_field_option_id => value) }
        answer
      when :date_field
        answer = DateFieldValue.new
        answer.date_value = Time.utc(answer_value["(1i)"].to_i,
                                     answer_value["(2i)"].to_i,
                                     answer_value["(3i)"].to_i)
        answer
      else
        raise ArgumentError.new("Unimplemented custom field answer for question #{question_type}")
      end
    end

    answer.question = question
    answer.listing_id = listing_id
    return answer
  end

  # Note! Requires that parent listing is already saved to DB. We
  # don't use association to link to listing but directly connect to
  # listing_id.
  def upsert_field_values!(listing, custom_field_params)
    custom_field_params ||= {}

    # Delete all existing
    custom_field_value_ids = listing.custom_field_values.map(&:id)
    CustomFieldOptionSelection.where(custom_field_value_id: custom_field_value_ids).delete_all
    CustomFieldValue.where(id: custom_field_value_ids).delete_all

    field_values = custom_field_params.map do |custom_field_id, answer_value|
      custom_field_value_factory(listing.id, custom_field_id, answer_value) unless is_answer_value_blank(answer_value)
    end.compact

    # Insert new custom fields in a single transaction
    CustomFieldValue.transaction do
      field_values.each(&:save!)
    end
  end

  def is_answer_value_blank(value)
    if value.kind_of?(Hash)
      value["(3i)"].blank? || value["(2i)"].blank? || value["(1i)"].blank?  # DateFieldValue check
    else
      value.blank?
    end
  end

  def is_authorized_to_post
    if @current_community.require_verification_to_post_listings?
      unless @current_user.has_admin_rights_in?(@current_community) || @current_community_membership.can_post_listings?
        redirect_to verification_required_listings_path
      end
    end
  end

  def numeric_field_ids(custom_fields)
    custom_fields.map do |custom_field|
      custom_field.with(:numeric) do
        custom_field.id
      end
    end.compact
  end

  def normalize_price_params(listing_params)
    currency = listing_params[:currency]
    listing_params.inject({}) do |hash, (k, v)|
      case k
      when "price"
        hash.merge(:price_cents =>  MoneyUtil.parse_str_to_subunits(v, currency))
      when "shipping_price"
        hash.merge(:shipping_price_cents =>  MoneyUtil.parse_str_to_subunits(v, currency))
      when "shipping_price_additional"
        hash.merge(:shipping_price_additional_cents =>  MoneyUtil.parse_str_to_subunits(v, currency))
      else
        hash.merge( k.to_sym => v )
      end
    end
  end

  def payment_setup_status(community:, user:, listing:, payment_type:, process:)
    case [payment_type, process]
    when matches([nil]),
         matches([__, :none])
      [true, ""]
    when matches([:braintree])
      can_post = !PaymentRegistrationGuard.new(community, user, listing).requires_registration_before_posting?
      settings_link = payment_settings_path(community.payment_gateway.gateway_type, user)
      error_msg = t("listings.new.you_need_to_fill_payout_details_before_accepting", :payment_settings_link => view_context.link_to(t("listings.new.payment_settings_link"), settings_link)).html_safe

      [can_post, error_msg]
    when matches([:paypal])
      can_post = PaypalHelper.community_ready_for_payments?(community.id)
      error_msg =
        if user.has_admin_rights_in?(community)
          t("listings.new.community_not_configured_for_payments_admin",
            payment_settings_link: view_context.link_to(
              t("listings.new.payment_settings_link"),
              admin_paypal_preferences_path()))
            .html_safe
        else
          t("listings.new.community_not_configured_for_payments",
            contact_admin_link: view_context.link_to(
              t("listings.new.contact_admin_link_text"),
              new_user_feedback_path))
            .html_safe
        end
      [can_post, error_msg]
    else
      [true, ""]
    end
  end

  def delivery_config(require_shipping_address, pickup_enabled, shipping_price, shipping_price_additional, currency)
    shipping = delivery_price_hash(:shipping, shipping_price, shipping_price_additional)
    pickup = delivery_price_hash(:pickup, Money.new(0, currency), Money.new(0, currency))

    case [require_shipping_address, pickup_enabled]
    when matches([true, true])
      [shipping, pickup]
    when matches([true, false])
      [shipping]
    when matches([false, true])
      [pickup]
    else
      []
    end
  end

  def create_listing_params(listing_params)
    listing_params.except(:delivery_methods).merge(
      require_shipping_address: Maybe(listing_params[:delivery_methods]).map { |d| d.include?("shipping") }.or_else(false),
      pickup_enabled: Maybe(listing_params[:delivery_methods]).map { |d| d.include?("pickup") }.or_else(false),
      price_cents: listing_params[:price_cents],
      shipping_price_cents: listing_params[:shipping_price_cents],
      shipping_price_additional_cents: listing_params[:shipping_price_additional_cents],
      currency: listing_params[:currency]
    )
  end

  def get_transaction_process(community_id:, transaction_process_id:)
    opts = {
      process_id: transaction_process_id,
      community_id: community_id
    }

    TransactionService::API::Api.processes.get(opts)
      .maybe[:process]
      .or_else(nil)
      .tap { |process|
        raise ArgumentError.new("Cannot find transaction process: #{opts}") if process.nil?
      }
  end

  def listings_api
    ListingService::API::Api
  end

  def transactions_api
    TransactionService::API::Api
  end

  def valid_unit_type?(shape:, unit_type:)
    if unit_type.nil?
      shape[:units].empty?
    else
      shape[:units].any? { |unit| unit[:type] == unit_type.to_sym }
    end
  end

  def get_shapes
    @shapes ||= listings_api.shapes.get(community_id: @current_community.id).maybe.or_else(nil).tap { |shapes|
      raise ArgumentError.new("Cannot find any listing shape for community #{@current_community.id}") if shapes.nil?
    }
  end

  def get_processes
    @processes ||= transactions_api.processes.get(community_id: @current_community.id).maybe.or_else(nil).tap { |processes|
      raise ArgumentError.new("Cannot find any transaction process for community #{@current_community.id}") if processes.nil?
    }
  end

  def get_shape(listing_shape_id)
    shape_find_opts = {
      community_id: @current_community.id,
      listing_shape_id: listing_shape_id
    }

    shape_res = listings_api.shapes.get(shape_find_opts)

    if shape_res.success
      shape_res.data
    else
      raise ArgumentError.new(shape_res.error_msg) unless shape_res.success
    end
  end

  def delivery_price_hash(delivery_type, price, shipping_price_additional)
      { name: delivery_type,
        price: price,
        shipping_price_additional: shipping_price_additional,
        price_info: ListingViewUtils.shipping_info(delivery_type, price, shipping_price_additional),
        default: true
      }
  end
end

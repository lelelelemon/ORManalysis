# encoding: utf-8
class HomepageController < ApplicationController

  before_filter :save_current_path, :except => :sign_in

  APP_DEFAULT_VIEW_TYPE = "grid"
  VIEW_TYPES = ["grid", "list", "map"]

  def index
    @homepage = true

    @view_type = HomepageController.selected_view_type(params[:view], @current_community.default_browse_view, APP_DEFAULT_VIEW_TYPE, VIEW_TYPES)

    @categories = @current_community.categories.includes(:children)
    @main_categories = @categories.select { |c| c.parent_id == nil }

    all_shapes = shapes.get(community_id: @current_community.id)[:data]

    # This assumes that we don't never ever have communities with only 1 main share type and
    # only 1 sub share type, as that would make the listing type menu visible and it would look bit silly
    listing_shape_menu_enabled = all_shapes.size > 1
    @show_categories = @categories.size > 1
    show_price_filter = @current_community.show_price_filter && all_shapes.any? { |s| s[:price_enabled] }
    @show_custom_fields = @current_community.custom_fields.any?(&:can_filter?) || show_price_filter
    @category_menu_enabled = @show_categories || @show_custom_fields

    @app_store_badge_filename = "/assets/Available_on_the_App_Store_Badge_en_135x40.svg"
    if File.exists?("app/assets/images/Available_on_the_App_Store_Badge_#{I18n.locale}_135x40.svg")
       @app_store_badge_filename = "/assets/Available_on_the_App_Store_Badge_#{I18n.locale}_135x40.svg"
    end

    filter_params = {}

    listing_shape_param = params[:transaction_type]

    all_shapes = shapes.get(community_id: @current_community.id)[:data]
    selected_shape = all_shapes.find { |s| s[:name] == listing_shape_param }

    filter_params[:listing_shape] = Maybe(selected_shape)[:id].or_else(nil)

    compact_filter_params = HashUtils.compact(filter_params)

    per_page = @view_type == "map" ? APP_CONFIG.map_listings_limit : APP_CONFIG.grid_listings_limit

    includes =
      case @view_type
      when "grid"
        [:author, :listing_images]
      when "list"
        [:author, :listing_images, :num_of_reviews]
      when "map"
        [:location]
      else
        raise ArgumentError.new("Unknown view_type #{@view_type}")
      end

    search_result = find_listings(params, per_page, compact_filter_params, includes.to_set)

    shape_name_map = all_shapes.map { |s| [s[:id], s[:name]]}.to_h

    if request.xhr? # checks if AJAX request
      search_result.on_success { |listings|
        @listings = listings # TODO Remove

        if @view_type == "grid" then
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
 
 frontpage_fragment_cache("grid_item", listing) do 
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
 
 link_to(person_path(id: listing.author.username)) do 
 image_tag(listing.author.avatar.thumb, :class => "home-fluid-thumbnail-grid-author-avatar-image") 
 end 
 link_to(person_path(id: listing.author.username), :class => "home-fluid-thumbnail-grid-author-name") do 
 PersonViewUtils::person_entity_display_name(listing.author, @current_community.name_display_type) 
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
 
 frontpage_fragment_cache("list_item", listing) do 
 if listing.listing_images.size > 0 
 link_to listing_path(listing.url), :class => "home-list-image-container-desktop" do 
 image_tag listing.listing_images.first[:small_3x2], {:alt => listed_listing_title(listing), :class => "home-list-image"} 
 end 
 end 
 if listing.listing_images.size > 0 
 link_to listing_path(listing.url), :class => "home-list-image-container-mobile" do 
 image_tag listing.listing_images.first[:thumb], {:alt => listed_listing_title(listing), :class => "home-list-image"} 
 end 
 end 
 if listing.price 
 humanized_money_with_symbol(listing.price).upcase 
 price_text = nil 
 if listing.quantity.present? 
 price_text = t("listings.form.price.per") + " " + listing.quantity 
 elsif listing.unit_type 
 price_text = price_quantity_per_unit(listing) 
 end 
 if price_text.present? 
 price_text 
 price_text 
 end 
 else 
 shape_name(listing) 
 end 
 link_to listing_path(listing.url) do 
 listing.title 
 if @current_community.show_category_in_listing_list 
 root_path(:transaction_type => shape_name_map[listing.listing_shape_id], :view => :list) 
 icon_tag(listing.icon_name, ["icon-fix"]) 
 shape_name(listing) 
 end 
 end 
 link_to(person_path(id: listing.author.username), :class => "home-fluid-thumbnail-grid-author-avatar-image") do 
 image_tag(listing.author.avatar.thumb) 
 end 
 link_to(person_path(id: listing.author.username), :class => "home-list-author-name") do 
 PersonViewUtils::person_entity_display_name(listing.author, @current_community.name_display_type) 
 end 
 if testimonials_in_use 
 if listing.author.num_of_reviews > 0 
 icon_tag("testimonial") 
 pluralize(listing.author.num_of_reviews, t(".review"), t(".reviews")) 
 end 
 end 
 if listing.price 
 humanized_money_with_symbol(listing.price).upcase 
 price_text = nil 
 if listing.quantity.present? 
 price_text = t("listings.form.price.per") + " " + listing.quantity 
 elsif listing.unit_type 
 price_text = price_quantity_per_unit(listing) 
 end 
 if price_text.present? 
 price_text 
 price_text 
 end 
 else 
 shape_name(listing) 
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
      }.on_error {
        render nothing: true, status: 500
      }
    else
      search_result.on_success { |listings|
        @listings = listings
        render locals: {
                 shapes: all_shapes,
                 show_price_filter: show_price_filter,
                 selected_shape: selected_shape,
                 shape_name_map: shape_name_map,
                 testimonials_in_use: @current_community.testimonials_in_use,
                 listing_shape_menu_enabled: listing_shape_menu_enabled }
      }.on_error { |e|
        flash[:error] = t("homepage.errors.search_engine_not_responding")
        @listings = Listing.none.paginate(:per_page => 1, :page => 1)
        render status: 500, locals: {
                 shapes: all_shapes,
                 show_price_filter: show_price_filter,
                 selected_shape: selected_shape,
                 shape_name_map: shape_name_map,
                 testimonials_in_use: @current_community.testimonials_in_use,
                 listing_shape_menu_enabled: listing_shape_menu_enabled }
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
 with_big_cover_photo do 
 community_slogan.html_safe 
 community_description.html_safe 
 if @current_community.private? 
 sign_up_path 
 t("layouts.application.connect") 
 else 
 if(feature_enabled?(:location_search)) 
  content_for(:location_search) do 
 if feature_enabled?(:location_search) 
 end 
 end 
 content_for :extra_javascript do 
 end 
 text_field_tag "q", params[:q], :placeholder => (@community_customization && @community_customization.search_placeholder) || t("homepage.index.what_do_you_need") 
 hidden_field_tag 'lc', params[:lc] 
 icon_tag("globelocation", ["icon-part"]) 
 
 else 
  text_field_tag "q", params[:q], :placeholder => (@community_customization && @community_customization.search_placeholder) || t("homepage.index.what_do_you_need") 
 icon_tag("search", ["icon-part"]) 
 
 end 
 end 
 end 
 with_small_cover_photo do 
 if(feature_enabled?(:location_search)) 
  content_for(:location_search) do 
 if feature_enabled?(:location_search) 
 end 
 end 
 content_for :extra_javascript do 
 end 
 text_field_tag "q", params[:q], :placeholder => (@community_customization && @community_customization.search_placeholder) || t("homepage.index.what_do_you_need") 
 hidden_field_tag 'lc', params[:lc] 
 icon_tag("globelocation", ["icon-part"]) 
 
 else 
  text_field_tag "q", params[:q], :placeholder => (@community_customization && @community_customization.search_placeholder) || t("homepage.index.what_do_you_need") 
 icon_tag("search", ["icon-part"]) 
 
 end 
 end 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 with_big_cover_photo do 
 community_slogan.html_safe 
 community_description.html_safe 
 if @current_community.private? 
 sign_up_path 
 t("layouts.application.connect") 
 else 
 if(feature_enabled?(:location_search)) 
  content_for(:location_search) do 
 if feature_enabled?(:location_search) 
 end 
 end 
 content_for :extra_javascript do 
 end 
 text_field_tag "q", params[:q], :placeholder => (@community_customization && @community_customization.search_placeholder) || t("homepage.index.what_do_you_need") 
 hidden_field_tag 'lc', params[:lc] 
 icon_tag("globelocation", ["icon-part"]) 
 
 else 
  text_field_tag "q", params[:q], :placeholder => (@community_customization && @community_customization.search_placeholder) || t("homepage.index.what_do_you_need") 
 icon_tag("search", ["icon-part"]) 
 
 end 
 end 
 end 
 with_small_cover_photo do 
 if(feature_enabled?(:location_search)) 
  content_for(:location_search) do 
 if feature_enabled?(:location_search) 
 end 
 end 
 content_for :extra_javascript do 
 end 
 text_field_tag "q", params[:q], :placeholder => (@community_customization && @community_customization.search_placeholder) || t("homepage.index.what_do_you_need") 
 hidden_field_tag 'lc', params[:lc] 
 icon_tag("globelocation", ["icon-part"]) 
 
 else 
  text_field_tag "q", params[:q], :placeholder => (@community_customization && @community_customization.search_placeholder) || t("homepage.index.what_do_you_need") 
 icon_tag("search", ["icon-part"]) 
 
 end 
 end 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 icon_class 
 flash[announcement] 
 end 
 end 
 
 content_for :javascript do 
 end 
 content_for :coverfade_class do 
 "without-text" 
 end 
  
 if @current_community.private? && show_big_cover_photo? 
 if @community_customization && @community_customization.private_community_homepage_content 
 @community_customization.private_community_homepage_content.html_safe 
 else 
 t(".this_is_private_community") 
 end 
 else 
 if listing_shape_menu_enabled || @category_menu_enabled 
 t(".filter") 
 end 
 listing_shape_menu_enabled 
 ["grid", "list", "map"].each do |view_type| 
 selected_class = @view_type == view_type ? "selected" : "" 
 link_to params.merge(view: view_type), :class => "home-toolbar-button-group-button #{selected_class}", :title => t("homepage.filters.#{view_type}_button") do 
 icon_tag(view_type, ["icon-fix", "home-button-group-icon"]) 
 t("homepage.filters.#{view_type}_button") 
 end 
 end 
 if listing_shape_menu_enabled || @category_menu_enabled 
 if listing_shape_menu_enabled 
 if selected_shape 
 t(selected_shape[:name_tr_key]) 
 else 
 t("homepage.filters.all_listing_types") 
 end 
 icon_tag("dropdown", ["icon-dropdown"]) 
 link_to t("homepage.filters.all_listing_types"), params.merge({transaction_type: "all"}) 
 shapes.each do |shape| 
 link_to params.merge({transaction_type: shape[:name]}), class:  "toggle-menu-subitem" do 
 t(shape[:name_tr_key]) 
 end 
 end 
 end 
 if @show_categories 
 if @selected_category 
 @selected_category.display_name(I18n.locale) 
 else 
 t("homepage.filters.all_categories") 
 end 
 icon_tag("dropdown", ["icon-dropdown"]) 
 link_to t("homepage.filters.all_categories"), params.merge({category: "all"}) 
 @main_categories.each do |category| 
 link_to category.display_name(I18n.locale), params.merge({category: category}) 
 if category.children 
 category.children.each do |child| 
 is_selected = @selected_category == child 
 link_to child.display_name(I18n.locale), params.merge({category: child}), :class => "toggle-menu-subitem" 
 end 
 end 
 end 
 end 
 # Filters will be relocated to #desktop-filters when in desktop 
  if show_price_filter || show_custom_fields 
 if show_price_filter 
  t("listings.form.price.price") 
 id = ["range-slider", "price"].join("-") 
 id 
 min = MoneyUtil.to_units(MoneyUtil.to_money(@current_community.price_filter_min, @current_community.default_currency)) 
 max = MoneyUtil.to_units(MoneyUtil.to_money(@current_community.price_filter_max, @current_community.default_currency)) 
 range = [min, max] 
 start = [params["price_min"] , params["price_max"] || max] 
 labels = ["#price-filter-min-value", "#price-filter-max-value"] 
 fields = ["#price_min", "#price_max"] 
 content_for :extra_javascript do 
 end 
 t("homepage.custom_filters.min") 
 params["price_min"] 
 t("homepage.custom_filters.max") 
 params["price_max"] 
 
 end 
 if show_custom_fields 
  @current_community.custom_fields.sort.each do |field| 
 field.with_type do |type| 
 if [:dropdown, :checkbox].include?(type) 
 field.name(I18n.locale) 
 make_scrollable = field.options.size > 10 
 field.options.sort.each do |option| 
 check_box_tag param_name, "#{option.id}", params[param_name] 
 option.title(I18n.locale) 
 end 
 end 
 end 
 field.with(:numeric) do 
 field.name(I18n.locale) 
 id = ["range-slider", field.id].join("-") 
 id 
 range = [field.min, field.max] 
 start = [params["nf_min_" + field.id.to_s] , params["nf_max_" + field.id.to_s] || field.max] 
 labels = ["#custom-filter-min-value-#{id}", "#custom-filter-max-value-#{id}"] 
 fields = ["#nf_min_#{id}", "#nf_max_#{id}"] 
 content_for :extra_javascript do 
 end 
 t(".min") 
 t(".max") 
 end 
 end 
 
 end 
 t("homepage.custom_filters.update_view") 
 end 
 
 end 
 if @category_menu_enabled 
 if @show_categories 
 link_to t("homepage.filters.all_categories"), params.merge({category: "all"}), :class => "home-categories-main #{if @selected_category.nil? then 'selected' end}" 
 @main_categories.each do |category| 
 show_subcategories = show_subcategory_list(category, Maybe(@selected_category).id.to_i.or_else(nil)) 
 link_to category.display_name(I18n.locale), params.merge({category: category}), :class => "home-categories-main #{if show_subcategories then 'selected' end} #{if category.has_subcategories? then 'has-subcategories' end}", :data => {category: category.id} 
 if category.children 
 if show_subcategories 
 category.children.each do |child| 
 is_selected = @selected_category == child 
 link_to child.display_name(I18n.locale), params.merge({category: child}), :class => "home-categories-sub #{if is_selected then 'selected' end}", :data => {:"sub-category" =>child.id} 
 end 
 end 
 end 
 end 
 end 
 # Filters will be relocated here when in desktop 
 end 
 main_container_class = if @category_menu_enabled then "col-9" else "col-12" end 
 main_container_class 
 if @listings.total_entries > 0 
 if @view_type.eql?("map") 
  content_for :extra_javascript do 
 javascript_include_tag "https://maps.google.com/maps/api/js?sensor=true" 
 javascript_include_tag 'markerclusterer.js' 
 end 
 community_location_lat = @current_community.location ? @current_community.location.latitude : nil 
 community_location_lon = @current_community.location ? @current_community.location.longitude : nil 
 content_for :extra_javascript do 
 end 
 
 else 
 if @view_type.eql?("grid") 
  frontpage_fragment_cache("grid_item", listing) do 
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
 
 link_to(person_path(id: listing.author.username)) do 
 image_tag(listing.author.avatar.thumb, :class => "home-fluid-thumbnail-grid-author-avatar-image") 
 end 
 link_to(person_path(id: listing.author.username), :class => "home-fluid-thumbnail-grid-author-name") do 
 PersonViewUtils::person_entity_display_name(listing.author, @current_community.name_display_type) 
 end 
 end 
 
 else 
  frontpage_fragment_cache("list_item", listing) do 
 if listing.listing_images.size > 0 
 link_to listing_path(listing.url), :class => "home-list-image-container-desktop" do 
 image_tag listing.listing_images.first[:small_3x2], {:alt => listed_listing_title(listing), :class => "home-list-image"} 
 end 
 end 
 if listing.listing_images.size > 0 
 link_to listing_path(listing.url), :class => "home-list-image-container-mobile" do 
 image_tag listing.listing_images.first[:thumb], {:alt => listed_listing_title(listing), :class => "home-list-image"} 
 end 
 end 
 if listing.price 
 humanized_money_with_symbol(listing.price).upcase 
 price_text = nil 
 if listing.quantity.present? 
 price_text = t("listings.form.price.per") + " " + listing.quantity 
 elsif listing.unit_type 
 price_text = price_quantity_per_unit(listing) 
 end 
 if price_text.present? 
 price_text 
 price_text 
 end 
 else 
 shape_name(listing) 
 end 
 link_to listing_path(listing.url) do 
 listing.title 
 if @current_community.show_category_in_listing_list 
 root_path(:transaction_type => shape_name_map[listing.listing_shape_id], :view => :list) 
 icon_tag(listing.icon_name, ["icon-fix"]) 
 shape_name(listing) 
 end 
 end 
 link_to(person_path(id: listing.author.username), :class => "home-fluid-thumbnail-grid-author-avatar-image") do 
 image_tag(listing.author.avatar.thumb) 
 end 
 link_to(person_path(id: listing.author.username), :class => "home-list-author-name") do 
 PersonViewUtils::person_entity_display_name(listing.author, @current_community.name_display_type) 
 end 
 if testimonials_in_use 
 if listing.author.num_of_reviews > 0 
 icon_tag("testimonial") 
 pluralize(listing.author.num_of_reviews, t(".review"), t(".reviews")) 
 end 
 end 
 if listing.price 
 humanized_money_with_symbol(listing.price).upcase 
 price_text = nil 
 if listing.quantity.present? 
 price_text = t("listings.form.price.per") + " " + listing.quantity 
 elsif listing.unit_type 
 price_text = price_quantity_per_unit(listing) 
 end 
 if price_text.present? 
 price_text 
 price_text 
 end 
 else 
 shape_name(listing) 
 end 
 end 
 
 end 
 will_paginate(@listings) 
 item_container = if @view_type.eql?("grid") then '.home-fluid-thumbnail-grid' else '.home-listings' end 
 pageless(@listings.total_pages, item_container, request.fullpath, t('.loading_more_content')) 
 end 
 else 
 if params[:q] || params[:category] || params[:share_type] # Some filter in use 
 t(".no_listings_with_your_search_criteria") 
 else 
 t(".no_listings_notification", :add_listing_link => link_to(t(".add_listing_link_text"), new_listing_path)).html_safe 
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

  def self.selected_view_type(view_param, community_default, app_default, all_types)
    if view_param.present? and all_types.include?(view_param)
      view_param
    elsif community_default.present? and all_types.include?(community_default)
      community_default
    else
      app_default
    end
  end

  private

  def find_listings(params, listings_per_page, filter_params, includes)
    Maybe(@current_community.categories.find_by_url_or_id(params[:category])).each do |category|
      filter_params[:categories] = category.own_and_subcategory_ids
      @selected_category = category
    end

    filter_params[:search] = params[:q] if params[:q]
    filter_params[:custom_dropdown_field_options] = HomepageController.dropdown_field_options_for_search(params)
    filter_params[:custom_checkbox_field_options] = HomepageController.checkbox_field_options_for_search(params)

    filter_params[:price_cents] = filter_range(params[:price_min], params[:price_max])

    p = HomepageController.numeric_filter_params(params)
    p = HomepageController.parse_numeric_filter_params(p)
    p = HomepageController.group_to_ranges(p)
    numeric_search_params = HomepageController.filter_unnecessary(p, @current_community.custom_numeric_fields)

    filter_params = filter_params.reject {
      |_, value| (value == "all" || value == ["all"])
    } # all means the filter doesn't need to be included

    checkboxes = filter_params[:custom_checkbox_field_options].map { |checkbox_field| checkbox_field.merge(type: :selection_group, operator: :and) }
    dropdowns = filter_params[:custom_dropdown_field_options].map { |dropdown_field| dropdown_field.merge(type: :selection_group, operator: :or) }
    numbers = numeric_search_params.map { |numeric| numeric.merge(type: :numeric_range) }

    search = {
      # Add listing_id
      categories: filter_params[:categories],
      listing_shape_id: Maybe(filter_params)[:listing_shape].or_else(nil),
      price_cents: filter_params[:price_cents],
      keywords: filter_params[:search],
      fields: checkboxes.concat(dropdowns).concat(numbers),
      per_page: listings_per_page,
      page: params[:page].to_i > 0 ? params[:page].to_i : 1
    }

    ListingIndexService::API::Api.listings.search(community_id: @current_community.id, search: search, includes: includes).and_then { |res|
      Result::Success.new(
        ListingIndexViewUtils.to_struct(
        result: res,
        includes: includes,
        page: search[:page],
        per_page: search[:per_page]
      ))
    }
  end

  def filter_range(price_min, price_max)
    if (price_min && price_max)
      min = MoneyUtil.parse_str_to_money(price_min, @current_community.default_currency).cents
      max = MoneyUtil.parse_str_to_money(price_max, @current_community.default_currency).cents

      if ((@current_community.price_filter_min..@current_community.price_filter_max) != (min..max))
        (min..max)
      else
        nil
      end
    end
  end

  # Return all params starting with `numeric_filter_`
  def self.numeric_filter_params(all_params)
    all_params.select { |key, value| key.start_with?("nf_") }
  end

  def self.parse_numeric_filter_params(numeric_params)
    numeric_params.inject([]) do |memo, numeric_param|
      key, value = numeric_param
      _, boundary, id = key.split("_")

      hash = {id: id.to_i}
      hash[boundary.to_sym] = value
      memo << hash
    end
  end

  def self.group_to_ranges(parsed_params)
    parsed_params
      .group_by { |param| param[:id] }
      .map do |key, values|
        boundaries = values.inject(:merge)

        {
          id: key,
          value: (boundaries[:min].to_f..boundaries[:max].to_f)
        }
      end
  end

  # Filter search params if their values equal min/max
  def self.filter_unnecessary(search_params, numeric_fields)
    search_params.reject do |search_param|
      numeric_field = numeric_fields.find(search_param[:id])
      search_param == { id: numeric_field.id, value: (numeric_field.min..numeric_field.max) }
    end
  end

  def self.options_from_params(params, regexp)
    option_ids = HashUtils.select_by_key_regexp(params, regexp).values

    array_for_search = CustomFieldOption.find(option_ids)
      .group_by { |option| option.custom_field_id }
      .map { |key, selected_options| {id: key, value: selected_options.collect(&:id) } }
  end

  def self.dropdown_field_options_for_search(params)
    options_from_params(params, /^filter_option/)
  end

  def self.checkbox_field_options_for_search(params)
    options_from_params(params, /^checkbox_filter_option/)
  end

  def shapes
    ListingService::API::Api.shapes
  end
end

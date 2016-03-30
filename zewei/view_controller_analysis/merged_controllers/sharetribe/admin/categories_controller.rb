class Admin::CategoriesController < ApplicationController

  before_filter :ensure_is_admin

  def index
    @selected_left_navi_link = "listing_categories"
    @categories = @current_community.top_level_categories.includes(:translations, children: :translations)
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
 t("layouts.admin.admin") 
 "-" 
 t(".listing_categories") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("layouts.admin.admin") 
 "-" 
 t(".listing_categories") 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 icon_class 
 flash[announcement] 
 end 
 end 
 
  
 content_for :javascript do 
 end 
  grouped_links = links.group_by {|l| l[:topic]} 
  APP_CONFIG.uservoice_widget_url 
 @current_user.confirmed_notification_email_to 
 @current_user.full_name 
 @current_user.id 
 @current_user.created_at.to_time.to_i
 @current_community.id 
 @current_community.full_url 
 @current_community.created_at.to_time.to_i 
 @current_plan[:plan_level] 
 ( @current_community.created_at < 10.days.ago ? "UserVoice.push(['autoprompt', {}]);".html_safe : "//no autoprompt yet for this site") 
 
 sel_link = (local_assigns.has_key? :selected_left_navi_link) ? selected_left_navi_link : @selected_left_navi_link 
 t("admin.left_hand_navigation.general") 
 grouped_links[:general].each do |link| 
 link[:data_uv_trigger] 
 link[:path] 
 link[:id] 
 link[:text] 
 link[:icon_class] 
 link[:text] 
 end 
 t("admin.left_hand_navigation.users_and_transactions") 
 grouped_links[:manage].each do |link| 
 link[:path] 
 link[:id] 
 link[:text] 
 link[:icon_class] 
 link[:text] 
 end 
 t("admin.left_hand_navigation.configure") 
 grouped_links[:configure].each do |link| 
 link[:path] 
 link[:id] 
 link[:text] 
 link[:icon_class] 
 link[:text] 
 end 
 links.each do |link| 
 if link[:name].eql?(sel_link) 
 link[:icon_class] 
 link[:text] 
 end 
 end 
 links.each do |link| 
 link[:icon_class] 
 link[:text] 
 end 
 
  category.display_name(I18n.locale) 
  link_to edit_admin_category_path(category), :class => "category-action-edit", :id => "edit_category_#{category.id}" do 
 icon_tag("edit", ["icon-fix"]) 
 end 
 remove_html_opts = {} 
 if !category.can_destroy? 
 icon_tag("cross", ["icon-fix disabled"]) 
 elsif category.remove_needs_caution? 
 link_to remove_admin_category_path(category), remove_html_opts do 
 icon_tag("cross", ["icon-fix"]) 
 end 
 else 
 link_to admin_category_path(category), remove_html_opts.merge(:method => :delete, :confirm => t("admin.categories.index.remove_category_confirmation", {category_name: category.display_name(I18n.locale)})) do 
 icon_tag("cross", ["icon-fix"]) 
 end 
 end 
 sort_disabled_class = category_count == 1 ? "disabled" : "" 
 link_to '#', :class => "category-action-up admin-sort-button #{sort_disabled_class}", :tabindex => "-1" do 
 icon_tag("directup", ["icon-fix"]) 
 end 
 link_to '#', :class => "category-action-down admin-sort-button #{sort_disabled_class}", :tabindex => "-1" do 
 icon_tag("directdown", ["icon-fix"]) 
 end 
 
 unless category.children.empty? 
  subcategory.display_name(I18n.locale) 
  link_to edit_admin_category_path(category), :class => "category-action-edit", :id => "edit_category_#{category.id}" do 
 icon_tag("edit", ["icon-fix"]) 
 end 
 remove_html_opts = {} 
 if !category.can_destroy? 
 icon_tag("cross", ["icon-fix disabled"]) 
 elsif category.remove_needs_caution? 
 link_to remove_admin_category_path(category), remove_html_opts do 
 icon_tag("cross", ["icon-fix"]) 
 end 
 else 
 link_to admin_category_path(category), remove_html_opts.merge(:method => :delete, :confirm => t("admin.categories.index.remove_category_confirmation", {category_name: category.display_name(I18n.locale)})) do 
 icon_tag("cross", ["icon-fix"]) 
 end 
 end 
 sort_disabled_class = category_count == 1 ? "disabled" : "" 
 link_to '#', :class => "category-action-up admin-sort-button #{sort_disabled_class}", :tabindex => "-1" do 
 icon_tag("directup", ["icon-fix"]) 
 end 
 link_to '#', :class => "category-action-down admin-sort-button #{sort_disabled_class}", :tabindex => "-1" do 
 icon_tag("directdown", ["icon-fix"]) 
 end 
 
 
 end 
 
 icon_class("loading") 
 t(".saving_order") 
 icon_class("check") 
 t(".save_order_successful") 
 t(".save_order_error") 
 link_to t(".create_a_new_category"), new_admin_category_path 
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
    @selected_left_navi_link = "listing_categories"
    @category = Category.new
    shapes = get_shapes
    selected_shape_ids = shapes.map { |s| s[:id] } # all selected by defaults
    render locals: { shapes: shapes, selected_shape_ids: selected_shape_ids }
  end

  def create
    @selected_left_navi_link = "listing_categories"
    @category = Category.new(params[:category].except(:listing_shapes))
    @category.community = @current_community
    @category.parent_id = nil if params[:category][:parent_id].blank?
    @category.sort_priority = Admin::SortingService.next_sort_priority(@current_community.categories)
    shapes = get_shapes
    selected_shape_ids = shape_ids_from_params(params)

    if @category.save
      update_category_listing_shapes(selected_shape_ids, @category)
      redirect_to admin_categories_path
    else
      flash[:error] = "Category saving failed"
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
 t("layouts.admin.admin") 
 "-" 
 t(".new_listing_category") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("layouts.admin.admin") 
 "-" 
 t(".new_listing_category") 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 icon_class 
 flash[announcement] 
 end 
 end 
 
 content_for :javascript do 
 end 
  
  grouped_links = links.group_by {|l| l[:topic]} 
  APP_CONFIG.uservoice_widget_url 
 @current_user.confirmed_notification_email_to 
 @current_user.full_name 
 @current_user.id 
 @current_user.created_at.to_time.to_i
 @current_community.id 
 @current_community.full_url 
 @current_community.created_at.to_time.to_i 
 @current_plan[:plan_level] 
 ( @current_community.created_at < 10.days.ago ? "UserVoice.push(['autoprompt', {}]);".html_safe : "//no autoprompt yet for this site") 
 
 sel_link = (local_assigns.has_key? :selected_left_navi_link) ? selected_left_navi_link : @selected_left_navi_link 
 t("admin.left_hand_navigation.general") 
 grouped_links[:general].each do |link| 
 link[:data_uv_trigger] 
 link[:path] 
 link[:id] 
 link[:text] 
 link[:icon_class] 
 link[:text] 
 end 
 t("admin.left_hand_navigation.users_and_transactions") 
 grouped_links[:manage].each do |link| 
 link[:path] 
 link[:id] 
 link[:text] 
 link[:icon_class] 
 link[:text] 
 end 
 t("admin.left_hand_navigation.configure") 
 grouped_links[:configure].each do |link| 
 link[:path] 
 link[:id] 
 link[:text] 
 link[:icon_class] 
 link[:text] 
 end 
 links.each do |link| 
 if link[:name].eql?(sel_link) 
 link[:icon_class] 
 link[:text] 
 end 
 end 
 links.each do |link| 
 link[:icon_class] 
 link[:text] 
 end 
 
 form_for [:admin, @category] do |form| 
  form.label :name_attributes, t(".category_title") 
 available_locales.each do |locale_name, locale_value| 
 if available_locales.size > 1 
 label_tag "category[translation_attributes][#{locale_value}][name]", locale_name + ": ", :class => "new-category-name-locale-label" 
 end 
 text_field_tag "category[translation_attributes][#{locale_value}][name]", @category.display_name(locale_value), :class => "required" 
 end 
 
  top_level_categories = @current_community.top_level_categories.reject { |c| c.id == @category.id } 
 if @category.children.empty? && top_level_categories.size > 0 
 form.label :parent_id, t(".category_parent") 
 form.select :parent_id, options_for_select([[t(".no_parent"), nil]] + top_level_categories.collect { |c| [c.display_name(I18n.locale), c.id] }, @category.parent_id) 
 end 
 
  if shapes.size > 1 
 t("admin.categories.form.category_transaction_types.transaction_types") 
 t("admin.categories.form.category_transaction_types.select_all") 
 t("admin.categories.form.category_transaction_types.clear_all") 
  icon_tag("information") 
 text 
 
 shapes.each do |shape| 
 checkbox_id = "listing_shape_checkbox_#{shape[:id].to_s}" 
 check_box_tag "category[listing_shapes][][listing_shape_id]", "#{shape[:id]}", selected_shape_ids.include?(shape[:id]), :id => checkbox_id, :class => "category-listing-shape-checkbox" 
 label_tag checkbox_id, t(shape[:name_tr_key]), :class => "category-listing-shape-checkbox-label" 
 end 
 else 
 hidden_field_tag "category[listing_shapes][][listing_shape_id]", shapes.first[:id] 
 end 
 
  form.button t(".save") 
 admin_categories_path 
 t(".cancel") 
 
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
  end

  def edit
    @selected_left_navi_link = "listing_categories"
    @category = @current_community.categories.find_by_url_or_id(params[:id])
    shapes = get_shapes
    selected_shape_ids = CategoryListingShape.where(category_id: @category.id).map(&:listing_shape_id)
    render locals: { shapes: shapes, selected_shape_ids: selected_shape_ids }
  end

  def update
    @selected_left_navi_link = "listing_categories"
    @category = @current_community.categories.find_by_url_or_id(params[:id])
    shapes = get_shapes
    selected_shape_ids = shape_ids_from_params(params)

    if @category.update_attributes(params[:category].except(:listing_shapes))
      update_category_listing_shapes(selected_shape_ids, @category)
      redirect_to admin_categories_path
    else
      flash[:error] = "Category saving failed"
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
 t("layouts.admin.admin") 
 "-" 
 t(".edit_listing_category", :category => @category.display_name(I18n.locale)) 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("layouts.admin.admin") 
 "-" 
 t(".edit_listing_category", :category => @category.display_name(I18n.locale)) 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 icon_class 
 flash[announcement] 
 end 
 end 
 
 content_for :javascript do 
 end 
  
  grouped_links = links.group_by {|l| l[:topic]} 
  APP_CONFIG.uservoice_widget_url 
 @current_user.confirmed_notification_email_to 
 @current_user.full_name 
 @current_user.id 
 @current_user.created_at.to_time.to_i
 @current_community.id 
 @current_community.full_url 
 @current_community.created_at.to_time.to_i 
 @current_plan[:plan_level] 
 ( @current_community.created_at < 10.days.ago ? "UserVoice.push(['autoprompt', {}]);".html_safe : "//no autoprompt yet for this site") 
 
 sel_link = (local_assigns.has_key? :selected_left_navi_link) ? selected_left_navi_link : @selected_left_navi_link 
 t("admin.left_hand_navigation.general") 
 grouped_links[:general].each do |link| 
 link[:data_uv_trigger] 
 link[:path] 
 link[:id] 
 link[:text] 
 link[:icon_class] 
 link[:text] 
 end 
 t("admin.left_hand_navigation.users_and_transactions") 
 grouped_links[:manage].each do |link| 
 link[:path] 
 link[:id] 
 link[:text] 
 link[:icon_class] 
 link[:text] 
 end 
 t("admin.left_hand_navigation.configure") 
 grouped_links[:configure].each do |link| 
 link[:path] 
 link[:id] 
 link[:text] 
 link[:icon_class] 
 link[:text] 
 end 
 links.each do |link| 
 if link[:name].eql?(sel_link) 
 link[:icon_class] 
 link[:text] 
 end 
 end 
 links.each do |link| 
 link[:icon_class] 
 link[:text] 
 end 
 
 form_for [:admin, @category] do |form| 
  form.label :name_attributes, t(".category_title") 
 available_locales.each do |locale_name, locale_value| 
 if available_locales.size > 1 
 label_tag "category[translation_attributes][#{locale_value}][name]", locale_name + ": ", :class => "new-category-name-locale-label" 
 end 
 text_field_tag "category[translation_attributes][#{locale_value}][name]", @category.display_name(locale_value), :class => "required" 
 end 
 
  top_level_categories = @current_community.top_level_categories.reject { |c| c.id == @category.id } 
 if @category.children.empty? && top_level_categories.size > 0 
 form.label :parent_id, t(".category_parent") 
 form.select :parent_id, options_for_select([[t(".no_parent"), nil]] + top_level_categories.collect { |c| [c.display_name(I18n.locale), c.id] }, @category.parent_id) 
 end 
 
  if shapes.size > 1 
 t("admin.categories.form.category_transaction_types.transaction_types") 
 t("admin.categories.form.category_transaction_types.select_all") 
 t("admin.categories.form.category_transaction_types.clear_all") 
  icon_tag("information") 
 text 
 
 shapes.each do |shape| 
 checkbox_id = "listing_shape_checkbox_#{shape[:id].to_s}" 
 check_box_tag "category[listing_shapes][][listing_shape_id]", "#{shape[:id]}", selected_shape_ids.include?(shape[:id]), :id => checkbox_id, :class => "category-listing-shape-checkbox" 
 label_tag checkbox_id, t(shape[:name_tr_key]), :class => "category-listing-shape-checkbox-label" 
 end 
 else 
 hidden_field_tag "category[listing_shapes][][listing_shape_id]", shapes.first[:id] 
 end 
 
  form.button t(".save") 
 admin_categories_path 
 t(".cancel") 
 
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
  end

  def order
    sort_priorities = params[:order]
                      .reject { |o| !o.match /[0-9]+/} #Guard against sql injection
                      .each_with_index
                      .map do |category_id, index|
      [category_id, index]
    end.inject({}) do |hash, ids|
      category_id, sort_priority = ids
      hash.merge(category_id.to_i => sort_priority)
    end

    #Guard against updates to wrong communities
    category_ids = @current_community.categories.pluck(:id)
    to_update = sort_priorities.select { |id, _| category_ids.include?(id) }

    # Optimize for marketplaces with large number of categories to sort
    ActiveRecord::Base.connection.execute(order_sql(to_update))

    render nothing: true, status: 200
  end

  # Remove form
  def remove
    @selected_left_navi_link = "listing_categories"
    @category = @current_community.categories.find_by_url_or_id(params[:id])
    @possible_merge_targets = Admin::CategoryService.merge_targets_for(@current_community.categories, @category)
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
 t("layouts.admin.admin") 
 "-" 
 t(".remove_category") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("layouts.admin.admin") 
 "-" 
 t(".remove_category") 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 icon_class 
 flash[announcement] 
 end 
 end 
 
  
  grouped_links = links.group_by {|l| l[:topic]} 
  APP_CONFIG.uservoice_widget_url 
 @current_user.confirmed_notification_email_to 
 @current_user.full_name 
 @current_user.id 
 @current_user.created_at.to_time.to_i
 @current_community.id 
 @current_community.full_url 
 @current_community.created_at.to_time.to_i 
 @current_plan[:plan_level] 
 ( @current_community.created_at < 10.days.ago ? "UserVoice.push(['autoprompt', {}]);".html_safe : "//no autoprompt yet for this site") 
 
 sel_link = (local_assigns.has_key? :selected_left_navi_link) ? selected_left_navi_link : @selected_left_navi_link 
 t("admin.left_hand_navigation.general") 
 grouped_links[:general].each do |link| 
 link[:data_uv_trigger] 
 link[:path] 
 link[:id] 
 link[:text] 
 link[:icon_class] 
 link[:text] 
 end 
 t("admin.left_hand_navigation.users_and_transactions") 
 grouped_links[:manage].each do |link| 
 link[:path] 
 link[:id] 
 link[:text] 
 link[:icon_class] 
 link[:text] 
 end 
 t("admin.left_hand_navigation.configure") 
 grouped_links[:configure].each do |link| 
 link[:path] 
 link[:id] 
 link[:text] 
 link[:icon_class] 
 link[:text] 
 end 
 links.each do |link| 
 if link[:name].eql?(sel_link) 
 link[:icon_class] 
 link[:text] 
 end 
 end 
 links.each do |link| 
 link[:icon_class] 
 link[:text] 
 end 
 
 t('.remove_category_name', category_name: @category.display_name(I18n.locale)) 
 icon_tag("alert", ["icon-fix"]) 
 t('.warning_remove_effects', category_name: @category.display_name(I18n.locale)) 
 prefix = @category.has_subcategories? ? '.warning_with_subcategories_' : '.warning_' 
 if @category.has_subcategories? 
 count = @category.subcategories.count 
 t('.warning_subcategory_will_be_removed', count: count) 
 end 
 if @category.has_own_or_subcategory_listings? 
 count = @category.own_and_subcategory_listings.count 
 t(prefix + 'listing_will_be_moved', count: count) 
 end 
 if @category.has_own_or_subcategory_custom_fields? 
 count = @category.own_and_subcategory_custom_fields.count 
 t(prefix + 'custom_field_will_be_moved', count: count) 
 end 
 form_tag('destroy_and_move', :method => :delete) do 
 if @category.has_own_or_subcategory_listings? || @category.has_own_or_subcategory_custom_fields? 
 t('.select_new_category') 
 select_tag "new_category", options_for_select(@possible_merge_targets.collect { |c| [c.display_name(I18n.locale), c.id] }) 
 end 
 button_tag t(".buttons.remove"), :class => "delete-button" 
 admin_categories_path 
 t(".buttons.cancel") 
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

  # Remove action
  def destroy
    @category = @current_community.categories.find_by_url_or_id(params[:id])
    @category.destroy
    redirect_to admin_categories_path
  end

  def destroy_and_move
    @category = @current_community.categories.find_by_url_or_id(params[:id])
    new_category = @current_community.categories.find_by_url_or_id(params[:new_category])

    if new_category
      # Move listings
      @category.own_and_subcategory_listings.update_all(:category_id => new_category.id)

      # Move custom fields
      Admin::CategoryService.move_custom_fields!(@category, new_category)
    end

    @category.destroy

    redirect_to admin_categories_path
  end

  private

  ##
  # Builds the following for category ids and corresponding priorities:
  # UPDATE categories
  #    SET sort_priority = CASE id
  #                          WHEN 1 THEN 0
  #                          WHEN 2 THEN 1
  #                            .
  #                            .
  #                            .
  #                       END
  #  WHERE id IN(1, 2, ...);
  ##
  def order_sql(sort_priorities)
    base = "UPDATE categories
              SET sort_priority = CASE id\n"

    update_statements = sort_priorities.reduce(base) do |sql, (cat_id, priority)|
      sql + "WHEN #{cat_id} THEN #{priority}\n"
    end

    update_statements + "END\n WHERE id IN (#{sort_priorities.keys.join(",")});"
  end

  def update_category_listing_shapes(shape_ids, category)
    shapes = ListingService::API::Api.shapes.get(community_id: @current_community.id)[:data]
    selected_shapes = shapes.select { |s| shape_ids.include? s[:id] }

    raise ArgumentError.new("No shapes selected for category #{category.id}, shape_ids: #{shape_ids}") if selected_shapes.empty?

    CategoryListingShape.delete_all(category_id: category.id)

    selected_shapes.each { |s|
      CategoryListingShape.create!(category_id: category.id, listing_shape_id: s[:id])
    }
  end

  def shape_ids_from_params(params)
    params[:category][:listing_shapes].map { |s_param| s_param[:listing_shape_id].to_i }
  end

  def get_shapes
    ListingService::API::Api.shapes.get(community_id: @current_community.id).maybe.or_else(nil).tap { |shapes|
      raise ArgumentError.new("Cannot find any shapes for community #{@current_community.id}") if shapes.nil?
    }
  end

end

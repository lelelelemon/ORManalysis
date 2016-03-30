class Admin::CommunityCustomizationsController < ApplicationController
  before_filter :ensure_is_admin

  def edit_details
    @selected_left_navi_link = "tribe_details"
    # @community_customization is fetched in application_controller
    @community_customizations ||= find_or_initialize_customizations(@current_community.locales)
    all_locales = MarketplaceService::API::Marketplaces.all_locales.map { |l|
      {locale_key: l[:locale_key], translated_name: t("admin.communities.available_languages.#{l[:locale_key]}")}
    }.sort_by { |l| l[:translated_name] }
    enabled_locale_keys = available_locales.map(&:second)

    @show_transaction_agreement = TransactionService::API::Api.processes.get(community_id: @current_community.id)
      .maybe
      .map { |data| has_preauthorize_process?(data) }
      .or_else(nil).tap { |p| raise ArgumentError.new("Cannot find transaction process: #{opts}") if p.nil? }
    render locals: {
      locale_selection_locals: { all_locales: all_locales, enabled_locale_keys: enabled_locale_keys, unofficial_locales: unofficial_locales }
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
 t("layouts.admin.admin") 
 "-" 
 t("admin.communities.edit_details.community_details") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("layouts.admin.admin") 
 "-" 
 t("admin.communities.edit_details.community_details") 
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
 
 t("admin.communities.edit_details.edit_community", :community_name => @current_community.name(I18n.locale)) 
 form_tag update_details_admin_community_path(@current_community), method: :put, id: "edit_community" do |form| 
  t("admin.communities.edit_details.enabled_languages") 
 if unofficial_locales.blank? 
 content_for :extra_javascript do 
 end 
  icon_tag("information") 
 text 
 
 true 
 all_locales.each do |locale| 
 locale[:locale_key] 
 locale[:translated_name] 
 end 
 t("admin.communities.edit_details.default_language") + ": " 
 t("admin.communities.available_languages.#{enabled_locale_keys.first}") 
 else 
  icon_tag("information") 
 text 
 
 end 
 
  # locals:  header, available_locales, input_name, translations, info_text 
 if header.present? 
 header 
 end 
  icon_tag("information") 
 text 
 
 translations.each do |language_key, value| 
 if translations.size > 1 
 label_tag "community_customizations[#{language_key}][#{input_name}]", value[:language], class: input_classes + ' label' 
 end 
 text_field_tag "community_customizations[#{language_key}][#{input_name}]", value[:translation], class: input_classes 
 end 
 
  # locals:  header, available_locales, input_name, translations, info_text 
 if header.present? 
 header 
 end 
  icon_tag("information") 
 text 
 
 translations.each do |language_key, value| 
 if translations.size > 1 
 label_tag "community_customizations[#{language_key}][#{input_name}]", value[:language], class: input_classes + ' label' 
 end 
 text_field_tag "community_customizations[#{language_key}][#{input_name}]", value[:translation], class: input_classes 
 end 
 
  # locals:  header, available_locales, input_name, translations, info_text 
 if header.present? 
 header 
 end 
  icon_tag("information") 
 text 
 
 translations.each do |language_key, value| 
 if translations.size > 1 
 label_tag "community_customizations[#{language_key}][#{input_name}]", value[:language], class: input_classes + ' label' 
 end 
 text_field_tag "community_customizations[#{language_key}][#{input_name}]", value[:translation], class: input_classes 
 end 
 
  # locals:  header, available_locales, input_name, translations, info_text 
 if header.present? 
 header 
 end 
  icon_tag("information") 
 text 
 
 translations.each do |language_key, value| 
 if translations.size > 1 
 label_tag "community_customizations[#{language_key}][#{input_name}]", value[:language], class: input_classes + ' label' 
 end 
 text_field_tag "community_customizations[#{language_key}][#{input_name}]", value[:translation], class: input_classes 
 end 
 
 if @show_transaction_agreement 
 label_tag "transaction_label", t("admin.communities.edit_details.transaction_agreement"), class: "input" 
 check_box_tag "community[transaction_agreement_checkbox]", @current_community.transaction_agreement_in_use?, @current_community.transaction_agreement_in_use?, class: "checkbox-row-checkbox" 
 label_tag "community[transaction_agreement_checkbox]", t("admin.communities.edit_details.transaction_agreement_checkbox"), class:"checkbox-row-label" 
  # locals:  header, available_locales, input_name, translations, info_text 
 if header.present? 
 header 
 end 
  icon_tag("information") 
 text 
 
 translations.each do |language_key, value| 
 if translations.size > 1 
 label_tag "community_customizations[#{language_key}][#{input_name}]", value[:language], class: input_classes + ' label' 
 end 
 text_field_tag "community_customizations[#{language_key}][#{input_name}]", value[:translation], class: input_classes 
 end 
 
  # locals:  translations, input_name, info_text, input_classes 
 header 
  icon_tag("information") 
 text 
 
 translations.each do |language_key, value| 
 if translations.size > 1 
 label_tag "community_customizations[#{language_key}][#{input_name}]", value[:language], class: input_classes + ' label' 
 end 
 text_area_tag "community_customizations[#{language_key}][#{input_name}]", value[:translation], class: input_classes 
 end 
 
 end 
 button_tag t("admin.communities.edit_details.save") 
 end 
  render :layout => "layouts/lightbox", locals: {id: field, field: field} do 
 unless field.eql?("terms") 
 t("people.help_texts.#{field}_title") 
 end 
 render :partial => "people/help_texts/#{field}" 
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

  def update_details
    updates_successful = @current_community.locales.map do |locale|
      permitted_params = [
        :name,
        :slogan,
        :description,
        :search_placeholder,
        :transaction_agreement_label,
        :transaction_agreement_content
      ]
      params.require(:community_customizations).require(locale).permit(*permitted_params)
      locale_params = params[:community_customizations][locale]
      customizations = find_or_initialize_customizations_for_locale(locale)
      customizations.update_attributes(locale_params)
    end

    process_locales = unofficial_locales.blank?

    if process_locales
      enabled_locales = params[:enabled_locales]
      all_locales = MarketplaceService::API::Marketplaces.all_locales.map{|l| l[:locale_key]}.to_set
      enabled_locales_valid = enabled_locales.present? && enabled_locales.map{ |locale| all_locales.include? locale }.all?
      if enabled_locales_valid
        MarketplaceService::API::Marketplaces.set_locales(@current_community, enabled_locales)
      end
    end

    transaction_agreement_checked = Maybe(params)[:community][:transaction_agreement_checkbox].is_some?
    community_update_successful = @current_community.update_attributes(transaction_agreement_in_use: transaction_agreement_checked)

    if updates_successful.all? && community_update_successful && (!process_locales || enabled_locales_valid)
      flash[:notice] = t("layouts.notifications.community_updated")
    else
      flash[:error] = t("layouts.notifications.community_update_failed")
    end

    redirect_to edit_details_admin_community_path(@current_community)
  end

  private

  def find_or_initialize_customizations(locales)
    locales.inject({}) do |customizations, locale|
      customizations[locale] = find_or_initialize_customizations_for_locale(locale)
      customizations
    end
  end

  def find_or_initialize_customizations_for_locale(locale)
    @current_community.community_customizations.find_by_locale(locale) || build_customization_with_defaults(locale)
  end

  def build_customization_with_defaults(locale)
    @current_community.community_customizations.build(
      slogan: @current_community.slogan,
      description: @current_community.description,
      search_placeholder: t("homepage.index.what_do_you_need", locale: locale),
      locale: locale
    )
  end

  def unofficial_locales
    all_locales = MarketplaceService::API::Marketplaces.all_locales.map{|l| l[:locale_key]}
    @current_community.locales.select { |locale| !all_locales.include?(locale) }
      .map { |unsupported_locale_key|
        unsupported_locale_name = Sharetribe::AVAILABLE_LOCALES.select { |l| l[:ident] == unsupported_locale_key }.map { |l| l[:name] }.first
        {key: unsupported_locale_key, name: unsupported_locale_name}
      }
  end

  def has_preauthorize_process?(processes)
    processes.any? { |p| p[:process] == :preauthorize }
  end

end

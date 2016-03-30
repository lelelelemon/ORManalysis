class CheckoutAccountsController < ApplicationController
  before_filter do |controller|
    controller.ensure_logged_in "You need to be logged in in order to change payment details."
  end

  CheckoutAccountForm = FormUtils.define_form("CheckoutAccountForm", :company_id_or_personal_id, :organization_address, :phone_number, :organization_website)
    .with_validations do
      validates_presence_of :organization_address, :phone_number
      validates_format_of :company_id_or_personal_id, with: /^(\d{7}\-\d)$|^(\d{6}\D\d{3}\w)$/, allow_nil: false
    end

  def new
    redirect_to action: :show and return if @current_user.checkout_account

    @selected_left_navi_link = "payments"
    render(locals: { checkout_account: CheckoutAccountForm.new({ phone_number: @current_user.phone_number }),
                     form_action: person_checkout_account_path(@current_user) })
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
 
  links.each do |link| 
 link[:path] 
 link[:id] 
 link[:text] 
 link[:icon_class] 
 link[:text] 
 end 
 links.each do |link| 
 if link[:name].eql?(@selected_left_navi_link) 
 link[:icon_class] 
 link[:text] 
 end 
 end 
 links.each do |link| 
 link[:icon_class] 
 link[:text] 
 end 
 
 content_for :javascript do 
 end 
 t("organizations.form.merhcant_registration_detailed_instructions", locale: :fi).html_safe 
 form_for checkout_account, url: form_action, :html => { :id => "payment_settings_form"} do |form| 
 hidden_field_tag :payment_settings, true 
 form.label :company_id_or_personal_id, t("organizations.form.company_id_or_personal_id", locale: :fi), :class => "input" 
 form.text_field :company_id_or_personal_id, :class => :text_field, :maxlenght => "11" 
 form.label :organization_address, t("organizations.form.organization_address", locale: :fi), :class => "input" 
 form.text_field :organization_address, :class => :text_field 
 form.label :phone_number, t("organizations.form.phone_number", locale: :fi) 
 form.text_field :phone_number, :class => "text_field", :maxlength => "25" 
 form.label :organization_website, t("organizations.form.organization_website", locale: :fi), :class => "input" 
 form.text_field :organization_website, :class => :text_field 
 form.button t("settings.save_information", locale: :fi), :class => "send_button" 
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

  def show
    redirect_to action: :new and return unless @current_user.checkout_account

    @selected_left_navi_link = "payments"
    render(locals: {person: @current_user})
  end

  def create
    checkout_account_form = CheckoutAccountForm.new(params[:checkout_account_form])

    if checkout_account_form.valid?
      payment_gateway = @current_community.payment_gateway
      # If updating payout details, check that they are valid
      registering_successful = payment_gateway.register_payout_details(@current_user, checkout_account_form)
      redirect_to action: :show
    else
      flash[:error] = checkout_account_form.errors.full_messages
      render(:new, locals: { checkout_account: checkout_account_form, form_action: person_checkout_account_path(@current_user) })
    end
  end
end

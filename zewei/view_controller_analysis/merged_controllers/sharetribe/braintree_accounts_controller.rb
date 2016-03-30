class BraintreeAccountsController < ApplicationController

  LIST_OF_STATES = [
      ['Alabama', 'AL'],
      ['Alaska', 'AK'],
      ['Arizona', 'AZ'],
      ['Arkansas', 'AR'],
      ['California', 'CA'],
      ['Colorado', 'CO'],
      ['Connecticut', 'CT'],
      ['Delaware', 'DE'],
      ['District of Columbia', 'DC'],
      ['Florida', 'FL'],
      ['Georgia', 'GA'],
      ['Hawaii', 'HI'],
      ['Idaho', 'ID'],
      ['Illinois', 'IL'],
      ['Indiana', 'IN'],
      ['Iowa', 'IA'],
      ['Kansas', 'KS'],
      ['Kentucky', 'KY'],
      ['Louisiana', 'LA'],
      ['Maine', 'ME'],
      ['Maryland', 'MD'],
      ['Massachusetts', 'MA'],
      ['Michigan', 'MI'],
      ['Minnesota', 'MN'],
      ['Mississippi', 'MS'],
      ['Missouri', 'MO'],
      ['Montana', 'MT'],
      ['Nebraska', 'NE'],
      ['Nevada', 'NV'],
      ['New Hampshire', 'NH'],
      ['New Jersey', 'NJ'],
      ['New Mexico', 'NM'],
      ['New York', 'NY'],
      ['North Carolina', 'NC'],
      ['North Dakota', 'ND'],
      ['Ohio', 'OH'],
      ['Oklahoma', 'OK'],
      ['Oregon', 'OR'],
      ['Pennsylvania', 'PA'],
      ['Puerto Rico', 'PR'],
      ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'],
      ['South Dakota', 'SD'],
      ['Tennessee', 'TN'],
      ['Texas', 'TX'],
      ['Utah', 'UT'],
      ['Vermont', 'VT'],
      ['Virginia', 'VA'],
      ['Washington', 'WA'],
      ['West Virginia', 'WV'],
      ['Wisconsin', 'WI'],
      ['Wyoming', 'WY']
    ]

  before_filter do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_change_payment_settings")
  end

  # Commonly used paths
  before_filter do |controller|
    @create_path = create_braintree_settings_payment_path(@current_user)
    @show_path = show_braintree_settings_payment_path(@current_user)
    @new_path = new_braintree_settings_payment_path(@current_user)
  end

  # New/create
  before_filter :ensure_user_does_not_have_account, :only => [:new, :create]

  before_filter :ensure_user_does_not_have_account_for_another_community

  def new
    redirect_to action: :show and return if @current_user.braintree_account

    @list_of_states = LIST_OF_STATES
    @braintree_account = create_new_account_object
    render locals: { form_action: @create_path }
  end

  def show
    redirect_to action: :new and return unless @current_user.braintree_account

    @list_of_states = LIST_OF_STATES
    @braintree_account = BraintreeAccount.find_by_person_id(@current_user.id)
    @state_name, _ = LIST_OF_STATES.find do |state|
      name, code = state
      code == @braintree_account.address_region
    end

    render locals: { form_action: @create_path }
  end

  def create
    @list_of_states = LIST_OF_STATES
    braintree_params = params[:braintree_account]
      .merge(person: @current_user)
      .merge(community_id: @current_community.id)
      .merge(hidden_account_number: StringUtils.trim_and_hide(params[:braintree_account][:account_number]))

    @braintree_account = BraintreeAccount.new(braintree_params)
    if @braintree_account.valid?
      # Save Braintree account before calling the Braintree API
      # Braintree may trigger the webhook very, very fast (at least in sandbox)
      # and saving account to DB now ensures that the webhook finds the account
      @braintree_account.save!
      merchant_account_result = BraintreeApi.create_merchant_account(@braintree_account, @current_community)
    else
      flash[:error] = @braintree_account.errors.full_messages
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
 
 content_for :javascript do 
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
 
 t(".add_payout_details") 
 form_for @braintree_account, :url => form_action, :html => { :id => "braintree_account_form"} do |form| 
 form.label :first_name, t(".first_name"), :class => "input" 
 form.text_field :first_name, :class => "auto_width", :size => 30 
 form.label :last_name, t(".last_name"), :class => "input" 
 form.text_field :last_name, :class => "auto_width", :size => 30 
 form.label :email, t(".email"), :class => "input" 
 form.text_field :email, :class => "auto_width", :size => 30 
 form.label :phone, t(".phone"), :class => "input" 
 form.text_field :phone, :class => "auto_width", :size => 30 
 form.label :address_street_address, t(".address_street_address"), :class => "input" 
 form.text_field :address_street_address, :class => "auto_width", :size => 30 
 form.label :address_postal_code, t(".address_postal_code"), :class => "input" 
 form.text_field :address_postal_code, :class => "auto_width", :size => 6 
 form.label :address_locality, t(".address_locality"), :class => "input" 
 form.text_field :address_locality, :class => "auto_width", :size => 20 
 form.label :address_region, t(".address_region"), :class => "input" 
 form.select :address_region, @list_of_states 
 form.label :date_of_birth, t(".date_of_birth"), :class => "input" 
 form.date_select :date_of_birth, {:start_year => Time.now.year - 12, :end_year => Time.now.year - 100, :default => 12.years.from_now} 
 form.label :routing_number, t(".routing_number"), :class => "input" 
 form.text_field :routing_number, :class => "auto_width", :size => 9 
 form.label :account_number, t(".account_number"), :class => "input" 
 form.text_field :account_number, :class => "auto_width", :size => 17 
  icon_tag("information") 
 text 
 
 form.button t(".save"), :class => "send_button" 
 end 
 link_to "https://www.braintreepayments.com/" do 
 image_tag("payments/braintree-logo-2x.png", height: '32') 
 end 
 "Our secure payment provider" 
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

    success = if merchant_account_result.success?
      BTLog.info("Successfully created Braintree account for person id #{@current_user.id}")
      update_status!(@braintree_account, merchant_account_result.merchant_account.status)
    else
      BTLog.error("Failed to created Braintree account for person id #{@current_user.id}: #{merchant_account_result.message}")

      error_string = "Your payout details could not be saved, because of following errors: "
      merchant_account_result.errors.each do |e|
        error_string << e.message + " "
      end
      flash[:error] = error_string

      @braintree_account.destroy

      false
    end

    if success
      flash[:notice] = t("layouts.notifications.payment_details_add_successful")
      redirect_to @show_path
    else
      flash[:error] ||= t("layouts.notifications.payment_details_add_error")
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
 
 content_for :javascript do 
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
 
 t(".add_payout_details") 
 form_for @braintree_account, :url => form_action, :html => { :id => "braintree_account_form"} do |form| 
 form.label :first_name, t(".first_name"), :class => "input" 
 form.text_field :first_name, :class => "auto_width", :size => 30 
 form.label :last_name, t(".last_name"), :class => "input" 
 form.text_field :last_name, :class => "auto_width", :size => 30 
 form.label :email, t(".email"), :class => "input" 
 form.text_field :email, :class => "auto_width", :size => 30 
 form.label :phone, t(".phone"), :class => "input" 
 form.text_field :phone, :class => "auto_width", :size => 30 
 form.label :address_street_address, t(".address_street_address"), :class => "input" 
 form.text_field :address_street_address, :class => "auto_width", :size => 30 
 form.label :address_postal_code, t(".address_postal_code"), :class => "input" 
 form.text_field :address_postal_code, :class => "auto_width", :size => 6 
 form.label :address_locality, t(".address_locality"), :class => "input" 
 form.text_field :address_locality, :class => "auto_width", :size => 20 
 form.label :address_region, t(".address_region"), :class => "input" 
 form.select :address_region, @list_of_states 
 form.label :date_of_birth, t(".date_of_birth"), :class => "input" 
 form.date_select :date_of_birth, {:start_year => Time.now.year - 12, :end_year => Time.now.year - 100, :default => 12.years.from_now} 
 form.label :routing_number, t(".routing_number"), :class => "input" 
 form.text_field :routing_number, :class => "auto_width", :size => 9 
 form.label :account_number, t(".account_number"), :class => "input" 
 form.text_field :account_number, :class => "auto_width", :size => 17 
  icon_tag("information") 
 text 
 
 form.button t(".save"), :class => "send_button" 
 end 
 link_to "https://www.braintreepayments.com/" do 
 image_tag("payments/braintree-logo-2x.png", height: '32') 
 end 
 "Our secure payment provider" 
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

  private

  # Before filter
  def ensure_user_does_not_have_account
    braintree_account = BraintreeAccount.find_by_person_id(@current_user.id)

    unless braintree_account.blank?
      flash[:error] = "Cannot create a new Braintree account. You already have one"
      redirect_to @show_path
    end
  end

  # Before filter
  # Support for multiple Braintree account in multipe communities
  # is not implemented. Show error.
  def ensure_user_does_not_have_account_for_another_community
    @braintree_account = BraintreeAccount.find_by_person_id(@current_user.id)

    if @braintree_account
      # Braintree account exists
      if @braintree_account.community_id.present? && @braintree_account.community_id != @current_community.id
        # ...but is associated to different community
        account_community = Community.find(@braintree_account.community_id)
        flash[:error] = "You have payment account for community #{account_community.name(I18n.locale)}. Unfortunately, you cannot have payment accounts for multiple communities. You are unable to receive money from transactions in community #{@current_community.name(I18n.locale)}. Please contact administrators."

        error_msg = "User #{@current_user.id} tried to create a Braintree payment account for community #{@current_community.name(I18n.locale)} even though she has existing account for #{account_community.name(I18n.locale)}"
        BTLog.error(error_msg)
        ApplicationHelper.send_error_notification(error_msg, "BraintreePaymentAccountError")
        redirect_to person_settings_path(@current_user)
      end
    end
  end

  # Give `braintree_account` and `new_status` candidate. Update the status, unless the status is already
  # active
  #
  # Background: If the webhook has already update the status to "active", we don't want to change it back
  # to pending. This may happen in sandbox environment, where the webhook is triggered very fast
  def update_status!(braintree_account, new_status)
    braintree_account.reload
    braintree_account.status = new_status if braintree_account.status != "active"
    braintree_account.save!
  end

  def create_new_account_object
    person = @current_user
    person_details = {
      first_name: person.given_name,
      last_name: person.family_name,
      email: person.confirmed_notification_email_to, # Our best guess for "primary" email
      phone: person.phone_number
    }

    BraintreeAccount.new(person_details)
  end
end

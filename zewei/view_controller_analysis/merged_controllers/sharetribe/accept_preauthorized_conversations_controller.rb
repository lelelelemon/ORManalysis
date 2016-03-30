class AcceptPreauthorizedConversationsController < ApplicationController

  before_filter do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_accept_or_reject")
  end

  before_filter :fetch_conversation
  before_filter :fetch_listing

  before_filter :ensure_is_author

  # Skip auth token check as current jQuery doesn't provide it automatically
  skip_before_filter :verify_authenticity_token

  def accept
    tx_id = params[:id]
    tx = TransactionService::API::Api.transactions.query(tx_id)

    if tx[:current_state] != :preauthorized
      redirect_to person_transaction_path(person_id: @current_user.id, id: tx_id)
      return
    end

    payment_type = tx[:payment_gateway]
    case payment_type
    when :braintree
      render_braintree_form("accept")
    when :paypal
      render_paypal_form("accept")
    else
      raise ArgumentError.new("Unknown payment type: #{payment_type}")
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
 t("layouts.no_tribe.inbox") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("layouts.no_tribe.inbox") 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 icon_class 
 flash[announcement] 
 end 
 end 
 
  
 content_for :extra_javascript do 
 end 
 t("conversations.accept.details") 
 link_to_unless listing.deleted?, listing.title, listing 
 if orderer 
 t("conversations.accept.order_by",          orderer_link: link_to_unless(orderer.deleted?, PersonViewUtils.person_display_name(orderer, @current_community), orderer)).html_safe 
 end 
 if booking 
 t("transactions.initiate.price_per_day") 
 humanized_money_with_symbol(listing.price) 
 t("transactions.initiate.booked_days") 
 l booking[:start_on], format: :long_with_abbr_day_name 
 "-" 
 l booking[:end_on], format: :long_with_abbr_day_name 
 "(#{pluralize(booking[:duration], t("listing_conversations.preauthorize.day"), t("listing_conversations.preauthorize.days"))})" 
 elsif listing_quantity > 1 
 t("transactions.price_per_quantity", unit_type: ListingViewUtils.translate_unit(listing.unit_type, listing.unit_tr_key)) 
 humanized_money_with_symbol(listing.price) 
 ListingViewUtils.translate_quantity(listing.unit_type, listing.unit_selector_tr_key) || t("conversations.accept.quantity_label") 
 listing_quantity 
 end 
 t("conversations.accept.sum_label") 
 humanized_money_with_symbol(sum) 
 t("conversations.accept.service_fee_label") 
 "-#{humanized_money_with_symbol(fee)}" 
 if shipping_price 
 t("conversations.accept.shipping_price_label") 
 humanized_money_with_symbol(shipping_price) 
 end 
 if payment_gateway == :paypal 
 t("conversations.accept.total_label") 
 t("conversations.accept.total_value", seller_gets: humanized_money_with_symbol(seller_gets)) 
 else 
 t("conversations.accept.you_will_get_label") 
 humanized_money_with_symbol(seller_gets) 
 end 
 if payment_gateway == :paypal 
 t("conversations.accept.paypal_fee_info", fee_info_link_id: "paypal_fee_info_link").html_safe 
 render layout: "layouts/lightbox", locals: { id: "paypal_fee_info_content"} do 
 t("common.paypal_fee_info.title") 
 text_with_line_breaks_html_safe do 
 link_to_paypal = link_to(t("common.paypal_fee_info.link_to_paypal_text"), paypal_fees_url, target: "_blank") 
 t("common.paypal_fee_info.body_text", link_to_paypal: link_to_paypal).html_safe 
 end 
 end 
 content_for :extra_javascript do 
 end 
 end 
  fields = [:name, :phone, :street1, :street2, :postal_code, :city, :state_or_province, :country] 
 if shipping_address && shipping_address.slice(*fields).values.any? 
 t("shipping_address.shipping_address") 
 fields.map do |field| 
 if shipping_address[field].present? 
 if shipping_address[field] == :name 
 shipping_address[field] 
 else 
 shipping_address[field] 
 end 
 end 
 end 
 end 
 
 form_for form, :url => form_action, :html => { id: "accept-reject-form", :method => "put" } do |form| 
 radio_button_tag "listing_conversation[status]", "paid", preselected_action.eql?("accept"), :id => "accept-link" 
 icon_for("accepted") 
 t("conversations.accept.accept_request") 
 radio_button_tag "listing_conversation[status]", "rejected", preselected_action.eql?("reject"), :id => "reject-link" 
 icon_for("rejected") 
 t("conversations.accept.reject_request") 
 fields_for "listing_conversation[message_attributes]", Message.new do |message_form| 
 message_form.label :content, t("conversations.new.message"), :class => "input" 
 message_form.text_area :content, :class => "text_area", :placeholder => t("conversations.accept.optional_message") 
 message_form.hidden_field :sender_id, :value => @current_user.id 
 end 
 initial_send_label = preselected_action == "accept" ? t('conversations.accept.accept') : t('conversations.accept.decline') 
 form.button initial_send_label, :class => "send_button", :id => "send_testimonial_button" 
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

  def reject
    tx_id = params[:id]
    tx = TransactionService::API::Api.transactions.query(tx_id)

    if tx[:current_state] != :preauthorized
      redirect_to person_transaction_path(person_id: @current_user.id, id: tx_id)
      return
    end

    payment_type = tx[:payment_gateway]
    case payment_type
    when :braintree
      render_braintree_form("reject")
    when :paypal
      render_paypal_form("reject")
    else
      raise ArgumentError.new("Unknown payment type: #{payment_type}")
    end
  end

  def accepted_or_rejected
    tx_id = params[:id]
    message = params[:listing_conversation][:message_attributes][:content]
    status = params[:listing_conversation][:status].to_sym
    sender_id = @current_user.id

    tx = TransactionService::API::Api.transactions.query(tx_id)

    if tx[:current_state] != :preauthorized
      redirect_to person_transaction_path(person_id: @current_user.id, id: tx_id)
      return
    end

    res = accept_or_reject_tx(@current_community.id, tx_id, status, message, sender_id)

    if res[:success]
      flash[:notice] = success_msg(res[:flow])
      redirect_to person_transaction_path(person_id: sender_id, id: tx_id)
    else
      flash[:error] = error_msg(res[:flow])
      redirect_to accept_preauthorized_person_message_path(person_id: sender_id , id: tx_id)
    end
  end

  private

  def accept_or_reject_tx(community_id, tx_id, status, message, sender_id)
    if (status == :paid)
      accept_tx(community_id, tx_id, message, sender_id)
    elsif (status == :rejected)
      reject_tx(community_id, tx_id, message, sender_id)
    else
      {flow: :unknown, success: false}
    end
  end

  def accept_tx(community_id, tx_id, message, sender_id)
    TransactionService::Transaction.complete_preauthorization(community_id: community_id,
                                                              transaction_id: tx_id,
                                                              message: message,
                                                              sender_id: sender_id)
      .maybe()
      .map { |_| {flow: :accept, success: true}}
      .or_else({flow: :accept, success: false})
  end

  def reject_tx(community_id, tx_id, message, sender_id)
    TransactionService::Transaction.reject(community_id: community_id,
                                           transaction_id: tx_id,
                                           message: message,
                                           sender_id: sender_id)
      .maybe()
      .map { |_| {flow: :reject, success: true}}
      .or_else({flow: :reject, success: false})
  end

  def success_msg(flow)
    if flow == :accept
      t("layouts.notifications.request_accepted")
    elsif flow == :reject
      t("layouts.notifications.request_rejected")
    end
  end

  def error_msg(flow)
    if flow == :accept
      t("error_messages.paypal.accept_authorization_error")
    elsif flow == :reject
      t("error_messages.paypal.reject_authorization_error")
    end
  end

  def ensure_is_author
    unless @listing.author == @current_user
      flash[:error] = "Only listing author can perform the requested action"
      redirect_to (session[:return_to_content] || root)
    end
  end

  def fetch_listing
    @listing = @listing_conversation.listing
  end

  def fetch_conversation
    @listing_conversation = @current_community.transactions.find(params[:id])
  end

  def render_paypal_form(preselected_action)
    transaction_conversation = MarketplaceService::Transaction::Query.transaction(@listing_conversation.id)
    result = TransactionService::Transaction.get(community_id: @current_community.id, transaction_id: @listing_conversation.id)
    transaction = result[:data]
    community_country_code = LocalizationUtils.valid_country_code(@current_community.country)

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
 t("layouts.no_tribe.inbox") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("layouts.no_tribe.inbox") 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 icon_class 
 flash[announcement] 
 end 
 end 
 
  
 content_for :extra_javascript do 
 end 
 t("conversations.accept.details") 
 link_to_unless listing.deleted?, listing.title, listing 
 if orderer 
 t("conversations.accept.order_by",          orderer_link: link_to_unless(orderer.deleted?, PersonViewUtils.person_display_name(orderer, @current_community), orderer)).html_safe 
 end 
 if booking 
 t("transactions.initiate.price_per_day") 
 humanized_money_with_symbol(listing.price) 
 t("transactions.initiate.booked_days") 
 l booking[:start_on], format: :long_with_abbr_day_name 
 "-" 
 l booking[:end_on], format: :long_with_abbr_day_name 
 "(#{pluralize(booking[:duration], t("listing_conversations.preauthorize.day"), t("listing_conversations.preauthorize.days"))})" 
 elsif listing_quantity > 1 
 t("transactions.price_per_quantity", unit_type: ListingViewUtils.translate_unit(listing.unit_type, listing.unit_tr_key)) 
 humanized_money_with_symbol(listing.price) 
 ListingViewUtils.translate_quantity(listing.unit_type, listing.unit_selector_tr_key) || t("conversations.accept.quantity_label") 
 listing_quantity 
 end 
 t("conversations.accept.sum_label") 
 humanized_money_with_symbol(sum) 
 t("conversations.accept.service_fee_label") 
 "-#{humanized_money_with_symbol(fee)}" 
 if shipping_price 
 t("conversations.accept.shipping_price_label") 
 humanized_money_with_symbol(shipping_price) 
 end 
 if payment_gateway == :paypal 
 t("conversations.accept.total_label") 
 t("conversations.accept.total_value", seller_gets: humanized_money_with_symbol(seller_gets)) 
 else 
 t("conversations.accept.you_will_get_label") 
 humanized_money_with_symbol(seller_gets) 
 end 
 if payment_gateway == :paypal 
 t("conversations.accept.paypal_fee_info", fee_info_link_id: "paypal_fee_info_link").html_safe 
 render layout: "layouts/lightbox", locals: { id: "paypal_fee_info_content"} do 
 t("common.paypal_fee_info.title") 
 text_with_line_breaks_html_safe do 
 link_to_paypal = link_to(t("common.paypal_fee_info.link_to_paypal_text"), paypal_fees_url, target: "_blank") 
 t("common.paypal_fee_info.body_text", link_to_paypal: link_to_paypal).html_safe 
 end 
 end 
 content_for :extra_javascript do 
 end 
 end 
  fields = [:name, :phone, :street1, :street2, :postal_code, :city, :state_or_province, :country] 
 if shipping_address && shipping_address.slice(*fields).values.any? 
 t("shipping_address.shipping_address") 
 fields.map do |field| 
 if shipping_address[field].present? 
 if shipping_address[field] == :name 
 shipping_address[field] 
 else 
 shipping_address[field] 
 end 
 end 
 end 
 end 
 
 form_for form, :url => form_action, :html => { id: "accept-reject-form", :method => "put" } do |form| 
 radio_button_tag "listing_conversation[status]", "paid", preselected_action.eql?("accept"), :id => "accept-link" 
 icon_for("accepted") 
 t("conversations.accept.accept_request") 
 radio_button_tag "listing_conversation[status]", "rejected", preselected_action.eql?("reject"), :id => "reject-link" 
 icon_for("rejected") 
 t("conversations.accept.reject_request") 
 fields_for "listing_conversation[message_attributes]", Message.new do |message_form| 
 message_form.label :content, t("conversations.new.message"), :class => "input" 
 message_form.text_area :content, :class => "text_area", :placeholder => t("conversations.accept.optional_message") 
 message_form.hidden_field :sender_id, :value => @current_user.id 
 end 
 initial_send_label = preselected_action == "accept" ? t('conversations.accept.accept') : t('conversations.accept.decline') 
 form.button initial_send_label, :class => "send_button", :id => "send_testimonial_button" 
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

  def render_braintree_form(preselected_action)
    result = TransactionService::Transaction.get(community_id: @current_community.id, transaction_id: @listing_conversation.id)
    transaction = result[:data]

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
 t("layouts.no_tribe.inbox") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("layouts.no_tribe.inbox") 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 icon_class 
 flash[announcement] 
 end 
 end 
 
  
 content_for :extra_javascript do 
 end 
 t("conversations.accept.details") 
 link_to_unless listing.deleted?, listing.title, listing 
 if orderer 
 t("conversations.accept.order_by",          orderer_link: link_to_unless(orderer.deleted?, PersonViewUtils.person_display_name(orderer, @current_community), orderer)).html_safe 
 end 
 if booking 
 t("transactions.initiate.price_per_day") 
 humanized_money_with_symbol(listing.price) 
 t("transactions.initiate.booked_days") 
 l booking[:start_on], format: :long_with_abbr_day_name 
 "-" 
 l booking[:end_on], format: :long_with_abbr_day_name 
 "(#{pluralize(booking[:duration], t("listing_conversations.preauthorize.day"), t("listing_conversations.preauthorize.days"))})" 
 elsif listing_quantity > 1 
 t("transactions.price_per_quantity", unit_type: ListingViewUtils.translate_unit(listing.unit_type, listing.unit_tr_key)) 
 humanized_money_with_symbol(listing.price) 
 ListingViewUtils.translate_quantity(listing.unit_type, listing.unit_selector_tr_key) || t("conversations.accept.quantity_label") 
 listing_quantity 
 end 
 t("conversations.accept.sum_label") 
 humanized_money_with_symbol(sum) 
 t("conversations.accept.service_fee_label") 
 "-#{humanized_money_with_symbol(fee)}" 
 if shipping_price 
 t("conversations.accept.shipping_price_label") 
 humanized_money_with_symbol(shipping_price) 
 end 
 if payment_gateway == :paypal 
 t("conversations.accept.total_label") 
 t("conversations.accept.total_value", seller_gets: humanized_money_with_symbol(seller_gets)) 
 else 
 t("conversations.accept.you_will_get_label") 
 humanized_money_with_symbol(seller_gets) 
 end 
 if payment_gateway == :paypal 
 t("conversations.accept.paypal_fee_info", fee_info_link_id: "paypal_fee_info_link").html_safe 
 render layout: "layouts/lightbox", locals: { id: "paypal_fee_info_content"} do 
 t("common.paypal_fee_info.title") 
 text_with_line_breaks_html_safe do 
 link_to_paypal = link_to(t("common.paypal_fee_info.link_to_paypal_text"), paypal_fees_url, target: "_blank") 
 t("common.paypal_fee_info.body_text", link_to_paypal: link_to_paypal).html_safe 
 end 
 end 
 content_for :extra_javascript do 
 end 
 end 
  fields = [:name, :phone, :street1, :street2, :postal_code, :city, :state_or_province, :country] 
 if shipping_address && shipping_address.slice(*fields).values.any? 
 t("shipping_address.shipping_address") 
 fields.map do |field| 
 if shipping_address[field].present? 
 if shipping_address[field] == :name 
 shipping_address[field] 
 else 
 shipping_address[field] 
 end 
 end 
 end 
 end 
 
 form_for form, :url => form_action, :html => { id: "accept-reject-form", :method => "put" } do |form| 
 radio_button_tag "listing_conversation[status]", "paid", preselected_action.eql?("accept"), :id => "accept-link" 
 icon_for("accepted") 
 t("conversations.accept.accept_request") 
 radio_button_tag "listing_conversation[status]", "rejected", preselected_action.eql?("reject"), :id => "reject-link" 
 icon_for("rejected") 
 t("conversations.accept.reject_request") 
 fields_for "listing_conversation[message_attributes]", Message.new do |message_form| 
 message_form.label :content, t("conversations.new.message"), :class => "input" 
 message_form.text_area :content, :class => "text_area", :placeholder => t("conversations.accept.optional_message") 
 message_form.hidden_field :sender_id, :value => @current_user.id 
 end 
 initial_send_label = preselected_action == "accept" ? t('conversations.accept.accept') : t('conversations.accept.decline') 
 form.button initial_send_label, :class => "send_button", :id => "send_testimonial_button" 
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

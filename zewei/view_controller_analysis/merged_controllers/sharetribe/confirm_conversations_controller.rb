class ConfirmConversationsController < ApplicationController

  before_filter do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_confirm_or_cancel")
  end

  before_filter :fetch_conversation
  before_filter :fetch_listing

  before_filter :ensure_is_starter

  MessageForm = Form::Message

  def confirm
    unless in_valid_pre_state(@listing_transaction)
      return redirect_to person_transaction_path(person_id: @current_user.id, message_id: @listing_transaction.id)
    end

    conversation =      MarketplaceService::Conversation::Query.conversation_for_person(@listing_transaction.conversation.id, @current_user.id, @current_community.id)
    can_be_confirmed =  MarketplaceService::Transaction::Query.can_transition_to?(@listing_transaction, :confirmed)
    other_person =      query_person_entity(@listing_transaction.other_party(@current_user).id)

    render(locals: {
      action_type: "confirm",
      message_form: MessageForm.new,
      listing_transaction: @listing_transaction,
      can_be_confirmed: can_be_confirmed,
      other_person: other_person,
      status: @listing_transaction.status,
      form: @listing_transaction # TODO fix me, don't pass objects
    })
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
 
 content_for :javascript do 
 end 
  
 form_for form, :url => confirmation_person_message_path(:person_id => @current_user.id, :id => listing_transaction[:id]), :html => { :method => "put" } do |form| 
 if can_be_confirmed 
 ["confirm", "cancel"].each do |action| 
 radio_button_tag "status", action, action_type.eql?(action), :id => "action-#{action}" 
 t("conversations.confirm.#{action}") 
 end 
 ["confirm", "cancel"].each do |action| 
 t("conversations.confirm.#{action}_description") 
 end 
 form.hidden_field :status, :value => "#{action_type}ed" 
 else 
 t("conversations.confirm.canceling_payed_transaction") 
 t("conversations.confirm.cancel_payed_description") 
 fields_for :message, message_form do |message_form| 
 message_form.label :content, t("conversations.new.message"), :class => "input" 
 message_form.text_area :content, :class => "text_area", :placeholder => t("conversations.accept.optional_message") 
 end 
 form.hidden_field :status, :value => "canceled" 
 end 
 if @current_community.testimonials_in_use 
 radio_button_tag "give_feedback", true, true, :id => "do_give_feedback" 
 label_tag "do_give_feedback", t("conversations.confirm.give_feedback_to", :person_link => link_to(other_person[:display_name], person_path(other_person[:username]))).html_safe, :class => "radio" 
 radio_button_tag "give_feedback", false, false, :id => "do_not_give_feedback" 
 label_tag "do_not_give_feedback", t("conversations.confirm.do_not_give_feedback"), :class => "radio" 
 end 
 form.button t("conversations.confirm.continue"), :class => "send_button", :id => "send_testimonial_button" 
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

  def cancel
    unless in_valid_pre_state(@listing_transaction)
      return redirect_to person_transaction_path(person_id: @current_user.id, message_id: @listing_transaction.id)
    end

    conversation =      MarketplaceService::Conversation::Query.conversation_for_person(@listing_transaction.conversation.id, @current_user.id, @current_community.id)
    can_be_confirmed =  MarketplaceService::Transaction::Query.can_transition_to?(@listing_transaction.id, :confirmed)
    other_person =      query_person_entity(@listing_transaction.other_party(@current_user).id)

    render(:confirm, locals: {
      action_type: "cancel",
      message_form: MessageForm.new,
      listing_transaction: @listing_transaction,
      can_be_confirmed: can_be_confirmed,
      other_person: other_person,
      status: @listing_transaction.status,
      form: @listing_transaction # TODO fix me, don't pass objects
    })
  end

  # Handles confirm and cancel forms
  def confirmation
    status = params[:transaction][:status].to_sym

    if !MarketplaceService::Transaction::Query.can_transition_to?(@listing_transaction.id, status)
      flash[:error] = t("layouts.notifications.something_went_wrong")
      return redirect_to person_transaction_path(person_id: @current_user.id, message_id: @listing_transaction.id)
    end


    msg, sender_id = parse_message_param()
    transaction = complete_or_cancel_tx(@current_community.id, @listing_transaction.id, status, msg, sender_id)

    give_feedback = Maybe(params)[:give_feedback].select { |v| v == "true" }.or_else { false }

    confirmation = ConfirmConversation.new(@listing_transaction, @current_user, @current_community)
    confirmation.update_participation(give_feedback)

    flash[:notice] = t("layouts.notifications.offer_#{status}")

    redirect_path =
      if give_feedback
        new_person_message_feedback_path(:person_id => @current_user.id, :message_id => @listing_transaction.id)
      else
        person_transaction_path(:person_id => @current_user.id, :id => @listing_transaction.id)
      end

    redirect_to redirect_path
  end

  private


  def complete_or_cancel_tx(community_id, tx_id, status, msg, sender_id)
    if status == :confirmed
      TransactionService::Transaction.complete(community_id: community_id, transaction_id: tx_id, message: msg, sender_id: sender_id)
    else
      TransactionService::Transaction.cancel(community_id: community_id, transaction_id: tx_id, message: msg, sender_id: sender_id)
    end
  end

  def parse_message_param
    if(params[:message])
      message = MessageForm.new(params[:message].merge({ sender_id: @current_user.id, conversation_id: @listing_transaction.conversation.id }))
      if(message.valid?)
        [message.content, message.sender_id]
      end
    end
  end

  def ensure_is_starter
    unless @listing_transaction.starter == @current_user
      flash[:error] = "Only listing starter can perform the requested action"
      redirect_to (session[:return_to_content] || root)
    end
  end

  def fetch_listing
    @listing = @listing_transaction.listing
  end

  def fetch_conversation
    @listing_transaction = @current_community.transactions.find(params[:id])
  end

  def in_valid_pre_state(transaction)
    transaction.can_be_confirmed? || transaction.can_be_canceled?
  end

  def query_person_entity(id)
    person_entity = MarketplaceService::Person::Query.person(id, @current_community.id)
    person_display_entity = person_entity.merge(
      display_name: PersonViewUtils.person_entity_display_name(person_entity, @current_community.name_display_type)
    )
  end
end

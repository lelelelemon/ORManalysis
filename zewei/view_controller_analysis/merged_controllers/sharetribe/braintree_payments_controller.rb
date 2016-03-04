class BraintreePaymentsController < ApplicationController

  before_filter :fetch_conversation
  before_filter :ensure_not_paid_already
  before_filter :payment_can_be_conducted

  before_filter do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_view_your_inbox")
  end

  before_filter :ensure_recipient_does_not_have_account_for_another_community

  # This expects that each conversation already has a (pending) payment at this point
  def edit
    @conversation = Transaction.find(params[:message_id])
    @braintree_payment = @conversation.payment
    community_payment_gateway = @current_community.payment_gateway
    @braintree_client_side_encryption_key = community_payment_gateway.braintree_client_side_encryption_key
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
   if APP_CONFIG.use_kissmetrics 
 "_kms('//i.kissmetrics.com/i.js');_kms('#{APP_CONFIG.kissmetrics_url}');" 
 if @current_user 
 "_kmq.push(['identify', '#{@current_user.id}']);" 
 end 
 if @current_community 
 "_kmq.push(['set', {'SiteName' : '#{@current_community.ident}'}]);" 
 else 
 "_kmq.push(['set', {'SiteName' : 'dashboard'}]);" 
 end 
 end 
 
 I18n.locale 
 content_for :head 
  
 
  
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
 announcement.to_s 
 icon_class 
 flash[announcement] 
 end 
 end 
 
  content_for :extra_javascript do 
 javascript_include_tag "https://js.braintreegateway.com/v1/braintree.js" 
 end 
 content_for :extra_javascript do 
 end 
 content_for :title_header do 
 t(".new_credit_card_payment") 
 end 
 payment_receiver = @conversation.payment_receiver 
 t(".payment_receiver") 
 "#{link_to payment_receiver.name(@current_community), payment_receiver}".html_safe 
 "#{t("payments.form.product")}" 
 link_to "#{@conversation.listing.title}", @conversation.listing 
 "#{t("payments.form.price")}" 
 humanized_money_with_symbol(@braintree_payment.sum) 
 form_for @braintree_payment,    :url => person_message_braintree_payment_path(@current_user.id,      @conversation.id,      @braintree_payment.id),      :html => { :id => "braintree-payment-form", :class => "hidden" } do |form| 
  fields_for :braintree_payment, braintree_form do |form| 
 form.text_field :cardholder_name, :class => :text_field, :placeholder => t("braintree_payments.edit.cardholder_name"), :data => { :'encrypted-name' => "braintree_payment[cardholder_name]" } 
 form.text_field :credit_card_number, :class => :text_field, :placeholder => t("braintree_payments.edit.credit_card_number"), :data => { :'encrypted-name' => "braintree_payment[credit_card_number]"} 
 form.text_field :cvv, :class => :text_field, :maxlength => 4, :placeholder => t("braintree_payments.edit.cvv"), :data => { :'encrypted-name' => "braintree_payment[cvv]"} 
 form.label :credit_card_expiration_month, t("braintree_payments.edit.exp"), :class => "preauthorize-exp" 
 form.select :credit_card_expiration_month, options_for_select(credit_card_expiration_month_options), {}, data: { "encrypted-name" => "braintree_payment[credit_card_expiration_month]" } 
 " / " 
 form.select :credit_card_expiration_year, options_for_select(credit_card_expiration_year_options), {}, data: { "encrypted-name" => "braintree_payment[credit_card_expiration_year]" } 
 end 
 
 end 
 "For security reasons JavaScript has to be enabled" 
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
 "_gaq.push(['b._addIgnoredOrganic', '#{@current_community.domain || @current_community.ident}']);" 
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
    payment = @braintree_payment
    braintree_form = Form::Braintree.new(params[:braintree_payment])
    result = BraintreeSaleService.new(payment, braintree_form.to_hash).pay(true)

    recipient = payment.recipient
    if result.success?
      MarketplaceService::Transaction::Command.transition_to(@conversation.id, "paid")
      redirect_to person_transaction_path(:id => params[:message_id])
    else
      flash[:error] = result.message
      redirect_to :edit_person_message_braintree_payment
    end
  end

  private

  # Before filter
  #
  # Support for multiple Braintree account in multipe communities
  # is not implemented. Show error.
  def ensure_recipient_does_not_have_account_for_another_community
    @braintree_account = BraintreeAccount.find_by_person_id(@braintree_payment.recipient_id)

    if @braintree_account
      # Braintree account exists
      if @braintree_account.community_id.present? && @braintree_account.community_id != @current_community.id
        # ...but is associated to different community
        account_community = Community.find(@braintree_account.community_id)
        flash[:error] = "Unfortunately, we cannot proceed with the payment. Please contact the administrators."

        error_msg = "User #{@current_user.id} tries to pay for user #{@braintree_payment.recipient_id} which has Braintree account for another community #{account_community.name(I18n.locale)}"
        BTLog.error(error_msg)
        ApplicationHelper.send_error_notification(error_msg, "BraintreePaymentAccountError")
        redirect_to person_transaction_path(@current_user, @conversation)
      end
    end
  end

  # Before filter
  def fetch_conversation
    @conversation = Transaction.find(params[:message_id])
    @braintree_payment = @conversation.payment
  end

  # Before filter
  def ensure_not_paid_already
    if @conversation.payment.status != "pending"
      flash[:error] = "Could not find pending payment. It might be the payment is paid already."
      redirect_to person_transaction_path(@current_user, @conversation) and return
    end
  end

  def payment_can_be_conducted
    redirect_to person_transaction_path(@current_user, @conversation) unless @conversation.requires_payment?(@current_community)
  end
end

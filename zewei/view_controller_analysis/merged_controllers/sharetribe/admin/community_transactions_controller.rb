require 'csv'

class Admin::CommunityTransactionsController < ApplicationController
  TransactionQuery = MarketplaceService::Transaction::Query
  before_filter :ensure_is_admin

  def index
    @selected_left_navi_link = "transactions"
    pagination_opts = PaginationViewUtils.parse_pagination_opts(params)

    conversations = if params[:sort].nil? || params[:sort] == "last_activity"
      TransactionQuery.transactions_for_community_sorted_by_activity(
        @current_community.id,
        sort_direction,
        pagination_opts[:limit],
        pagination_opts[:offset])
    else
      TransactionQuery.transactions_for_community_sorted_by_column(
        @current_community.id,
        simple_sort_column(params[:sort]),
        sort_direction,
        pagination_opts[:limit],
        pagination_opts[:offset])
    end

    count = TransactionQuery.transactions_count_for_community(@current_community.id)

    # TODO THIS IS COPY-PASTE
    conversations = conversations.map do |transaction|
      conversation = transaction[:conversation]
      # TODO Embed author and starter to the transaction entity
      # author = conversation[:other_person]
      author = Maybe(conversation[:other_person]).or_else({is_deleted: true})
      starter = Maybe(conversation[:starter_person]).or_else({is_deleted: true})

      [author, starter].each { |p|
        p[:url] = person_path(p[:username]) unless p[:username].nil?
        p[:display_name] = PersonViewUtils.person_entity_display_name(p, "fullname")
      }

      if transaction[:listing].present?
        # This if was added to tolerate cases where listing has been deleted
        # due the author deleting his/her account completely
        # UPDATE: December 2014, we did an update which keeps the listing row even if user is deleted.
        # So, we do not need to tolerate this anymore. However, there are transactions with deleted
        # listings in DB, so those have to be handled.
        transaction[:listing_url] = listing_path(id: transaction[:listing][:id])
      end

      transaction[:last_activity_at] = last_activity_for(transaction)

      transaction.merge({author: author, starter: starter})
    end

    conversations = WillPaginate::Collection.create(pagination_opts[:page], pagination_opts[:per_page], count) do |pager|
      pager.replace(conversations)
    end

    respond_to do |format|
      format.html do
        render("index", {
          locals: {
            community: @current_community,
            conversations: conversations
          }
        })
      end
      with_feature(:export_transactions_as_csv) do
        format.csv do
          marketplace_name = if @current_community.use_domain
            @current_community.domain
          else
            @current_community.ident
          end

          self.response.headers["Content-Type"] ||= 'text/csv'
          self.response.headers["Content-Disposition"] = "attachment; filename=#{marketplace_name}-transactions-#{Date.today}.csv"
          self.response.headers["Content-Transfer-Encoding"] = "binary"
          self.response.headers["Last-Modified"] = Time.now.ctime.to_s

          self.response_body = Enumerator.new do |yielder|
            generate_csv_for(yielder, conversations)
          end
        end
      end
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
 t("layouts.admin.admin") 
 "-" 
 t("admin.communities.transactions.transactions") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("layouts.admin.admin") 
 "-" 
 t("admin.communities.transactions.transactions") 
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
 
 t("admin.communities.transactions.transactions", community_name: community.name(I18n.locale)) 
 if feature_enabled?(:export_transactions_as_csv) 
 link_to(" " + t("admin.communities.transactions.export_all_as_csv"), {per_page: 99999, format: :csv}, {class: icon_class("download")}) 
 end 
 page_entries_info(conversations, :model => "Transaction") 
  link_to({:sort => column, :direction => direction, :page => (params[:page] )}, {:class => "sort-link"}) do 
 title 
 if params[:sort].eql?(column) 
 if direction.eql?('asc') 
 else 
 end 
 end 
 end 
 
 t("admin.communities.transactions.headers.status") 
 t("admin.communities.transactions.headers.sum") 
  link_to({:sort => column, :direction => direction, :page => (params[:page] )}, {:class => "sort-link"}) do 
 title 
 if params[:sort].eql?(column) 
 if direction.eql?('asc') 
 else 
 end 
 end 
 end 
 
  link_to({:sort => column, :direction => direction, :page => (params[:page] )}, {:class => "sort-link"}) do 
 title 
 if params[:sort].eql?(column) 
 if direction.eql?('asc') 
 else 
 end 
 end 
 end 
 
 t("admin.communities.transactions.headers.initiated_by") 
 t("admin.communities.transactions.headers.other_party") 
 conversations.each do |conversation| 
 listing_title = conversation[:listing_title] || t("admin.communities.transactions.not_available") 
 Maybe(conversation[:listing]).map { |listing| link_to_unless(listing[:deleted], listing_title, conversation[:listing_url]) }.or_else(listing_title) 
 link_to person_transaction_path(person_id: @current_user.id, id: conversation[:id]) do 
 t("admin.communities.transactions.status.#{conversation[:status]}") 
 end 
 conversation[:payment_total] ? humanized_money_with_symbol(conversation[:payment_total]) : "" 
 l(conversation[:created_at], format: :short_date) 
 l(conversation[:last_activity_at], format: :short_date) 
 Maybe(conversation[:starter]).map { |p| link_to_unless(p[:is_deleted], p[:display_name], p[:url]) }.or_else("") 
 Maybe(conversation[:author]).map { |p| link_to_unless(p[:is_deleted], p[:display_name], p[:url]) }.or_else("") 
 end 
 will_paginate conversations 
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

  def generate_csv_for(yielder, conversations)
    # first line is column names
    yielder << %w{
      transaction_id
      listing_id
      listing_title
      status
      currency
      sum
      started_at
      last_activity_at
      starter_username
      other_party_username
    }.to_csv(force_quotes: true)
    conversations.each do |conversation|
      yielder << [
        conversation[:id],
        conversation[:listing] ? conversation[:listing][:id] : "N/A",
        conversation[:listing_title] || "N/A",
        conversation[:status],
        conversation[:payment_total].is_a?(Money) ? conversation[:payment_total].currency : "N/A",
        conversation[:payment_total],
        conversation[:created_at],
        conversation[:last_activity_at],
        conversation[:starter] ? conversation[:starter][:username] : "DELETED",
        conversation[:author] ? conversation[:author][:username] : "DELETED"
      ].to_csv(force_quotes: true)
    end
  end

  private

  def last_activity_for(conversation)
    last_activity_at = 0
    if conversation[:conversation][:last_message_at].nil?
      last_activity_at = conversation[:last_transition_at]
    elsif conversation[:last_transition_at].nil?
      last_activity_at = conversation[:conversation][:last_message_at]
    else
      last_activity_at = [conversation[:last_transition_at], conversation[:conversation][:last_message_at]].max
    end
    last_activity_at
  end

  def simple_sort_column(sort_column)
    case sort_column
    when "listing"
      "listings.title"
    when "started"
      "created_at"
    end
  end

  def sort_direction
    params[:direction] || "desc"
  end
end

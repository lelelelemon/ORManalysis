class InvitationsController < ApplicationController

  before_filter do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_invite_new_user")
  end

  before_filter :users_can_invite_new_users

  def new
    @selected_tribe_navi_tab = "members"
    @invitation = Invitation.new
    invitation_limit = @current_community.join_with_invite_only ? Invitation.invite_only_invitation_limit : Invitation.invitation_limit
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
 t("layouts.admin.admin") 
 "-" 
 t("admin.communities.edit_details.invite_people") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("layouts.admin.admin") 
 "-" 
 t("admin.communities.edit_details.invite_people") 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 announcement.to_s 
 icon_class 
 flash[announcement] 
 end 
 end 
 
  content_for :extra_javascript do 
 end 
  
 support_link = link_to(t("homepage.invitation_form.this_article_link"), "http://support.sharetribe.com/knowledgebase/articles/675040", target: "_blank") 
 t("homepage.invitation_form.add_email_addresses_description") 
 if has_admin_rights 
 t("homepage.invitation_form.add_lots_of_email_addresses", this_article_link: support_link).html_safe 
 end 
 form_for Invitation.new, :url => invitations_path do |f| 
 f.label :email, t("homepage.invitation_form.email") 
 f.text_area :email, :class => "text_field", :placeholder => t("homepage.invitation_form.invitation_emails_field_placeholder") 
 f.label :message, t("homepage.invitation_form.message") 
 f.text_area :message, :class => "invitation_message_text", :placeholder => t("homepage.invitation_form.invitation_message_field_placeholder") 
 f.hidden_field :community_id, :value => @current_community.id.to_s 
 f.hidden_field :inviter_id, :value => @current_user.id 
 f.button t("homepage.invitation_form.send_invitation") 
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

  def create
    invitation_emails = params[:invitation][:email].split(",")

    unless validate_daily_limit(@current_user.id, invitation_emails.size, @current_community)
      return redirect_to new_invitation_path, flash: { error: t("layouts.notifications.invitation_limit_reached")}
    end

    sending_problems = nil
    invitation_emails.each do |email|
      invitation = Invitation.new(params[:invitation].merge!({:email => email.strip, :inviter => @current_user}))
      if invitation.save
        Delayed::Job.enqueue(InvitationCreatedJob.new(invitation.id, @current_community.id))
      else
        sending_problems = true
      end
    end

    if sending_problems
      flash[:error] = t("layouts.notifications.invitation_cannot_be_sent")
    else
      flash[:notice] = t("layouts.notifications.invitation_sent")
    end

    redirect_to new_invitation_path
  end

  private

  def users_can_invite_new_users
    unless @current_community.allows_user_to_send_invitations?(@current_user)
      flash[:error] = t("layouts.notifications.inviting_new_users_is_not_allowed_in_this_community")
      redirect_to root and return
    end
  end

  def validate_daily_limit(inviter_id, number_of_emails, community)
    email_count = (number_of_emails + daily_email_count(inviter_id))
    email_count < Invitation.invitation_limit || (community.join_with_invite_only && email_count < Invitation.invite_only_invitation_limit)
  end

  def daily_email_count(inviter_id)
    Invitation.where(inviter_id: inviter_id, created_at: 1.day.ago..Time.now).count
  end

end

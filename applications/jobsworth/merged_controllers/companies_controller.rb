# encoding: UTF-8
class CompaniesController < ApplicationController
  before_filter :authorize_user_is_admin, :except => [:show_logo, :properties]

  layout 'admin'

  def edit
    @company = current_user.company
 @page_title = "#{t("companies.company_settings")} - #{Setting.productName}" 
 content_for :navigation do 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 scripts = all_custom_scripts 
 t("companies.admin_panel") 
 active_class(selected, "general") 
 link_to( t("companies.general"), edit_company_path(current_user.company) ) 
 if current_user.company.use_score_rules? 
 active_class(selected, "score-rules") 
 link_to( ScoreRule.model_name.human(:count => 2), score_rules_companies_path ) 
 end 
 if scripts.size > 0 
 active_class(selected, "custom-scripts") 
 link_to( t("custom_scripts.custom_scripts"), custom_scripts_companies_path ) 
 end 
 active_class(selected, "templates") 
 link_to( ::Template.model_name.human(:count => 2), task_templates_path ) 
 active_class(selected, "triggers") 
 link_to( Trigger.model_name.human(:count => 2), triggers_path ) 
 if current_user.can_use_billing? 
 active_class(selected, "services") 
 link_to( Service.model_name.human(:count => 2), services_path ) 
 end 
 active_class(selected, "news-items") 
 link_to( NewsItem.model_name.human(:count =>2), news_items_path ) 
 active_class(selected, "snippets") 
 link_to( Snippet.model_name.human(:count => 2), snippets_path ) 
 active_class(selected, "orphaned-emails") 
 link_to( t("email_addresses.orphaned_emails_link"), email_addresses_path ) 
 t("companies.properties") 
 active_class(selected, "users-properties") 
 link_to t("companies.person"), "/custom_attributes/edit?type=User" 
 active_class(selected, "customers-properties") 
 link_to Company.model_name.human(:count => 1), "/custom_attributes/edit?type=Customer" 
 active_class(selected, "organizational-units-properties") 
 link_to t("companies.company_location"), "/custom_attributes/edit?type=OrganizationalUnit" 
 active_class(selected, "work-logs-properties") 
 link_to WorkLog.model_name.human(:count => 1), "/custom_attributes/edit?type=WorkLog" 
 active_class(selected, "task-properties") 
 link_to TaskRecord.model_name.human(:count => 1), properties_path 
 if current_user.use_resources? 
 active_class(selected, "resource-type") 
 link_to ResourceType.model_name.human(:count => 1), resource_types_path 
 end 

end
 
 end 
 content_tag :legend, t("companies.company_settings") 
 form_for(@company, :html => {:class => "form-horizontal", :multipart => true}) do |f| 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 f.label(:company_name) 
 f.text_field 'name' 
 f.label(:show_wiki) 
 f.check_box 'show_wiki' 
 f.label(:use_resource) 
 f.check_box 'use_resources' 
 f.label(:use_billing) 
 f.check_box 'use_billing' 
 f.label(:use_score_rules) 
 f.check_box 'use_score_rules' 
 f.label(:suppressed_email_addresses) 
 f.text_area 'suppressed_email_addresses', :rows => 5, :class => "input-xxlarge" 
 t("companies.suppressed_email_hint") 
 t 'hint.company.receiving_emails' 
 t("companies.incoming_email_project") 
 incoming_email_select_tag 
 if current_user.company.logo? 
 f.label(:logo) 
 tag("img", {:src => "/companies/show_logo/#{current_user.company.id}", :border => 0 } ) 
 end 
 f.label(:logo, t("companies.new_logo")) 
 f.file_field :logo 
 t("companies.logo_hint") 

end
 
 end 

  end

  def score_rules
    @company = current_user.company
 @page_title = "#{t('score_rules.score_rules')} - #{Setting.productName}" 
 content_for :navigation do 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 scripts = all_custom_scripts 
 t("companies.admin_panel") 
 active_class(selected, "general") 
 link_to( t("companies.general"), edit_company_path(current_user.company) ) 
 if current_user.company.use_score_rules? 
 active_class(selected, "score-rules") 
 link_to( ScoreRule.model_name.human(:count => 2), score_rules_companies_path ) 
 end 
 if scripts.size > 0 
 active_class(selected, "custom-scripts") 
 link_to( t("custom_scripts.custom_scripts"), custom_scripts_companies_path ) 
 end 
 active_class(selected, "templates") 
 link_to( ::Template.model_name.human(:count => 2), task_templates_path ) 
 active_class(selected, "triggers") 
 link_to( Trigger.model_name.human(:count => 2), triggers_path ) 
 if current_user.can_use_billing? 
 active_class(selected, "services") 
 link_to( Service.model_name.human(:count => 2), services_path ) 
 end 
 active_class(selected, "news-items") 
 link_to( NewsItem.model_name.human(:count =>2), news_items_path ) 
 active_class(selected, "snippets") 
 link_to( Snippet.model_name.human(:count => 2), snippets_path ) 
 active_class(selected, "orphaned-emails") 
 link_to( t("email_addresses.orphaned_emails_link"), email_addresses_path ) 
 t("companies.properties") 
 active_class(selected, "users-properties") 
 link_to t("companies.person"), "/custom_attributes/edit?type=User" 
 active_class(selected, "customers-properties") 
 link_to Company.model_name.human(:count => 1), "/custom_attributes/edit?type=Customer" 
 active_class(selected, "organizational-units-properties") 
 link_to t("companies.company_location"), "/custom_attributes/edit?type=OrganizationalUnit" 
 active_class(selected, "work-logs-properties") 
 link_to WorkLog.model_name.human(:count => 1), "/custom_attributes/edit?type=WorkLog" 
 active_class(selected, "task-properties") 
 link_to TaskRecord.model_name.human(:count => 1), properties_path 
 if current_user.use_resources? 
 active_class(selected, "resource-type") 
 link_to ResourceType.model_name.human(:count => 1), resource_types_path 
 end 

end
 
 end 
 content_tag :legend, t("score_rules.score_rules") 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
container_name 
 container_id 

end
 

  end

  def custom_scripts
    @company = current_user.company
 @page_title = "#{t('custom_scripts.custom_scripts')} - #{Setting.productName}" 
 content_for :navigation do 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 scripts = all_custom_scripts 
 t("companies.admin_panel") 
 active_class(selected, "general") 
 link_to( t("companies.general"), edit_company_path(current_user.company) ) 
 if current_user.company.use_score_rules? 
 active_class(selected, "score-rules") 
 link_to( ScoreRule.model_name.human(:count => 2), score_rules_companies_path ) 
 end 
 if scripts.size > 0 
 active_class(selected, "custom-scripts") 
 link_to( t("custom_scripts.custom_scripts"), custom_scripts_companies_path ) 
 end 
 active_class(selected, "templates") 
 link_to( ::Template.model_name.human(:count => 2), task_templates_path ) 
 active_class(selected, "triggers") 
 link_to( Trigger.model_name.human(:count => 2), triggers_path ) 
 if current_user.can_use_billing? 
 active_class(selected, "services") 
 link_to( Service.model_name.human(:count => 2), services_path ) 
 end 
 active_class(selected, "news-items") 
 link_to( NewsItem.model_name.human(:count =>2), news_items_path ) 
 active_class(selected, "snippets") 
 link_to( Snippet.model_name.human(:count => 2), snippets_path ) 
 active_class(selected, "orphaned-emails") 
 link_to( t("email_addresses.orphaned_emails_link"), email_addresses_path ) 
 t("companies.properties") 
 active_class(selected, "users-properties") 
 link_to t("companies.person"), "/custom_attributes/edit?type=User" 
 active_class(selected, "customers-properties") 
 link_to Company.model_name.human(:count => 1), "/custom_attributes/edit?type=Customer" 
 active_class(selected, "organizational-units-properties") 
 link_to t("companies.company_location"), "/custom_attributes/edit?type=OrganizationalUnit" 
 active_class(selected, "work-logs-properties") 
 link_to WorkLog.model_name.human(:count => 1), "/custom_attributes/edit?type=WorkLog" 
 active_class(selected, "task-properties") 
 link_to TaskRecord.model_name.human(:count => 1), properties_path 
 if current_user.use_resources? 
 active_class(selected, "resource-type") 
 link_to ResourceType.model_name.human(:count => 1), resource_types_path 
 end 

end
 
 end 
 content_tag :legend, t("custom_scripts.custom_scripts") 
 content_tag :p, t("custom_scripts.explanation", :custom_scripts_root => Setting.custom_scripts_root), :class => "alert alert-info" 
 scripts = all_custom_scripts 
 if scripts and scripts.any? 
 scripts.each do |script| 
 link_to script, :controller => "scripts", :script => script 
 end 
 else 
 t('custom_scripts.no_scripts_found', :custom_scripts_root => Setting.custom_scripts_root) 
 end 

  end

  def update
    @company = current_user.company

    #TODO: When refactoring the model, remove this whole 'internal_customer' thingy,
    # as far as I can tell, the internal customer is only used for storing the
    # company logo.
    @internal = @company.internal_customer
    if @internal.nil?
      flash[:error] = t('error.company.no_internal_customer')
      ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 @page_title = "#{t("companies.company_settings")} - #{Setting.productName}" 
 content_for :navigation do 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 scripts = all_custom_scripts 
 t("companies.admin_panel") 
 active_class(selected, "general") 
 link_to( t("companies.general"), edit_company_path(current_user.company) ) 
 if current_user.company.use_score_rules? 
 active_class(selected, "score-rules") 
 link_to( ScoreRule.model_name.human(:count => 2), score_rules_companies_path ) 
 end 
 if scripts.size > 0 
 active_class(selected, "custom-scripts") 
 link_to( t("custom_scripts.custom_scripts"), custom_scripts_companies_path ) 
 end 
 active_class(selected, "templates") 
 link_to( ::Template.model_name.human(:count => 2), task_templates_path ) 
 active_class(selected, "triggers") 
 link_to( Trigger.model_name.human(:count => 2), triggers_path ) 
 if current_user.can_use_billing? 
 active_class(selected, "services") 
 link_to( Service.model_name.human(:count => 2), services_path ) 
 end 
 active_class(selected, "news-items") 
 link_to( NewsItem.model_name.human(:count =>2), news_items_path ) 
 active_class(selected, "snippets") 
 link_to( Snippet.model_name.human(:count => 2), snippets_path ) 
 active_class(selected, "orphaned-emails") 
 link_to( t("email_addresses.orphaned_emails_link"), email_addresses_path ) 
 t("companies.properties") 
 active_class(selected, "users-properties") 
 link_to t("companies.person"), "/custom_attributes/edit?type=User" 
 active_class(selected, "customers-properties") 
 link_to Company.model_name.human(:count => 1), "/custom_attributes/edit?type=Customer" 
 active_class(selected, "organizational-units-properties") 
 link_to t("companies.company_location"), "/custom_attributes/edit?type=OrganizationalUnit" 
 active_class(selected, "work-logs-properties") 
 link_to WorkLog.model_name.human(:count => 1), "/custom_attributes/edit?type=WorkLog" 
 active_class(selected, "task-properties") 
 link_to TaskRecord.model_name.human(:count => 1), properties_path 
 if current_user.use_resources? 
 active_class(selected, "resource-type") 
 link_to ResourceType.model_name.human(:count => 1), resource_types_path 
 end 

end
 
 end 
 content_tag :legend, t("companies.company_settings") 
 form_for(@company, :html => {:class => "form-horizontal", :multipart => true}) do |f| 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 f.label(:company_name) 
 f.text_field 'name' 
 f.label(:show_wiki) 
 f.check_box 'show_wiki' 
 f.label(:use_resource) 
 f.check_box 'use_resources' 
 f.label(:use_billing) 
 f.check_box 'use_billing' 
 f.label(:use_score_rules) 
 f.check_box 'use_score_rules' 
 f.label(:suppressed_email_addresses) 
 f.text_area 'suppressed_email_addresses', :rows => 5, :class => "input-xxlarge" 
 t("companies.suppressed_email_hint") 
 t 'hint.company.receiving_emails' 
 t("companies.incoming_email_project") 
 incoming_email_select_tag 
 if current_user.company.logo? 
 f.label(:logo) 
 tag("img", {:src => "/companies/show_logo/#{current_user.company.id}", :border => 0 } ) 
 end 
 f.label(:logo, t("companies.new_logo")) 
 f.file_field :logo 
 t("companies.logo_hint") 

end
 
 end 

end

      return
    end

    if @company.update_attributes(params[:company])
      @internal.name = @company.name
      @internal.save

      flash[:success] = t('flash.notice.settings_updated', model: Company.model_name.human)
      redirect_from_last
    else
      flash[:error] = @company.errors.full_messages.join(". ")
      ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 @page_title = "#{t("companies.company_settings")} - #{Setting.productName}" 
 content_for :navigation do 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 scripts = all_custom_scripts 
 t("companies.admin_panel") 
 active_class(selected, "general") 
 link_to( t("companies.general"), edit_company_path(current_user.company) ) 
 if current_user.company.use_score_rules? 
 active_class(selected, "score-rules") 
 link_to( ScoreRule.model_name.human(:count => 2), score_rules_companies_path ) 
 end 
 if scripts.size > 0 
 active_class(selected, "custom-scripts") 
 link_to( t("custom_scripts.custom_scripts"), custom_scripts_companies_path ) 
 end 
 active_class(selected, "templates") 
 link_to( ::Template.model_name.human(:count => 2), task_templates_path ) 
 active_class(selected, "triggers") 
 link_to( Trigger.model_name.human(:count => 2), triggers_path ) 
 if current_user.can_use_billing? 
 active_class(selected, "services") 
 link_to( Service.model_name.human(:count => 2), services_path ) 
 end 
 active_class(selected, "news-items") 
 link_to( NewsItem.model_name.human(:count =>2), news_items_path ) 
 active_class(selected, "snippets") 
 link_to( Snippet.model_name.human(:count => 2), snippets_path ) 
 active_class(selected, "orphaned-emails") 
 link_to( t("email_addresses.orphaned_emails_link"), email_addresses_path ) 
 t("companies.properties") 
 active_class(selected, "users-properties") 
 link_to t("companies.person"), "/custom_attributes/edit?type=User" 
 active_class(selected, "customers-properties") 
 link_to Company.model_name.human(:count => 1), "/custom_attributes/edit?type=Customer" 
 active_class(selected, "organizational-units-properties") 
 link_to t("companies.company_location"), "/custom_attributes/edit?type=OrganizationalUnit" 
 active_class(selected, "work-logs-properties") 
 link_to WorkLog.model_name.human(:count => 1), "/custom_attributes/edit?type=WorkLog" 
 active_class(selected, "task-properties") 
 link_to TaskRecord.model_name.human(:count => 1), properties_path 
 if current_user.use_resources? 
 active_class(selected, "resource-type") 
 link_to ResourceType.model_name.human(:count => 1), resource_types_path 
 end 

end
 
 end 
 content_tag :legend, t("companies.company_settings") 
 form_for(@company, :html => {:class => "form-horizontal", :multipart => true}) do |f| 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 f.label(:company_name) 
 f.text_field 'name' 
 f.label(:show_wiki) 
 f.check_box 'show_wiki' 
 f.label(:use_resource) 
 f.check_box 'use_resources' 
 f.label(:use_billing) 
 f.check_box 'use_billing' 
 f.label(:use_score_rules) 
 f.check_box 'use_score_rules' 
 f.label(:suppressed_email_addresses) 
 f.text_area 'suppressed_email_addresses', :rows => 5, :class => "input-xxlarge" 
 t("companies.suppressed_email_hint") 
 t 'hint.company.receiving_emails' 
 t("companies.incoming_email_project") 
 incoming_email_select_tag 
 if current_user.company.logo? 
 f.label(:logo) 
 tag("img", {:src => "/companies/show_logo/#{current_user.company.id}", :border => 0 } ) 
 end 
 f.label(:logo, t("companies.new_logo")) 
 f.file_field :logo 
 t("companies.logo_hint") 

end
 
 end 

end

    end
  end

  # Show a company logo
  def show_logo
    company = Company.find(params[:id])

    if company.logo?
      send_file(company.logo_path, :filename => "logo", :disposition => "inline", :type => company.logo_content_type)
    else
      render :nothing => true
    end
  end

  # get company properties in JSON format
  def properties
    @properties = current_user.company.properties
    render :json => @properties
  end
end

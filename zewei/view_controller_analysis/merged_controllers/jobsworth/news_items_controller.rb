class NewsItemsController < ApplicationController
  before_filter :authorize_user_is_admin

  layout "admin"

  def index
    @news = current_user.company.news_items.paginate(:page => params[:page], :per_page => 10)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :navigation do 
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
 link_to t("news_items.new"), new_news_item_path, :class => "btn pull-right" 
 for news in @news 
 news.created_at.strftime("%H:%M %d/%m-%y") 
 news.body 
 link_to t("button.edit"), edit_news_item_path(news) 
 link_to t("button.delete"), news_item_path(news), :method => "delete" 
 end 

end

  end

  def new
    @news = NewsItem.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :navigation do 
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
 t("news_items.create") 
 form_tag({:action => 'create'}, :clas => "form-horizontal")  do 
  t("news_items.body") 
 text_area 'news', 'body', :class => "span12" 
 t("news_items.public") 
 check_box 'news', 'portal' 
 
 end 

end

  end

  def create
    @news = NewsItem.create(params[:news])
    @news.company = current_user.company

    if @news.valid?
      flash[:success] = t('flash.notice.model_created', model: NewsItem.model_name.human)
      redirect_to news_items_path
    else
      flash[:error] = @news.errors.full_messages.join(". ")
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :navigation do 
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
 t("news_items.create") 
 form_tag({:action => 'create'}, :clas => "form-horizontal")  do 
  t("news_items.body") 
 text_area 'news', 'body', :class => "span12" 
 t("news_items.public") 
 check_box 'news', 'portal' 
 
 end 

end

    end
  end

  def edit
    @news = current_user.company.news_items.find(params[:id])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :navigation do 
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
 t("news_items.edit") 
 form_for(@news, :html => {:class => "form-horizontal"}) do 
  t("news_items.body") 
 text_area 'news', 'body', :class => "span12" 
 t("news_items.public") 
 check_box 'news', 'portal' 
 
 end 

end

  end

  def update
    @news = current_user.company.news_items.find(params[:id])

    if @news.update_attributes(params[:news])
      flash[:success] = t('flash.notice.model_updated', model: NewsItem.model_name.human)
      redirect_to news_items_path
    else
      flash[:error] = @news.errors.full_messages.join(". ")
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :navigation do 
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
 t("news_items.edit") 
 form_for(@news, :html => {:class => "form-horizontal"}) do 
  t("news_items.body") 
 text_area 'news', 'body', :class => "span12" 
 t("news_items.public") 
 check_box 'news', 'portal' 
 
 end 

end

    end
  end

  def destroy
    if current_user.company.news_items.find(params[:id]).destroy
      flash[:success] = t('flash.notice.model_deleted', model: NewsItem.model_name.human)
    else
      flash[:error] = t('flash.error.model_deleted', model: NewsItem.model_name.human)
    end
    redirect_to news_items_path
  end
end

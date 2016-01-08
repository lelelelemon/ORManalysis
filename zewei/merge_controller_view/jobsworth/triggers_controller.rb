# encoding: UTF-8
class TriggersController < ApplicationController
  layout  "admin"
  before_filter :authorize_user_is_admin

  def index
    @triggers = current_user.company.triggers

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @triggers }
    end
  end

  def show
    @trigger = current_user.company.triggers.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @trigger }
    end
  end

  def new
    @trigger = Trigger.new(:trigger_type => "due_at")

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @trigger }
    end
  end

  def edit
    @trigger = current_user.company.triggers.find(params[:id])
 @page_title = t("triggers.trigger_title", title: Setting.productName) 
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
 t("triggers.edit_trigger") 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 form_for(@trigger, :html => {:class => "form-horizontal"}) do |f| 
 f.error_messages 
 f.label :task_filter_id, t("triggers.task_filter") 
 f.select :task_filter_id, objects_to_names_and_ids(current_user.visible_task_filters) 
 f.label :event_id, t("triggers.event") 
 f.select :event_id, objects_to_names_and_ids(Trigger::Event.all) 
 t("triggers.add_action") 
 t("shared.none") 
 options_from_collection_for_select(Trigger::ActionFactory.all, :id, :name) 
 @trigger.actions.each do |action| 
 fields_for('trigger[actions_attributes]', action,  :index=>'') do |fields| 
  render_action_partial(fields)  
 fields.hidden_field :id 
 fields.hidden_field :factory_id, :value=>nil 
 end 
 end 
 cit_submit_tag(f.object) 
 end 
 Trigger::ActionFactory.all.each do |factory| 
factory.id
 fields_for('trigger[actions_attributes][]', factory.build)  do |fields| 
 render_action_partial(fields)  
 fields.hidden_field :id 
 fields.hidden_field :factory_id, :value=>factory.id 
 end 
 end 

end
 

  end

  def create
    @trigger = Trigger.new(params[:trigger])
    @trigger.company = current_user.company

    respond_to do |format|
      if @trigger.save
        flash[:success] = t('flash.notice.model_created', model: Trigger.model_name.human)
        format.html { redirect_to(triggers_path) }
        format.xml  { render :xml => @trigger, :status => :created, :location => @trigger }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 @page_title = t("triggers.new_trigger_title", title: Setting.productName) 
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
 t("triggers.create_trigger") 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 form_for(@trigger, :html => {:class => "form-horizontal"}) do |f| 
 f.error_messages 
 f.label :task_filter_id, t("triggers.task_filter") 
 f.select :task_filter_id, objects_to_names_and_ids(current_user.visible_task_filters) 
 f.label :event_id, t("triggers.event") 
 f.select :event_id, objects_to_names_and_ids(Trigger::Event.all) 
 t("triggers.add_action") 
 t("shared.none") 
 options_from_collection_for_select(Trigger::ActionFactory.all, :id, :name) 
 @trigger.actions.each do |action| 
 fields_for('trigger[actions_attributes]', action,  :index=>'') do |fields| 
  render_action_partial(fields)  
 fields.hidden_field :id 
 fields.hidden_field :factory_id, :value=>nil 
 end 
 end 
 cit_submit_tag(f.object) 
 end 
 Trigger::ActionFactory.all.each do |factory| 
factory.id
 fields_for('trigger[actions_attributes][]', factory.build)  do |fields| 
 render_action_partial(fields)  
 fields.hidden_field :id 
 fields.hidden_field :factory_id, :value=>factory.id 
 end 
 end 

end
 

end
 }
        format.xml  { render :xml => @trigger.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @trigger = current_user.company.triggers.find(params[:id])

    respond_to do |format|
      if @trigger.update_attributes(params[:trigger])
        flash[:success] = t('flash.notice.model_updated', model: Trigger.model_name.human)
        format.html { redirect_to(triggers_path) }
        format.xml  { head :ok }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 @page_title = t("triggers.trigger_title", title: Setting.productName) 
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
 t("triggers.edit_trigger") 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 form_for(@trigger, :html => {:class => "form-horizontal"}) do |f| 
 f.error_messages 
 f.label :task_filter_id, t("triggers.task_filter") 
 f.select :task_filter_id, objects_to_names_and_ids(current_user.visible_task_filters) 
 f.label :event_id, t("triggers.event") 
 f.select :event_id, objects_to_names_and_ids(Trigger::Event.all) 
 t("triggers.add_action") 
 t("shared.none") 
 options_from_collection_for_select(Trigger::ActionFactory.all, :id, :name) 
 @trigger.actions.each do |action| 
 fields_for('trigger[actions_attributes]', action,  :index=>'') do |fields| 
  render_action_partial(fields)  
 fields.hidden_field :id 
 fields.hidden_field :factory_id, :value=>nil 
 end 
 end 
 cit_submit_tag(f.object) 
 end 
 Trigger::ActionFactory.all.each do |factory| 
factory.id
 fields_for('trigger[actions_attributes][]', factory.build)  do |fields| 
 render_action_partial(fields)  
 fields.hidden_field :id 
 fields.hidden_field :factory_id, :value=>factory.id 
 end 
 end 

end
 

end
 }
        format.xml  { render :xml => @trigger.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @trigger = current_user.company.triggers.find(params[:id])
    @trigger.destroy

    respond_to do |format|
      format.html { redirect_to(triggers_url) }
      format.xml  { head :ok }
    end
  end
end

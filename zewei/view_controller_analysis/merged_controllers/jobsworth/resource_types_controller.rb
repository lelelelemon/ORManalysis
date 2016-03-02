# encoding: UTF-8
class ResourceTypesController < ApplicationController
  before_filter :authorize_user_is_admin
  layout  "admin"

  def index
    @resource_types = current_user.company.resource_types

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @resource_types }
    end
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
 link_to t("resource_types.new"), new_resource_type_path, :class => "btn pull-right" 
 t("resource_types.name") 
 t("resource_types.attributes") 
 @resource_types.each do |rt| 
 rt.name 
 rt.resource_type_attributes.count 
 link_to t("button.edit"), edit_resource_type_path(rt) 
 link_to(t("button.delete"), resource_type_path(rt), :method => :delete, :confirm => t("shared.are_you_sure")) 
 end 

end

  end

  def new
    @resource_type = ResourceType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @resource_type }
    end
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
 t("resource_types.create") 
  form_for(@resource_type, :html => {:class => "form-horizontal"}) do |f| 
 t("resource_types.name") 
 f.text_field :name 
 t("resource_types.attributes") 
 @resource_type.resource_type_attributes.each do |rta| 
  attribute.id 

     prefix = "type_attributes"
     prefix = "new_#{ prefix }" if attribute.new_record?
     prefix = "resource_type[#{ prefix }]"
     ids	= attribute.id || rand(99999999)
   
 fields_for(prefix, attribute) do |f| 
 f.hidden_field(:position, :index => ids, :class => "position") 
 t("resource_types.name") 
 f.text_field :name, :index => ids 
 sortable_handle_tag(attribute) 
 link_to_function(t("custom_attributes.remove_attribute"), "jQuery(this).parents('.attribute').remove()") 
 t("resource_types.mandatory") 
 f.check_box :is_mandatory, :index => ids, :class => "nested-checkbox" 
 t("resource_types.is_password") 
 f.check_box :is_password, :index => ids, :class => "nested-checkbox" 
 t("resource_types.allows_multiple") 
 f.check_box :allows_multiple, :index => ids, :class => "nested-checkbox" 
 t("resource_types.validation_regex") 
 f.text_field :validation_regex, :index => ids 
 t("resource_types.default_length") 
 f.text_field :default_field_length, :index => ids 
 end 
 
 end 
 cit_submit_tag(@resource_type) 
 add_attribute_link 
 end 
 

end

  end

  def edit
    @resource_type = current_user.company.resource_types.find(params[:id])
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
 t("resource_types.edit") 
  form_for(@resource_type, :html => {:class => "form-horizontal"}) do |f| 
 t("resource_types.name") 
 f.text_field :name 
 t("resource_types.attributes") 
 @resource_type.resource_type_attributes.each do |rta| 
  attribute.id 

     prefix = "type_attributes"
     prefix = "new_#{ prefix }" if attribute.new_record?
     prefix = "resource_type[#{ prefix }]"
     ids	= attribute.id || rand(99999999)
   
 fields_for(prefix, attribute) do |f| 
 f.hidden_field(:position, :index => ids, :class => "position") 
 t("resource_types.name") 
 f.text_field :name, :index => ids 
 sortable_handle_tag(attribute) 
 link_to_function(t("custom_attributes.remove_attribute"), "jQuery(this).parents('.attribute').remove()") 
 t("resource_types.mandatory") 
 f.check_box :is_mandatory, :index => ids, :class => "nested-checkbox" 
 t("resource_types.is_password") 
 f.check_box :is_password, :index => ids, :class => "nested-checkbox" 
 t("resource_types.allows_multiple") 
 f.check_box :allows_multiple, :index => ids, :class => "nested-checkbox" 
 t("resource_types.validation_regex") 
 f.text_field :validation_regex, :index => ids 
 t("resource_types.default_length") 
 f.text_field :default_field_length, :index => ids 
 end 
 
 end 
 cit_submit_tag(@resource_type) 
 add_attribute_link 
 end 
 

end

  end

  def create
    @resource_type = ResourceType.new(params[:resource_type])
    @resource_type.company = current_user.company

    respond_to do |format|
      if @resource_type.save
        flash[:success] = t('flash.notice.model_created', model: ResourceType.model_name.human)
        format.html { redirect_to(edit_resource_type_path(@resource_type)) }
        format.xml  { render :xml => @resource_type, :status => :created, :location => @resource_type }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 t("resource_types.create") 
  form_for(@resource_type, :html => {:class => "form-horizontal"}) do |f| 
 t("resource_types.name") 
 f.text_field :name 
 t("resource_types.attributes") 
 @resource_type.resource_type_attributes.each do |rta| 
  attribute.id 

     prefix = "type_attributes"
     prefix = "new_#{ prefix }" if attribute.new_record?
     prefix = "resource_type[#{ prefix }]"
     ids	= attribute.id || rand(99999999)
   
 fields_for(prefix, attribute) do |f| 
 f.hidden_field(:position, :index => ids, :class => "position") 
 t("resource_types.name") 
 f.text_field :name, :index => ids 
 sortable_handle_tag(attribute) 
 link_to_function(t("custom_attributes.remove_attribute"), "jQuery(this).parents('.attribute').remove()") 
 t("resource_types.mandatory") 
 f.check_box :is_mandatory, :index => ids, :class => "nested-checkbox" 
 t("resource_types.is_password") 
 f.check_box :is_password, :index => ids, :class => "nested-checkbox" 
 t("resource_types.allows_multiple") 
 f.check_box :allows_multiple, :index => ids, :class => "nested-checkbox" 
 t("resource_types.validation_regex") 
 f.text_field :validation_regex, :index => ids 
 t("resource_types.default_length") 
 f.text_field :default_field_length, :index => ids 
 end 
 
 end 
 cit_submit_tag(@resource_type) 
 add_attribute_link 
 end 
 

end
 }
        format.xml  { render :xml => @resource_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @resource_type = current_user.company.resource_types.find(params[:id])

    # need to set type_attributes param when all have been deleted
    params[:resource_type][:type_attributes] ||= {}

    saved = @resource_type.update_attributes(params[:resource_type])
    @resource_type.company = current_user.company
    saved &&= @resource_type.save

    respond_to do |format|
      if saved
        flash[:success] = t('flash.notice.model_updated', model: ResourceType.model_name.human)
        format.html { redirect_to(edit_resource_type_path(@resource_type)) }
        format.xml  { head :ok }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 t("resource_types.edit") 
  form_for(@resource_type, :html => {:class => "form-horizontal"}) do |f| 
 t("resource_types.name") 
 f.text_field :name 
 t("resource_types.attributes") 
 @resource_type.resource_type_attributes.each do |rta| 
  attribute.id 

     prefix = "type_attributes"
     prefix = "new_#{ prefix }" if attribute.new_record?
     prefix = "resource_type[#{ prefix }]"
     ids	= attribute.id || rand(99999999)
   
 fields_for(prefix, attribute) do |f| 
 f.hidden_field(:position, :index => ids, :class => "position") 
 t("resource_types.name") 
 f.text_field :name, :index => ids 
 sortable_handle_tag(attribute) 
 link_to_function(t("custom_attributes.remove_attribute"), "jQuery(this).parents('.attribute').remove()") 
 t("resource_types.mandatory") 
 f.check_box :is_mandatory, :index => ids, :class => "nested-checkbox" 
 t("resource_types.is_password") 
 f.check_box :is_password, :index => ids, :class => "nested-checkbox" 
 t("resource_types.allows_multiple") 
 f.check_box :allows_multiple, :index => ids, :class => "nested-checkbox" 
 t("resource_types.validation_regex") 
 f.text_field :validation_regex, :index => ids 
 t("resource_types.default_length") 
 f.text_field :default_field_length, :index => ids 
 end 
 
 end 
 cit_submit_tag(@resource_type) 
 add_attribute_link 
 end 
 

end
 }
        format.xml  { render :xml => @resource_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @resource_type = current_user.company.resource_types.find(params[:id])
    @resource_type.destroy

    respond_to do |format|
      format.html { redirect_to(resource_types_url) }
      format.xml  { head :ok }
    end
  end

  def attribute
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 attribute.id 

     prefix = "type_attributes"
     prefix = "new_#{ prefix }" if attribute.new_record?
     prefix = "resource_type[#{ prefix }]"
     ids	= attribute.id || rand(99999999)
   
 fields_for(prefix, attribute) do |f| 
 f.hidden_field(:position, :index => ids, :class => "position") 
 t("resource_types.name") 
 f.text_field :name, :index => ids 
 sortable_handle_tag(attribute) 
 link_to_function(t("custom_attributes.remove_attribute"), "jQuery(this).parents('.attribute').remove()") 
 t("resource_types.mandatory") 
 f.check_box :is_mandatory, :index => ids, :class => "nested-checkbox" 
 t("resource_types.is_password") 
 f.check_box :is_password, :index => ids, :class => "nested-checkbox" 
 t("resource_types.allows_multiple") 
 f.check_box :allows_multiple, :index => ids, :class => "nested-checkbox" 
 t("resource_types.validation_regex") 
 f.text_field :validation_regex, :index => ids 
 t("resource_types.default_length") 
 f.text_field :default_field_length, :index => ids 
 end 

end
end
end

# encoding: UTF-8
class PropertiesController < ApplicationController
  before_filter :authorize_user_is_admin
  layout  "admin"

  # GET /properties
  # GET /properties.xml
  def index
    @properties = current_user.company.properties
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @properties }
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
 t("properties.index") 
 link_to t("properties.new"), new_property_path, :class => "btn pull-right" 
 t("properties.name") 
 t("properties.default_sort") 
 t("properties.default_color") 
 render :partial => @properties 

end

  end

  # GET /properties/new
  # GET /properties/new.xml
  def new
    @property = Property.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @property }
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
 t("properties.create") 
  form_for(@property, :html => {:class => "form-horizontal"}) do |f| 
 f.error_messages 
 t("properties.name") 
 f.text_field :name 
 t("properties.mandatory") 
 f.check_box :mandatory 
 t("properties.default_sort") 
 f.check_box :default_sort 
 t("properties.default_color") 
 f.check_box :default_color 
 t("properties.possible_values") 
 @property.property_values.each do |pv| 
  pv.id 
 pv.id 

     prefix = "property_values"
     prefix = "new_#{ prefix }" if pv.new_record?
   
 fields_for(prefix, pv) do |f| 
 t "properties.value" 
 f.text_field :value, :index => pv.id 
 sortable_handle_tag(pv) 
 link_to "Remove value", "#", :class => "remove_property_value_link" 
 t 'properties.default' 
 f.check_box :default, :index => pv.id, :class => 'default nested-checkbox' 
 t 'properties.color' 
 f.text_field :color, :index => pv.id 
 t "properties.icon_url" 
 f.select :icon_url, task_icon_options(pv), {}, { :index => pv.id } 
 end 
 if current_user.company.use_score_rules? 
 container_name 
 container_id 
 
 end 
 
 end 
 cit_submit_tag(@property) 
 add_value_link 
 end 
 

end

  end

  # GET /properties/1/edit
  def edit
    @property = current_user.company.properties.find(params[:id])
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
 t("properties.edit") 
  form_for(@property, :html => {:class => "form-horizontal"}) do |f| 
 f.error_messages 
 t("properties.name") 
 f.text_field :name 
 t("properties.mandatory") 
 f.check_box :mandatory 
 t("properties.default_sort") 
 f.check_box :default_sort 
 t("properties.default_color") 
 f.check_box :default_color 
 t("properties.possible_values") 
 @property.property_values.each do |pv| 
  pv.id 
 pv.id 

     prefix = "property_values"
     prefix = "new_#{ prefix }" if pv.new_record?
   
 fields_for(prefix, pv) do |f| 
 t "properties.value" 
 f.text_field :value, :index => pv.id 
 sortable_handle_tag(pv) 
 link_to "Remove value", "#", :class => "remove_property_value_link" 
 t 'properties.default' 
 f.check_box :default, :index => pv.id, :class => 'default nested-checkbox' 
 t 'properties.color' 
 f.text_field :color, :index => pv.id 
 t "properties.icon_url" 
 f.select :icon_url, task_icon_options(pv), {}, { :index => pv.id } 
 end 
 if current_user.company.use_score_rules? 
 container_name 
 container_id 
 
 end 
 
 end 
 cit_submit_tag(@property) 
 add_value_link 
 end 
 

end

  end

  # POST /properties
  # POST /properties.xml
  def create
    @property = Property.new(params[:property])
    @property.property_values.build(params[:new_property_values]) if params[:new_property_values]
    @property.company = current_user.company

    respond_to do |format|
      if @property.save
        flash[:success] = t('flash.notice.model_created', model: Property.model_name.human)
        format.html { redirect_to(edit_property_path(@property)) }
        format.xml  { render :xml => @property, :status => :created, :location => @property }
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
 t("properties.create") 
  form_for(@property, :html => {:class => "form-horizontal"}) do |f| 
 f.error_messages 
 t("properties.name") 
 f.text_field :name 
 t("properties.mandatory") 
 f.check_box :mandatory 
 t("properties.default_sort") 
 f.check_box :default_sort 
 t("properties.default_color") 
 f.check_box :default_color 
 t("properties.possible_values") 
 @property.property_values.each do |pv| 
  pv.id 
 pv.id 

     prefix = "property_values"
     prefix = "new_#{ prefix }" if pv.new_record?
   
 fields_for(prefix, pv) do |f| 
 t "properties.value" 
 f.text_field :value, :index => pv.id 
 sortable_handle_tag(pv) 
 link_to "Remove value", "#", :class => "remove_property_value_link" 
 t 'properties.default' 
 f.check_box :default, :index => pv.id, :class => 'default nested-checkbox' 
 t 'properties.color' 
 f.text_field :color, :index => pv.id 
 t "properties.icon_url" 
 f.select :icon_url, task_icon_options(pv), {}, { :index => pv.id } 
 end 
 if current_user.company.use_score_rules? 
 container_name 
 container_id 
 
 end 
 
 end 
 cit_submit_tag(@property) 
 add_value_link 
 end 
 

end
 }
        format.xml  { render :xml => @property.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /properties/1
  # PUT /properties/1.xml
  def update
    @property = current_user.company.properties.find(params[:id])
    update_existing_property_values(@property, params)
    @property.property_values.build(params[:new_property_values]) if params[:new_property_values]

    saved = @property.update_attributes(params[:property])
    # force company in case somebody passes in company_id param
    @property.company = current_user.company
    saved &&= @property.save

    respond_to do |format|
      if saved
        flash[:success] = t('flash.notice.model_updated', model: Property.model_name.human)
        format.html { redirect_to(edit_property_path(@property)) }
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
 t("properties.edit") 
  form_for(@property, :html => {:class => "form-horizontal"}) do |f| 
 f.error_messages 
 t("properties.name") 
 f.text_field :name 
 t("properties.mandatory") 
 f.check_box :mandatory 
 t("properties.default_sort") 
 f.check_box :default_sort 
 t("properties.default_color") 
 f.check_box :default_color 
 t("properties.possible_values") 
 @property.property_values.each do |pv| 
  pv.id 
 pv.id 

     prefix = "property_values"
     prefix = "new_#{ prefix }" if pv.new_record?
   
 fields_for(prefix, pv) do |f| 
 t "properties.value" 
 f.text_field :value, :index => pv.id 
 sortable_handle_tag(pv) 
 link_to "Remove value", "#", :class => "remove_property_value_link" 
 t 'properties.default' 
 f.check_box :default, :index => pv.id, :class => 'default nested-checkbox' 
 t 'properties.color' 
 f.text_field :color, :index => pv.id 
 t "properties.icon_url" 
 f.select :icon_url, task_icon_options(pv), {}, { :index => pv.id } 
 end 
 if current_user.company.use_score_rules? 
 container_name 
 container_id 
 
 end 
 
 end 
 cit_submit_tag(@property) 
 add_value_link 
 end 
 

end
 }
        format.xml  { render :xml => @property.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /properties/1
  # DELETE /properties/1.xml
  def destroy
    @property = current_user.company.properties.find(params[:id])
    @property.destroy

    respond_to do |format|
      format.html { redirect_to(properties_url) }
      format.xml  { head :ok }
    end
  end

  def order
    if params[:property_values]
      values = params[:property_values].map { |id| PropertyValue.find(id) }
      # if it's a new record, we can just ignore this (because update will use the correct order)
      if values.first.property
        values.each_with_index do |v, i|
          v.position = i
          v.save
        end
      end
    end

    render :text => ''
  end

  # GET /properties/remove_property_value_dialog
  # params:
  #   property_value_id
  def remove_property_value_dialog
    @pv = PropertyValue.find(params[:property_value_id])
    render :layout => false
  end

  # POST /properties/remove_property_value
  # params:
  #   property_value_id
  #   replace_with
  def remove_property_value
    @pv = PropertyValue.find(params[:property_value_id])

    # check if user can access this property value
    if current_user.company != @pv.property.company
      return render json: {success: false, message: t('flash.alert.access_denied_to_model', model: Property.model_name.human)}
    end

    # if delete directly
    if !params[:replace_with].blank?
      # if replace with another value
      @replace_with = PropertyValue.find(params[:replace_with])
      # check if user can access this property value
      if current_user.company != @replace_with.property.company
        return render json: {success: false, message: t('flash.alert.access_denied_to_model', model: Property.model_name.human)}
      end

      @pv.task_property_values.each {|tpv| @replace_with.task_property_values << tpv}
      @pv.task_filter_qualifiers.each {|tfq| @replace_with.task_filter_qualifiers << tfq}
    end

    # reload is important
    @pv.reload.destroy
    return render :json => { :success => true }
  end

  private

  def update_existing_property_values(property, params)
    return if !property or !params[:property_values]

    property.property_values.each do |pv|
      posted_vals = params[:property_values][pv.id.to_s]
      if posted_vals
        pv.update_attributes(posted_vals)
      else
        property.property_values.delete(pv)
      end
    end
  end

end

# encoding: UTF-8
class CustomAttributesController < ApplicationController
  before_filter :authorize_user_is_admin
  before_filter :check_type_param, only: [ :edit, :update ]

  layout  "admin"

  def index
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title = "#{t('custom_attributes.custom_attributes')} - #{Setting.productName}" 
 content_tag :legend, t('custom_attributes.custom_properties') 
 edit_custom_attribute_link_for('user') 
 edit_custom_attribute_link_for('customer') 
 edit_custom_attribute_link_for('organizational_unit') 
 edit_custom_attribute_link_for('work_log') 
 link_to(TaskRecord.model_name.human(:count => 2), properties_path) 
 link_to(ResourceType.model_name.human(:count => 2), resource_types_path) 

end

  end

  def edit
    @attributes = CustomAttribute.attributes_for(current_user.company, params[:type])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title = "Custom Attributes - #{Setting.productName}" 
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
 params[:type].titleize + " Properties" 
 form_tag({:action => "update"}, :class => "form-horizontal") do 
 hidden_field_tag(:type, params[:type]) 
  dom_id(attribute) 

     preset = attribute.custom_attribute_choices.any?
   
 fields_for(prefix(attribute), attribute) do |f| 
 f.hidden_field :position, :index => attribute.id, :class => "position" 
 f.label :display_name 
 f.text_field :display_name, :index => attribute.id 
 sortable_handle_tag(attribute) 
 link_to_function(t("custom_attributes.remove_attribute"), "jQuery(this).parents('.attribute').remove()", :class => "remove_attribute") 
 f.label :ldap_attribute_type 
 f.text_field :ldap_attribute_type, :index => attribute.id 
 f.label :mandatory 
 f.check_box :mandatory, :index => attribute.id, :class => "nested-checkbox" 
 preset ? "none" : "" 
 f.label :multiple 
 f.check_box :multiple, :index => attribute.id, :class => "nested-checkbox" 
 preset ? "none" : "" 
 f.label :max_length 
 f.text_field :max_length, :index => attribute.id 
 f.label :preset 
 check_box_tag :preset, 1, preset, :class => "preset-checkbox" 
 preset ? "" : "none" 
  fields_for(choice_prefix(choice, attribute), choice) do |cf| 
 t("custom_attributes.choice") 
 cf.text_field(:value) 
 sortable_handle_tag(choice) 
 link_to_function(t("custom_attributes.remove_choice"), "jQuery(this).parents('.choice').remove()", :class => "remove_attribute") 
 t("custom_attributes.color") 
 cf.text_field(:color) 
 cf.hidden_field :position, :class => "position" 
 end 
 
 add_choice_link(attribute) 
 end 
 
 t('button.update') 
 link_to_add_attribute 
 end 

end

  end

  def update
    update_existing_attributes(params)
    create_new_attributes(params) if params[:new_custom_attributes]

    flash[:success] = t('flash.notice.model_updated', model: CustomAttribute.model_name.human)
    redirect_to(action: 'edit', type: params[:type])
  end

  def fields
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 dom_id(attribute) 

     preset = attribute.custom_attribute_choices.any?
   
 fields_for(prefix(attribute), attribute) do |f| 
 f.hidden_field :position, :index => attribute.id, :class => "position" 
 f.label :display_name 
 f.text_field :display_name, :index => attribute.id 
 sortable_handle_tag(attribute) 
 link_to_function(t("custom_attributes.remove_attribute"), "jQuery(this).parents('.attribute').remove()", :class => "remove_attribute") 
 f.label :ldap_attribute_type 
 f.text_field :ldap_attribute_type, :index => attribute.id 
 f.label :mandatory 
 f.check_box :mandatory, :index => attribute.id, :class => "nested-checkbox" 
 preset ? "none" : "" 
 f.label :multiple 
 f.check_box :multiple, :index => attribute.id, :class => "nested-checkbox" 
 preset ? "none" : "" 
 f.label :max_length 
 f.text_field :max_length, :index => attribute.id 
 f.label :preset 
 check_box_tag :preset, 1, preset, :class => "preset-checkbox" 
 preset ? "" : "none" 
  fields_for(choice_prefix(choice, attribute), choice) do |cf| 
 t("custom_attributes.choice") 
 cf.text_field(:value) 
 sortable_handle_tag(choice) 
 link_to_function(t("custom_attributes.remove_choice"), "jQuery(this).parents('.choice').remove()", :class => "remove_attribute") 
 t("custom_attributes.color") 
 cf.text_field(:color) 
 cf.hidden_field :position, :class => "position" 
 end 
 
 add_choice_link(attribute) 
 end 

end
nd

  def choice
    attribute = CustomAttribute.new
    if params[:id]
      attribute = current_user.company.custom_attributes.find(params[:id])
    end

    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 fields_for(choice_prefix(choice, attribute), choice) do |cf| 
 t("custom_attributes.choice") 
 cf.text_field(:value) 
 sortable_handle_tag(choice) 
 link_to_function(t("custom_attributes.remove_choice"), "jQuery(this).parents('.choice').remove()", :class => "remove_attribute") 
 t("custom_attributes.color") 
 cf.text_field(:color) 
 cf.hidden_field :position, :class => "position" 
 end 

end

ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 fields_for(choice_prefix(choice, attribute), choice) do |cf| 
 t("custom_attributes.choice") 
 cf.text_field(:value) 
 sortable_handle_tag(choice) 
 link_to_function(t("custom_attributes.remove_choice"), "jQuery(this).parents('.choice').remove()", :class => "remove_attribute") 
 t("custom_attributes.color") 
 cf.text_field(:color) 
 cf.hidden_field :position, :class => "position" 
 end 

end

  end

  private
  def check_type_param
    redirect_to root_path if params[:type].blank?
  end

  def update_existing_attributes(params)
    attributes = CustomAttribute.attributes_for(current_user.company, params[:type])

    updated = []
    (params[:custom_attributes] || {}).each do |id, values|
      # need to ensure this is set so can delete all
      values[:choice_attributes] ||= {}

      attr = attributes.detect { |ca| ca.id == id.to_i }
      updated << attr

      attr.update_attributes(values)
    end
    missing = attributes - updated
    missing.each { |ca| ca.destroy }
  end

  def create_new_attributes(params)
    attributes = CustomAttribute.attributes_for(current_user.company, params[:type])
    offset = attributes.length

    params[:new_custom_attributes].each_with_index do |values, i|
      values[:attributable_type] = params[:type]
      values[:position] = offset + i
      current_user.company.custom_attributes.create(values)
    end
  end
end

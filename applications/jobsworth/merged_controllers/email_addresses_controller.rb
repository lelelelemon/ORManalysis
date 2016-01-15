# encoding: UTF-8
class EmailAddressesController < ApplicationController
  layout 'admin'

  def index
    @email_addresses = current_user.company.email_addresses.where("user_id IS NULL").order("email ASC").paginate(:page => params[:page], :per_page => 50)
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
 content_tag :legend, t('email_addresses.orphaned') 
 t('email_addresses.select') 
 @email_addresses.each do |ea| 
 link_to ea.email, edit_email_address_path(ea) 
 end 
 will_paginate @email_addresses 

  end

  def create
    # try link orphaned email address first
    @email_address = current_user.company.email_addresses.where(:email => params[:email_address][:email]).where('user_id IS NULL').first
    @email_address ||= EmailAddress.new(params[:email_address])

    # newly added email address can't be default
    @email_address.default = false
    @email_address.company_id = current_user.company_id

    if @email_address.user != current_user and !current_user.admin?
      return render json: {success: false, message: t('flash.alert.unauthorized_operation')}
    end

    # link to orhpaned email address
    if !@email_address.new_record?
      @email_address.link_to_user(params[:email_address][:user_id])
      html = render_to_string :partial => 'email_addresses/email_address', :locals => {:email_address => @email_address}
      return render :json => {:success => true, :html => html}
    end

    if @email_address.save
      html = render_to_string :partial => 'email_addresses/email_address', :locals => {:email_address => @email_address}
      return render :json => {:success => true, :html => html}
    else
      return render :json => {:success => false, :message => @email_address.errors.full_messages.join(', ') }
    end
  end

  def update
    @email_address = current_user.company.email_addresses.find(params[:id])
    @email_address.link_to_user(params[:email_address][:user_id])
    flash[:success] = t('flash.notice.model_attached_to_other',
                        model: EmailAddress.model_name.human,
                        other: User.model_name.human)
    render :edit
  end

  def edit
    @email_address = current_user.company.email_addresses.find(params[:id])
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
 content_tag :legend, t('email_addresses.attach') 
 @email_address.email 
 form_for(@email_address, :html => {:class => "form-inline"}) do 
@email_address.user.nil? ? 0 :@email_address.user.id 
 text_field :user, :name, {
        :id=>"email_attach_user_name",
        :size => 24,
        :value => @email_address.user ? @email_address.user.name : '',
        :autocomplete => "off",
        :title => t('email_addresses.input_title'),
        :rel => "tooltip"
      }
  
 submit_tag t("button.save"), :class => "btn btn-primary" 
 end 

  end

  def destroy
    @email_address = current_user.company.email_addresses.find(params[:id])

    if @email_address.user != current_user and !current_user.admin?
      return render json: {success: false, message: t('flash.alert.unauthorized_operation')}
    end

    if @email_address.default?
      render :json => {success: false, message: t('flash.error.cant_delete_default_model', model: EmailAddress.model_name.human)}
    else
      @email_address.destroy
      render :json => {success: true}
    end
  end

  def default
    @email_address = current_user.company.email_addresses.find(params[:id])

    if @email_address.user != current_user and !current_user.admin?
      return render :json => {:success => false, :message => t('flash.alert.unauthorized_operation')}
    end

    @email_address.user.email_addresses.update_all(:default => false)
    @email_address.update_column(:default, true)

    render :json => {:success => true}
  end
end

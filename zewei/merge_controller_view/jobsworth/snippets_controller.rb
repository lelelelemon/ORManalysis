class SnippetsController < ApplicationController
  before_filter :authorize_user_is_admin, :only => [:index, :new, :edit, :create, :update, :delete]
  before_filter :authenticate_user!, :only => [:show]

  layout "admin"

  def index
    @snippets = current_user.company.snippets.order("position")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @snippets }
    end
  end

  def show
    @snippet = current_user.company.snippets.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @snippet }
    end
  end

  def new
    @snippet = Snippet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @snippet }
    end
  end

  def edit
    @snippet = current_user.company.snippets.find(params[:id])
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
 t("snippets.edit_snippet") 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 form_for(@snippet) do |f| 
 if @snippet.errors.any? 
 t("shared.#{pluralize(@snippet.errors.count, "error")}") 
 t("snippets.error_msg") 
 @snippet.errors.full_messages.each do |msg| 
 msg 
 end 
 end 
 f.label t("snippets.name") 
 f.text_field :name, :class => "required input-xxlarge" 
 f.label t("snippets.body") 
 f.text_area :body, :style => "width:100%;", :class => "required" 
 f.submit :class => "btn btn-primary" 
 unless @snippet.new_record? 
 link_to t("button.delete"), snippet_path(@snippet), :method => "delete", :class => "btn btn-danger", :confirm => t("shared.are_you_sure") 
 end 
 end 

end
 

  end

  def create
    @snippet = Snippet.new(params[:snippet])
    @snippet.company = current_user.company
    @snippet.user = current_user

    respond_to do |format|
      if @snippet.save
        format.html { redirect_to @snippet, notice: t('flash.notice.model_created', model: Snippet.model_name.human) }
        format.json { render json: @snippet, status: :created, location: @snippet }
      else
        format.html { render action: "new" }
        format.json { render json: @snippet.errors, status: :unprocessable_entity }
      end
    end
  end

  def reorder
    params[:snippets].values.each do |snippet|
      t=Snippet.find(snippet[:id])
      t.position=snippet[:position]
      t.save!
    end
    # touch company so that task_form cache is invalidated
    current_user.company.touch
    render :nothing=>true
  end

  def update
    @snippet = current_user.company.snippets.find(params[:id])

    respond_to do |format|
      if @snippet.update_attributes(params[:snippet].slice(:name, :body))
        format.html { redirect_to @snippet, notice: t('flash.notice.model_created', model: Snippet.model_name.human) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @snippet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /snippets/1
  # DELETE /snippets/1.json
  def destroy
    @snippet = current_user.company.snippets.find(params[:id])
    @snippet.destroy

    respond_to do |format|
      format.html { redirect_to snippets_url }
      format.json { head :ok }
    end
  end
end

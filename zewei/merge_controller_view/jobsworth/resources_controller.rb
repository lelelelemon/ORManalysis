# encoding: UTF-8
class ResourcesController < ApplicationController
  before_filter :check_permission

  def new
    @resource = Resource.new
    @resource.customer_id = params[:customer_id]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @resource }
    end
  end

  def show
    redirect_to(params.merge(:action => "edit"))
  end

  def edit
    @resource = current_user.company.resources.find(params[:id])
 @page_title = t("resources.edit_title", title: "#{@resource.name} - #{Setting.productName}") 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 form_for(@resource, :html => {:class => "form-horizontal"}) do |f| 
 if @resource.new_record? 
 t("resources.new") 
 else 
 t("resources.edit") 
 end 
 t("resources.name") 
 f.text_field :name 
 t("resources.company") 
 f.hidden_field(:customer_id, :class => "auto_complete_id")  
 text_field :resource_customer, :name, { :value => @resource.customer } 
 @resource.customer.nil? ? "#" : "/customers/edit/#{@resource.customer.id}" 
 t("resources.parent_resource") 
 text_field :resource, :parent_id, { :size => 15 } 
 t("resources.type") 
 f.select(:resource_type_id, resource_types_options_array, { :include_blank => true }, :onchange => "updateResourceAttributes(this)") 
 t("resources.active") 
 f.check_box :active
 t("resources.notes") 
 f.text_area :notes, :class => "input-xxlarge", :rows => 4 
 t("resources.attributes") 
 @resource.all_attributes.each do |ra| 
 render(:partial => "attribute", :locals => { :attribute => ra }) 
 end 
 cit_submit_tag(@resource) 
 if !@resource.new_record? 
 link_to(t("button.delete"), resource_path(@resource), :method => :delete, :confirm => t("shared.are_you_sure"), :class => "btn btn-danger") 
 end 
 end 

end
 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 t("resources.history") 
 resource.event_logs.each do |log| 
 history_date_if_needed(log) 
 avatar_for(log.user, 25) if log.user 
 tz.utc_to_local(log.started_at).strftime(current_user.time_format) 
 log.user.name 
 log.body.html_safe 
 end 

end
 

  end

  def create
    @resource = Resource.new
    @resource.company = current_user.company

    respond_to do |format|
      if @resource.update_attributes(params[:resource])
        flash[:success] = t('flash.notice.model_created', model: Resource.model_name.human)
        format.html { redirect_to(edit_resource_path(@resource)) }
        format.xml  { render :xml => @resource, :status => :created, :location => @resource }
      else
        flash[:error] = @resource.errors.full_messages.join(". ")
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 @page_title = t("resources.new_title", title: "New Resource - #{Setting.productName}") 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 form_for(@resource, :html => {:class => "form-horizontal"}) do |f| 
 if @resource.new_record? 
 t("resources.new") 
 else 
 t("resources.edit") 
 end 
 t("resources.name") 
 f.text_field :name 
 t("resources.company") 
 f.hidden_field(:customer_id, :class => "auto_complete_id")  
 text_field :resource_customer, :name, { :value => @resource.customer } 
 @resource.customer.nil? ? "#" : "/customers/edit/#{@resource.customer.id}" 
 t("resources.parent_resource") 
 text_field :resource, :parent_id, { :size => 15 } 
 t("resources.type") 
 f.select(:resource_type_id, resource_types_options_array, { :include_blank => true }, :onchange => "updateResourceAttributes(this)") 
 t("resources.active") 
 f.check_box :active
 t("resources.notes") 
 f.text_area :notes, :class => "input-xxlarge", :rows => 4 
 t("resources.attributes") 
 @resource.all_attributes.each do |ra| 
 render(:partial => "attribute", :locals => { :attribute => ra }) 
 end 
 cit_submit_tag(@resource) 
 if !@resource.new_record? 
 link_to(t("button.delete"), resource_path(@resource), :method => :delete, :confirm => t("shared.are_you_sure"), :class => "btn btn-danger") 
 end 
 end 

end
 

end
 }
        format.xml  { render :xml => @resource.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @resource = current_user.company.resources.find(params[:id])
    @resource.attributes = params[:resource]
    @resource.company = current_user.company
    log = log_resource_changes(@resource)

    respond_to do |format|
      if @resource.save
        # BW: not sure why these aren't getting updated automatically
        @resource.resource_attributes.each { |ra| ra.save }
        log.save! if log

        flash[:success] = t('flash.notice.model_updated', model: Resource.model_name.human)
        format.html { redirect_to(edit_resource_path(@resource)) }
        format.xml  { head :ok }
      else
        flash[:error] = @resource.errors.full_messages.join(". ")
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 @page_title = t("resources.edit_title", title: "#{@resource.name} - #{Setting.productName}") 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 form_for(@resource, :html => {:class => "form-horizontal"}) do |f| 
 if @resource.new_record? 
 t("resources.new") 
 else 
 t("resources.edit") 
 end 
 t("resources.name") 
 f.text_field :name 
 t("resources.company") 
 f.hidden_field(:customer_id, :class => "auto_complete_id")  
 text_field :resource_customer, :name, { :value => @resource.customer } 
 @resource.customer.nil? ? "#" : "/customers/edit/#{@resource.customer.id}" 
 t("resources.parent_resource") 
 text_field :resource, :parent_id, { :size => 15 } 
 t("resources.type") 
 f.select(:resource_type_id, resource_types_options_array, { :include_blank => true }, :onchange => "updateResourceAttributes(this)") 
 t("resources.active") 
 f.check_box :active
 t("resources.notes") 
 f.text_area :notes, :class => "input-xxlarge", :rows => 4 
 t("resources.attributes") 
 @resource.all_attributes.each do |ra| 
 render(:partial => "attribute", :locals => { :attribute => ra }) 
 end 
 cit_submit_tag(@resource) 
 if !@resource.new_record? 
 link_to(t("button.delete"), resource_path(@resource), :method => :delete, :confirm => t("shared.are_you_sure"), :class => "btn btn-danger") 
 end 
 end 

end
 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 t("resources.history") 
 resource.event_logs.each do |log| 
 history_date_if_needed(log) 
 avatar_for(log.user, 25) if log.user 
 tz.utc_to_local(log.started_at).strftime(current_user.time_format) 
 log.user.name 
 log.body.html_safe 
 end 

end
 

end
 }
        format.xml  { render :xml => @resource.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @resource = current_user.company.resources.find(params[:id])
    @resource.destroy

    respond_to do |format|
      format.html { redirect_to [:edit, @resource.customer] }
      format.xml  { head :ok }
    end
  end

  def attributes
    type = current_user.company.resource_types.find(params[:type_id])
    rtas = type.resource_type_attributes

    attributes = rtas.map do |rta|
      attr = ResourceAttribute.new
      attr.resource_type_attribute = rta
      attr
    end

    ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 
     field_id = "attribute_#{ attribute.id }" 
     prefix = "resource[attribute_values][]"
     type = attribute.resource_type_attribute
     same_as_last_type = (type == @last_type)
     @last_type = type
  
 field_id 
 type.name 
 hidden_field_tag("#{ prefix }[resource_type_attribute_id]", type.id, :class => "type_id") 
 hidden_field_tag "#{ prefix }[id]", attribute.id, :class => "attr_id" 
 value_field(attribute, prefix, field_id, same_as_last_type) 

end

  end

  def show_password
    resource = current_user.company.resources.find(params[:id])
    @attribute = resource.resource_attributes.find(params[:attr_id])

    body = "Requested password for resource %s - %s" % [resource_path(resource), resource.name]

    el = EventLog.new(:user => current_user,
                     :company => current_user.company,
                     :event_type => EventLog::RESOURCE_PASSWORD_REQUESTED,
                     :body => CGI::escapeHTML(body),
                      :target => resource
                     )
    el.save!
    ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

   name = "resource[attribute_values][][password]"
   id = "attribute_#{ @attribute.id }"


   field = text_field_tag(name, @attribute.password, :id => id, :class => "value",
                           :size => @attribute.resource_type_attribute.default_field_length)


end

  end

  def auto_complete_for_resource_parent_id
    search = params[:term]
    search = search[:parent_id] if search
    @resources = []
    if !search.blank?
      cond = [ "lower(name) like ?", "%#{ search.downcase }%" ]
      @resources = current_user.company.resources.where(cond)
      render :json=> @resources.collect{|resource| {:value => resource.name, :id=> resource.id} }.to_json
    end
  end

  private

  def check_permission
    redirect_to root_path unless current_user.use_resources?
  end

  ###
  # Returns an unsaved event log of any changed attributes in resource.
  # Save the response to add it to the system event log.
  ###
  def log_resource_changes(resource)
    all_changes = resource.changes_as_html
    resource.resource_attributes.each { |ra| all_changes += ra.changes_as_html }

    return if all_changes.empty?

    body = all_changes.join(", ")
    el = EventLog.new(:user => current_user,
                 :company => current_user.company,
                 :event_type => EventLog::RESOURCE_CHANGE,
                 :body => body,
                 :target => @resource
                 )
    return el
  end
end

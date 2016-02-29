# encoding: UTF-8
class OrganizationalUnitsController < ApplicationController
  before_filter :load_customer

  def new
    @org_unit = OrganizationalUnit.new(:customer => @customer)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t("new_title", customer: @org_unit.customer) 
  form_for(@org_unit, :html => {:class => "form-horizontal"}) do |f| 
 f.error_messages 
 f.hidden_field(:customer_id) 
 t("org_units.name") 
 f.text_field :name 
 t("org_units.active") 
 f.check_box :active 
  values = object.all_custom_attribute_values 
 values.each do |value| 
 prefix = "#{ object.class.name.underscore }[set_custom_attribute_values]" 
 ca = value.custom_attribute 
 field_id = custom_attribute_field_id 
 fields_for(prefix, value) do |f| 
 f.hidden_field(:custom_attribute_id, :index => nil) 
 label_tag field_id, value.custom_attribute.display_name 
 if ca and ca.preset? 
 options = objects_to_names_and_ids(ca.custom_attribute_choices, :name_method => :value) 
 options.unshift("") if ca.mandatory? 
 f.select(:choice_id, options, { }, :id => field_id, :index => nil) 
 elsif value.custom_attribute.max_length.to_i >= 100 
 f.text_area(:value, :id => field_id, :index => nil, :class => "input-xxlarge", :rows => 10) 
 else 
 f.text_field(:value, :id => field_id, :index => nil, :class => "value") 
 end 
 multi_links(value) 
 end 
 end 
 
 cit_submit_tag(@org_unit) 
 if !@org_unit.new_record? 
 link_to(t("button.delete"),
	  organizational_unit_path(@org_unit, :customer_id => @org_unit.customer.id),
          :method => :delete, :confirm => t("shared.are_you_sure"), :class => "btn btn-danger") 
 end 
 end 
 

end

  end

  def create
    @org_unit = OrganizationalUnit.new(params[:organizational_unit])
    @org_unit.customer = @customer

    respond_to do |format|
      if @org_unit.save
        flash[:success] = t('flash.notice.model_created', model: OrganizationalUnit.model_name.human)
        format.html { send_to_customer_page }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t("new_title", customer: @org_unit.customer) 
  form_for(@org_unit, :html => {:class => "form-horizontal"}) do |f| 
 f.error_messages 
 f.hidden_field(:customer_id) 
 t("org_units.name") 
 f.text_field :name 
 t("org_units.active") 
 f.check_box :active 
  values = object.all_custom_attribute_values 
 values.each do |value| 
 prefix = "#{ object.class.name.underscore }[set_custom_attribute_values]" 
 ca = value.custom_attribute 
 field_id = custom_attribute_field_id 
 fields_for(prefix, value) do |f| 
 f.hidden_field(:custom_attribute_id, :index => nil) 
 label_tag field_id, value.custom_attribute.display_name 
 if ca and ca.preset? 
 options = objects_to_names_and_ids(ca.custom_attribute_choices, :name_method => :value) 
 options.unshift("") if ca.mandatory? 
 f.select(:choice_id, options, { }, :id => field_id, :index => nil) 
 elsif value.custom_attribute.max_length.to_i >= 100 
 f.text_area(:value, :id => field_id, :index => nil, :class => "input-xxlarge", :rows => 10) 
 else 
 f.text_field(:value, :id => field_id, :index => nil, :class => "value") 
 end 
 multi_links(value) 
 end 
 end 
 
 cit_submit_tag(@org_unit) 
 if !@org_unit.new_record? 
 link_to(t("button.delete"),
	  organizational_unit_path(@org_unit, :customer_id => @org_unit.customer.id),
          :method => :delete, :confirm => t("shared.are_you_sure"), :class => "btn btn-danger") 
 end 
 end 
 

end
 }
      end
    end
  end

  def edit
    @org_unit = @customer.organizational_units.find(params[:id])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t("edit_title", unit: @org_unit) 
  form_for(@org_unit, :html => {:class => "form-horizontal"}) do |f| 
 f.error_messages 
 f.hidden_field(:customer_id) 
 t("org_units.name") 
 f.text_field :name 
 t("org_units.active") 
 f.check_box :active 
  values = object.all_custom_attribute_values 
 values.each do |value| 
 prefix = "#{ object.class.name.underscore }[set_custom_attribute_values]" 
 ca = value.custom_attribute 
 field_id = custom_attribute_field_id 
 fields_for(prefix, value) do |f| 
 f.hidden_field(:custom_attribute_id, :index => nil) 
 label_tag field_id, value.custom_attribute.display_name 
 if ca and ca.preset? 
 options = objects_to_names_and_ids(ca.custom_attribute_choices, :name_method => :value) 
 options.unshift("") if ca.mandatory? 
 f.select(:choice_id, options, { }, :id => field_id, :index => nil) 
 elsif value.custom_attribute.max_length.to_i >= 100 
 f.text_area(:value, :id => field_id, :index => nil, :class => "input-xxlarge", :rows => 10) 
 else 
 f.text_field(:value, :id => field_id, :index => nil, :class => "value") 
 end 
 multi_links(value) 
 end 
 end 
 
 cit_submit_tag(@org_unit) 
 if !@org_unit.new_record? 
 link_to(t("button.delete"),
	  organizational_unit_path(@org_unit, :customer_id => @org_unit.customer.id),
          :method => :delete, :confirm => t("shared.are_you_sure"), :class => "btn btn-danger") 
 end 
 end 
 

end

  end

  def update
    @org_unit = @customer.organizational_units.find(params[:id])

    respond_to do |format|
      if @org_unit.update_attributes(params[:organizational_unit])
        flash[:success] = t('flash.notice.model_updated', model: OrganizationalUnit.model_name.human)
        @org_unit.update_attribute(:customer_id, @customer.id)
        format.html { send_to_customer_page }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t("edit_title", unit: @org_unit) 
  form_for(@org_unit, :html => {:class => "form-horizontal"}) do |f| 
 f.error_messages 
 f.hidden_field(:customer_id) 
 t("org_units.name") 
 f.text_field :name 
 t("org_units.active") 
 f.check_box :active 
  values = object.all_custom_attribute_values 
 values.each do |value| 
 prefix = "#{ object.class.name.underscore }[set_custom_attribute_values]" 
 ca = value.custom_attribute 
 field_id = custom_attribute_field_id 
 fields_for(prefix, value) do |f| 
 f.hidden_field(:custom_attribute_id, :index => nil) 
 label_tag field_id, value.custom_attribute.display_name 
 if ca and ca.preset? 
 options = objects_to_names_and_ids(ca.custom_attribute_choices, :name_method => :value) 
 options.unshift("") if ca.mandatory? 
 f.select(:choice_id, options, { }, :id => field_id, :index => nil) 
 elsif value.custom_attribute.max_length.to_i >= 100 
 f.text_area(:value, :id => field_id, :index => nil, :class => "input-xxlarge", :rows => 10) 
 else 
 f.text_field(:value, :id => field_id, :index => nil, :class => "value") 
 end 
 multi_links(value) 
 end 
 end 
 
 cit_submit_tag(@org_unit) 
 if !@org_unit.new_record? 
 link_to(t("button.delete"),
	  organizational_unit_path(@org_unit, :customer_id => @org_unit.customer.id),
          :method => :delete, :confirm => t("shared.are_you_sure"), :class => "btn btn-danger") 
 end 
 end 
 

end
 }
      end
    end
  end

  def destroy
    @org_unit = @customer.organizational_units.find(params[:id])
    @org_unit.destroy

    respond_to do |format|
      format.html { send_to_customer_page }
      format.xml  { head :ok }
    end
  end

  private

  def load_customer
    id = params[:customer_id]
    id ||= params[:organizational_unit][:customer_id] if params[:organizational_unit]

    if id
      @customer ||= current_user.company.customers.find(id)
    else
      org_unit = OrganizationalUnit.find(params[:id])
      if current_user.company.customers.include?(org_unit.customer)
        @customer = org_unit.customer
      end
    end
  end

  def send_to_customer_page
    redirect_to(:id => @customer.id, :action => "edit",
                :controller => "customers", :anchor => "organizational_units")
  end
end

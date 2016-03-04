class Admin::CustomFieldsController < ApplicationController

  before_filter :ensure_is_admin
  before_filter :field_type_is_valid, :only => [:new, :create]

  def index
    @selected_left_navi_link = "listing_fields"
    @community = @current_community
    @custom_fields = @current_community.custom_fields

    shapes = listings_api.shapes.get(community_id: @community.id).data
    price_in_use = shapes.any? { |s| s[:price_enabled] }

    render locals: { show_price_filter: price_in_use }
  end

  def new
    @selected_left_navi_link = "listing_fields"
    @community = @current_community
    @custom_field = params[:field_type].constantize.new #before filter checks valid field types and prevents code injection

    if params[:field_type] == "CheckboxField"
      @min_option_count = 1
      @custom_field.options = [CustomFieldOption.new(sort_priority: 1)]
    else
      @min_option_count = 2
      @custom_field.options = [CustomFieldOption.new(sort_priority: 1), CustomFieldOption.new(sort_priority: 2)]
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :javascript do 
 end 
 content_for :title_header do 
 t("layouts.admin.admin") 
 "-" 
 t("admin.custom_fields.new.new_listing_field") 
 end 
  
 form_for @custom_field, :as => :custom_field, :url => admin_custom_fields_path(:field_type => @custom_field.type) do |form| 
  form.label :name_attributes, t("admin.custom_fields.index.field_title") 
 available_locales.each do |locale_name, locale_value| 
 if available_locales.size > 1 
 label_tag "custom_field[name_attributes][#{locale_value}]", locale_name + ": ", :class => "new-field-name-locale-label" 
 end 
 text_field_tag "custom_field[name_attributes][#{locale_value}]", @custom_field.name(locale_value), :class => "new-field-name-locale-text-field required" 
 end 
 
 end 

end

  end

  def create
    @selected_left_navi_link = "listing_fields"
    @community = @current_community

    # Hack for comma/dot issue. Consider creating an app-wide comma/dot handling mechanism
    params[:custom_field][:min] = ParamsService.parse_float(params[:custom_field][:min]) if params[:custom_field][:min].present?
    params[:custom_field][:max] = ParamsService.parse_float(params[:custom_field][:max]) if params[:custom_field][:max].present?

    @custom_field = params[:field_type].constantize.new(params[:custom_field]) #before filter checks valid field types and prevents code injection
    @custom_field.community = @current_community

    success = if valid_categories?(@current_community, params[:custom_field][:category_attributes])
      @custom_field.save
    end

    if success
      redirect_to admin_custom_fields_path
    else
      flash[:error] = "Listing field saving failed"
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :javascript do 
 end 
 content_for :title_header do 
 t("layouts.admin.admin") 
 "-" 
 t("admin.custom_fields.new.new_listing_field") 
 end 
  
 form_for @custom_field, :as => :custom_field, :url => admin_custom_fields_path(:field_type => @custom_field.type) do |form| 
  form.label :name_attributes, t("admin.custom_fields.index.field_title") 
 available_locales.each do |locale_name, locale_value| 
 if available_locales.size > 1 
 label_tag "custom_field[name_attributes][#{locale_value}]", locale_name + ": ", :class => "new-field-name-locale-label" 
 end 
 text_field_tag "custom_field[name_attributes][#{locale_value}]", @custom_field.name(locale_value), :class => "new-field-name-locale-text-field required" 
 end 
 
 end 

end

    end
  end

  def edit
    @selected_tribe_navi_tab = "admin"
    @selected_left_navi_link = "listing_fields"
    @community = @current_community

    if params[:field_type] == "CheckboxField"
      @min_option_count = 1
    else
      @min_option_count = 2
    end

    @custom_field = CustomField.find(params[:id])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :javascript do 
 end 
 content_for :title_header do 
 t("layouts.admin.admin") 
 "-" 
 t("admin.custom_fields.edit.edit_listing_field", :field_name => @custom_field.name(I18n.locale)) 
 end 
  
 form_for @custom_field, :as => :custom_field, :url => admin_custom_field_path(@custom_field), :method => :put do |form| 
  form.label :name_attributes, t("admin.custom_fields.index.field_title") 
 available_locales.each do |locale_name, locale_value| 
 if available_locales.size > 1 
 label_tag "custom_field[name_attributes][#{locale_value}]", locale_name + ": ", :class => "new-field-name-locale-label" 
 end 
 text_field_tag "custom_field[name_attributes][#{locale_value}]", @custom_field.name(locale_value), :class => "new-field-name-locale-text-field required" 
 end 
 
 end 

end

  end

  def update
    @custom_field = CustomField.find(params[:id])

    # Hack for comma/dot issue. Consider creating an app-wide comma/dot handling mechanism
    params[:custom_field][:min] = ParamsService.parse_float(params[:custom_field][:min]) if params[:custom_field][:min].present?
    params[:custom_field][:max] = ParamsService.parse_float(params[:custom_field][:max]) if params[:custom_field][:max].present?

    @custom_field.update_attributes(params[:custom_field])

    redirect_to admin_custom_fields_path
  end

  def edit_price
    @selected_tribe_navi_tab = "admin"
    @selected_left_navi_link = "listing_fields"
    @community = @current_community
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :title_header do 
 t("layouts.admin.admin") 
 "-" 
 t(".edit_price_field") 
 end 
 content_for :extra_javascript do 
 end 
  
 form_for @community, :as => :community, :url => update_price_admin_custom_fields_path, :method => :put do |form| 
 min = MoneyUtil.to_units(MoneyUtil.to_money(@current_community.price_filter_min, @current_community.default_currency)) || 0 
 max = MoneyUtil.to_units(MoneyUtil.to_money(@current_community.price_filter_max, @current_community.default_currency)) || 100000 
 form.check_box :show_price_filter 
 form.label :show_price_filter, t(".show_price_filter_homepage") 
 form.label "community[price_filter_min]", t(".price_min") 
 text_field_tag "community[price_filter_min]", min, :class => "required number-no-decimals" 
 form.label "community[price_filter_max]", t(".price_max") 
 text_field_tag "community[price_filter_max]", max, :class => "required number-no-decimals" 
  icon_tag("information") 
 text 
 
  form.button t("admin.custom_fields.index.save") 
 admin_custom_fields_path 
 t("admin.custom_fields.index.cancel") 
 
 end 

end

  end

  def edit_location
    @selected_tribe_navi_tab = "admin"
    @selected_left_navi_link = "listing_fields"
    @community = @current_community
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :title_header do 
 t("layouts.admin.admin") 
 "-" 
 t(".edit_location_field") 
 end 
  
 form_for @community, :as => :community, :url => update_location_admin_custom_fields_path, :method => :put do |form| 
 form.check_box :listing_location_required 
 form.label :listing_location_required, t(".this_field_is_required") 
  form.button t("admin.custom_fields.index.save") 
 admin_custom_fields_path 
 t("admin.custom_fields.index.cancel") 
 
 end 

end

  end

  def update_price
    # To cents
    params[:community][:price_filter_min] = MoneyUtil.parse_str_to_money(params[:community][:price_filter_min], @current_community.default_currency).cents if params[:community][:price_filter_min]
    params[:community][:price_filter_max] = MoneyUtil.parse_str_to_money(params[:community][:price_filter_max], @current_community.default_currency).cents if params[:community][:price_filter_max]

    success = @current_community.update_attributes(params[:community])

    if success
      redirect_to admin_custom_fields_path
    else
      flash[:error] = "Price field editing failed"
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :title_header do 
 t("layouts.admin.admin") 
 "-" 
 t(".edit_price_field") 
 end 
 content_for :extra_javascript do 
 end 
  
 form_for @community, :as => :community, :url => update_price_admin_custom_fields_path, :method => :put do |form| 
 min = MoneyUtil.to_units(MoneyUtil.to_money(@current_community.price_filter_min, @current_community.default_currency)) || 0 
 max = MoneyUtil.to_units(MoneyUtil.to_money(@current_community.price_filter_max, @current_community.default_currency)) || 100000 
 form.check_box :show_price_filter 
 form.label :show_price_filter, t(".show_price_filter_homepage") 
 form.label "community[price_filter_min]", t(".price_min") 
 text_field_tag "community[price_filter_min]", min, :class => "required number-no-decimals" 
 form.label "community[price_filter_max]", t(".price_max") 
 text_field_tag "community[price_filter_max]", max, :class => "required number-no-decimals" 
  icon_tag("information") 
 text 
 
  form.button t("admin.custom_fields.index.save") 
 admin_custom_fields_path 
 t("admin.custom_fields.index.cancel") 
 
 end 

end

    end
  end

  def update_location
    success = @current_community.update_attributes(params[:community])

    if success
      redirect_to admin_custom_fields_path
    else
      flash[:error] = "Location field editing failed"
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :title_header do 
 t("layouts.admin.admin") 
 "-" 
 t(".edit_location_field") 
 end 
  
 form_for @community, :as => :community, :url => update_location_admin_custom_fields_path, :method => :put do |form| 
 form.check_box :listing_location_required 
 form.label :listing_location_required, t(".this_field_is_required") 
  form.button t("admin.custom_fields.index.save") 
 admin_custom_fields_path 
 t("admin.custom_fields.index.cancel") 
 
 end 

end

    end
  end

  def destroy
    @custom_field = CustomField.find(params[:id])

    success = if custom_field_belongs_to_community?(@custom_field, @current_community)
      @custom_field.destroy
    end

    flash[:error] = "Field doesn't belong to current community" unless success
    redirect_to admin_custom_fields_path
  end

  def order
    sort_priorities = params[:order].each_with_index.map do |custom_field_id, index|
      [custom_field_id, index]
    end.inject({}) do |hash, ids|
      custom_field_id, sort_priority = ids
      hash.merge(custom_field_id.to_i => sort_priority)
    end

    @current_community.custom_fields.each do |custom_field|
      custom_field.update_attributes(:sort_priority => sort_priorities[custom_field.id])
    end

    render nothing: true, status: 200
  end

  private

  # Return `true` if all the category id's belong to `community`
  def valid_categories?(community, category_attributes)
    is_community_category = category_attributes.map do |category|
      community.categories.any? { |community_category| community_category.id == category[:category_id].to_i }
    end

    is_community_category.all?
  end

  def custom_field_belongs_to_community?(custom_field, community)
    community.custom_fields.include?(custom_field)
  end

  private

  def field_type_is_valid
    redirect_to admin_custom_fields_path unless CustomField::VALID_TYPES.include?(params[:field_type])
  end

  def listings_api
    ListingService::API::Api
  end

end

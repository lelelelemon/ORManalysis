class Admin::CategoriesController < ApplicationController

  before_filter :ensure_is_admin

  def index
    @selected_left_navi_link = "listing_categories"
    @categories = @current_community.top_level_categories.includes(:translations, children: :translations)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :title_header do 
 t("layouts.admin.admin") 
 "-" 
 t(".listing_categories") 
 end 
 content_for :javascript do 
 end 
  
  
 icon_class("loading") 
 t(".saving_order") 
 icon_class("check") 
 t(".save_order_successful") 
 t(".save_order_error") 
 link_to t(".create_a_new_category"), new_admin_category_path 

end

  end

  def new
    @selected_left_navi_link = "listing_categories"
    @category = Category.new
    shapes = get_shapes
    selected_shape_ids = shapes.map { |s| s[:id] } # all selected by defaults
    render locals: { shapes: shapes, selected_shape_ids: selected_shape_ids }
  end

  def create
    @selected_left_navi_link = "listing_categories"
    @category = Category.new(params[:category].except(:listing_shapes))
    @category.community = @current_community
    @category.parent_id = nil if params[:category][:parent_id].blank?
    @category.sort_priority = Admin::SortingService.next_sort_priority(@current_community.categories)
    shapes = get_shapes
    selected_shape_ids = shape_ids_from_params(params)

    if @category.save
      update_category_listing_shapes(selected_shape_ids, @category)
      redirect_to admin_categories_path
    else
      flash[:error] = "Category saving failed"
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :javascript do 
 end 
 content_for :title_header do 
 t("layouts.admin.admin") 
 "-" 
 t(".new_listing_category") 
 end 
  
 form_for [:admin, @category] do |form| 
  form.label :name_attributes, t(".category_title") 
 available_locales.each do |locale_name, locale_value| 
 if available_locales.size > 1 
 label_tag "category[translation_attributes][#{locale_value}][name]", locale_name + ": ", :class => "new-category-name-locale-label" 
 end 
 text_field_tag "category[translation_attributes][#{locale_value}][name]", @category.display_name(locale_value), :class => "required" 
 end 
 
 end 

end

    end
  end

  def edit
    @selected_left_navi_link = "listing_categories"
    @category = @current_community.categories.find_by_url_or_id(params[:id])
    shapes = get_shapes
    selected_shape_ids = CategoryListingShape.where(category_id: @category.id).map(&:listing_shape_id)
    render locals: { shapes: shapes, selected_shape_ids: selected_shape_ids }
  end

  def update
    @selected_left_navi_link = "listing_categories"
    @category = @current_community.categories.find_by_url_or_id(params[:id])
    shapes = get_shapes
    selected_shape_ids = shape_ids_from_params(params)

    if @category.update_attributes(params[:category].except(:listing_shapes))
      update_category_listing_shapes(selected_shape_ids, @category)
      redirect_to admin_categories_path
    else
      flash[:error] = "Category saving failed"
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :javascript do 
 end 
 content_for :title_header do 
 t("layouts.admin.admin") 
 "-" 
 t(".edit_listing_category", :category => @category.display_name(I18n.locale)) 
 end 
  
 form_for [:admin, @category] do |form| 
  form.label :name_attributes, t(".category_title") 
 available_locales.each do |locale_name, locale_value| 
 if available_locales.size > 1 
 label_tag "category[translation_attributes][#{locale_value}][name]", locale_name + ": ", :class => "new-category-name-locale-label" 
 end 
 text_field_tag "category[translation_attributes][#{locale_value}][name]", @category.display_name(locale_value), :class => "required" 
 end 
 
 end 

end

    end
  end

  def order
    sort_priorities = params[:order]
                      .reject { |o| !o.match /[0-9]+/} #Guard against sql injection
                      .each_with_index
                      .map do |category_id, index|
      [category_id, index]
    end.inject({}) do |hash, ids|
      category_id, sort_priority = ids
      hash.merge(category_id.to_i => sort_priority)
    end

    #Guard against updates to wrong communities
    category_ids = @current_community.categories.pluck(:id)
    to_update = sort_priorities.select { |id, _| category_ids.include?(id) }

    # Optimize for marketplaces with large number of categories to sort
    ActiveRecord::Base.connection.execute(order_sql(to_update))

    render nothing: true, status: 200
  end

  # Remove form
  def remove
    @selected_left_navi_link = "listing_categories"
    @category = @current_community.categories.find_by_url_or_id(params[:id])
    @possible_merge_targets = Admin::CategoryService.merge_targets_for(@current_community.categories, @category)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :title_header do 
 t("layouts.admin.admin") 
 "-" 
 t(".remove_category") 
 end 
  
 t('.remove_category_name', category_name: @category.display_name(I18n.locale)) 
 icon_tag("alert", ["icon-fix"]) 
 t('.warning_remove_effects', category_name: @category.display_name(I18n.locale)) 
 prefix = @category.has_subcategories? ? '.warning_with_subcategories_' : '.warning_' 
 if @category.has_subcategories? 
 count = @category.subcategories.count 
 t('.warning_subcategory_will_be_removed', count: count) 
 end 
 if @category.has_own_or_subcategory_listings? 
 count = @category.own_and_subcategory_listings.count 
 t(prefix + 'listing_will_be_moved', count: count) 
 end 
 if @category.has_own_or_subcategory_custom_fields? 
 count = @category.own_and_subcategory_custom_fields.count 
 t(prefix + 'custom_field_will_be_moved', count: count) 
 end 
 form_tag('destroy_and_move', :method => :delete) do 
 if @category.has_own_or_subcategory_listings? || @category.has_own_or_subcategory_custom_fields? 
 t('.select_new_category') 
 select_tag "new_category", options_for_select(@possible_merge_targets.collect { |c| [c.display_name(I18n.locale), c.id] }) 
 end 
 button_tag t(".buttons.remove"), :class => "delete-button" 
 admin_categories_path 
 t(".buttons.cancel") 
 end 

end

  end

  # Remove action
  def destroy
    @category = @current_community.categories.find_by_url_or_id(params[:id])
    @category.destroy
    redirect_to admin_categories_path
  end

  def destroy_and_move
    @category = @current_community.categories.find_by_url_or_id(params[:id])
    new_category = @current_community.categories.find_by_url_or_id(params[:new_category])

    if new_category
      # Move listings
      @category.own_and_subcategory_listings.update_all(:category_id => new_category.id)

      # Move custom fields
      Admin::CategoryService.move_custom_fields!(@category, new_category)
    end

    @category.destroy

    redirect_to admin_categories_path
  end

  private

  ##
  # Builds the following for category ids and corresponding priorities:
  # UPDATE categories
  #    SET sort_priority = CASE id
  #                          WHEN 1 THEN 0
  #                          WHEN 2 THEN 1
  #                            .
  #                            .
  #                            .
  #                       END
  #  WHERE id IN(1, 2, ...);
  ##
  def order_sql(sort_priorities)
    base = "UPDATE categories
              SET sort_priority = CASE id\n"

    update_statements = sort_priorities.reduce(base) do |sql, (cat_id, priority)|
      sql + "WHEN #{cat_id} THEN #{priority}\n"
    end

    update_statements + "END\n WHERE id IN (#{sort_priorities.keys.join(",")});"
  end

  def update_category_listing_shapes(shape_ids, category)
    shapes = ListingService::API::Api.shapes.get(community_id: @current_community.id)[:data]
    selected_shapes = shapes.select { |s| shape_ids.include? s[:id] }

    raise ArgumentError.new("No shapes selected for category #{category.id}, shape_ids: #{shape_ids}") if selected_shapes.empty?

    CategoryListingShape.delete_all(category_id: category.id)

    selected_shapes.each { |s|
      CategoryListingShape.create!(category_id: category.id, listing_shape_id: s[:id])
    }
  end

  def shape_ids_from_params(params)
    params[:category][:listing_shapes].map { |s_param| s_param[:listing_shape_id].to_i }
  end

  def get_shapes
    ListingService::API::Api.shapes.get(community_id: @current_community.id).maybe.or_else(nil).tap { |shapes|
      raise ArgumentError.new("Cannot find any shapes for community #{@current_community.id}") if shapes.nil?
    }
  end

end

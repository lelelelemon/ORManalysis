class ProductsController < ApplicationController

  def index
    products = Product.active.includes(:variants)

    product_types = nil
    if params[:product_type_id].present? && product_type = ProductType.find_by_id(params[:product_type_id])
      product_types = product_type.self_and_descendants.map(&:id)
    end
    if product_types
      @products = products.where(product_type_id: product_types).
                           paginate(page: pagination_page, per_page: pagination_rows)
    else
      @products = products.paginate(page: pagination_page, per_page: pagination_rows)
    end
 
 content_for?(:title) ? "#{site_name}: #{yield(:title)}" : site_name 
 stylesheet_link_tag "normalize.css" 
 stylesheet_link_tag "application.css" 
 stylesheet_link_tag 'site/app.css' 
 stylesheet_link_tag('ie.css', media: 'screen, projection')
 stylesheet_link_tag('ie6.css', media: 'screen, projection') 
 csrf_meta_tag 
 yield :head 
 render 'shared/metadata' 
 render partial: '/shared/welcome_header'
 if notice || alert 
 !!alert ? 'alert' : 'warning' 
 if alert 
 alert 
 elsif notice 
 notice 
 end 
 end 
 "myaccount" if myaccount_tab 
 if myaccount_tab 
 site_name 
 render :partial => '/shared/myaccount_subheader' 
 end 
 yield 
 render 'shared/main_footer' 
 render 'shared/google_analytics' unless @disable_ga 
 javascript_include_tag 'application' 
 yield :bottom 
 yield :below_body 

 content_for :head do 
 stylesheet_link_tag 'products_page.css' 
 end 
 @products.each_with_index do |product, i| 
 i 
 link_to product_path(product), title: product.name do 
 if product.hero_variant.try(:low_stock?) 
 image_tag("ribbons/#{product.stock_status}.png",
                                 width: 63, height: 62,
                                 class: 'upper_left_overlay' ) 
 end 
 number_to_currency product.price_range.first 
 if product.price_range? 
 number_to_currency product.price_range.last 
 end 
 link_to image_tag(product.featured_image(:medium)), product_path(product), title: product.name, class:  'clearfix' 
 end 
 product.name 
 end 
 will_paginate @products 
 image_tag "logos/#{Image::MAIN_LOGO}.png", :alt => 'hadean image.'

 end

  def create
    if params[:q] && params[:q].present?
      @products = Product.standard_search(params[:q]).results
    else
      @products = Product.where('deleted_at IS NULL OR deleted_at > ?', Time.zone.now )
    end

    render :template => '/products/index'
 
 content_for?(:title) ? "#{site_name}: #{yield(:title)}" : site_name 
 stylesheet_link_tag "normalize.css" 
 stylesheet_link_tag "application.css" 
 stylesheet_link_tag 'site/app.css' 
 stylesheet_link_tag('ie.css', media: 'screen, projection')
 stylesheet_link_tag('ie6.css', media: 'screen, projection') 
 csrf_meta_tag 
 yield :head 
 render 'shared/metadata' 
 render partial: '/shared/welcome_header'
 if notice || alert 
 !!alert ? 'alert' : 'warning' 
 if alert 
 alert 
 elsif notice 
 notice 
 end 
 end 
 "myaccount" if myaccount_tab 
 if myaccount_tab 
 site_name 
 render :partial => '/shared/myaccount_subheader' 
 end 
 yield 
 render 'shared/main_footer' 
 render 'shared/google_analytics' unless @disable_ga 
 javascript_include_tag 'application' 
 yield :bottom 
 yield :below_body 

 content_for :head do 
 stylesheet_link_tag 'products_page.css' 
 end 
 @products.each_with_index do |product, i| 
 i 
 link_to product_path(product), title: product.name do 
 if product.hero_variant.try(:low_stock?) 
 image_tag("ribbons/#{product.stock_status}.png",
                                 width: 63, height: 62,
                                 class: 'upper_left_overlay' ) 
 end 
 number_to_currency product.price_range.first 
 if product.price_range? 
 number_to_currency product.price_range.last 
 end 
 link_to image_tag(product.featured_image(:medium)), product_path(product), title: product.name, class:  'clearfix' 
 end 
 product.name 
 end 
 will_paginate @products 
 image_tag "logos/#{Image::MAIN_LOGO}.png", :alt => 'hadean image.'

 end

  def show
    @product = Product.friendly.active.find(params[:id])
    form_info
    @cart_item.variant_id = @product.active_variants.first.try(:id)
 
 content_for?(:title) ? "#{site_name}: #{yield(:title)}" : site_name 
 stylesheet_link_tag "normalize.css" 
 stylesheet_link_tag "application.css" 
 stylesheet_link_tag 'site/app.css' 
 stylesheet_link_tag('ie.css', media: 'screen, projection')
 stylesheet_link_tag('ie6.css', media: 'screen, projection') 
 csrf_meta_tag 
 yield :head 
 render 'shared/metadata' 
 render partial: '/shared/welcome_header'
 if notice || alert 
 !!alert ? 'alert' : 'warning' 
 if alert 
 alert 
 elsif notice 
 notice 
 end 
 end 
 "myaccount" if myaccount_tab 
 if myaccount_tab 
 site_name 
 render :partial => '/shared/myaccount_subheader' 
 end 
 yield 
 render 'shared/main_footer' 
 render 'shared/google_analytics' unless @disable_ga 
 javascript_include_tag 'application' 
 yield :bottom 
 yield :below_body 

 content_for :head do 
 stylesheet_link_tag 'product_page.css' 
 end 
 if @product.active_variants.empty? 
 else 
 if @product.images.size >= 1 
@product.name 
 @product.images.each_with_index do |image, i|
 'is-active' if i == 0 
 image_tag(image.photo.url(:large)) 
 image.caption || @product.name 
 end 
 @product.images.each_with_index do |image, i|
 'is-active' if i == 0 
 i 
 i 
 i 
 if i == 0 
 end 
 end 
 elsif @product.images.size == 0 
 image_tag(@product.featured_image(:large)) 
 end 
 @product.name 
 if @product.active_variants.count > 0 
 number_to_currency @product.active_variants.first.price 
 @product.active_variants.each_with_index do |variant, i| 
 variant.id 
 'secondary' if i != 0 
 'selected_variant success' if i == 0 
 variant.id 
 raw variant.product_name 
 end 
 form_for  @cart_item,
                                  :url  => shopping_cart_items_path(@cart_item),
                                  :html => { :id => 'new_cart_item', :class => 'custom' } do |f| 
 f.hidden_field :variant_id 
 f.select :quantity, [1,2,3,4], { include_blank: false }, { class: ' ' } 
 unless @product.active_variants.empty? 
 link_to 'Add to Cart', '#', id: 'submit_add_to_cart', class: 'small button' 
 end 
 end 
 @product.active_variants.each_with_index do |variant, i| 
 if variant.low_stock? || variant.sold_out? 
 variant.id 
 'is-hidden' if i != 0 
 image_tag("ribbons/#{variant.stock_status}_upper_right.png",
                                      :width => 63, :height => 62,
                                      :style => 'border:none;',
                                      :class => 'upper_right_overlay float-right'
                                       ) 
 if variant.sold_out? && (!current_user || !current_user.requested_to_be_notified?(variant.id)) 
 if current_user 
 link_to 'Notify me', notification_path(variant), data: { confirm: 'Click OK and you will get an email when this product is back in stock.' }, class: 'button tiny alert', style: 'margin-top:15px;', method: :put 
 else 
 link_to 'Notify me', '#', disabled: true, class: 'button tiny disabled', style: 'margin-top:15px;' 
 end 
 elsif variant.sold_out? && (current_user && current_user.requested_to_be_notified?(variant.id)) 
 end 
 end 
 end 
 raw @product.description 
 @product.active_variants.each_with_index do |var, i| 
 var.id 
 'is-hidden' if i != 0 
 if var.low_stock? || var.sold_out? 
 var.id 
 'is-hidden' if i != 0 
 image_tag("ribbons/#{var.stock_status}_upper_right.png",
                                        :width => 63, :height => 62,
                                        :style => 'border:none;',
                                        :class => 'upper_right_overlay float-right'
                                         ) 
 end 
 var.variant_properties.each do |prop| 
 prop.property_name 
 prop.description 
 end 
 if var.sold_out? && (!current_user || !current_user.requested_to_be_notified?(var.id)) 
 if current_user 
 link_to 'Notify me', notification_path(var), data: { confirm: 'Click OK and you will get an email when this product is back in stock.' }, class: 'button tiny alert', style: 'margin-top:15px;', method: :put 
 else 
 link_to 'Notify me', '#', disabled: true, class: 'button tiny', style: 'margin-top:15px;' 
 end 
 end 
 end 
 end 
 end 
 content_for :below_body do 
 javascript_include_tag 'shopping/cart.js' 
 javascript_include_tag 'product_page.js' 
 end 

 end

  private

  def form_info
    @cart_item = CartItem.new
  end

  def featured_product_types
    [ProductType::FEATURED_TYPE_ID]
  end

  def pagination_rows
    params[:rows] ||= 60
    params[:rows].to_i
  end
end

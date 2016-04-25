class Admin::ProductsController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'

  def index
    clean_drafts
    @products = Product.active.load
    @categories = Category.joins(:products).group('categories.id').all
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 'Products' 
 "- #{Store.settings.name} Administration" 
 csrf_meta_tag 
 include_gon(watch: true) 
 stylesheet_link_tag :administration, "data-turbolinks-track" => true 
 javascript_include_tag "modernizr/modernizr" 
 javascript_include_tag :administration, "data-turbolinks-track" => true 
 yield :header 
  link_to admin_root_path do 
 end 
 link_to admin_categories_path do 
 end 
 link_to admin_products_path do 
 end 
 link_to admin_accessories_path do 
 end 
 link_to admin_orders_path do 
 end 
 link_to admin_delivery_services_path do 
 end 
 link_to admin_pages_path do 
 end 
 link_to root_path, target: '_blank' do 
 end 
 link_to admin_settings_path do 
 end 
 
  if Store.settings.attachment.nil? 
 image_tag 'fallback/square/default.png', width: 60, height: 60 
 else 
 image_tag Store.settings.attachment.file.square, width: 60, height: 60 
 end 
 if current_user.attachment.nil? 
 image_tag 'fallback/square/default.png', 'data-toggle' => 'dropdown', width: 40, height: 40, href: '#' 
 else  
 image_tag current_user.attachment.file.square, 'data-toggle' => 'dropdown', width: 40, height: 40, href: '#' 
 end 
 link_to admin_profile_path do 
 end 
 link_to destroy_user_session_path, method: :delete do 
 end 
 
  active_controller?(controller: 'admin/admin', action: 'dashboard') 
 link_to admin_root_path, 'data-toggle' => 'tooltip', 'data-placement' => 'right', 'data-original-title' => 'Dashboard' do 
 end 
 active_controller?(controller: 'admin/categories') 
 link_to admin_categories_path, 'data-toggle' => 'tooltip', 'data-placement' => 'right', 'data-original-title' => 'Categories' do 
 end 
 active_controller?(controller: 'admin/products') 
 active_controller?(controller: 'admin/products/stock') 
 link_to admin_products_path, 'data-toggle' => 'tooltip', 'data-placement' => 'right', 'data-original-title' => 'Products' do 
 end 
 active_controller?(controller: 'admin/accessories') 
 link_to admin_accessories_path, 'data-toggle' => 'tooltip', 'data-placement' => 'right', 'data-original-title' => 'Accessories' do 
 end 
 active_controller?(controller: 'admin/orders') 
 link_to admin_orders_path, 'data-toggle' => 'tooltip', 'data-placement' => 'right', 'data-original-title' => 'Orders' do 
 end 
 active_controller?(controller: 'admin/delivery_services') 
 active_controller?(controller: 'admin/delivery_service_prices') 
 link_to admin_delivery_services_path, 'data-toggle' => 'tooltip', 'data-placement' => 'right', 'data-original-title' => 'Delivery' do 
 end 
 active_controller?(controller: 'admin/pages') 
 link_to admin_pages_path, 'data-toggle' => 'tooltip', 'data-placement' => 'right', 'data-original-title' => 'Pages' do 
 end 
 link_to root_path, 'data-toggle' => 'tooltip', 'data-placement' => 'right', 'data-original-title' => 'Storefront', target: '_blank' do 
 end 
 active_controller?(controller: 'admin/admin', action: 'settings') 
 link_to admin_settings_path, 'data-toggle' => 'tooltip', 'data-placement' => 'right', 'data-original-title' => 'Settings' do 
 end 
 
  
 render_flash 
 render_breadcrumbs 0 
  
 content_for :breadcrumb, 'Products' 
 link_to new_admin_product_path, :class => "btn btn-blue btn-large", "data-placement" => "bottom", "data-toggle" => "tooltip", title: "Add product" do 
 end 
 link_to admin_products_stock_index_path, :class => "btn btn-blue btn-large", "data-placement" => "bottom", "data-toggle" => "tooltip", title: "Stock management" do 
 end 
 @categories.each do |category| 
 category.slug 
 category.name 
 end 
 if @products.empty? 
 else 
 @products.each do |product| 
 product_filter_classes(product) 
 product.slug 
 product.order_count 
 product.weighting 
 product.sku 
 product.part_number 
 product.name 
 product.skus.active.each do |sku| 
 render_variants(sku) 
 Store::Price.new(price: sku.price, tax_type: 'net').single 
 Store::Price.new(price: sku.price, tax_type: 'gross').single 
 end 
 table_actions [:admin, product], 'edit', 'delete' 
 end 
 end 
 yield :footer 

end

  end

  def new
    get_associations
    @product = Product.new
    @product.save(validate: false)
    redirect_to edit_admin_product_path(@product)
  end

  def edit
    get_associations
    set_product
    set_skus
    set_attachments
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 'Edit product' 
 "- #{Store.settings.name} Administration" 
 csrf_meta_tag 
 include_gon(watch: true) 
 stylesheet_link_tag :administration, "data-turbolinks-track" => true 
 javascript_include_tag "modernizr/modernizr" 
 javascript_include_tag :administration, "data-turbolinks-track" => true 
 yield :header 
  link_to admin_root_path do 
 end 
 link_to admin_categories_path do 
 end 
 link_to admin_products_path do 
 end 
 link_to admin_accessories_path do 
 end 
 link_to admin_orders_path do 
 end 
 link_to admin_delivery_services_path do 
 end 
 link_to admin_pages_path do 
 end 
 link_to root_path, target: '_blank' do 
 end 
 link_to admin_settings_path do 
 end 
 
  if Store.settings.attachment.nil? 
 image_tag 'fallback/square/default.png', width: 60, height: 60 
 else 
 image_tag Store.settings.attachment.file.square, width: 60, height: 60 
 end 
 if current_user.attachment.nil? 
 image_tag 'fallback/square/default.png', 'data-toggle' => 'dropdown', width: 40, height: 40, href: '#' 
 else  
 image_tag current_user.attachment.file.square, 'data-toggle' => 'dropdown', width: 40, height: 40, href: '#' 
 end 
 link_to admin_profile_path do 
 end 
 link_to destroy_user_session_path, method: :delete do 
 end 
 
  active_controller?(controller: 'admin/admin', action: 'dashboard') 
 link_to admin_root_path, 'data-toggle' => 'tooltip', 'data-placement' => 'right', 'data-original-title' => 'Dashboard' do 
 end 
 active_controller?(controller: 'admin/categories') 
 link_to admin_categories_path, 'data-toggle' => 'tooltip', 'data-placement' => 'right', 'data-original-title' => 'Categories' do 
 end 
 active_controller?(controller: 'admin/products') 
 active_controller?(controller: 'admin/products/stock') 
 link_to admin_products_path, 'data-toggle' => 'tooltip', 'data-placement' => 'right', 'data-original-title' => 'Products' do 
 end 
 active_controller?(controller: 'admin/accessories') 
 link_to admin_accessories_path, 'data-toggle' => 'tooltip', 'data-placement' => 'right', 'data-original-title' => 'Accessories' do 
 end 
 active_controller?(controller: 'admin/orders') 
 link_to admin_orders_path, 'data-toggle' => 'tooltip', 'data-placement' => 'right', 'data-original-title' => 'Orders' do 
 end 
 active_controller?(controller: 'admin/delivery_services') 
 active_controller?(controller: 'admin/delivery_service_prices') 
 link_to admin_delivery_services_path, 'data-toggle' => 'tooltip', 'data-placement' => 'right', 'data-original-title' => 'Delivery' do 
 end 
 active_controller?(controller: 'admin/pages') 
 link_to admin_pages_path, 'data-toggle' => 'tooltip', 'data-placement' => 'right', 'data-original-title' => 'Pages' do 
 end 
 link_to root_path, 'data-toggle' => 'tooltip', 'data-placement' => 'right', 'data-original-title' => 'Storefront', target: '_blank' do 
 end 
 active_controller?(controller: 'admin/admin', action: 'settings') 
 link_to admin_settings_path, 'data-toggle' => 'tooltip', 'data-placement' => 'right', 'data-original-title' => 'Settings' do 
 end 
 
  
 render_flash 
 render_breadcrumbs 0 
  
 content_for :breadcrumb, 'Edit' 
 breadcrumb_add 'Products', admin_products_path 
 javascript :footer, 'products' 
  form_for [:admin, @product], html: {role: 'form', method: :patch} do |f| 
  if object && object.errors.any? 
 object.errors.full_messages.each do |msg| 
 msg   
 end 
 end 
 
 end 
 
 yield :footer 

end

  end

  def update
    get_associations
    set_product
    set_skus
    set_attachments
    @product.attributes = params[:product]
    @product.save(validate: false)
    if params[:commit] == "Save"
      @product.status = :draft
      params[:product][:status] = 'draft'
      @message = "Your product has been saved successfully as a draft."
    elsif params[:commit] == "Publish"
      @product.status = :published
      params[:product][:status] = 'published'
      @message = "Your product has been published successfully. It is now live in your store."
    end
    if @product.update(params[:product])
      Tag.add(params[:taggings], @product.id)
      Tag.del(params[:taggings], @product.id)
      flash_message :success, @message
      redirect_to admin_products_url
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 'Edit product' 
 "- #{Store.settings.name} Administration" 
 csrf_meta_tag 
 include_gon(watch: true) 
 stylesheet_link_tag :administration, "data-turbolinks-track" => true 
 javascript_include_tag "modernizr/modernizr" 
 javascript_include_tag :administration, "data-turbolinks-track" => true 
 yield :header 
  link_to admin_root_path do 
 end 
 link_to admin_categories_path do 
 end 
 link_to admin_products_path do 
 end 
 link_to admin_accessories_path do 
 end 
 link_to admin_orders_path do 
 end 
 link_to admin_delivery_services_path do 
 end 
 link_to admin_pages_path do 
 end 
 link_to root_path, target: '_blank' do 
 end 
 link_to admin_settings_path do 
 end 
 
  if Store.settings.attachment.nil? 
 image_tag 'fallback/square/default.png', width: 60, height: 60 
 else 
 image_tag Store.settings.attachment.file.square, width: 60, height: 60 
 end 
 if current_user.attachment.nil? 
 image_tag 'fallback/square/default.png', 'data-toggle' => 'dropdown', width: 40, height: 40, href: '#' 
 else  
 image_tag current_user.attachment.file.square, 'data-toggle' => 'dropdown', width: 40, height: 40, href: '#' 
 end 
 link_to admin_profile_path do 
 end 
 link_to destroy_user_session_path, method: :delete do 
 end 
 
  active_controller?(controller: 'admin/admin', action: 'dashboard') 
 link_to admin_root_path, 'data-toggle' => 'tooltip', 'data-placement' => 'right', 'data-original-title' => 'Dashboard' do 
 end 
 active_controller?(controller: 'admin/categories') 
 link_to admin_categories_path, 'data-toggle' => 'tooltip', 'data-placement' => 'right', 'data-original-title' => 'Categories' do 
 end 
 active_controller?(controller: 'admin/products') 
 active_controller?(controller: 'admin/products/stock') 
 link_to admin_products_path, 'data-toggle' => 'tooltip', 'data-placement' => 'right', 'data-original-title' => 'Products' do 
 end 
 active_controller?(controller: 'admin/accessories') 
 link_to admin_accessories_path, 'data-toggle' => 'tooltip', 'data-placement' => 'right', 'data-original-title' => 'Accessories' do 
 end 
 active_controller?(controller: 'admin/orders') 
 link_to admin_orders_path, 'data-toggle' => 'tooltip', 'data-placement' => 'right', 'data-original-title' => 'Orders' do 
 end 
 active_controller?(controller: 'admin/delivery_services') 
 active_controller?(controller: 'admin/delivery_service_prices') 
 link_to admin_delivery_services_path, 'data-toggle' => 'tooltip', 'data-placement' => 'right', 'data-original-title' => 'Delivery' do 
 end 
 active_controller?(controller: 'admin/pages') 
 link_to admin_pages_path, 'data-toggle' => 'tooltip', 'data-placement' => 'right', 'data-original-title' => 'Pages' do 
 end 
 link_to root_path, 'data-toggle' => 'tooltip', 'data-placement' => 'right', 'data-original-title' => 'Storefront', target: '_blank' do 
 end 
 active_controller?(controller: 'admin/admin', action: 'settings') 
 link_to admin_settings_path, 'data-toggle' => 'tooltip', 'data-placement' => 'right', 'data-original-title' => 'Settings' do 
 end 
 
  
 render_flash 
 render_breadcrumbs 0 
  
 content_for :breadcrumb, 'Edit' 
 breadcrumb_add 'Products', admin_products_path 
 javascript :footer, 'products' 
  form_for [:admin, @product], html: {role: 'form', method: :patch} do |f| 
  if object && object.errors.any? 
 object.errors.full_messages.each do |msg| 
 msg   
 end 
 end 
 
 end 
 
 yield :footer 

end

    end
  end

  # Destroying a product
  #
  def destroy
    @product = Product.find(params[:id])
    CartItem.where(sku_id: @product.skus.pluck(:id)).destroy_all unless @product.carts.empty?
    if @product.orders.empty? 
      @product.destroy
    else
      @product.skus.map { |s| Store.inactivate!(s) }
      Store.inactivate!(@product)
    end

    flash_message :success, "Product was successfully deleted."
    redirect_to admin_products_url
  end

  private

  def get_associations
    @accessories = Accessory.active.load
    @products = Product.active.published.load
    @categories = Category.all
  end

  def clean_drafts
    Product.where("name = :blank_value OR name IS :nil_value OR sku = :blank_value OR sku IS :nil_value OR part_number = :nil_value", nil_value: nil, blank_value: '').destroy_all
  end

  def set_product
    @product = Product.includes(:skus, :accessories, :attachments, :variant_types, :attachments).find(params[:id])
  end

  def set_attachments
    @attachments = @product.attachments.includes(:attachable)
  end

  def set_skus
    @skus = @product.skus.includes(:variants, :stock_adjustments).active.order(code: :asc)
  end
end

class Admin::Products::StockController < ApplicationController
    before_action :authenticate_user!
    layout 'admin'

    def index
        @skus = Sku.includes(:product).complete.active.all
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 'Stock management' 
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
  
 content_for :breadcrumb, 'Stock management' 
 breadcrumb_add 'Products', admin_products_path 
 if @skus.empty? 
 else 
 @skus.each do |sku| 
 sku.full_sku 
 sku.product.name 
 render_variants(sku) 
 sku.stock 
 sku.stock_warning_level 
 link_to admin_products_stock_path(sku) do 
 end 
 end 
 end 
 yield :footer 

end

    end

    def show
        @sku = Sku.includes(:product).active.find(params[:id])
        @stock_adjustments = @sku.stock_adjustments.active
        @stock_adjustment = @sku.stock_adjustments.build
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 'Stock management' 
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
  
 content_for :breadcrumb, @sku.full_sku 
 breadcrumb_add 'Products', admin_products_path 
 breadcrumb_add 'Stock management', admin_products_stock_index_path 
 link_to new_admin_product_sku_stock_adjustment_path(@sku.product, @sku), remote: true, id: 'add-stock-adjustment-button', :class => "btn btn-blue btn-large", "data-placement" => "bottom", "data-toggle" => "tooltip", title: "Add stock adjustment" do 
 end 
 @sku.full_sku 
 @stock_adjustments.each do |adjustment| 
  stock_adjustment.created_at.strftime('%d/%m/%Y at %I:%M%p') 
 stock_adjustment.description 
 stock_adjustment.adjustment 
 latest_stock_adjustment(stock_adjustment, stock_adjustment.sku) 
 stock_adjustment.stock_total 
 
 end 
 yield :footer 

end

    end
end
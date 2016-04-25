class Admin::OrdersController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'

  def index
    @orders = Order.active.order(created_at: :desc)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 'Orders' 
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
  
 content_for :breadcrumb, 'Orders' 
 javascript :footer, 'admin/soca.datepicker' 
 if @orders.empty? 
 else 
 @orders.each do |order| 
 order.id 
  order.id 
 if order.transactions.last.paypal_id.nil? 
 else 
 link_to(order.transactions.last.paypal_id, "#{Rails.application.secrets.transaction_link}#{order.transactions.last.paypal_id}", target: '_blank') 
 end 
 status_label order, order.shipping_status 
 status_label order.transactions.last, order.transactions.last.payment_status 
 Store::Price.new(price: order.gross_amount, tax_type: 'net').single 
 order.updated_at.strftime('%d/%m/%Y at %I:%M%p') 
 table_actions [:admin, order], 'show', 'remote-edit' 
 
 end 
 end 
 yield :footer 

end

  end

  def show
    set_order
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 "Order ##{@order.id}" 
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
  
 content_for :breadcrumb, "##{@order.id}" 
 breadcrumb_add 'Orders', admin_orders_path 
 "Order ##{@order.id}" 
 @order.email 
 status_label @order, @order.shipping_status 
 @order.shipping_date.strftime(" #{@order.shipping_date.day.ordinalize} %b %Y") unless @order.shipping_date.nil?  
 Store::Price.new(price: @order.actual_shipping_cost, tax_type: 'net').single unless @order.actual_shipping_cost.nil? 
 @order.delivery.full_name 
 unless @order.consignment_number.nil? || @order.delivery_service.tracking_url.nil? 
 link_to @order.consignment_number, Store.tracking_url(@order.delivery_service.tracking_url, @order.consignment_number), target: '_blank' 
 end 
 @order.billing_address.full_name 
 @order.billing_address.address 
 @order.billing_address.city 
 @order.billing_address.postcode 
 @order.billing_address.country 
 @order.billing_address.telephone 
 @order.delivery_address.full_name 
 @order.delivery_address.address 
 @order.delivery_address.city 
 @order.delivery_address.postcode 
 @order.delivery_address.country 
 @order.delivery_address.telephone 
 @order.order_items.each do |item| 
 link_to item.sku.product.name, [item.sku.product.category, item.sku.product] 
 render_variants(item.sku) unless item.sku.product.single? 
 unless item.order_item_accessory.nil? 
 "<i class='icon-code-fork'></i> #{item.order_item_accessory.accessory.name}".html_safe 
 end 
 item.sku.full_sku 
 Store::Price.new(price: item.price, tax_type: 'net').single 
 item.quantity 
 Store::Price.new(price: item.total_price, tax_type: 'net').single 
 end 
 Store::Price.new(price: @order.net_amount, tax_type: 'net').single 
 Store::Price.new(price: @order.delivery.price, tax_type: 'net').single 
 Store::Price.new(price: @order.tax_amount, tax_type: 'net').single 
 Store::Price.new(price: @order.gross_amount, tax_type: 'net').single 
 @order.transactions.each do |transaction| 
 transaction.id 
 transaction.transaction_type 
 transaction.payment_type  
 if transaction.paypal_id.nil? 
 else 
 link_to transaction.paypal_id, "#{Rails.application.secrets.transaction_link}#{transaction.paypal_id}", :target => '_blank'  
 end 
 status_label transaction, transaction.payment_status 
 transaction.error_code.nil? ? "-" : transaction.error_code 
 Store::Price.new(price: transaction.fee, tax_type: 'net').single 
 Store::Price.new(price: transaction.net_amount, tax_type: 'net').single 
 Store::Price.new(price: transaction.gross_amount, tax_type: 'net').single 
 transaction.updated_at.strftime('%B %-d, %Y, %I:%M %P') 
 end 
 yield :footer 

end

  end

  def edit
    set_order
    render json: { modal: render_to_string(partial: 'admin/orders/modal') }, status: 200
  end

  def update
    set_order
    if @order.update(params[:order])
      OrderMailer.tracking(@order).deliver_later if @order.new_order_tracking_mailer?
      render json: { order_id: @order.id }, status: 200
    else 
      render json: { errors: @order.errors.full_messages }, status: 422
    end
  end

  def dispatcher
    set_order
    render json: { modal: render_to_string(partial: 'admin/orders/dispatch/modal', locals: { order: @order }) }, status: 200
  end

  def dispatched
    set_order
    @order.shipping_date = Time.now
    @order.shipping_status = 'dispatched'
    if @order.update(params[:order])
      OrderMailer.dispatched(@order).deliver_later
      render json: 
      { 
        order_id: @order.id, 
        date: @order.updated_at.strftime("%d/%m/%Y"), 
        row: render_to_string(partial: 'admin/orders/single', locals: { order: @order }) 
      }, status: 200
    end
  end

  private

  def set_order
    @order ||= Order.find(params[:id])
  end
end

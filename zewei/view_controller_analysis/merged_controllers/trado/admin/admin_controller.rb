class Admin::AdminController < ApplicationController
    before_action :authenticate_user!
    layout 'admin'

    def dashboard
        set_setting
        @dashboard = Order.dashboard_data
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 'Dashboard' 
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
  
 content_for :breadcrumb, 'Dashboard' 
 javascript :header, 'admin/chart' 
  id 
 raw(labels) 
 datasets.each do |set| 
 set.first.to_s.titleize 
 set.last[:color] 
 set.last[:color] 
 set.last[:color] 
 set.last[:color] 
 set.last[:data] 
 end 
 id 
 id 
 id 
 id 
 id 

                
 @dashboard[:completed] 
 @dashboard[:pending] 
 @dashboard[:failed] 
  id 
 datasets.each do |set| 
 set.last[:value] 
 set.last[:color] 
 set.first.to_s.titleize 
 end 
 id 
 id 
 id 
 id 
 id 
 
 Store::Price.new(price: @dashboard[:gross_total]).single 
 Store::Price.new(price: @dashboard[:net_total]).single 
 Store::Price.new(price: @dashboard[:tax_total]).single 
 Store::Price.new(price: @dashboard[:paypal_fee_total]).single 
 yield :footer 

end

    end

    def settings
        set_setting
        @settings.build_attachment unless @settings.attachment
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 'Settings' 
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
  
 content_for :breadcrumb, 'Settings' 
 form_for @settings, url: admin_settings_update_path, html: { role: 'form' } do |f| 
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
        set_setting
        respond_to do |format|
          if @settings.update(params[:store_setting])
            flash_message :success, 'Store settings were successfully updated.'
            format.html { redirect_to admin_root_path }
          else
            format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 'Settings' 
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
  
 content_for :breadcrumb, 'Settings' 
 form_for @settings, url: admin_settings_update_path, html: { role: 'form' } do |f| 
  if object && object.errors.any? 
 object.errors.full_messages.each do |msg| 
 msg   
 end 
 end 
 
 end 
 yield :footer 

end
 } 
          end
        end
    end

    private

    def set_setting
        @settings = Store.settings
    end
end
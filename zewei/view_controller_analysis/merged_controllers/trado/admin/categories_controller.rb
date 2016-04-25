class Admin::CategoriesController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'

  def index
    @categories = Category.all
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 'Categories' 
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
  
 content_for :breadcrumb, 'Categories' 
 link_to new_admin_category_path, :class => "btn btn-blue btn-large", "data-placement" => "bottom", "data-toggle" => "tooltip", title: "Add category" do 
 end 
 if @categories.empty? 
 else 
 @categories.each do |category| 
 category.name 
 category.description 
 category.sorting 
 category.active ? "<i class='icon-checkmark icon-green'></i>".html_safe : "<i class='icon-close icon-red'></i>".html_safe 
 category.products.count 
 table_actions [:admin, category], "edit", "delete" 
 end 
 end 
 yield :footer 

end

  end

  def new
    @category = Category.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 'New category' 
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
  
 content_for :breadcrumb, 'New' 
 breadcrumb_add 'Categories', admin_categories_path 
 form_for [:admin, @category], html: { role: 'form' } do |f| 
  if object && object.errors.any? 
 object.errors.full_messages.each do |msg| 
 msg   
 end 
 end 
 
 end 
 yield :footer 

end

  end

  def edit
    set_category
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 'Edit category' 
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
 breadcrumb_add 'Categories', admin_categories_path 
 form_for [:admin, @category], html: { role: 'form' } do |f| 
  if object && object.errors.any? 
 object.errors.full_messages.each do |msg| 
 msg   
 end 
 end 
 
 end 
 yield :footer 

end

  end

  def create
    @category = Category.new(params[:category])

    if @category.save
      flash_message :success, 'Category was successfully created.'
      redirect_to admin_categories_url
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 'New category' 
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
  
 content_for :breadcrumb, 'New' 
 breadcrumb_add 'Categories', admin_categories_path 
 form_for [:admin, @category], html: { role: 'form' } do |f| 
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

  def update
    set_category
    if @category.update(params[:category])
      flash_message :success, 'Category was successfully updated.'
      redirect_to admin_categories_url
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 'Edit category' 
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
 breadcrumb_add 'Categories', admin_categories_path 
 form_for [:admin, @category], html: { role: 'form' } do |f| 
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

  def destroy
    set_category
    @result = Store.last_record(@category, Category.all.count)

    flash_message @result[0], @result[1]
    redirect_to admin_categories_url
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

end

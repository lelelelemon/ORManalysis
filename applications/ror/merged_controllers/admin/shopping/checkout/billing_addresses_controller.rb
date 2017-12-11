class Admin::Shopping::Checkout::BillingAddressesController < Admin::Shopping::Checkout::BaseController
  helper_method :countries

  def index
    @billing_address = Address.new
    if !Settings.require_state_in_address  && countries.size == 1
      @billing_address.country = countries.first
    end
    form_info
  end

  def new
    old_address       = Address.find_by_id(params[:old_address_id])
    attributes        = old_address.try(:address_attributes)
    @billing_address = session_admin_cart.customer.addresses.new(attributes)
    if !Settings.require_state_in_address && countries.size == 1
      @billing_address.country = countries.first
    end
    form_info
  end

  # POST /shopping/addresses
  # POST /shopping/addresses.xml
  def create
    if params[:address].present?
      @billing_address = checkout_user.addresses.new(allowed_params)
      @billing_address.default = true          if checkout_user.default_billing_address.nil?
      @billing_address.billing_default = true  if checkout_user.default_billing_address.nil?
      @billing_address.save
    elsif params[:billing_address_id].present?
      @billing_address = checkout_user.addresses.find(params[:billing_address_id])
    end
    if @billing_address.id
      update_order_address_id(@billing_address.id)
      redirect_to(next_admin_order_form_url, :notice => 'Address was successfully created.')
    else
      form_info
      render :action => "new"
    end
 
 site_name 
 stylesheet_link_tag 'sprite.css' 
 stylesheet_link_tag "normalize.css" 
 stylesheet_link_tag "application.css" 
 stylesheet_link_tag 'admin/app.css' 
 stylesheet_link_tag "admin/cart.css" 
 csrf_meta_tag 
 javascript_include_tag 'application' 
 yield :head 
 if notice || alert 
 !!alert ? 'alert' : 'warning' 
 if alert 
 alert 
 elsif notice 
 notice 
 end 
 end 
 render :partial => 'shared/admin/header_bar' 
 yield 
 render :partial => '/admin/shopping/right_panel_summary'
 yield :right_side_bar 
 yield :bottom 
 yield :below_body 

 form_for( @billing_address, url: admin_shopping_checkout_billing_addresses_path(@billing_address)) do |f| 
 render partial: 'form', locals: { f: f } 
 end 
 link_to 'Back', admin_shopping_checkout_billing_addresses_path 

 end

  def select_address
    address = checkout_user.addresses.find(params[:id])
    update_order_address_id(address.id)
    redirect_to next_admin_order_form_url
  end

  private

  def allowed_params
    params.require(:address).permit(:first_name, :last_name, :address1, :address2, :city, :state_id, :state_name, :zip_code, :default, :billing_default, :country_id)
  end

  def form_info
    @billing_addresses = session_admin_cart.customer.billing_addresses
    @states     = State.form_selector
  end
  def update_order_address_id(id)
    session_admin_order.update_attributes( :bill_address_id => id )
  end
end

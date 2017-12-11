class Admin::History::AddressesController < Admin::BaseController
  helper_method :states
  # GET /admin/history/addresses
  def index
    @order = Order.includes({:user => :addresses}).find_by_number(params[:order_id])
    @addresses = @order.user.addresses
  end

  # GET /admin/history/addresses/1
  def show
    @order = Order.includes({:user => :addresses}).find_by_number(params[:order_id])
    @address = Address.find(params[:id])
  end

  # GET /admin/history/addresses/new
  def new
    @order    = Order.includes({:user => :addresses}).find_by_number(params[:order_id])
    @address  = Address.new
  end

  # GET /admin/history/addresses/1/edit
  def edit
    @order    = Order.includes({:user => :addresses}).find_by_number(params[:order_id])
    @address  = Address.find(params[:id])
  end

  # POST /admin/history/addresses
  def create  ##  This create a new address, sets the orders address & redirects to order_history
    @order    = Order.includes([:ship_address, {:user => :addresses}]).find_by_number(params[:order_id])
    @address  = @order.user.addresses.new(allowed_params)

    respond_to do |format|
      if @address.save
        @order.ship_address = @address
        @order.save
        format.html { redirect_to(admin_history_order_url(@order), :notice => 'Address was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
 
 site_name 
 stylesheet_link_tag "normalize.css" 
 stylesheet_link_tag "application.css" 
 stylesheet_link_tag 'admin/app.css' 
 stylesheet_link_tag "admin/ie.css" 
 csrf_meta_tag 
 yield :head 
 if notice || alert 
 !!alert ? 'alert' : 'warning' 
 if alert 
 alert 
 elsif notice 
 notice 
 end 
 end 
 render :partial => "shared/admin/header_bar" 
 if content_for? :header_sub_bar 
 yield :header_sub_bar 
 end 
 if content_for?(:sidemenu) 
 yield 
 yield :sidemenu 
 else 
 yield 
 end 
 site_name 
 link_to "RoR eCommerce", "http://ror-e.com" 
 RoReCommerce::Version 
 javascript_include_tag 'application' 
 yield :bottom 
 if Rails.env.development? 
 end 
 yield :below_body 

 @order.user.name 
 form_for(@address, :url => admin_history_order_addresses_path(@order)) do |f| 
 render :partial => '/admin/history/addresses/form', :locals => {:f => f } 
 end 
 link_to 'Back', admin_history_order_path(@order), class: 'button secondary' 

 end

  # PUT /admin/history/addresses/1
  def update ##  This selects a new address, sets the orders address & redirects to order_history
    @order    = Order.includes([:ship_address, {:user => :addresses}]).find_by_number(params[:order_id])
    @address  = Address.find(params[:id])

    respond_to do |format|
      if @address && @order.ship_address = @address
        if @order.save
          format.html { redirect_to(admin_history_order_url(@order) , :notice => 'Address was successfully selected.') }
        else
          format.html { render :action => "edit" }
        end
      else
        format.html { render :action => "edit" }
      end
    end
 
 site_name 
 stylesheet_link_tag "normalize.css" 
 stylesheet_link_tag "application.css" 
 stylesheet_link_tag 'admin/app.css' 
 stylesheet_link_tag "admin/ie.css" 
 csrf_meta_tag 
 yield :head 
 if notice || alert 
 !!alert ? 'alert' : 'warning' 
 if alert 
 alert 
 elsif notice 
 notice 
 end 
 end 
 render :partial => "shared/admin/header_bar" 
 if content_for? :header_sub_bar 
 yield :header_sub_bar 
 end 
 if content_for?(:sidemenu) 
 yield 
 yield :sidemenu 
 else 
 yield 
 end 
 site_name 
 link_to "RoR eCommerce", "http://ror-e.com" 
 RoReCommerce::Version 
 javascript_include_tag 'application' 
 yield :bottom 
 if Rails.env.development? 
 end 
 yield :below_body 

 form_for(@address, url: admin_history_order_address_path(@order, @address)) do |f| 
 render partial: '/admin/history/addresses/form', locals: { f: f } 
 end 
 link_to 'Show', admin_history_order_address_path(@order, @address), class: 'button secondary' 
 link_to 'Back', admin_history_orders_path(), class: 'button secondary' 

 end
  private

  def allowed_params
    params.require(:admin_history_address).permit(:address_type_id, :first_name, :last_name, :address1, :address2, :city, :state_id, :state_name, :zip_code, :phone_id, :alternative_phone, :default, :billing_default, :active, :country_id)
  end

  def states
    @states     ||= State.form_selector
  end
end

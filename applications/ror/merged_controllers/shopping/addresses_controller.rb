class Shopping::AddressesController < Shopping::BaseController
  helper_method :countries
  # GET /shopping/addresses
  def index
    @form_address = @shopping_address = Address.new
    if !Settings.require_state_in_address && countries.size == 1
      @shopping_address.country = countries.first
    end
    form_info
  end

  # GET /shopping/addresses/1/edit
  def edit
    form_info
    @form_address = @shopping_address = Address.find(params[:id])
  end

  # POST /shopping/addresses
  def create
    if params[:address].present?
      @shopping_address = current_user.addresses.new(allowed_params)
      @shopping_address.default = true          if current_user.default_shipping_address.nil?
      @shopping_address.billing_default = true  if current_user.default_billing_address.nil?
      @shopping_address.save
      @form_address = @shopping_address
    elsif params[:shopping_address_id].present?
      @shopping_address = current_user.addresses.find(params[:shopping_address_id])
    end

      if @shopping_address.id
        update_order_address_id(@shopping_address.id)
        redirect_to(shopping_shipping_methods_url, :notice => 'Address was successfully created.')
      else
        form_info
        render :action => "index"
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

 if  @shopping_addresses.empty? 
 else 
 end 
 @shopping_addresses.each do |shopping_address| 
 render :partial => '/shared/compact_address', :locals => {:shopping_address => shopping_address} 
 button_to 'Use', select_address_shopping_address_path(shopping_address), :class => 'button spade inline-block', :method => :put 
 link_to 'Edit', edit_shopping_address_path(shopping_address) 
 link_to 'Delete', shopping_address_path(shopping_address), :data => {:confirm => 'Are you sure?'}, :method => :delete 
 end 
 if session_order.ready_to_checkout? 
 link_to 'Order Summary', shopping_orders_path, :class => 'button success' 
 end 
 form_for @shopping_address, url: shopping_addresses_path, html: {class: 'custom'} do |address_form| 
 render :partial =>  'form', :locals => {:f => address_form}  
 end 

 shopping_address.name 
 shopping_address.address_lines_array.each do |line| 
 line 
 end 
 shopping_address.city_state_zip 

 end

  def update
    @shopping_address = current_user.addresses.new(allowed_params)
    @shopping_address.replace_address_id = params[:id] # This makes the address we are updating inactive if we save successfully

    # if we are editing the current default address then this is the default address
    @shopping_address.default         = true if params[:id].to_i == current_user.default_shipping_address.try(:id)
    @shopping_address.billing_default = true if params[:id].to_i == current_user.default_billing_address.try(:id)

      if @shopping_address.save
        update_order_address_id(@shopping_address.id)
        redirect_to(shopping_shipping_methods_url, :notice => 'Address was successfully updated.')
      else
        # the form needs to have an id
        @form_address = current_user.addresses.find(params[:id])
        # the form needs to reflect the attributes to customer entered
        @form_address.attributes = allowed_params
        @states     = State.form_selector
        render :action => "edit"
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

 form_for(@form_address, url: shopping_address_path(@form_address), html: {class: 'custom'}) do |f| 
 render :partial => 'form', :locals => {:f => f} 
 end 
 link_to 'Back', shopping_addresses_path 

 end

  def select_address
    address = current_user.addresses.find(params[:id])
    update_order_address_id(address.id)
    redirect_to shopping_shipping_methods_url
  end

  def destroy
    @shopping_address = Address.find(params[:id])
    @shopping_address.update_attributes(:active => false)

    redirect_to(shopping_addresses_url)
  end

  private

  def allowed_params
    params.require(:address).permit(:first_name, :last_name, :address1, :address2, :city, :state_id, :state_name, :zip_code, :default, :billing_default, :country_id)
  end

  def form_info
    @shopping_addresses = current_user.shipping_addresses
    @states     = State.form_selector
  end

  def update_order_address_id(id)
    session_order.update_attributes(
                          ship_address_id: id ,
                          bill_address_id: (session_order.bill_address_id ? session_order.bill_address_id : id)
                                    )
  end

  def countries
    @countries ||= Country.active
  end

end

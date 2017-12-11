class Shopping::BillingAddressesController < Shopping::BaseController
  helper_method :countries, :phone_types
  # GET /shopping/addresses
  def index
    if session_cart.shopping_cart_items.empty?
      flash[:notice] = I18n.t('do_not_have_anything_in_your_cart')
      redirect_to products_url and return
    end
    @form_address = @shopping_address = Address.new
    @form_address.phones.build
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
        redirect_to(next_form_url(session_order))
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
 button_to 'Use', select_address_shopping_billing_address_path(shopping_address), :class => 'button spade inline-block', :method => :put 
 link_to 'Edit', edit_shopping_billing_address_path(shopping_address) 
 end 
 if session_order.ready_to_checkout? 
 link_to 'Order Summary', shopping_orders_path, class: 'button success' 
 end 
 form_for @shopping_address, url: shopping_billing_addresses_path, html: {class: 'custom'} do |address_form| 
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
        redirect_to(next_form_url(session_order))
      else
        # the form needs to have an id
        @form_address = current_user.addresses.find(params[:id])
        # the form needs to reflect the attributes to customer entered
        @form_address.attributes = allowed_params
        @form_address.phones.build if @form_address.phones.empty?
        @states     = State.form_selector
        render action: "edit"
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

 end

  def select_address
    address = current_user.addresses.find(params[:id])
    update_order_address_id(address.id)
    redirect_to next_form_url(session_order)
  end

  def destroy
    @shopping_address = Address.find(params[:id])
    @shopping_address.update_attributes(active: false)

    redirect_to(shopping_billing_addresses_url)
  end

  private

  def selected_checkout_tab(tab)
    tab == 'billing-address'
  end

  def allowed_params
    params.require(:address).permit(:first_name, :last_name, :address1, :address2, :city, :state_id, :state_name, :zip_code, :default, :billing_default, :country_id)
  end

  def phone_types
    @phone_types ||= PhoneType.all.map{|p| [p.name, p.id]}
  end

  def form_info
    @shopping_addresses = current_user.shipping_addresses
    @states     = State.form_selector
  end

  def update_order_address_id(id)
    session_order.update_attributes(
                          :bill_address_id => id
                                    )
  end
end

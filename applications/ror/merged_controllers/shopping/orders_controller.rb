class Shopping::OrdersController < Shopping::BaseController
  before_action :require_login
  # GET /shopping/orders
  ### The intent of this action is two fold
  #
  # A)  if there is a current order redirect to the process that
  # => needs to be completed to finish the order process.
  # B)  if the order is ready to be checked out...  give the order summary page.
  #
  ##### THIS METHOD IS BASICALLY A CHECKOUT ENGINE
  def index
    @order = find_or_create_order
    if f = next_form(@order)
      redirect_to f
    else
      expire_all_browser_cache
      form_info
    end
  end


  #  add checkout button
  def checkout
    #current or in-progress otherwise cart (unless cart is empty)
    order = find_or_create_order
    @order = session_cart.add_items_to_checkout(order) # need here because items can also be removed
    redirect_to next_form_url(order)
  end

  # POST /shopping/orders
  def update
    @order = find_or_create_order
    @order.ip_address = request.remote_ip

    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(cc_params)

    address = @order.bill_address.cc_params

    if !session_cart.shopping_cart_items_equal_order_items?(@order)
      flash[:alert] = I18n.t('shopping_cart_items_do_not_match_order_items')
      redirect_to shopping_cart_items_url
    elsif !@order.in_progress?
      session_cart.mark_items_purchased(@order)
      session[:order_id] = nil
      flash[:error] = I18n.t('the_order_purchased')
      redirect_to myaccount_order_url(@order)
    elsif @credit_card.valid?
      if response = @order.create_invoice(@credit_card,
                                          @order.credited_total,
                                          { email: @order.email, billing_address: address, ip: @order.ip_address },
                                          @order.amount_to_credit)
        if response.succeeded?
          expire_all_browser_cache
          ##  MARK items as purchased
          session_cart.mark_items_purchased(@order)
          session[:last_order] = @order.number
          redirect_to( confirmation_shopping_order_url(@order) ) and return
        else
          flash[:alert] =  [I18n.t('could_not_process'), I18n.t('the_order')].join(' ')
        end
      else
        flash[:alert] = [I18n.t('could_not_process'), I18n.t('the_credit_card')].join(' ')
      end
      form_info
      render :action => 'index'
    else
      form_info
      flash[:alert] = [I18n.t('credit_card'), I18n.t('is_not_valid')].join(' ')
      render :action => 'index'
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
 stylesheet_link_tag 'tables.css' 
 end 
 i = 1 
 @order.order_items.group_by(&:variant_id).each do |variant_id, items| 
 i 
 render :partial => 'order_item', :locals => {:items => items } 
 i += 1 
 end 
 render :partial => '/shared/compact_address', :locals => {:shopping_address => @order.ship_address} 
 link_to 'Change address', shopping_addresses_path, :class => 'button tiny green' 
 render :partial => '/shared/compact_address', :locals => {:shopping_address => @order.bill_address} 
 link_to 'Change address', shopping_billing_addresses_path, :class => 'button tiny green' 
 @order.order_items.each do |item| 
 cycle("odd", "")
 item.variant.product.name 
 number_to_currency item.price 
 number_to_currency item.total 
 end 
 number_to_currency @order.sub_total 
 number_to_currency @order.shipping_charges 
 if @order.coupon_amount > 0.0 
 number_to_currency @order.coupon_amount 
 end 
 if @order.deal_amount && @order.deal_amount > 0.0 
 number_to_currency @order.deal_amount 
 end 
 number_to_currency @order.taxed_amount 
 if @order.amount_to_credit && @order.amount_to_credit > 0.0 
 number_to_currency @order.amount_to_credit 
 end 
 number_to_currency @order.credited_total 
 form_tag( shopping_order_path(@order),
                                  method: :put,
                                  html:  {class: 'custom'},
                                  id:    'purchase_order') do  
 label_tag  :name 
 label_tag 'First' 
 text_field_tag(:first_name, @credit_card.first_name) 
 label_tag :last_name, 'Last' 
 text_field_tag(:last_name, @credit_card.last_name) 
 label_tag 'Number'
 text_field_tag(:number, @credit_card.number , class: ' disableAutoComplete', :autocomplete => "off") 
 label_tag :verification_value, 'VCC'
 text_field_tag(:verification_value, @credit_card.verification_value , class: 'disableAutoComplete', :autocomplete => "off") 
 label_tag :type, 'Type'
 select_tag(:type,
                            options_for_select(
                              ['visa', 'mastercard'],
                              selected: @credit_card.type
                            )) 
 label_tag :month 
 select_tag(:month,
                           options_for_select(
                             ['01', '02',  '03', '04', '05', '06', '07', '08', '09', '10', '11', '12' ],
                             selected: @credit_card.month
                           )) 
 label_tag :year 
 select_tag(:year,
                            options_for_select(
                              (Time.zone.now.year..(Time.zone.now.year + 10)),
                              selected: @credit_card.year
                            )) 
 submit_tag 'Complete Order', class: 'button success' 
 end 

 cycle("line_item_blue", "line_item_light_gray") 
 image_tag(items.first.variant.product.featured_image(:mini)) 
 items.first.variant.product.name 
 items.size 
 raw items.first.variant.display_property_details 

 shopping_address.name 
 shopping_address.address_lines_array.each do |line| 
 line 
 end 
 shopping_address.city_state_zip 

 end

  def confirmation
    @tab = 'confirmation'
    if session[:last_order].present? && session[:last_order] == params[:id]
      session[:last_order] = nil
      @order = Order.includes({order_items: :variant}).find_by(number: params[:id])
      render :layout => 'application'
    else
      session[:last_order] = nil
      if current_user.finished_orders.present?
        redirect_to myaccount_order_url( current_user.finished_orders.last )
      elsif current_user
        redirect_to myaccount_orders_url
      end
    end
  end
  private

  def customer_confirmation_page_view
    @tab && (@tab == 'confirmation')
  end

  def form_info
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new()
    @order.credited_total
  end

  def require_login
    if !current_user
      session[:return_to] = shopping_orders_url
      redirect_to( login_url() ) and return
    end
  end

end

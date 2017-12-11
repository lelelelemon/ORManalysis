class Admin::Shopping::Checkout::OrdersController < Admin::Shopping::Checkout::BaseController
  ### The intent of this action is two fold
  #
  # A)  if there is a current order redirect to the process that
  # => needs to be completed to finish the order process.
  # B)  if the order is ready to be checked out...  give the order summary page.
  #
  ##### THIS METHOD IS BASICALLY A CHECKOUT ENGINE
  def show
    authorize! :create_orders, current_user

    @order = find_or_create_order
    #@order = session_admin_cart.add_items_to_checkout(order) # need here because items can also be removed
    if f = next_admin_order_form()
      redirect_to f
    else
      if @order.order_items.empty?
        redirect_to admin_shopping_products_url() and return
      end
      @credit_card ||= ActiveMerchant::Billing::CreditCard.new(cc_params)
    end
  end

  def start_checkout_process
    authorize! :create_orders, current_user

    order = session_admin_order
    @order = session_admin_cart.add_items_to_checkout(order) # need here because items can also be removed
    if session_admin_cart.number_of_shopping_cart_items != @order.order_items.size
      flash[:alert] = "Some items could not be added to the cart.  Out of Stock."
    end
    redirect_to next_admin_order_form_url
  end

  def update
    @order = session_admin_order
    @order.ip_address = request.remote_ip

    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(cc_params)

    address = @order.bill_address.cc_params

    if @order.complete?
      session_admin_cart.mark_items_purchased(@order)
      flash[:alert] = I18n.t('the_order_purchased')
      redirect_to admin_history_order_url(@order)
    elsif @credit_card.valid?
      if response = @order.create_invoice(@credit_card,
                                          @order.credited_total,
                                          {:email => @order.email, :billing_address=> address, :ip=> @order.ip_address },
                                          @order.amount_to_credit)
        if response.succeeded?
          order_completed!(@order)
          redirect_to admin_history_order_url(@order)
        else
          flash[:alert] =  [I18n.t('could_not_process'), I18n.t('the_order')].join(' ')
          render :action => "show"
        end
      else
        flash[:alert] = [I18n.t('could_not_process'), I18n.t('the_credit_card')].join(' ')
        render :action => 'show'
      end
    else
      flash[:alert] = [I18n.t('credit_card'), I18n.t('is_not_valid')].join(' ')
      render :action => 'show'
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

 i = 1 
 session_admin_order.order_items.group_by(&:variant_id).each do |variant_id, items| 
 i 
 render partial: 'order_item', locals: { items: items } 
 i += 1 
 end 
 form_tag( admin_shopping_checkout_order_path(),
                                :method => :put,
                                :id   => 'purchase_admin_order') do  
 label_tag  :name 
 label_tag 'First' 
 text_field_tag(:first_name, @credit_card.first_name ,:class => '') 
 label_tag :last_name, 'Last' 
 text_field_tag(:last_name, @credit_card.last_name,:class => '') 
 label_tag 'Number'
 text_field_tag(:number, @credit_card.number ,:class => ' disableAutoComplete', :autocomplete => "off") 
 label_tag :verification_value, 'VCC'
 text_field_tag(:verification_value, @credit_card.verification_value ,:class => 'four disableAutoComplete', :autocomplete => "off") 
 'form-field error' if @credit_card.errors['brand'].present? 
 label_tag :brand, 'Type'
 select_tag(:brand, options_for_select(['visa', 'mastercard']), :class => " #{'form-field error' if @credit_card.errors['brand'].present?}" ) 
 'form-field error' if @credit_card.errors['month'].present? 
 label_tag :month, 'Month', :class => " #{'form-field error' if @credit_card.errors['month'].present?}" 
 select_tag(:month, options_for_select(['01', '02',  '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'])) 
 'form-field error' if @credit_card.errors['year'].present? 
 label_tag :year, 'Year', :class => " #{'form-field error' if @credit_card.errors['year'].present?}" 
 select_tag(:year, options_for_select((Time.zone.now.year..(Time.zone.now.year + 10))), :class => " #{'form-field error' if @credit_card.errors['year'].present?}") 
 submit_tag 'Complete Order', :class => 'button ' 
 end 
 content_for :right_side_bar do 
 render :partial => '/shared/compact_address', :locals => {:shopping_address => session_admin_order.ship_address} 
 link_to 'Change', admin_shopping_checkout_shipping_addresses_path 
 render :partial => '/shared/compact_address', :locals => {:shopping_address => session_admin_order.bill_address} 
 link_to 'Change', admin_shopping_checkout_billing_addresses_path 
 end 

 end

  private

  def form_info

  end

end

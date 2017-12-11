class Admin::Rma::ReturnAuthorizationsController < Admin::Rma::BaseController
  helper_method :sort_column, :sort_direction
  # GET /return_authorizations
  def index
    load_info
    @return_authorizations = ReturnAuthorization.admin_grid(params).order(sort_column + " " + sort_direction).
                                              paginate(:page => pagination_page, :per_page => pagination_rows)
  end

  # GET /return_authorizations/1
  def show
    load_info
    @return_authorization = ReturnAuthorization.find(params[:id])
  end

  # GET /return_authorizations/new
  def new
    load_info

    @return_authorization = ReturnAuthorization.new
    comment = Comment.new()
    comment.user_id = @order.user_id
    comment.created_by = current_user.id
    @return_authorization.comments << (comment)
    form_info
  end

  # GET /return_authorizations/1/edit
  def edit
    load_info
    @return_authorization = ReturnAuthorization.includes(:comments).find(params[:id])
    form_info
  end

  # POST /return_authorizations
  def create
    load_info
    @return_authorization = @order.return_authorizations.new(allowed_params)
    @return_authorization.created_by = current_user.id
    @return_authorization.user_id    = @order.user_id

      if @return_authorization.save
        redirect_to(admin_rma_order_return_authorization_url(@order, @return_authorization), :notice => 'Return authorization was successfully created.')
      else
        form_info
        render :action => "new"
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

 @order.invoices.each do |invoice| 
 invoice.number 
 invoice.state 
 I18n.localize(invoice.updated_at, :format => :us_time)
 number_to_currency invoice.amount 
 end 
 @order.order_items.each do |item| 
 item.variant.product_name 
 number_to_currency item.total 
 end 
 form_for(@return_authorization, :url => admin_rma_order_return_authorizations_path(@order)) do |f| 
 render partial: '/admin/rma/return_authorizations/form', locals: { f: f } 
 end 
 if @order.return_authorizations.size > 0 
 link_to 'Back', admin_rma_order_return_authorizations_path(@order), class: 'button' 
 end 

 end

  # PUT /return_authorizations/1
  def update
    load_info
    @return_authorization = ReturnAuthorization.find(params[:id])

      if @return_authorization.update_attributes(allowed_params)
        redirect_to(admin_rma_order_return_authorization_url(@order, @return_authorization), :notice => 'Return authorization was successfully updated.')
      else
        form_info
        render :action => "edit"
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

 form_for(@return_authorization, url: admin_rma_order_return_authorization_path(@order, @return_authorization)) do |f| 
 render partial: '/admin/rma/return_authorizations/form', locals: { f: f } 
 end 
 link_to 'Show', admin_rma_order_return_authorization_path(@order, @return_authorization), class: 'button' 
 link_to 'Back', admin_rma_order_return_authorizations_path(@order), class: 'button' 

 end

  def complete
    load_info
    @return_authorization = ReturnAuthorization.find(params[:id])
    if @return_authorization.complete!
      flash[:notice] = 'This RMA is complete.'
    else
      flash[:error] = 'Something when wrong!'
    end

    render :action => 'show'
 
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

 notice 
 @return_authorization.number 
 @return_authorization.amount 
 @return_authorization.restocking_fee 
 @return_authorization.state 
 @return_authorization.return_items.each do |item| 
 item.order_item.variant.product_name 
 end 
 @order.number 
 @order.order_items.each do |item| 
 item.variant.product_name 
 number_to_currency item.total 
 end 
 if @return_authorization.authorized? 
 link_to 'Cancel RMA',
                  edit_admin_rma_order_return_authorization_path(@order, @return_authorization),
                  :class => 'button heart', :method => :delete, :data => {:confirm => "Are you sure, you want to Cancel?"} 
 button_to 'Receive RMA',
                  complete_admin_rma_order_return_authorization_path(@order, @return_authorization),
                  :class => 'button green', :data => {:confirm => "Are you sure, you want to Receive?"}, :method => :put 
 end 
 if @return_authorization.authorized? 
 link_to 'Edit RMA',
                  edit_admin_rma_order_return_authorization_path(@order, @return_authorization),
                  :class => 'button heart'
 end 
 link_to 'Order Info',
                admin_history_order_path(@order),
                :class => 'button spade' 
 link_to 'All RMAs for this Order.',
                admin_rma_order_return_authorizations_path(@order),
                :class => 'button heart' 

 end
  # DELETE /return_authorizations/1
  def destroy
    load_info
    @return_authorization = ReturnAuthorization.find(params[:id])

      if @return_authorization.cancel!
        redirect_to(admin_rma_order_return_authorization_url(@order, @return_authorization), :notice => 'Return authorization was successfully updated.')
      else
        flash[:notice] = 'Return authorization had an error.'
        form_info
        render :action => "edit"
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

 form_for(@return_authorization, url: admin_rma_order_return_authorization_path(@order, @return_authorization)) do |f| 
 render partial: '/admin/rma/return_authorizations/form', locals: { f: f } 
 end 
 link_to 'Show', admin_rma_order_return_authorization_path(@order, @return_authorization), class: 'button' 
 link_to 'Back', admin_rma_order_return_authorizations_path(@order), class: 'button' 

 end
private

  def allowed_params
    params.require(:return_authorization).permit( :amount, :restocking_fee, :order_id, :active)
  end

  def form_info
    @return_conditions  = ReturnCondition.select_form
    @return_reasons     = ReturnReason.select_form
  end

  def load_info
    @order = Order.includes([:ship_address, :invoices,
                             {:shipments => :shipping_method},
                             {:order_items => [
                                                {:variant => [:product, :variant_properties]}]
                              }]).find(params[:order_id])
  end

  def sort_column
    return 'users.last_name' if params[:sort] == 'user_name'
    ReturnAuthorization.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end

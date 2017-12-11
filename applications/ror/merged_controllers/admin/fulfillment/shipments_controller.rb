class Admin::Fulfillment::ShipmentsController < Admin::Fulfillment::BaseController
  # GET /admin/fulfillment/shipments
  # GET /admin/fulfillment/shipments.xml
  def index
    @shipments = Shipment.includes([:order, {:order_items => {:variant => :product} }])
    if params[:order_id].present?
      @order = Order.find_by_number(params[:order_id])
      @shipments = @shipments.where(['shipments.order_id = ?', @order.id])
    end
  end

  # GET /admin/fulfillment/shipments/1
  # GET /admin/fulfillment/shipments/1.xml
  def show
    @shipment = Shipment.includes([{:order => :user}, :address, {:order_items => {:variant => :product} }]).find(params[:id])
    add_to_recent_user(@shipment.order.user)
  end

  # GET /admin/fulfillment/shipments/new
  # GET /admin/fulfillment/shipments/new.xml
  def new
    @shipment = Shipment.new
    form_info
  end

  # GET /admin/fulfillment/shipments/1/edit
  def edit
    @shipment = Shipment.find(params[:id])
    form_info
  end


  # create shipments if they wre created already
  def create
    #@shipment = Shipment.new(params[:shipment])
    @order = Order.find_by_number(params[:order_number])

    respond_to do |format|
      if @order.shipments.count == 0
        @shipments = Shipment.create_shipments_with_items(@order)
        format.html { redirect_to(admin_fulfillment_shipments_path(:order_id => @order.number), :notice => 'Shipment was successfully created.') }
      else
        form_info
        flash[:alert] = 'This order already has a shipment.'
        format.html { redirect_to(edit_admin_fulfillment_order_path( @order )) }
      end
    end
  end

  # PUT /admin/fulfillment/shipments/1
  # PUT /admin/fulfillment/shipments/1.xml
  def update
    @shipment = Shipment.find(params[:id])

    respond_to do |format|
      if @shipment.update_attributes(allowed_params)
        format.html { redirect_to(admin_fulfillment_shipment_path(@shipment, :order_id => @shipment.order.number), :notice => 'Shipment was successfully updated.') }
      else
        form_info
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

 render :partial => '/shared/compact_address', :locals => {:shopping_address => @shipment.address} 
 link_to 'Change Address', edit_admin_fulfillment_shipment_address_path(@shipment, @shipment.address) 
 form_for(@shipment, :url => admin_fulfillment_shipment_path(@shipment)) do |f| 
 render :partial => 'form', :locals => {:f => f } 
 end 
 link_to 'Show', admin_fulfillment_shipment_path(@shipment) 
 link_to 'Back', admin_fulfillment_shipments_path(:order_id => @shipment.order.number) 
 @shipment.order.comments.each do |comment| 
 comment.note 
 end 
 form_for( @comment,

                  :url => admin_fulfillment_order_comments_path(@shipment.order),
                  :html => {'data-order_id' => @shipment.order.number}
                ) do |f| 
 render :partial => 'comments_form', :locals => {:f => f } 
 end 
 content_for :bottom do 
 javascript_include_tag "admin/fulfillment_shipment.js" 
 end 

 end

  # PUT /admin/fulfillment/shipments/1
  # PUT /admin/fulfillment/shipments/1.xml
  def ship
    load_info
    @shipment = Shipment.includes({:order_items => :variant}).find(params[:id])

    respond_to do |format|
      if @shipment.ship!
        format.html { redirect_to(admin_fulfillment_shipment_path(@shipment, :order_id => @shipment.order.number), :notice => 'Shipment was successfully updated.') }
      else
        format.html { redirect_to(admin_fulfillment_shipment_path(@shipment, :order_id => @shipment.order.number), :error => 'Shipment could not be shipped!!!') }
      end
    end
  end

  # DELETE /admin/fulfillment/shipments/1
  # DELETE /admin/fulfillment/shipments/1.xml
  def destroy
    @shipment = Shipment.find(params[:id])
    raise error
    @shipment.update_attributes(:active => false)


    # We need to add capability to refund and return to stock in one large destroy form

    respond_to do |format|
      format.html { redirect_to(admin_fulfillment_shipments_url( :order_id => (@shipment.order.number)) ) }
    end
  end

  private

  def allowed_params
    params.require(:shipment).permit!
  end

  def load_info
    @order = Order.includes([:shipments, {:order_items => [:shipment, {:variant => :product}]}]).find_by_number(params[:order_id])
  end

  def form_info
    @comment = Comment.new()
  end

end

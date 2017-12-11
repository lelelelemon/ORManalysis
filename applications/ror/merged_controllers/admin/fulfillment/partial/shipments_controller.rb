class Admin::Fulfillment::Partial::ShipmentsController < Admin::Fulfillment::BaseController
  def create
    @order = Order.find_by_number(params[:order_id])
    if  @order.create_shipments_with_order_item_ids(params[:order_item_ids])
      redirect_to edit_admin_fulfillment_order_url( @order ), notice: "Successfully created shipment."
    else
      flash[:alert] = "There was an issue creating the shipment."
      render :new
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

 end

  def new
    @order = Order.includes({:order_items => {:variant => :product}}).find_by_number(params[:order_id])
  end

  def update
    @order = Order.find_by_number(params[:order_id])
    if  @order.create_shipments_with_order_item_ids(order_item_ids)
      redirect_to edit_admin_fulfillment_order_url( @order ), :notice => "Successfully created shipment."
    else
      flash[:alert] = "There was an issue creating the shipment."
      render :new
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

 end

  private

    def order_item_ids
      params[:order] ? params[:order][:order_item_ids] : []
    end
end

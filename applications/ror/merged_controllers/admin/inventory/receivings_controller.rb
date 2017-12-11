class Admin::Inventory::ReceivingsController < Admin::BaseController
  helper_method :sort_column, :sort_direction
  def index
    # by default find all POs that are not received
    @purchase_orders = PurchaseOrder.receiving_admin_grid(params).order(sort_column + " " + sort_direction).
                                                        paginate( page: pagination_page, per_page: pagination_rows)
  end

  def edit
    @purchase_order = PurchaseOrder.includes([:variants ,
                                              :supplier,
                                              { purchase_order_variants: { variant: :product }}]).find(params[:id])
  end

  def update
    @purchase_order = PurchaseOrder.find(params[:id])

    if @purchase_order.update_attributes(allowed_params)
      redirect_to(:action => :index, :notice => 'Purchase order was successfully updated.')
    else
      render action: "edit"
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

  def show
  end

private

  def allowed_params
    params.require(:purchase_order).permit(:invoice_number, :tracking_number, :notes, :receive_po)
  end

  def pagination_rows
    params[:rows] ||= 25
    params[:rows].to_i
  end

  def sort_column
    return 'suppliers.name' if params[:sort] == 'supplier_name'
    PurchaseOrder.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end

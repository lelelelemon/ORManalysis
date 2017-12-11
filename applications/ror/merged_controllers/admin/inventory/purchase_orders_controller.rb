class Admin::Inventory::PurchaseOrdersController < Admin::BaseController
  helper_method :sort_column, :sort_direction
  # GET /purchase_orders
  def index
    @purchase_orders = PurchaseOrder.admin_grid(params).order(sort_column + " " + sort_direction).
                                                        paginate(:page => pagination_page, :per_page => pagination_rows)

  end

  # GET /purchase_orders/1
  def show
    @purchase_order = PurchaseOrder.find(params[:id])
  end

  # GET /purchase_orders/new
  def new
    @purchase_order = PurchaseOrder.new
    form_info
    if @select_suppliers.empty?
      flash[:notice] = 'You need to have a supplier before you can create a purchase order.'
      redirect_to new_admin_inventory_supplier_url
    end
  end

  # GET /purchase_orders/1/edit
  def edit
    @purchase_order = PurchaseOrder.find(params[:id])
    form_info
  end

  # POST /purchase_orders
  def create
    @purchase_order = PurchaseOrder.new(allowed_params)

    if @purchase_order.save
      redirect_to(:action => :index, :notice => 'Purchase order was successfully created.')
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

 form_for @purchase_order, url: admin_inventory_purchase_orders_path do |form| 
 render partial: '/admin/inventory/purchase_orders/form', locals: { form: form } 
 submit_tag "Create", class: "button float-right" 
 link_to 'Back', admin_inventory_purchase_orders_path, class: 'tiny button secondary' 
 end 
 content_for :head do 
 stylesheet_link_tag 'chosen.css' 
 end 
 content_for :below_body do 
 javascript_include_tag 'chosen/chosen.jquery.min.js' 
 javascript_include_tag 'admin/purchase_orders' 
 end 

 end

  # PUT /purchase_orders/1
  def update
    @purchase_order = PurchaseOrder.find(params[:id])
    if @purchase_order.update_attributes(allowed_params)
      redirect_to(:action => :index, :notice => 'Purchase order was successfully updated.')
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

 form_for @purchase_order, :url  => admin_inventory_purchase_order_path(@purchase_order) do |form| 
 render :partial => '/admin/inventory/purchase_orders/form', :locals => {:form => form} 
 submit_tag "Update", class: "button float-right" 
 end 
 if !@purchase_order.receive_po 
 link_to 'Receive PO', edit_admin_inventory_receiving_path(@purchase_order) 
 end 
 link_to 'Back', admin_inventory_purchase_orders_path 
 content_for :head do 
 stylesheet_link_tag 'chosen.css' 
 end 
 content_for :below_body do 
 javascript_include_tag 'chosen/chosen.jquery.min.js' 
 javascript_include_tag 'admin/purchase_orders' 
 end 

 end

  # DELETE /purchase_orders/1
  def destroy
    @purchase_order = PurchaseOrder.find(params[:id])
    @purchase_order.destroy
    redirect_to(admin_inventory_purchase_orders_url)
  end
  private


  def allowed_params
    params.require(:purchase_order).permit!
  end

  def form_info
    @select_suppliers = Supplier.all.collect{|s| [s.name, s.id]}
    @select_variants  = Variant.includes(:product).collect {|v| [v.name_with_sku, v.id]}
  end

  def sort_column
    return 'suppliers.name' if params[:sort] == 'supplier_name'
    PurchaseOrder.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end

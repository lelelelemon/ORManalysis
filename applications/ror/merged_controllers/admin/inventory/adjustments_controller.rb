class Admin::Inventory::AdjustmentsController < Admin::BaseController
  def show
    @product = Product.friendly.includes(:variants).find(params[:id])
  end

  def index
    @products = Product.paginate(:page => pagination_page, :per_page => pagination_rows)
  end

  def edit
    @variant = Variant.includes(:product).find(params[:id])
  end

  def update
    @variant = Variant.find(params[:id])
    ###  the reason will effect accounting
    #    if the item is refunded by the supplier the accounting will be reflected
    if params[:refund].present? && params[:variant][:qty_to_add].present?
      if params[:refund].to_f > 0.0
        AccountingAdjustment.adjust_stock(@variant.inventory, params[:variant][:qty_to_add].to_i, params[:refund].to_f)
        flash[:notice] = "Successfully updated the inventory."
        redirect_to admin_inventory_adjustment_url(@variant.product)
      elsif @variant.update_attributes(allowed_params)
        flash[:notice] = "Successfully updated the inventory."
        redirect_to admin_inventory_adjustment_url(@variant.product)
      else
        render :action => 'edit', :id => params[:id]
      end
    else
      flash[:alert] = "Refund must be entered (fill in 0 for no refund)." unless params[:refund].present?
      render :action => 'edit', :id => params[:id]
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

 @variant.product_name 
 form_for(@variant, url: admin_inventory_adjustment_path(@variant)) do |f| 
 render partial: 'form', locals: { f: f } 
 f.submit "Update Inventory",
                    class: "button",
                    id:    "adjust_inventory_button" 
 end 
 @variant.sku 
 @variant.inventory.count_on_hand 
 @variant.inventory.count_pending_to_customer 
 @variant.inventory.count_pending_from_supplier 
 link_to "Show #{@variant.product_name}" , admin_inventory_adjustment_path( @variant.product ), class: 'button secondary' 
 link_to 'View Products', admin_inventory_adjustments_path, class: 'button secondary' 

 end

  private

  def allowed_params
    params.require(:variant).permit(:qty_to_add)
  end

end


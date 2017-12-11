class Admin::Inventory::OverviewsController < Admin::BaseController

  def index
    @products = Product.active.order("#{params[:sidx]} #{params[:sord]}").
                        includes({:variants => [{:variant_properties => :property}, :inventory]}).
                        paginate(:page => pagination_page, :per_page => pagination_rows)

  end

  def edit
    @product = Product.friendly.includes(:variants).find(params[:id])
  end

  def update
    @product = Product.friendly.find(params[:id])

    if @product.update_attributes(allowed_params)
      redirect_to action: :index
    else
      render action: :edit
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

  def allowed_params
    params.require(:product).permit!
  end

end

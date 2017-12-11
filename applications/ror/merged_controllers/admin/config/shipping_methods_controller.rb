class Admin::Config::ShippingMethodsController < Admin::Config::BaseController
  # GET /admin/config/shipping_methods
  def index
    @shipping_methods = ShippingMethod.all
  end

  # GET /admin/config/shipping_methods/new
  def new

    form_info
    if @shipping_zones.empty?
        flash[:notice] = "You must create a Shipping Zone before you create a Shipping Method."
        redirect_to new_admin_config_shipping_zone_path
    else
      @shipping_method = ShippingMethod.new
    end
  end

  # GET /admin/config/shipping_methods/1/edit
  def edit
    @shipping_method = ShippingMethod.find(params[:id])
    form_info
  end

  # POST /admin/config/shipping_methods
  def create
    @shipping_method = ShippingMethod.new(allowed_params)

    if @shipping_method.save
      redirect_to(admin_config_shipping_methods_url, notice: 'Shipping method was successfully created.')
    else
      form_info
      render action: "new"
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

  # PUT /admin/config/shipping_methods/1
  def update
    @shipping_method = ShippingMethod.find(params[:id])
    if @shipping_method.update_attributes(allowed_params)
      redirect_to(admin_config_shipping_methods_url, notice: 'Shipping method was successfully updated.')
    else
      form_info
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

  private

  def allowed_params
    params.require(:shipping_method).permit(:name, :shipping_zone_id)
  end

  def form_info
    @shipping_zones = ShippingZone.all.map{|sz| [sz.name, sz.id]}
  end
end

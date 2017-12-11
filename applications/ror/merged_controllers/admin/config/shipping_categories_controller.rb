class Admin::Config::ShippingCategoriesController < Admin::Config::BaseController
  # GET /admin/merchandise/shipping_categories
  def index
    @shipping_categories = ShippingCategory.all
  end

  # GET /admin/merchandise/shipping_categories/1
  def show
    @shipping_category = ShippingCategory.find(params[:id])
  end

  # GET /admin/merchandise/shipping_categories/new
  def new
    @shipping_category = ShippingCategory.new
  end

  # GET /admin/merchandise/shipping_categories/1/edit
  def edit
    @shipping_category = ShippingCategory.find(params[:id])
  end

  # POST /admin/merchandise/shipping_categories
  def create
    @shipping_category = ShippingCategory.new(allowed_params)

    if @shipping_category.save
      redirect_to(admin_config_shipping_rates_url(), notice: 'Shipping category was successfully created.')
    else
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

 form_for(@shipping_category, url: admin_config_shipping_categories_path) do |f| 
 render partial: 'form', locals: { f: f } 
 end 
 link_to 'Back', admin_config_shipping_categories_path, class: 'button' 

 end

  # PUT /admin/merchandise/shipping_categories/1
  def update
    @shipping_category = ShippingCategory.find(params[:id])

    if @shipping_category.update_attributes(allowed_params)
      redirect_to(admin_config_shipping_rates_url(), notice: 'Shipping category was successfully updated.')
    else
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

 @shipping_category.name 
 form_for(@shipping_category, url: admin_config_shipping_category_path(@shipping_category)) do |f| 
 render partial: 'form', locals: { f: f } 
 end 
 link_to 'Show', admin_config_shipping_category_path(@shipping_category), class: 'button' 
 link_to 'Back', admin_config_shipping_categories_path, class: 'button' 

 end

  # DELETE /admin/merchandise/shipping_categories/1
  #def destroy
  #  @shipping_category = ShippingCategory.find(params[:id])
  # # @shipping_category.destroy
  #
  #  respond_to do |format|
  #    format.html { redirect_to(admin_merchandise_shipping_categories_url) }
  #  end
  #end

  private

  def allowed_params
    params.require(:shipping_category).permit(:name)
  end
end

class Admin::Merchandise::BrandsController < Admin::BaseController
  def index
    @brands = Brand.all
  end

  def show
    @brand = Brand.find(params[:id])
  end

  def new
    @brand = Brand.new
  end

  def create
    @brand = Brand.new(allowed_params)
    if @brand.save
      flash[:notice] = "Successfully created brand."
      redirect_to admin_merchandise_brand_url(@brand)
    else
      render :action => 'new'
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

 render partial: '/admin/merchandise/sub_header'
 form_for(@brand, :url => admin_merchandise_brands_path(@brand)) do |f| 
 render partial: 'form', locals: { f: f } 
 f.submit 'Create', class: 'button' 
 end 
 link_to 'Back to List', admin_merchandise_brands_path, class: 'button' 

 end

  def edit
    @brand = Brand.find(params[:id])
  end

  def update
    @brand = Brand.find(params[:id])
    if @brand.update_attributes(allowed_params)
      flash[:notice] = "Successfully updated brand."
      redirect_to admin_merchandise_brand_url(@brand)
    else
      render :action => 'edit'
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

 render partial: '/admin/merchandise/sub_header'
 @brand.name 
 form_for(@brand, url: admin_merchandise_brand_path(@brand)) do |f| 
 render partial: 'form', locals: { f: f } 
 f.submit 'Update', class: 'button' 
 end 
 link_to 'Show', admin_merchandise_brand_path( @brand ), class: 'button' 
 link_to 'View All', admin_merchandise_brands_path, class: 'button' 

 end

  def destroy
    @brand = Brand.find(params[:id])

    if @brand.products.empty?
      @brand.destroy
    else
      flash[:alert] = "Sorry this brand is already associated with a product.  You can not delete this brand."
    end

    redirect_to admin_merchandise_brands_url
  end

  private

  def allowed_params
    params.require(:brand).permit(:name)
  end

end

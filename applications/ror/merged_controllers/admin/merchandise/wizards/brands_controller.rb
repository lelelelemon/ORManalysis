class Admin::Merchandise::Wizards::BrandsController < Admin::Merchandise::Wizards::BaseController
  helper_method :selected?
  def index
    form_info
    session[:product_wizard] ||= {}
  end

  def create
    @brand = Brand.new(allowed_params)
    if @brand.save
      session[:product_wizard] ||= {}
      session[:product_wizard][:brand_id] = @brand.id
      flash[:notice] = "Successfully created brand."
      redirect_to next_form
    else
      form_info
      render :action => 'index'
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

 render :partial => '/admin/merchandise/wizards/sub_header'
 if  @brands.empty? 
 else 
 end 
 @brands.each do |brand| 
 cycle( '', 'last') 
 'selected' if selected?(brand.id) 
 brand.name 
 button_to 'Use', admin_merchandise_wizards_brand_path(brand), class: "button secondary inline-block", method: :put 
 end 
 unless  @brands.empty? 
 end 
 form_for @brand, url: admin_merchandise_wizards_brands_path do |brand_form| 
 render partial: 'form', locals: { f: brand_form }  
 end 

 content_for :sidemenu do 
 link_to 'Brand', admin_merchandise_wizards_brands_path 
 link_to 'Product Type', admin_merchandise_wizards_product_types_path 
 link_to 'Properties', admin_merchandise_wizards_properties_path 
 link_to 'Shipping Categories', admin_merchandise_wizards_shipping_categories_path 
 link_to 'Product', new_admin_merchandise_wizards_product_path unless next_wizard_form 
 end 

 end

  def update
    @brand = Brand.find_by_id(params[:id])
    if @brand
      session[:product_wizard] ||= {}
      session[:product_wizard][:brand_id] = @brand.id
      flash[:notice] = "Successfully added brand."
      redirect_to next_form
    else
      form_info
      render :action => 'index'
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

 render :partial => '/admin/merchandise/wizards/sub_header'
 if  @brands.empty? 
 else 
 end 
 @brands.each do |brand| 
 cycle( '', 'last') 
 'selected' if selected?(brand.id) 
 brand.name 
 button_to 'Use', admin_merchandise_wizards_brand_path(brand), class: "button secondary inline-block", method: :put 
 end 
 unless  @brands.empty? 
 end 
 form_for @brand, url: admin_merchandise_wizards_brands_path do |brand_form| 
 render partial: 'form', locals: { f: brand_form }  
 end 

 content_for :sidemenu do 
 link_to 'Brand', admin_merchandise_wizards_brands_path 
 link_to 'Product Type', admin_merchandise_wizards_product_types_path 
 link_to 'Properties', admin_merchandise_wizards_properties_path 
 link_to 'Shipping Categories', admin_merchandise_wizards_shipping_categories_path 
 link_to 'Product', new_admin_merchandise_wizards_product_path unless next_wizard_form 
 end 

 end

  private

  def allowed_params
    params.require(:brand).permit(:name)
  end

  def form_info
    @brands ||= Brand.all
    @brand ||= Brand.new
  end

  def selected?(id)
    session[:product_wizard][:brand_id] && session[:product_wizard][:brand_id] == id
  end
end

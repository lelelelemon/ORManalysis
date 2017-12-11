class Admin::Merchandise::Wizards::ProductsController < Admin::Merchandise::Wizards::BaseController
  def new
    if f = next_wizard_form
      redirect_to f
    else
      form_info
      @product = Product.new
      @product.brand_id         = session[:product_wizard][:brand_id]
      @product.product_type_id  = session[:product_wizard][:product_type_id]

      @product.shipping_category_id = session[:product_wizard][:shipping_category_id]
    end
  end

  def create
    @product = Product.new(allowed_params)
    if @product.save
      reset_product_wizard
      flash[:notice] = "Successfully created product."
      redirect_to edit_admin_merchandise_products_description_url(@product)
    else
      form_info
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

 render partial: '/admin/merchandise/wizards/sub_header'
 form_for(@product, url: admin_merchandise_wizards_products_path()) do |f| 
 render partial: 'form', locals: { form: f } 
 submit_tag "Create", class: "button" 
 end 

 end

  private

  def allowed_params
    params.require(:product).permit(:name, :description, :product_keywords, :set_keywords, :product_type_id, :prototype_id, :shipping_category_id, :permalink, :available_at, :deleted_at, :meta_keywords, :meta_description, :featured, :description_markup, :brand_id)
  end

  def form_info
    if session[:product_wizard][:prototype_id]
      @all_properties           = Prototype.find(session[:product_wizard][:prototype_id]).properties
    else #@all_properties           = Property.all
      @all_properties           = Property.find(session[:product_wizard][:property_ids])
    end
    @select_product_types     = ProductType.all.collect{|pt| [pt.name, pt.id]}
    @select_shipping_category = ShippingCategory.all.collect {|sc| [sc.name, sc.id]}
    @brands        = Brand.order(:name).collect {|ts| [ts.name, ts.id]}
  end
end

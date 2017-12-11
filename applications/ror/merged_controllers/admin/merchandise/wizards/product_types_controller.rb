class Admin::Merchandise::Wizards::ProductTypesController < Admin::Merchandise::Wizards::BaseController
  helper_method :selected?
  def index
    form_info
  end

  def create
    product_type = ProductType.new(allowed_params)

    flash[:notice] = "Successfully created product type." if product_type.save
    form_info
    render :action => 'index'
 
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
 if  @product_types.empty? 
 else 
 end 
 @product_types.each do |product_type| 
 cycle( '', 'last') 
 'selected' if selected?(product_type.id) 
 product_type.name 
 button_to 'Use', admin_merchandise_wizards_product_type_path(product_type),
                    class: "button secondary inline-block  ",
                    method: :put 
 end 
 form_for @product_type, url: admin_merchandise_wizards_product_types_path do |product_type_form| 
 render partial: 'form', locals: { form: product_type_form } 
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
    @product_type = ProductType.find_by_id(params[:id])
    if @product_type
      session[:product_wizard] ||= {}
      session[:product_wizard][:product_type_id] = @product_type.id
      flash[:notice] = "Successfully added product type."
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
 if  @product_types.empty? 
 else 
 end 
 @product_types.each do |product_type| 
 cycle( '', 'last') 
 'selected' if selected?(product_type.id) 
 product_type.name 
 button_to 'Use', admin_merchandise_wizards_product_type_path(product_type),
                    class: "button secondary inline-block  ",
                    method: :put 
 end 
 form_for @product_type, url: admin_merchandise_wizards_product_types_path do |product_type_form| 
 render partial: 'form', locals: { form: product_type_form } 
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
    params.require(:product_type).permit(:name, :parent_id)
  end

  def form_info
    @product_types ||= ProductType.all
    @product_type ||= ProductType.new
  end

  def selected?(id)
    session[:product_wizard][:product_type_id] && session[:product_wizard][:product_type_id] == id
  end
end

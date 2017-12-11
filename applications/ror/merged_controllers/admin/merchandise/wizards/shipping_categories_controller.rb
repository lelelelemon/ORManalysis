class Admin::Merchandise::Wizards::ShippingCategoriesController < Admin::Merchandise::Wizards::BaseController
  helper_method :selected?
  def index
    form_info
  end

  def create
    @shipping_category = ShippingCategory.new(allowed_params)
    if @shipping_category.save
      session[:product_wizard] ||= {}
      session[:product_wizard][:shipping_category_id] = @shipping_category.id
      flash[:notice] = "Successfully created shipping category."
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

 render partial: '/admin/merchandise/wizards/sub_header'
 if  @shipping_categories.empty? 
 else 
 end 
 @shipping_categories.each do |shipping_category| 
 cycle( '', 'last') 
 selected?(shipping_category.id)  
 shipping_category.name 
 button_to 'Use', admin_merchandise_wizards_shipping_category_path(shipping_category),
                   class: "button secondary inline-block",
                   method: :put 
 end 
 form_for @shipping_category, url: admin_merchandise_wizards_shipping_categories_path do |shipping_category_form| 
 render partial: 'form', locals: { f: shipping_category_form }  
 end 

 end

  def update
    @shipping_category = ShippingCategory.find_by_id(params[:id])
    if @shipping_category
      session[:product_wizard] ||= {}
      session[:product_wizard][:shipping_category_id] = @shipping_category.id
      flash[:notice] = "Successfully updated shipping category."
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

 render partial: '/admin/merchandise/wizards/sub_header'
 if  @shipping_categories.empty? 
 else 
 end 
 @shipping_categories.each do |shipping_category| 
 cycle( '', 'last') 
 selected?(shipping_category.id)  
 shipping_category.name 
 button_to 'Use', admin_merchandise_wizards_shipping_category_path(shipping_category),
                   class: "button secondary inline-block",
                   method: :put 
 end 
 form_for @shipping_category, url: admin_merchandise_wizards_shipping_categories_path do |shipping_category_form| 
 render partial: 'form', locals: { f: shipping_category_form }  
 end 

 end

  private

  def allowed_params
    params.require(:shipping_category).permit(:name)
  end

  def form_info
    @shipping_categories ||= ShippingCategory.all
    @shipping_category ||= ShippingCategory.new
  end

  def selected?(id)
    (session[:product_wizard][:shipping_category_id] && session[:product_wizard][:shipping_category_id] == id) ? 'selected' : ''
  end
end

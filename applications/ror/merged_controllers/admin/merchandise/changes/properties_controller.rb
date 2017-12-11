class Admin::Merchandise::Changes::PropertiesController < Admin::BaseController
  helper_method :all_properties
  before_action :get_product
  def edit
    #@product.product_properties.build
  end

  def update
    if @product.update_attributes(allowed_params)
      flash[:notice] = "Successfully updated properties."
      redirect_to admin_merchandise_product_url(@product.id)
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
 form_for(@product, url: admin_merchandise_changes_product_property_path(@product.id)) do |f| 
 render partial: 'form', locals: { f: f } 
 f.submit "Update",
                    class: "button",
                    id:    "update_product_properties_button" 
 link_to "Back to Product", admin_merchandise_product_path(@product), class: 'button' 
 end 

 end

  private

  def allowed_params
    params.require(:product).permit!
  end

  def all_properties
     @all_properties ||= Property.all.map{|p| [ p.identifing_name, p.id ]}
  end

  def get_product
    @product = Product.friendly.find_by(id: params[:product_id])
  end

end

class Admin::Merchandise::Products::DescriptionsController < Admin::BaseController
  def edit
    @product = Product.friendly.find(params[:id])
  end

  def update
    @product = Product.friendly.find(params[:id])
    if @product.update_attributes(allowed_params)
      redirect_to admin_merchandise_product_url(@product)
    else
      render :action => :edit
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
 link_to 'Back to Product', admin_merchandise_product_path(@product), class: 'button secondary float-right small', style: "margin-top:-5px" 
 form_for @product, url: admin_merchandise_products_description_path(@product) do |f| 
 f.text_field :name 
 f.text_area :description_markup, id: "markItUp", cols: "92", rows: "15" 
 f.submit "Update", class: "button" 
 end 
 content_for :head do 
 stylesheet_link_tag "markitup/skins/markitup/style" 
 stylesheet_link_tag "markitup/sets/default/style" 
 end 
 content_for :bottom do 
 javascript_include_tag "markitup/jquery.markitup" 
 javascript_include_tag "markitup/sets/default/set" 
 end 

 end
  private

  def allowed_params
    params.require(:product).permit(:name, :description_markup)
  end
end

class Admin::Merchandise::ProductsController < Admin::BaseController
  helper_method :sort_column, :sort_direction, :product_types
  authorize_resource

  def index
    params[:page] ||= 1
    @products = Product.admin_grid(params).order(sort_column + " " + sort_direction).
                                              paginate(page: pagination_page, per_page: pagination_rows)
  end

  def show
    @product        = Product.friendly.find(params[:id])
    @shipping_zones =  ShippingZone.all
    respond_to do |format|
      format.html
      format.json { render json: @product }
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
 @product.name 
 @product.active ? "#3A3" : "#C33" 
 if @product.active? 
 link_to 'Make Inactive', admin_merchandise_product_path(@product),
                          :method => :delete,
                          :data => {:confirm => "This will inactivate the product,  Are you sure?"},
                          :class => 'button success float-right' 
 elsif @product.available? 
 link_to 'Activate', activate_admin_merchandise_product_path(@product),
                              :method => 'PUT',
                              :data => {:confirm => "This will activate the product,  Are you sure?"},
                              :class => 'button alert float-right' 
 else 
 end 
 @product.name 
 link_to 'edit', edit_admin_merchandise_products_description_path(@product) 
 raw @product.description 
 @product.meta_keywords 
 @product.meta_description 
 @product.product_type.name 
 @product.shipping_category.name 
 rates = @product.shipping_category.shipping_rates 
 link_to 'Shipping Zone', admin_config_shipping_rates_path 
 @shipping_zones.each do |zone| 
 zone.name 
 product_rates = rates.map { |rate| rate.shipping_method.name if rate.shipping_method.shipping_zone_id == zone.id }.compact 
 if product_rates.empty? 
 else 
 product_rates.join('</br>').html_safe 
 end 
 end 
 @product.product_properties.each do |product_prop|  
 product_prop.property.identifing_name 
 product_prop.description 
 end 
 if @product.variants.size == 0 
 link_to 'Create some variants?', edit_admin_merchandise_multi_product_variant_path(@product) 
 else 
 link_to 'Edit Variants', edit_admin_merchandise_multi_product_variant_path(@product) 
 @product.variants.each do |variant|  
 'color:#FFAEB9;' unless variant.active? 
 variant.sku 
 variant.price 
 variant.cost 
 variant.brand.try(:name) 
 link_to '2', admin_merchandise_product_variant_path(@product, variant) 
 end 
 end 
 link_to 'edit', edit_admin_merchandise_images_product_path(@product) 
 @product.images.each do |image| 
 image.photo_file_name 
 image_tag image.photo.url(:small) 
 end 
 link_to 'All Products', admin_merchandise_products_path(), :class => 'button yellow warning'

 end

  def new
    form_info
    if @prototypes.empty?
      flash[:notice] = "You must create a prototype before you create a product."
      redirect_to new_admin_merchandise_prototype_url
    else
      @product            = Product.new
      @product.prototype  = Prototype.new
    end
  end

  def create
    @product = Product.new(allowed_params)

    if @product.save
      flash[:notice] = "Success, You should create a variant for the product."
      redirect_to edit_admin_merchandise_products_description_url(@product)
    else
      form_info
      flash[:error] = "The product could not be saved"
      render action: :new
    end
  rescue
    render :text => "Please make sure you have solr started... Run this in the command line => bundle exec rake sunspot:solr:start"
 
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

  def edit
    @product        = Product.friendly.includes(:properties,:product_properties, {:prototype => :properties}).find(params[:id])
    form_info
  end

  def update
    @product = Product.friendly.find(params[:id])

    if @product.update_attributes(allowed_params)
      redirect_to admin_merchandise_product_url(@product)
    else
      form_info
      render action: :edit#, :layout => 'admin_markup'
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

  def add_properties
    prototype  = Prototype.friendly.includes(:properties).find(params[:id])
    @properties = prototype.properties
    all_properties = Property.all

    @properties_hash = all_properties.inject({:active => [], :inactive => []}) do |h, property|
      if  @properties.detect{|p| (p.id == property.id) }
        h[:active] << property.id
      else
        h[:inactive] << property.id
      end
      h
    end
    respond_to do |format|
      format.html
      format.json { render json: @properties_hash.to_json }
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

 @prototype.properties.each_with_index do |property, i| 
 check_box_tag 'product[property][]',property.id 
 property.display_name 
 raw '<br>' if i%3 == 2 
 end 

 end

  def activate
    @product = Product.friendly.find(params[:id])
    @product.deleted_at = nil
    if @product.save
      redirect_to admin_merchandise_product_url(@product)
    else
      if @product.description.blank?
        flash[:alert] = "Please add a description before Activating."
      else
        flash[:alert] = @product.errors.full_messages.join('  ')
      end
      redirect_to edit_admin_merchandise_products_description_url(@product)
    end
  end

  def destroy
    @product = Product.friendly.find(params[:id])
    @product.deleted_at ||= Time.zone.now
    @product.save

    redirect_to admin_merchandise_product_url(@product)
  end

  private

    def allowed_params
      params.require(:product).permit(:name, :description, :product_keywords, :set_keywords, :product_type_id,
                                      :prototype_id, :shipping_category_id, :permalink, :available_at, :deleted_at,
                                      :meta_keywords, :meta_description, :featured, :description_markup, :brand_id,
                                      product_properties_attributes: [:id, :product_id, :property_id, :position, :description])
    end

    def form_info
      @prototypes               = Prototype.all.map{|pt| [pt.name, pt.id]}
      @all_properties           = Property.all
      @select_shipping_category = ShippingCategory.all.map {|sc| [sc.name, sc.id]}
      @brands                   = Brand.order(:name).map {|ts| [ts.name, ts.id]}
    end

    def product_types
      @product_types ||= ProductType.all
    end

    def sort_column
      Product.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

end

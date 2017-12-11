class Admin::Merchandise::VariantsController < Admin::BaseController
  helper_method :sort_column, :sort_direction

  def index
    @product = Product.friendly.find(params[:product_id])
    @variants = @product.variants.admin_grid(@product, params).order(sort_column + " " + sort_direction).
                                              paginate(:page => pagination_page, :per_page => pagination_rows)
  end

  def show
    @variant = Variant.includes(:product).find(params[:id])
    @product  =  @variant.product
    respond_to do |format|
      format.html
      format.json { render json: @variant }
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
 '*' if @variant.master 
 @variant.sku 
 link_to "Back to Product", admin_merchandise_product_path(@product), class: 'button small' 
 link_to 'Edit Variant', edit_admin_merchandise_product_variant_path(@product, @variant), class: 'button' 
 label :variant, :sku 
 @variant.sku 
 label :variant, :price 
 @variant.price 
 label :variant, :cost 
 @variant.cost 
 label :variant, :count_on_hand 
 @variant.count_on_hand 
 label :variant, :count_pending_to_customer 
 @variant.count_pending_to_customer 
 label :variant, :count_pending_from_supplier 
 @variant.count_pending_from_supplier 
 @variant.variant_properties.each do |variant_prop|  
 variant_prop.property.identifing_name 
 variant_prop.description 
 end 
 if @variant.active? 
 link_to 'Inactivate Variant',
              admin_merchandise_product_variant_path(@product, @variant),
              class: 'button red-button alert', method: :delete, data: { confirm: "Are you sure?" } 
 end 

 end

  def new
    form_info
    @product = Product.friendly.find(params[:product_id])
    @variant = @product.variants.new()
  end

  def create
    @product = Product.friendly.find(params[:product_id])
    @variant = @product.variants.new(allowed_params)

    if @variant.save
      redirect_to admin_merchandise_product_variants_url(@product)
    else
      form_info
      flash[:error] = "The variant could not be saved"
      render :action => :new
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

 render :partial => '/admin/merchandise/sub_header'
 @product.name 
 link_to "Back to Product", admin_merchandise_product_path(@product), class: 'button small' 
 form_for @variant, :url  => admin_merchandise_product_variants_path(@product,@variant),
                        :html => {:class => ''}  do |form| 
 render :partial => '/admin/merchandise/variants/form', :locals => {:form => form}
 submit_tag "Create",
                    :class  => "button",
                    :id     => "create_variant_button" 
 end 

 if @product && @product.id 
 content_for :sidemenu do 
 link_to 'Description',
                      edit_admin_merchandise_products_description_path(@product),
                      :style => "#{@product.description.blank? ? 'color:#EF2255;' : ''}" 
 link_to 'Images',
                      edit_admin_merchandise_images_product_path(@product),
                      :style => "#{@product.images.size == 0 ? 'color:#EF2255;' : ''}" 
 link_to 'Product',     admin_merchandise_product_path(@product) 
 link_to 'Properties',
                          edit_admin_merchandise_changes_product_property_path(@product.id),
                          :style => "#{@product.properties.size == 0 ? 'color:#EF2255;' : ''}" 
 link_to 'Variants',
                      edit_admin_merchandise_multi_product_variant_path(@product),
                      :style => "#{@product.variants.size == 0 ? 'color:#EF2255;' : ''}" 
 link_to "Inventory",
                      admin_inventory_adjustment_path(@product) 
 end 
 end 

 end

  def edit
    @variant  = Variant.includes(:properties,:variant_properties, {:product => :properties}).find(params[:id])
    @product  =  @variant.product
    form_info
  end

  def update
    @variant = Variant.includes( :product ).find(params[:id])

    if @variant.update_attributes(allowed_params)
      redirect_to admin_merchandise_product_variants_url(@variant.product)
    else
      form_info
      @product  =  @variant.product
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
 @product.name 
 form_for @variant, url: admin_merchandise_product_variant_path(@product, @variant),
                         html: { class: ''}  do |form| 
 render partial: '/admin/merchandise/variants/form', locals: { form: form } 
 submit_tag "Update",
                      class: "button",
                      id:    "create_variant_button" 
 end 

 end

  def destroy
    @variant = Variant.find(params[:id])
    @variant.deleted_at = Time.zone.now
    @variant.save

    redirect_to admin_merchandise_product_variants_url(@variant.product)
  end

  private

  def allowed_params
    params.require(:variant).permit(:sku, :name, :price, :cost, :deleted_at, :master, :inventory_id, :variant_properties_attributes=>{} )
  end

    def form_info

    end

    def sort_column
      Variant.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

end

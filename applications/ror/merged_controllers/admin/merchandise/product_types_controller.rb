class Admin::Merchandise::ProductTypesController < Admin::BaseController
  helper_method :sort_column, :sort_direction

  def index
    @product_types = ProductType.admin_grid(params).order(sort_column + " " + sort_direction).
                                              paginate(:page => pagination_page, :per_page => pagination_rows)
  end

  def show
    @product_type = ProductType.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @product_type }
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

  def new
    @product_type = ProductType.new
    form_info
  end

  def create
    @product_type = ProductType.new(allowed_params)

    if @product_type.save
      redirect_to :action => :index
    else
      form_info
      flash[:error] = "The product_type could not be saved"
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

 render partial: '/admin/merchandise/sub_header'
 form_for @product_type, url: admin_merchandise_product_types_path do |form| 
 render partial: '/admin/merchandise/product_types/form', locals: { form: form, button_action: "Create"}
 end 

 end

  def edit
    @product_type = ProductType.find(params[:id])
    form_info
  end

  def update
    @product_type = ProductType.find(params[:id])

    if @product_type.update_attributes(allowed_params)
      redirect_to :action => :index
    else
      form_info
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
 form_for @product_type, url: admin_merchandise_product_type_path(@product_type) do |form| 
 render partial: '/admin/merchandise/product_types/form', locals: { form: form, button_action: "Update"}
 end 

 end

  def destroy
    @product_type = ProductType.find(params[:id])
    @product_type.active = false
    @product_type.save

    redirect_to :action => :index
  end

  private

  def allowed_params
    params.require(:product_type).permit( :name, :parent_id )
  end

  def form_info
    @product_types = ProductType.all
  end

  def sort_column
    ProductType.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

end

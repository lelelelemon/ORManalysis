class Admin::Merchandise::PropertiesController < Admin::BaseController
  helper_method :sort_column, :sort_direction

  def index
    @properties = Property.admin_grid(params).order(sort_column + " " + sort_direction).
                                              paginate(page: pagination_page, per_page: pagination_rows)
  end

  def new
    @property = Property.new
  end

  def create
    @property = Property.new(allowed_params)
    if @property.save
      redirect_to action: :index
    else
      flash[:error] = "The property could not be saved"
      render action: :new
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

  def edit
    @property = Property.find(params[:id])
  end

  def update
    @property = Property.find(params[:id])
    if @property.update_attributes(allowed_params)
      redirect_to action: :index
    else
      render action: :edit
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

  def destroy
    @property = Property.find(params[:id])
    @property.active = false
    @property.save

    redirect_to action: :index
  end

  private

  def allowed_params
    params.require(:property).permit(:identifing_name, :display_name, :active)
  end

  def sort_column
    Property.column_names.include?(params[:sort]) ? params[:sort] : "identifing_name"
  end

end

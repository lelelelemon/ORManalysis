# Image groups allow any variant to have "variant specific" images.  Thus a red shit would show as red an not green.

class Admin::Merchandise::ImageGroupsController < Admin::BaseController
  helper_method :sort_column, :sort_direction, :products
  def index
    @image_groups = ImageGroup.order(sort_column + " " + sort_direction).
                                     paginate(page: pagination_page, per_page: pagination_rows)
  end

  def show
    @image_group = ImageGroup.find(params[:id])
  end

  def new
    @image_group = ImageGroup.new
  end

  def create
    @image_group = ImageGroup.new(allowed_params)
    if @image_group.save
      redirect_to edit_admin_merchandise_image_group_url( @image_group ), notice: "Successfully created image group."
    else
      render :new
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
    @image_group  = ImageGroup.includes(:images).find(params[:id])
  end

  def update
    @image_group = ImageGroup.find(params[:id])
    if @image_group.update_attributes(allowed_params)
      redirect_to [:admin, :merchandise, @image_group], notice: "Successfully updated image group."
    else
      render :edit
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

  private

    def allowed_params
      params.require(:image_group).permit!
    end

    def products
      @products ||= Product.all.map{|p|[p.name, p.id]}
    end

    def sort_column
      ImageGroup.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

end

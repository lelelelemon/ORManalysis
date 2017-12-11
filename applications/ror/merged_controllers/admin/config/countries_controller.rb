class Admin::Config::CountriesController < Admin::Config::BaseController
  helper_method :sort_column, :shipping_zones
  def index
    @countries = Country.order(sort_column + " " + sort_direction)
    @active_countries = Country.active_countries.order(sort_column + " " + sort_direction).
                                              paginate(page: pagination_page, per_page: pagination_rows)
  end
  def edit
    @country = Country.find(params[:id])
  end

  def update
    @country = Country.find(params[:id])
    if @country.update_attributes(allowed_params)
      redirect_to admin_config_countries_url, :notice  => "Successfully activated country."
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

  def activate
    @country = Country.find(params[:id])
    @country.active = true
    if @country.save
      redirect_to admin_config_countries_url, :notice  => "Successfully activated country."
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

  def destroy
    @country = Country.find(params[:id])
    @country.active = false
    @country.save
    redirect_to admin_config_countries_url, :notice => "Successfully inactivated country."
  end

  private

    def allowed_params
      params.require(:country).permit(:shipping_zone_id)
    end

    def sort_column
      Country.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

    def shipping_zones
      ShippingZone.all.map{|srt| [srt.name, srt.id]}
    end

end

class Admin::Generic::CouponsController < Admin::Generic::BaseController
  def index
    @coupons = Coupon.all
  end

  def show
    @coupon = Coupon.find(params[:id])
  end

  def new
    form_info
    @coupon = Coupon.new
  end

  def create
    @coupon = Coupon.new(allowed_params)
    @coupon.type = params[:c_type]
    @coupon.errors.add(:base, 'please select coupon type') if params[:c_type].blank?
    if @coupon.errors.size == 0 && @coupon.save
      flash[:notice] = "Successfully created coupon."
      redirect_to admin_generic_coupon_url(@coupon)
    else
      form_info
      render :action => 'new'
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

 form_for(@coupon, :as => :coupon, :url => admin_generic_coupons_path(@coupon)) do |f| 
 render :partial => 'form', :locals => {:f => f} 
 end 
 link_to "Back to List", admin_generic_coupons_path, class: "button secondary" 

 end

  def edit
    form_info
    @coupon = Coupon.find(params[:id])
  end

  def update
      @coupon = Coupon.find(params[:id])
    if @coupon.update_attributes(allowed_params)
      flash[:notice] = "Successfully updated coupon."
      redirect_to admin_generic_coupon_url(@coupon)
    else
      form_info
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

 form_for(@coupon, :as => :coupon, :url => admin_generic_coupon_path(@coupon)) do |f| 
 render :partial => 'form', :locals => {:f => f} 
 end 
 link_to 'Show', admin_generic_coupon_path( @coupon ), :class => 'button secondary' 
 link_to 'View All', admin_generic_coupons_path, :class => 'button secondary' 

 end

  def destroy
    @coupon = Coupon.find(params[:id])
    @coupon.destroy
    flash[:notice] = "Successfully destroyed coupon."
    redirect_to admin_generic_coupons_url
  end

  private

  def allowed_params
    params.require(:coupon).permit(:code, :amount, :minimum_value, :percent, :description, :combine, :starts_at, :expires_at)
  end

  def form_info
    @coupon_types = Coupon::COUPON_TYPES
  end
end

class Shopping::CouponsController < Shopping::BaseController
  def show
    form_info
  end

  def create
    @coupon = Coupon.find_by_code(params[:coupon][:code])

    if @coupon && @coupon.eligible?(session_order) && update_order_coupon_id(@coupon.id)
      flash[:notice] = "Successfully added coupon code #{@coupon.code}."
      redirect_to next_form_url(session_order)
    else
      form_info
      flash[:notice] = "Sorry coupon code: #{params[:coupon][:code]} is not valid."
      render :action => 'show'
    end
 
 content_for?(:title) ? "#{site_name}: #{yield(:title)}" : site_name 
 stylesheet_link_tag "normalize.css" 
 stylesheet_link_tag "application.css" 
 stylesheet_link_tag 'site/app.css' 
 stylesheet_link_tag('ie.css', media: 'screen, projection')
 stylesheet_link_tag('ie6.css', media: 'screen, projection') 
 csrf_meta_tag 
 yield :head 
 render 'shared/metadata' 
 render partial: '/shared/welcome_header'
 if notice || alert 
 !!alert ? 'alert' : 'warning' 
 if alert 
 alert 
 elsif notice 
 notice 
 end 
 end 
 "myaccount" if myaccount_tab 
 if myaccount_tab 
 site_name 
 render :partial => '/shared/myaccount_subheader' 
 end 
 yield 
 render 'shared/main_footer' 
 render 'shared/google_analytics' unless @disable_ga 
 javascript_include_tag 'application' 
 yield :bottom 
 yield :below_body 

 unless @coupon.errors.empty? 
 @coupon.errors.full_messages.each do |msg| 
 msg 
 end 
 end 
 form_for(@coupon, :url => shopping_coupon_path(@coupon)) do |f| 
 f.label :code 
 f.text_field :code 
 submit_tag "Save", class: 'button small' 
 link_to 'Skip Coupon', shopping_orders_path, class: ' button small' 
 end 

 end

  private

  def form_info
    @coupon = Coupon.new
  end

  def update_order_coupon_id(id)
    session_order.update_attributes(
                          :coupon_id => id
                                    )
  end
end

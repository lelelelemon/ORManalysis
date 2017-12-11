class NotificationsController < ApplicationController
  before_action :require_user

  def update
    @notification = InStockNotification.where(user_id: current_user.id, notifiable: variant).first_or_create()
    @notification.update_attribute(:sent_at, nil) if @notification.sent_at?
    redirect_to product_url(variant.product), notice: "You will be notified when the item is back in stock."
 
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

 end

  private

  def variant
    @variant ||= Variant.find(params[:id])
  end

end

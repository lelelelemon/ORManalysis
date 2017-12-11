class WelcomeController < ApplicationController
  layout 'welcome'

  def index
    @featured_product = Product.featured
    @best_selling_products = Product.limit(5)
    @other_products  ## search 2 or 3 categories (maybe based on the user)
    unless @featured_product
      if current_user && current_user.admin?
        redirect_to admin_merchandise_products_url
      else
        redirect_to login_url
      end
    end
 
 content_for?(:title) ? "#{site_name}: #{yield(:title)}" : site_name 
 stylesheet_link_tag "normalize.css" 
 stylesheet_link_tag "application.css" 
 stylesheet_link_tag 'site/app.css' 
 stylesheet_link_tag 'ie.css', :media => 'screen, projection'
 stylesheet_link_tag 'ie6.css', :media => 'screen, projection' 
 csrf_meta_tag 
 yield :head 
 render 'shared/metadata' 
 render :partial => '/shared/welcome_header'
 if notice || alert 
 if notice || alert 
 raw "<div data-alert class='alert-box warning'> #{notice} <a href='' class='close'>&times;</a></div>"  if notice 
 raw "<div data-alert class='alert-box alert'>#{alert} <a href='' class='close'>&times;</a></div>"     if alert 
 end 
 end 
 yield 
 render 'shared/main_footer' 
 render 'shared/google_analytics' unless @disable_ga 
 yield :bottom 
 javascript_include_tag 'application' 
 yield :below_body 

 content_for :head do 
 stylesheet_link_tag 'home_page.css' 
 end 
 image_tag 'home.png' 

 end
end

module Piggybak
  class CartController < ApplicationController
    def show
      @cart = Cart.new(cookies["cart"])
      @cart.update_quantities
      cookies["cart"] = { :value => @cart.to_cookie, :path => '/' }
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title || "Piggybak Demo" 
 stylesheet_link_tag    "application" 
 javascript_include_tag "application" 
 csrf_meta_tags 
 piggybak_track_order("Piggybak Demo") 
 link_to image_tag("piggybak_demo.png"), "/demo/" 
 render_navigation(false, false) 
 link_to "Professional Frames", main_app.frame_url 
 link_to "Gift Certificates", piggybak_giftcerts.buy_giftcert_url 
 if current_user 
 if current_user.piggybak_orders.any? 
 orders_link("Order History") 
 end 
 if current_user.roles.size > 0 
 link_to 'ADMIN', "/demo/admin" 
 end 
 link_to 'LOGOUT', main_app.destroy_user_session_path, :method => :delete, :class => "last" 
 else 
 link_to 'LOG IN', main_app.new_user_session_path 
 end 
 cart_link 
 if params[:controller] == "home" 
 elsif params[:controller] == "image" 
 link_to "Home", root_url 
 if @image.categories.any? 
 link_to @image.categories.first.title, category_url(@image.categories.first.slug) 
 end 
 @image.title 
 end 
 if false 
 end 
 if @cart.errors.any? 
 raw @cart.errors.join('<br />') 
 end 
  if @cart.sellables.any? 
 form_tag piggybak.cart_update_url do 
 if page == "cart" 
 end 
 @cart.sellables.each do |item| 
 item[:sellable].description 
 number_to_currency item[:sellable].price 
 if page == "cart" 
 number_field_tag "quantity[#{item[:sellable].id}]", item[:quantity] 
 else 
 item[:quantity] 
 end 
 number_to_currency item[:quantity]*item[:sellable].price 
 if page == "cart" 
 link_to "Remove", piggybak.remove_item_url(item[:sellable].id), :method => :delete 
 end 
 end 
 page == "cart" ? "5" : "4" 
 page == "cart" ? "3" : "2" 
 @cart.total 
 number_to_currency @cart.total 
 if page != "cart" 
 page == "cart" ? "3" : "2" 
 page == "cart" ? "3" : "2" 
 Piggybak.config.line_item_types.each do |k, v| 
 if v.has_key?(:display_in_cart) 
 "#{k}_row" 
 page == "cart" ? "3" : "2" 
 v[:display_in_cart] 
 'reduce_tax_subtotal' if v.has_key?(:reduce_tax_subtotal) && v[:reduce_tax_subtotal] 
 k 
 end 
 end 
 page == "cart" ? "3" : "2" 
 end 
 if page == "cart" 
 link_to "Proceed to Checkout", piggybak.orders_url, :id => "checkout" 
 submit_tag "Update", :id => "update" 
 end 
 end 
 else 
 end 
 
 Time.now.year.to_s 
 RUBY_VERSION 
 Rails::VERSION::STRING 
 Gem.loaded_specs["piggybak"].version.to_s 
 Page.all.each do |page| 
 link_to page.title, "/demo/#{page.slug}/" 
 end 

end

    end
  
    def add
      cookies["cart"] = { :value => Cart.add(cookies["cart"], params), :path => '/' }
      redirect_to piggybak.cart_url
    end
  
    def remove
      response.set_cookie("cart", { :value => Cart.remove(cookies["cart"], params[:item]), :path => '/' })
      redirect_to piggybak.cart_url
    end
  
    def clear
      cookies["cart"] = { :value => '', :path => '/' }
      redirect_to piggybak.cart_url
    end
  
    def update
      cookies["cart"] = { :value => Cart.update(cookies["cart"], params), :path => '/' }
      redirect_to piggybak.cart_url
    end
  end
end

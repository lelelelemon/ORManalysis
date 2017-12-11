
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

 current_user.wish_list_items do |item| 
 item 
 end 
 if current_user.wish_list_items.empty? 
 render :partial => '/shopping/cart_items/saved_items' unless current_user.saved_cart_items.empty? 
 else 
 current_user.wish_list_items.each_with_index do |item, i| 
 i 
 photo_url = item.variant.product.featured_image 
 image_tag(photo_url) if photo_url 
 item.variant.product_name 
 link_to 'remove', wish_item_path(item, :variant_id => item.variant_id), 
                                  :method => :delete 
 end 
 render :partial => '/shopping/cart_items/saved_items' unless current_user.saved_cart_items.empty? 
 end 

 @saved_cart_items.each_with_index do |item, i| 
 i 
 item.created_at.strftime(I18n.translate('time.formats.long_date')) 
 i 
 unless item.variant.sold_out? 
 link_to 'Move to Cart',
                          move_to_shopping_cart_item_path(item, :variant_id => item.variant_id,
                                                          :item_type_id     => ItemType::SHOPPING_CART_ID),
                                                          :method           => 'put',
                                                          :class            => 'button tiny success' 
 end 
 link_to 'Remove', shopping_cart_item_path(item, variant_id: item.variant_id),
                                  method: :delete, class: 'button tiny alert' 
 link_to item.variant.product_name, product_path(item.variant.product) 
  item.variant.brand_name.blank? ? '' : ['-', item.variant.brand_name].join(' ') 
 item.variant.display_stock_status('', '') 
 number_to_currency item.price 
 end 

class WishItemsController < ApplicationController
  before_action :require_user

  def index
  end

  # DELETE /wish_items/1
  def destroy
    if params[:variant_id].present?
      item = current_user.wish_list_items.find_by(variant_id: params[:variant_id])
      item.update_attributes( active: false )
    end
    render  action: :index
 
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
end

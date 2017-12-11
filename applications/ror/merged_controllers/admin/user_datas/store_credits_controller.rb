class Admin::UserDatas::StoreCreditsController < Admin::UserDatas::BaseController
  helper_method :customer
  def show
    @store_credit = customer.store_credit
  end

  def edit
    form_info
  end

  def update
    if amount_to_add_is_valid?
      customer.store_credit.add_credit(amount_to_add)
      redirect_to admin_user_datas_user_store_credits_url( customer ), :notice  => "Successfully updated store credit."
    else
      customer.errors.add(:base, 'Amount must be numeric')
      form_info
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
    def form_info

    end

    def customer
      @customer ||= User.includes(:store_credit).find(params[:user_id])
    end

    def amount_to_add_is_valid?
      params[:amount_to_add] && params[:amount_to_add].is_numeric?
    end
    def amount_to_add
      amount_to_add_is_valid? ? params[:amount_to_add].to_f : 0.0
    end

end

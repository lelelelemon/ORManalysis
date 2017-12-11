class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
    @user = User.new
 
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

 content_for :head do 
 if @registration 
 stylesheet_link_tag 'signup.css' 
 else 
 stylesheet_link_tag 'login.css' 
 end 
 stylesheet_link_tag 'cupertino/jquery-ui-1.8.12.custom' 
 end 
 content_for :bottom do 
 javascript_include_tag 'jquery.datePicker-2.1.2', 'datePickerInitialize' 
 end 
 if @user_session.errors.any? 
 pluralize(@user_session.errors.count, "error") 
 @user_session.errors.full_messages.each do |msg| 
 msg 
 end 
 end 
 if @user.errors.any? 
 @user.errors.full_messages.each do |msg| 
 msg 
 end 
 end 
 form_for  @user_session, :as => :user_session,
                  :url => user_sessions_path(@user_session),
                  :html => {:class => 'span-12 custom'} do |form| 
form.label :email, 'Email' 
 form.email_field :email, :autocomplete => 'off', :autocapitalize => 'off' 
form.label :password, 'Password' 
 form.password_field :password, :autocomplete => 'off', :autocapitalize => 'off' 
 form.submit "Log In", :class => 'button' 
 end 
 link_to 'forgot password?', new_customer_password_reset_path() 
 form_for @user, url: customer_registrations_path(@user), html: {class: 'custom'}  do |form| 
 site_name 
 site_name 
form.label :first_name, 'First name*' 
 form.text_field :first_name 
form.label :last_name, 'Last name*' 
 form.text_field :last_name 
form.label :email, 'Email*' 
 form.email_field :email, :autocomplete => 'off', :autocapitalize => 'off'  
form.label :password, 'Password*' 
 form.password_field :password, :autocomplete => 'off', :autocapitalize => 'off'  
form.label :password_confirmation, 'Confirm*' 
 form.password_field :password_confirmation, :autocomplete => 'off', :autocapitalize => 'off'  
 form.submit "Register", :class => 'button' 
 end 

 end

  def create
    @user_session = UserSession.new(user_params.to_h)
    if @user_session.save
      cookies[:hadean_uid] = @user_session.record.access_token
      session[:authenticated_at] = Time.now
      ## if there is a cart make sure the user_id is correct
      set_user_to_cart_items(@user_session.record)
      merge_carts
      flash[:notice] = I18n.t('login_successful')
      if @user_session.record.admin?
        redirect_back_or_default admin_users_url
      else
        redirect_back_or_default root_url
      end
    else
      @user = User.new(user_params)
      redirect_to login_url, alert: I18n.t('login_failure')
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

 end

  def destroy
    current_user_session.destroy
    reset_session
    cookies.delete(:hadean_uid)
    redirect_to login_url, notice: I18n.t('logout_successful')
 
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

  def user_params
    params.require(:user_session).permit(:password, :password_confirmation, :first_name, :last_name, :email)
  end

end

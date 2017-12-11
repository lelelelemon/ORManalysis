class Customer::PasswordResetsController < ApplicationController
  before_action :load_user_using_perishable_token, :only => [ :edit, :update ]

  def new
    @user = User.new
    #render
  end

  def create
    @user = User.find_by_email(params[:user][:email])
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = 'Instructions to reset your password have been emailed.'
      render :template => '/customer/password_resets/confirmation'
    else
      @user = User.new
      flash[:notice] = 'No user was found with that email address'
      render :action => 'new'
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


 content_for :head do 
 stylesheet_link_tag 'signup.css' 
 end 
 I18n.t :reset_password_title 
t :reset_password_text 
 form_for(@user, url: customer_password_reset_path(@user)) do |f| 
 f.label :email 
 f.text_field :email 
 submit_tag 'Continue', class: 'button' 
 end 

 end

  def edit
    #render
  end

  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      #@user.activate!
      flash[:notice] = 'Your password has been reset'
      redirect_to login_url
    else
      render :action => :edit
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

 site_name 
 form_for(@user, url: customer_password_reset_path(id: @user.perishable_token)) do |f| 
 render partial: 'form', locals: { f: f } 
 end 

 end

  protected

  def load_user_using_perishable_token
    unless @user = User.find_by_perishable_token( params[:id].to_s )
      flash[:notice] = 'The link you used in no longer valid.  Click the password reset link to get a new link to reset your password.'
      redirect_to login_url and return
    end
  end

end

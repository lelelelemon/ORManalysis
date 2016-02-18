class AccountsController < ApplicationController
  before_action :verify_config
  before_action :verify_users, only: [:login, :recover_password]
  before_action :redirect_if_already_logged_in, only: :login

  def index
    if User.count.zero?
      redirect_to signup_accounts_url
    else
      redirect_to login_accounts_url
    end
  end

  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:user][:login], params[:user][:password])
    if logged_in?
      successful_login
    else
      flash[:error] = t('accounts.login.error')
      @login = params[:user][:login]
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :page_title do 
 "#{this_blog.blog_name} - #{t('.title')}" 
 end 
 form_tag action: "login" do 
 text_field(:user, :login, {class: 'form-control', placeholder: t(".login"), autofocus: 'autofocus'}) 
 password_field(:user, :password, {class: 'form-control', placeholder: t(".password")}) 
 check_box_tag 'remember_me' 
 t('.remember_me') 
 submit_tag t('.sign_in'), class: "btn btn-lg btn-success btn-block" 
 end 
 content_for :account_links do 
 link_to(t("accounts.lost_my_password"), action: 'recover_password') 
 if this_blog.allow_signup? 
 link_to(t("accounts.create_account"), action: 'signup') 
 end 
 link_to(t("accounts.back_to", place: this_blog.blog_name).html_safe, this_blog.base_url) 
 end 

end

  end

  def signup
    unless User.count.zero? || this_blog.allow_signup == 1
      redirect_to login_accounts_url
      return
    end

    @user = User.new((params[:user].permit! if params[:user]))

    return unless request.post?

    @user.generate_password!
    session[:tmppass] = @user.password
    @user.name = @user.login
    if @user.save
      self.current_user = @user
      session[:user_id] = @user.id

      redirect_to confirm_accounts_url
      return
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :page_title do 
 "#{this_blog.blog_name} - #{t('.title')}" 
 end 
 form_tag action: "signup" do 
 text_field(:user, :login, {class: 'form-control', placeholder: t(".username") }) 
 text_field(:user, :email, {class: 'form-control', placeholder: t(".email") }) 
 t('.signup') 
 end 
 content_for :account_links do 
 link_to(t("accounts.lost_my_password"), action: 'recover_password') 
 link_to(t("accounts.back_to_login"), action: 'login') 
 link_to(t("accounts.back_to", place: this_blog.blog_name).html_safe, this_blog.base_url) 
 end 

end

  end

  def recover_password
    return unless request.post?
    @user = User.where('login = ? or email = ?', params[:user][:login], params[:user][:login]).first

    if @user
      @user.generate_password!
      @user.save
      flash[:notice] = t('accounts.recover_password.notice')
      redirect_to login_accounts_url
    else
      flash[:error] = t('accounts.recover_password.error')
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :page_title do 
 "#{this_blog.blog_name} - #{t('.title')}" 
 end 
 form_tag action: "recover_password" do 
 text_field(:user, :login, {class: 'form-control', placeholder: t(".username_or_email")}) 
 submit_tag t('.reset_my_password'), class: "btn btn-lg btn-success btn-block" 
 end 
 content_for :account_links do 
 link_to(t("accounts.back_to_login"), action: 'login') 
 if this_blog.allow_signup? 
 link_to(t("accounts.create_account"), action: 'signup') 
 end 
 link_to(t("accounts.back_to", place: this_blog.blog_name).html_safe, this_blog.base_url) 
 end 

end

  end

  def logout
    flash[:notice] = t('accounts.logout.notice')
    current_user.forget_me
    self.current_user = nil
    session[:user_id] = nil
    cookies.delete :auth_token
    cookies.delete :publify_user_profile
    redirect_to login_accounts_url
  end

  private

  def verify_users
    redirect_to(controller: 'accounts', action: 'signup') if User.count == 0
    true
  end

  def verify_config
    redirect_to controller: 'setup', action: 'index' unless this_blog.configured?
  end

  def redirect_if_already_logged_in
    if session[:user_id] && session[:user_id] == current_user.id
      redirect_back_or_default
    end
  end

  def successful_login
    session[:user_id] = current_user.id
    if params[:remember_me] == '1'
      current_user.remember_me unless current_user.remember_token?
      cookies[:auth_token] = {
        value: current_user.remember_token,
        expires: current_user.remember_token_expires_at,
        httponly: true # Help prevent auth_token theft.
      }
    end
    add_to_cookies(:publify_user_profile, current_user.profile_label, '/')

    current_user.update_connection_time
    flash[:success] = t('accounts.login.success')
    redirect_back_or_default
  end

  def redirect_back_or_default
    redirect_to(session[:return_to] || { controller: 'admin/dashboard', action: 'index' })
    session[:return_to] = nil
  end
end

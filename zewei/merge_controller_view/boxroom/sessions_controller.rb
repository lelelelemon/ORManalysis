class SessionsController < ApplicationController
  skip_before_action :require_login

  def new
 content_for :title, t(:sign_in) 
 content_for :title 
 form_tag(sessions_path) do 
 label_tag :username, t(:username) 
 text_field_tag :username, nil, :class => 'text_input' 
 label_tag :password, t(:password) 
 password_field_tag :password, nil, :class => 'text_input' 
 check_box_tag :remember_me, 'true' 
 label_tag :remember_me, t(:remember_me) 
 submit_tag t(:sign_in) 
 link_to t(:reset_password), new_reset_password_path 
 end 

  end

  def create
    user = User.authenticate(params[:username], params[:password])

    unless user.nil?
      if params[:remember_me] == 'true'
        user.refresh_remember_token
        cookies[:auth_token] = { :value => user.remember_token, :expires => 2.weeks.from_now }
      end

      session[:user_id] = user.id
      redirect_url = session.delete(:return_to) || folders_url
      redirect_to redirect_url, :only_path => true
    else
      log_failed_sign_in_attempt(Time.now, params[:username], request.remote_ip)
      redirect_to new_session_url, :alert => t(:credentials_incorrect)
    end
  end

  def destroy
    current_user.forget_me
    cookies.delete :auth_token
    reset_session
    session[:user_id] = nil
    redirect_to new_session_url
  end

  private

  def log_failed_sign_in_attempt(date, username, ip)
    Rails.logger.error(
      "\nFAILED SIGN IN ATTEMPT:\n" +
      "=======================\n" +
      " Date: #{date}\n" +
      " Username: #{username}\n" +
      " IP address: #{ip}\n\n"
    )
  end
end

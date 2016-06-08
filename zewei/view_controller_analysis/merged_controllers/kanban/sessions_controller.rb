class SessionsController < ApplicationController
  before_action :require_login, only: [] # disable require login
  before_action :redirect_logged_in_user, only: [:new]

  def new
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 favicon_link_tag "/favicon.ico" 
 stylesheet_link_tag "application", media: "all" 
 javascript_include_tag "application" 
 csrf_meta_tags 
 if logged_in? 
 link_to image_tag(current_user.gravatar_url(30), class: "avatar"), "#" 
 link_to "logout", logout_url 
 else 
 link_to "login", login_url 
 end 
 form_authenticity_token 

end
end

  def create
    user = User.find_by_email(params[:email])

    if UserAuth.new(user).login(params[:password])
      session[:session_key] = user.session_key
      redirect_to root_url
    else
      # TODO: add errors
      redirect_to login_url
    end
  end

  def destroy
    UserAuth.new(current_user).logout
    reset_session
    redirect_to login_url
  end
end

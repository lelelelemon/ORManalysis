# This controller handles the login/logout function of the site.
class SessionsController < BaseController

  skip_before_action :store_location, :only => [:new, :create]

  def index
    redirect_to :action => "new"
  end

  def new
    redirect_to user_path(current_user) and return if current_user
    @user_session = UserSession.new
 @page_title=:log_in_to_site.l(:site => configatron.community_name) 
  widget do 
 :help.l 
 :dont_have_an_account.l 
 link_to :click_here_to_sign_up.l, signup_path 
 :forgot_your_password.l 
 link_to :click_here_to_retrieve_it.l, forgot_password_url 
 :forgot_your_username.l 
 link_to :click_here_to_retrieve_it.l, forgot_username_url 
 end 
 
 if configatron.auth_providers.to_hash.keys.any?       
 widget do 
 t 'sessions.new.omniauth.header' 
 configatron.auth_providers.to_hash.keys.each do |provider| 
 alt = t('sessions.new.omniauth.button_alt', :provider => provider) 
 link_to(image_tag("auth/#{provider.to_s}_64.png", :alt => alt), "/auth/#{provider.to_s}", :title => alt) 
 end 
 end 
 end 
 bootstrap_form_tag :url => sessions_path, :layout => :horizontal do |f| 
 f.email_field :email, value: params[:email] 
 f.password_field :password 
 f.form_group :remember_group do 
 f.check_box :check_box do 
 :remember_me.l 
 end 
 end 
 f.form_group :submit_group do 
 f.primary :log_in.l 
 end 
 end 

  end

  def create
    @user_session = UserSession.new(:login => params[:email], :password => params[:password], :remember_me => params[:remember_me])

    if @user_session.save
      self.current_user = @user_session.record #if current_user has been called before this, it will ne nil, so we have to make to reset it

      flash[:notice] = :thanks_youre_now_logged_in.l
      redirect_back_or_default(dashboard_user_path(current_user))
    else
      flash[:notice] = :uh_oh_we_couldnt_log_you_in_with_the_username_and_password_you_entered_try_again.l
       @page_title=:log_in_to_site.l(:site => configatron.community_name) 
  widget do 
 :help.l 
 :dont_have_an_account.l 
 link_to :click_here_to_sign_up.l, signup_path 
 :forgot_your_password.l 
 link_to :click_here_to_retrieve_it.l, forgot_password_url 
 :forgot_your_username.l 
 link_to :click_here_to_retrieve_it.l, forgot_username_url 
 end 
 
 if configatron.auth_providers.to_hash.keys.any?       
 widget do 
 t 'sessions.new.omniauth.header' 
 configatron.auth_providers.to_hash.keys.each do |provider| 
 alt = t('sessions.new.omniauth.button_alt', :provider => provider) 
 link_to(image_tag("auth/#{provider.to_s}_64.png", :alt => alt), "/auth/#{provider.to_s}", :title => alt) 
 end 
 end 
 end 
 bootstrap_form_tag :url => sessions_path, :layout => :horizontal do |f| 
 f.email_field :email, value: params[:email] 
 f.password_field :password 
 f.form_group :remember_group do 
 f.check_box :check_box do 
 :remember_me.l 
 end 
 end 
 f.form_group :submit_group do 
 f.primary :log_in.l 
 end 
 end 

    end
  end

  def destroy
    redirect_to new_session_path and return if current_user_session.nil?
    current_user_session.destroy
    reset_session
    flash[:notice] = :youve_been_logged_out_hope_you_come_back_soon.l
    redirect_to new_session_path
  end

end

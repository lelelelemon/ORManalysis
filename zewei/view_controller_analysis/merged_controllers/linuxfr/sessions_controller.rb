# encoding: utf-8
class SessionsController < DeviseController
  prepend_before_action :allow_params_authentication!, only: [:create]
  prepend_before_action :require_no_authentication,    only: [:new, :create]
  skip_before_action    :verify_authenticity_token,    only: [:new, :create]

  def new
    session[:account_return_to] ||= url_for('/')
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  render "sessions/new", id_suffix: "" 
 render "devise/shared/links" 
 
  if controller_name != 'sessions' 
 link_to "Se connecter", new_session_path(:account) 
 end 
 if devise_mapping.registerable? && controller_name != 'registrations' 
 link_to "S'inscrire", new_registration_path(:account) 
 end 
 if devise_mapping.recoverable? && controller_name != 'passwords' 
 link_to "Mot de passe oubli ?", new_password_path(:account) 
 end 
 if devise_mapping.confirmable? && controller_name != 'confirmations' 
 link_to "Pas encore reu les instructions de confirmation ?", new_confirmation_path(:account) 
 end 
 if devise_mapping.lockable? && controller_name != 'unlocks' 
 link_to "Pas encore reu les instructions pour dverrouill votre compte ?", new_unlock_path(:account) 
 end 
 

end

  end

  def create
    cookies.permanent[:https] = { value: "1", secure: false } if request.ssl?
    @account = warden.authenticate!(scope: :account, recall: "#{controller_path}#new")
    sign_in :account, @account
    redirect_to stored_location_for(:account) || :back, notice: I18n.t("devise.sessions.signed_in")
  rescue ActionController::RedirectBackError
    redirect_to '/'
  end

  def destroy
    cookies.delete :https
    sign_out :account
    redirect_to "/"
  end
end

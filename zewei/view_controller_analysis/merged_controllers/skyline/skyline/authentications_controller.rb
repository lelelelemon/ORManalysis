class Skyline::AuthenticationsController < Skyline::ApplicationController
  layout false

  def new
    messages.now[:success] = t(:password_changed_successfully, :scope => [:authentication, :new, :flashes]) if params[:message]
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  stylesheet_link_tag "#{Skyline::Configuration.url_prefix}/stylesheets/undohtml.css", "#{Skyline::Configuration.url_prefix}/stylesheets/general.css" 
 stylesheet_link_tag "#{Skyline::Configuration.url_prefix}/stylesheets/ie.css" 
 if Skyline::Configuration.custom_stylesheets.any? 
 Skyline::Configuration.custom_stylesheets.each do |stylesheet| 
 if stylesheet[:if] 
 stylesheet[:if] 
 stylesheet_link_tag stylesheet[:path] 
 else 
 stylesheet_link_tag stylesheet[:path] 
 end 
 end 
 end 
 javascript_include_tag "#{Skyline::Configuration.url_prefix}/javascripts/skyline.js" 
 javascript_include_tag "#{Skyline::Configuration.url_prefix}/javascripts/skyline.editor.js" 
 javascript_include_tag "#{Skyline::Configuration.url_prefix}/javascripts/application.js" 
 javascript_include_tag skyline_locale_path(I18n.locale) 
form_authenticity_token
 I18n.locale 
 Skyline::Configuration.url_prefix 
 skyline_user_preferences_path  
 form_authenticity_token 
 plugin_hook :footer 
 
 Skyline::Configuration.skyline_logo 
 form_tag skyline_auth_skyline_strategy_callback_path do 
 t(:log_in, :scope => [:authentication,:new]) 
 label_tag t(:email, :scope => [:authentication,:new])
text_field_tag 'email',params[:email], :class => "full" 
label_tag t(:password, :scope => [:authentication,:new])
password_field_tag 'password'
 submit_button :login, :class => "medium green" 
 end 
 Skyline.version 
 if Skyline::Configuration.custom_logo 
 Skyline::Configuration.branding_name 
 Skyline::Configuration.url_prefix 
 end 
 render_messages 
 render_notifications 

end

  end

  # You can pass in the following from your authentication strategy:
  #
  # @param [String,Integer] omniauth.auth.uid The User id to find
  # @param [Array] omniauth.auth.extra.keep_session_keys The session keys to keep after resetting the session
  def create
    if user = Skyline::Configuration.user_class.find_by_identification(request.env["omniauth.auth"]["uid"])

      # Store any keys found in ["omniauth.auth"]["extra"]["keep_session_keys"]
      session_values_before_reset = {}
      keep_keys = request.env["omniauth.auth"]["extra"]["keep_session_keys"]
      if keep_keys && keep_keys.kind_of?(Array)
        keep_keys.each do |key|
          session_values_before_reset[key] = session[key]
        end
      end

      # Reset the session to prevent Session Injection attack
      reset_session

      # Restore the previously set keys
      if session_values_before_reset.present?
        session_values_before_reset.each do |k,v|
          session[k] = v
        end
      end

      session[:skyline_user_identification] = user.identification
      redirect_to skyline_root_path
    else
      messages.now[:error] = t(:error, :scope => [:authentication,:create,:flashes])
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  stylesheet_link_tag "#{Skyline::Configuration.url_prefix}/stylesheets/undohtml.css", "#{Skyline::Configuration.url_prefix}/stylesheets/general.css" 
 stylesheet_link_tag "#{Skyline::Configuration.url_prefix}/stylesheets/ie.css" 
 if Skyline::Configuration.custom_stylesheets.any? 
 Skyline::Configuration.custom_stylesheets.each do |stylesheet| 
 if stylesheet[:if] 
 stylesheet[:if] 
 stylesheet_link_tag stylesheet[:path] 
 else 
 stylesheet_link_tag stylesheet[:path] 
 end 
 end 
 end 
 javascript_include_tag "#{Skyline::Configuration.url_prefix}/javascripts/skyline.js" 
 javascript_include_tag "#{Skyline::Configuration.url_prefix}/javascripts/skyline.editor.js" 
 javascript_include_tag "#{Skyline::Configuration.url_prefix}/javascripts/application.js" 
 javascript_include_tag skyline_locale_path(I18n.locale) 
form_authenticity_token
 I18n.locale 
 Skyline::Configuration.url_prefix 
 skyline_user_preferences_path  
 form_authenticity_token 
 plugin_hook :footer 
 
 Skyline::Configuration.skyline_logo 
 form_tag skyline_auth_skyline_strategy_callback_path do 
 t(:log_in, :scope => [:authentication,:new]) 
 label_tag t(:email, :scope => [:authentication,:new])
text_field_tag 'email',params[:email], :class => "full" 
label_tag t(:password, :scope => [:authentication,:new])
password_field_tag 'password'
 submit_button :login, :class => "medium green" 
 end 
 Skyline.version 
 if Skyline::Configuration.custom_logo 
 Skyline::Configuration.branding_name 
 Skyline::Configuration.url_prefix 
 end 
 render_messages 
 render_notifications 

end

    end
  end

  def destroy
    reset_session
    redirect_to new_skyline_authentication_path
  end

  def fail
    if Skyline::Configuration.login_attempts_allowed > 0
      messages.now[:error] = t(:error_with_lockout, :scope => [:authentication,:create,:flashes])
    else
      if params[:message] == "password_expired"
        messages.now[:error] = t(:error_with_invalid_credentials, :scope => [:authentication,:create,:flashes], :url => "#{ENTOPICMAIL_ADMIN_URL}/admin/renew_passwords/new?reason=password_expired&r=#{CGI.escape(new_skyline_authentication_path(:only_path => false, :message => 'password_changed_successfully'))}")
      else
        messages.now[:error] = t(:error, :scope => [:authentication,:create,:flashes])
      end
    end
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  stylesheet_link_tag "#{Skyline::Configuration.url_prefix}/stylesheets/undohtml.css", "#{Skyline::Configuration.url_prefix}/stylesheets/general.css" 
 stylesheet_link_tag "#{Skyline::Configuration.url_prefix}/stylesheets/ie.css" 
 if Skyline::Configuration.custom_stylesheets.any? 
 Skyline::Configuration.custom_stylesheets.each do |stylesheet| 
 if stylesheet[:if] 
 stylesheet[:if] 
 stylesheet_link_tag stylesheet[:path] 
 else 
 stylesheet_link_tag stylesheet[:path] 
 end 
 end 
 end 
 javascript_include_tag "#{Skyline::Configuration.url_prefix}/javascripts/skyline.js" 
 javascript_include_tag "#{Skyline::Configuration.url_prefix}/javascripts/skyline.editor.js" 
 javascript_include_tag "#{Skyline::Configuration.url_prefix}/javascripts/application.js" 
 javascript_include_tag skyline_locale_path(I18n.locale) 
form_authenticity_token
 I18n.locale 
 Skyline::Configuration.url_prefix 
 skyline_user_preferences_path  
 form_authenticity_token 
 plugin_hook :footer 
 
 Skyline::Configuration.skyline_logo 
 form_tag skyline_auth_skyline_strategy_callback_path do 
 t(:log_in, :scope => [:authentication,:new]) 
 label_tag t(:email, :scope => [:authentication,:new])
text_field_tag 'email',params[:email], :class => "full" 
label_tag t(:password, :scope => [:authentication,:new])
password_field_tag 'password'
 submit_button :login, :class => "medium green" 
 end 
 Skyline.version 
 if Skyline::Configuration.custom_logo 
 Skyline::Configuration.branding_name 
 Skyline::Configuration.url_prefix 
 end 
 render_messages 
 render_notifications 

end

  end

  protected

  def protect?
    self.action_name == "destroy"
  end
end

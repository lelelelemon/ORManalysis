module Cms
  module Sites
    class PasswordsController < Devise::PasswordsController
      include Cms::ContentPage
      helper AuthenticationHelper

      template :default

      def new
        use_page_title('Forgot Password')
        super
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 
   flash.each do |name, msg|

 content_tag :div, class: 'flash-message' do 
 msg 
 end 
 end 
 
  simple_form_for(resource, :as => resource_name, :url => password_path(resource_name), :html => { :method => :post }) do |f| 
 f.error_notification 
 f.input :email, :required => true, :autofocus => true 
 f.button :submit, "Send me reset password instructions" 
 end 
  if controller_name != 'sessions' 
 link_to "Sign in", new_session_path(resource_name) 
 end 
 if devise_mapping.registerable? && controller_name != 'registrations' 
 link_to "Sign up", new_registration_path(resource_name) 
 end 
 if devise_mapping.recoverable? && controller_name != 'passwords' && controller_name != 'registrations' 
 link_to "Forgot your password?", new_password_path(resource_name) 
 end 
 if devise_mapping.confirmable? && controller_name != 'confirmations' 
 link_to "Didn't receive confirmation instructions?", new_confirmation_path(resource_name) 
 end 
 if devise_mapping.lockable? && resource_class.unlock_strategy_enabled?(:email) && controller_name != 'unlocks' 
 link_to "Didn't receive unlock instructions?", new_unlock_path(resource_name) 
 end 
 if devise_mapping.omniauthable? 
 resource_class.omniauth_providers.each do |provider| 
 link_to "Sign in with #{provider.to_s.titleize}", omniauth_authorize_path(resource_name, provider) 
 end 
 end 
 
 

end

      end

      def create
        use_page_title('Forgot Password')
        super
      end

      def edit
        use_page_title('Reset Password')
        super
      end

      protected

      # @override [Devise::PasswordsController]
      def after_sending_reset_password_instructions_path_for(resource_name)
        main_app.new_cms_user_session_path
      end
    end
  end
end

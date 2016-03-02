  module Sites
    class PasswordsController < Devise::PasswordsController
      include ContentPage
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
 
 render file: 'devise/passwords/new' 

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
  module Sites

    # Handles Sign In/Out for public site.
    class SessionsController < Devise::SessionsController
      include ContentPage
      helper AuthenticationHelper
      helper UiElementsHelper

      template :default

      def new
        use_page_title 'Login'
        super
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 
   flash.each do |name, msg|

 content_tag :div, class: 'flash-message' do 
 msg 
 end 
 end 
 
 render file: 'cms/sessions/new' 

end

      end


    end
  end

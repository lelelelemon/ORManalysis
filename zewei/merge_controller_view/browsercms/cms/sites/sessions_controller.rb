module Cms
  module Sites

    # Handles Sign In/Out for public site.
    class SessionsController < Devise::SessionsController
      include Cms::ContentPage
      helper AuthenticationHelper
      helper UiElementsHelper

      template :default

      def new
        use_page_title 'Login'
        super
 render 'cms/sites/flash' 
 render file: 'cms/sessions/new' 

      end


    end
  end
end

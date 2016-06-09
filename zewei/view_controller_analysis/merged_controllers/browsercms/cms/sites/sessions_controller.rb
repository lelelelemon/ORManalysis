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
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 
   flash.each do |name, msg|

 content_tag :div, class: 'flash-message' do 
 msg 
 end 
 end 
 
  use_page_title 'Sign in' 
  span = 'span6' unless local_assigns.has_key? :span 
 span 
 page_title 
 yield 
 
 simple_form_for(resource, :as => resource_name, :url => session_path(resource_name)) do |f| 
 render layout: 'cms/application/main_with_sidebar' do 
 f.input :login, :required => false, :autofocus => true 
 f.input :password, :required => false 
 f.input :remember_me, :as => :boolean if devise_mapping.rememberable? 
 render "devise/shared/links" 
 end 
 render layout: 'cms/application/row' do 
 button_menu :bottom do 
 f.button :submit, "Sign in", class: 'right btn-primary' 
 end 
 end 
 end 
 

end

      end


    end
  end
end

  class PasswordsController < Devise::PasswordsController
    include AdminController
    layout 'cms/application'

    def new
      use_page_title('Forgot Password')
      super
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  span = 'span6' unless local_assigns.has_key? :span 
 span 
 page_title 
 yield 
 
 simple_form_for(resource, :as => resource_name, :url => password_path(resource_name), :html => { :method => :post }) do |f| 
 render layout: 'cms/application/main_with_sidebar' do 
 f.error_notification 
 f.input :email, :required => true, :autofocus => true 
 render "devise/shared/links" 
 end 
 render layout: 'cms/application/row' do 
 button_menu :bottom do 
 f.button :submit, "Send me reset password instructions", class: 'right btn-primary' 
 end 
 end 
 end 

end

    end

    def create
      use_page_title('Forgot Password')
      super
    end

    def edit
      use_page_title('Change Password')
      super
    end

  end
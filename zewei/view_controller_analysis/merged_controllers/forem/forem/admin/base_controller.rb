module Forem
  module Admin
    class BaseController < ApplicationController
      layout Forem.layout
      
      before_filter :authenticate_forem_admin

      def index
        # TODO: perhaps gather some stats here to show on the admin page?
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag    "application", media: "all", "data-turbolinks-track" => true 
 javascript_include_tag "application", "data-turbolinks-track" => true 
 csrf_meta_tags 
 if current_user 
 current_user 
 link_to "Sign out", main_app.destroy_user_session_path, :method => :delete 
 else 
 link_to "Sign in", main_app.new_user_session_path 
 link_to "Register", main_app.new_user_registration_path 
 end 
 t('forem.admin.area') 
 t('forem.admin.welcome') 
 link_to t('forem.admin.forum.index'), forem.admin_forums_path 
 link_to t('forem.admin.category.index'), forem.admin_categories_path 
 link_to t('forem.admin.group.index'), forem.admin_groups_path 
 link_to t(:back_to_forums, :scope => 'forem.admin'), forem.root_path 

end

      end

      private

      def authenticate_forem_admin
        if !forem_user || !forem_user.forem_admin?
          flash.alert = t("forem.errors.access_denied")
          redirect_to forums_path #TODO: not positive where to redirect here
        end
      end
    end
  end
end

module Api
  module OpenidConnect
    class UserApplicationsController < ApplicationController
      before_action :authenticate_user!

      def index
        @user_apps = UserApplicationsPresenter.new current_user
 content_for :page_title do 
 t(".edit_applications") 
 end 
 render "shared/settings_nav" 
 t(".title") 
 render "add_remove_applications" 

      end
    end
  end
end

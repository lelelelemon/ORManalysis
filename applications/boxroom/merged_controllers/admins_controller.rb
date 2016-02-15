class AdminsController < ApplicationController
  skip_before_action :require_admin_in_system, :require_login
  before_action :require_no_admin

  def new
    @user = User.new
 content_for :title, t(:create_admin) 
 content_for :title 
 t :no_administrator_yet 
 form_for @user, :url => { :action => 'create' } do |f| 
 f.error_messages 
 f.label :name, t(:username) 
 f.text_field :name, { :class => 'text_input' } 
 f.label :email 
 f.text_field :email, { :class => 'text_input' } 
 label_tag :password 
 f.password_field :password, { :class => 'text_input' } 
 label_tag :confirm_password 
 f.password_field :password_confirmation, { :class => 'text_input' } 
 f.submit t(:create_admin_account) 
 end 

  end

  def create
    @user = User.new(permitted_params.user)
    @user.password_required = true
    @user.is_admin = true

    if @user.save
      redirect_to new_session_url, :notice => t(:admin_user_created_successfully)
    else
       content_for :title, t(:create_admin) 
 content_for :title 
 t :no_administrator_yet 
 form_for @user, :url => { :action => 'create' } do |f| 
 f.error_messages 
 f.label :name, t(:username) 
 f.text_field :name, { :class => 'text_input' } 
 f.label :email 
 f.text_field :email, { :class => 'text_input' } 
 label_tag :password 
 f.password_field :password, { :class => 'text_input' } 
 label_tag :confirm_password 
 f.password_field :password_confirmation, { :class => 'text_input' } 
 f.submit t(:create_admin_account) 
 end 

    end
  end

  private

  def require_no_admin
    redirect_to new_session_url unless User.no_admin_yet?
  end
end

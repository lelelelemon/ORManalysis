class Admin::DashboardController < ApplicationController
  layout 'admin'

  skip_before_filter :authenticate_user!, :only => [:index, :new_admin, :create_admin]
  skip_authorization_check
  before_filter :require_admin!, :except => [:index, :new_admin, :create_admin]
  before_filter :require_no_admins_defined, :only => [:new_admin, :create_admin]
  before_filter :set_navigation_ids

  def index
    if User.where(:admin => true).count == 0
      redirect_to :action => 'new_admin'
    elsif current_user && current_user.accessible_sites.count == 0
      redirect_to :action => 'new_site'
    else
      redirect_to admin_sites_path
    end
  end

  def new_admin
    @user = User.new
 form_for(@user, :url => { :action => 'create_admin' }, :method => 'put') do |f| 
 if @user.errors.any? 
 pluralize(@user.errors.count, "error") 
 @user.errors.full_messages.each do |msg| 
 msg 
 end 
 end 
 f.label :email 
 f.text_field :email 
 f.label :password 
 f.password_field :password 
 f.label :password_confirmation, 'Confirm password' 
 f.password_field :password_confirmation 
 primary_button_submit_tag "Create account & login &raquo;".html_safe 
 end 

  end

  def create_admin
    @user = User.new(params[:user])
    @user.admin = true
    if @user.save
      sign_in(@user)
      redirect_to dashboard_path
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 form_for(@user, :url => { :action => 'create_admin' }, :method => 'put') do |f| 
 if @user.errors.any? 
 pluralize(@user.errors.count, "error") 
 @user.errors.full_messages.each do |msg| 
 msg 
 end 
 end 
 f.label :email 
 f.text_field :email 
 f.label :password 
 f.password_field :password 
 f.label :password_confirmation, 'Confirm password' 
 f.password_field :password_confirmation 
 primary_button_submit_tag "Create account & login &raquo;".html_safe 
 end 

end

    end
  end

  def new_site
    @site = Site.new
 @title = "Welcome" 
 form_for(@site, :url => { :action => 'create_site' }, :method => 'put', :html => { :class => 'dashboard_new_site' }) do |f| 
 if @site.errors.any? 
 pluralize(@site.errors.count, "error") 
 @site.errors.full_messages.each do |msg| 
 msg 
 end 
 end 
 f.text_field :name 
 f.radio_button :moderation_method, :none 
 f.radio_button :moderation_method, :akismet 
 f.radio_button :moderation_method, :manual 
 f.text_field :url 
 f.text_field :akismet_key 
 arrowright_button_submit_tag 'Next step &raquo;'.html_safe 
 end 

  end

  def create_site
    @site = Site.new(params[:site])
    @site.user = current_user
    if @site.save
      redirect_to created_admin_site_path(@site)
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 @title = "Welcome" 
 form_for(@site, :url => { :action => 'create_site' }, :method => 'put', :html => { :class => 'dashboard_new_site' }) do |f| 
 if @site.errors.any? 
 pluralize(@site.errors.count, "error") 
 @site.errors.full_messages.each do |msg| 
 msg 
 end 
 end 
 f.text_field :name 
 f.radio_button :moderation_method, :none 
 f.radio_button :moderation_method, :akismet 
 f.radio_button :moderation_method, :manual 
 f.text_field :url 
 f.text_field :akismet_key 
 arrowright_button_submit_tag 'Next step &raquo;'.html_safe 
 end 

end

    end
  end

private
  def require_no_admins_defined
    if User.where(:admin => true).count > 0
      render :template => 'shared/forbidden'
    end
  end

  def set_navigation_ids
    @navigation_ids = [:dashboard]
  end
end

class Skyline::UsersController < Skyline::ApplicationController
  layout "skyline/layouts/settings"

  self.default_menu = :admin

  authorize :index, :by => "user_show"
  authorize :new,:create, :by => "user_create"
  authorize :edit,:update, :by => "user_update"
  authorize :destroy, :by => "user_delete"

  before_filter :check_for_custom_user_class

  def index

    @users = Skyline::User.paginate(:per_page => self.per_page,:conditions => {:system => false, :is_destroyed => false}, :include => [:roles], :page => params[:page])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for(:left) do 
t(:users, :scope => [:navigation, :mainnavigation]) 
 link_to t(:left_header, :scope => [:user,:index]), "#" , :class => "selected" 
 end 
 if current_user.allow?(:user_create) 
 link_to(
              button_text(:add),
              new_skyline_user_path,
              :remote => true,
              :method => :get,
              :class => "button small right",
              :style => "margin-top: 3px; visibility:visible;") 
 end 
 t(:header, :scope => [:user, :index], :count => @users.total_entries) 
 Skyline::User.human_attribute_name("email") 
 Skyline::User.human_attribute_name("name") 
 Skyline::User.human_attribute_name("role") 
 Skyline::User.human_attribute_name("created_at") 
 @users.each do |u| 
 cycle("odd","even") 
 u.email 
 u.name 
 u.roles.map{|s| t(s.name, :scope => [:user,:roles], :default => s.name) }.to_sentence 
 u.created_at.present? ? l(u.created_at, :format => :long) : "" 
 if current_user.allow?(:user_update) 
 link_to button_text(:edit), edit_skyline_user_path(u), :class => "button small edit" 
 end 
 if current_user.allow?(:user_delete) 
 link_to(
                          button_text(:delete),
                          skyline_user_path(u,:page => params[:page]),
                          :remote => true,
                          :method => :delete,
                          :confirm => t(:confirm_destroy, :scope => [:user,:index], :display_name => u.display_name),
                          :class => "button #{@current_user == u ? "disabled" : "red"} small") 
 end 
 end 
 if @users.total_pages > 1 
 will_paginate @users 
 end 

end

  end

  def new
    @user = Skyline::User.new(params[:user])
    @roles = current_user.viewable_roles
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 dialog(t(:dialog_title, :display_name => @user.display_name, :scope => [:user,:new]), :partial => "new", :width => 700) 

end

  end

  def create
    if (@user = Skyline::User.find_by_email(params[:user][:email])) && @user.is_destroyed
      @user.editing_user = current_user
      @user = @user.reactivate(params[:user])
    else
      @user = Skyline::User.new(params[:user])
      @user.editing_user = current_user
    end

    if @user.save
      notifications[:success] = t(:success, :scope => [:user,:create,:flashes])
      javascript_redirect_to skyline_users_path(:page => page_number_for_user(@user))
    else
      @roles = current_user.viewable_roles
      messages.now[:error] = t(:error,:scope => [:user,:create,:flashes])
    end

ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  skyline_form_for @user, {:as => :user, :url => skyline_users_path(), :remote => true, :method => :post} do |f|
   if current_user == f.object 
 f.label_with_text :current_password 
 f.password_field :current_password, :class => "full" 
 t(:current_password_info, :scope => [:user, :edit]) 
 end 
 f.label_with_text :email 
 f.text_field :email, :class => "full" 
 f.label_with_text :name 
 f.text_field :name, :class => "full" 
 f.label password_attribute, Skyline::User.human_attribute_name("password") 
 f.password_field password_attribute, :class => "full" 
 if password_attribute == :force_password 
 t(:password_info, :scope => [:user,:edit]) 
 end 
 f.label password_confirmation_attribute, f.t(:password_confirmation) 
 f.password_field password_confirmation_attribute, :class => "full" 
 if Skyline::Configuration.login_attempts_allowed > 0 && @user.login_attempts > 0 
 f.label :login_reset, f.t(:login_reset) 
 f.check_box :login_reset, :class => "full", :class => 'checkbox' 
 t(:login_attempts_info, 
                       :count => @user.login_attempts,
                       :since => l(@user.last_login_attempt, :format => :long),
                       :duration => distance_of_time_in_words_to_now(@user.last_login_attempt),
                       :scope => [:user, :edit]) 
 else 
 unless current_user == f.object
 f.label :is_locked, f.t(:is_locked) 
 f.check_box :is_locked, :class => "full", :class => 'checkbox' 
 end 
 end 
 if current_user == f.object 
 f.t(:role) 
 t(@user.grants.first.andand.role.andand.name, :scope => [:user,:roles]) 
 t(:cannot_change_role, :scope => [:user,:edit]) 
 else 
 f.fields_for "grants_attributes", (@user.grants.first || @user.grants.build), :index => 1 do |gf| 
 gf.hidden_field :id unless gf.object.new_record? 
 gf.label :role_id, Skyline::User.human_attribute_name("role") 
 gf.select :role_id, @roles.map{|s| [t(s.name, :scope => [:user,:roles], :default => s.name), s.id] } 
 if @user.errors[:roles].any? 
 @user.errors[:roles].first 
 end 
 end 
 end 
 link_to_function t(:cancel, :scope => [:buttons]), "Skyline.Dialog.current.close()", :class => "cancel"  
 submit_button :save, :class => "small green"  
 render_messages(:area => "Skyline.Dialog.current.contentEl.getElement('.messageArea')") 
  
 end 
 

end

  end

  def edit
    @user = Skyline::User.find_by_id(params[:id])
    @roles = current_user.viewable_roles
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 dialog(t(:dialog_title, :display_name => @user.display_name, :scope => [:user,:edit]), :partial => "edit", :width => 700) 

end

  end

  def update
    @user = Skyline::User.find_by_id(params[:id])
    attributes = params[:user]
    login_reset = attributes.andand.delete(:login_reset)
    @user.force_password = attributes.andand.delete(:force_password)
    @user.attributes = attributes
    @user.editing_user = current_user

    if @user.save
      @user.reset_login_attempts! if login_reset == '1'
      notifications[:success] = t(:success, :scope => [:user,:update,:flashes])
      javascript_redirect_to skyline_users_path(:page => page_number_for_user(@user))
    else
      @roles = current_user.viewable_roles
      messages.now[:error] = t(:error,:scope => [:user,:update,:flashes])
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  skyline_form_for @user, :as => :user, :url => skyline_user_path(@user), :remote => true, :method => :put do |f|
   if current_user == f.object 
 f.label_with_text :current_password 
 f.password_field :current_password, :class => "full" 
 t(:current_password_info, :scope => [:user, :edit]) 
 end 
 f.label_with_text :email 
 f.text_field :email, :class => "full" 
 f.label_with_text :name 
 f.text_field :name, :class => "full" 
 f.label password_attribute, Skyline::User.human_attribute_name("password") 
 f.password_field password_attribute, :class => "full" 
 if password_attribute == :force_password 
 t(:password_info, :scope => [:user,:edit]) 
 end 
 f.label password_confirmation_attribute, f.t(:password_confirmation) 
 f.password_field password_confirmation_attribute, :class => "full" 
 if Skyline::Configuration.login_attempts_allowed > 0 && @user.login_attempts > 0 
 f.label :login_reset, f.t(:login_reset) 
 f.check_box :login_reset, :class => "full", :class => 'checkbox' 
 t(:login_attempts_info, 
                       :count => @user.login_attempts,
                       :since => l(@user.last_login_attempt, :format => :long),
                       :duration => distance_of_time_in_words_to_now(@user.last_login_attempt),
                       :scope => [:user, :edit]) 
 else 
 unless current_user == f.object
 f.label :is_locked, f.t(:is_locked) 
 f.check_box :is_locked, :class => "full", :class => 'checkbox' 
 end 
 end 
 if current_user == f.object 
 f.t(:role) 
 t(@user.grants.first.andand.role.andand.name, :scope => [:user,:roles]) 
 t(:cannot_change_role, :scope => [:user,:edit]) 
 else 
 f.fields_for "grants_attributes", (@user.grants.first || @user.grants.build), :index => 1 do |gf| 
 gf.hidden_field :id unless gf.object.new_record? 
 gf.label :role_id, Skyline::User.human_attribute_name("role") 
 gf.select :role_id, @roles.map{|s| [t(s.name, :scope => [:user,:roles], :default => s.name), s.id] } 
 if @user.errors[:roles].any? 
 @user.errors[:roles].first 
 end 
 end 
 end 
 link_to_function t(:cancel, :scope => [:buttons]), "Skyline.Dialog.current.close()", :class => "cancel"  
 submit_button :save, :class => "small green"  
 render_messages(:area => "Skyline.Dialog.current.contentEl.getElement('.messageArea')") 
  
 end 
 

end

  end

  def destroy
    @user = Skyline::User.find_by_id(params[:id])
    if @user == current_user
      notifications[:error] = t(:cant_delete_myself, :scope => [:user,:destroy,:flashes])
    elsif @user.destroy
      notifications[:success] = t(:success, :scope => [:user,:destroy,:flashes])
    else
      notifications[:error] = t(:error, :scope => [:user,:destroy,:flashes])
    end

    javascript_redirect_to skyline_users_path(:page => params[:page])
  end


  protected

  def check_for_custom_user_class
    unless Skyline::Configuration.user_class == Skyline::User
      notifications[:error] = t(:custom_class, :scope => [:user, :filters, :flashes])
      redirect_to skyline_root_path
    end
  end

  def per_page
    30
  end

  def page_number_for_user(user)
    (Skyline::User.count(:conditions => ["email < :email",{:email => user.email}]).to_i / self.per_page)  + 1
  end
  helper_method :page_number_for_user

end

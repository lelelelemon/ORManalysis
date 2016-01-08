module Admin

class UsersController < ApplicationController
  layout 'admin'
  
  skip_authorization_check :only => [:index, :edit]
  before_filter :set_navigation_ids
  
  def index
    if !can?(:list, User)
      redirect_to dashboard_path
      return
    end

    @users = User.order('email').page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
    end
  end

  def show
    @user = User.find(params[:id])
    authorize! :read, @user
    @sites    = @user.sites
    @topics   = @user.topics

    respond_to do |format|
      format.html
      format.json { render :json => @user }
    end
  end
  
  def new
    authorize! :create, User
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user }
    end
  end

  def edit
    redirect_to admin_user_path(params[:id])
  end

  def create
    authorize! :create, User
    @user = User.new(params[:user], :as => current_user.role)

    respond_to do |format|
      if @user.save
        format.html { redirect_to(admin_users_path, :notice => 'User was successfully created.') }
        format.json { render :json => @user, :status => :created, :location => @user }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 form_for([:admin, @user]) do |f| 
 if @user.errors.any? 
 pluralize(@user.errors.count, "error") 
 @user.errors.full_messages.each do |msg| 
 msg 
 end 
 end 
 @user.email_md5 
 f.label :email 
 f.text_field :email 
 f.label :password,
      @user.new_record? ?
      nil :
      "Change password (leave blank if you don't want to change it)" 
 f.password_field :password 
 f.label :password_confirmation, 'Confirm password' 
 f.password_field :password_confirmation 
 if can?(:make_admin, @user) 
 f.check_box :admin 
 f.label :admin, 'Administrator rights' 
 end 
 primary_button_submit_tag(@user.new_record? ? 'Create' : 'Update') 
 button_link_to 'Cancel', admin_users_path 
 if can?(:destroy, @user) && !@user.new_record? 
 danger_button_link_to 'Delete', [:admin, @user],
        :method => :delete,
        :confirm => 'Are you sure? All sites, comments and topics belonging to this user will also be deleted!' 
 end 
 end 

end
 

end
 }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @user = User.find(params[:id])
    authorize! :update, @user

    respond_to do |format|
      if @user.update_attributes(params[:user], :as => current_user.role)
        format.html { redirect_to(admin_users_path, :notice => 'User was successfully updated.') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    authorize! :destroy, @user
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(admin_users_path) }
      format.json { head :ok }
    end
  end

private
  def set_navigation_ids
    @navigation_ids = [:dashboard, :users]
  end
end

end # module Admin

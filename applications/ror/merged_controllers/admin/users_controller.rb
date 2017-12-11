class Admin::UsersController < Admin::BaseController
  helper_method :sort_column, :sort_direction

  def index
    authorize! :view_users, current_user
    @users = User.admin_grid(params).order(sort_column + " " + sort_direction).
                                    paginate(:page => pagination_page, :per_page => pagination_rows)
  end

  def show
    @user = User.includes([:shipments, :finished_orders, :return_authorizations]).find(params[:id])
    add_to_recent_user(@user)
  end

  def new
    @user = User.new
    authorize! :create_users, current_user
    form_info
  end

  def create
    @user = User.new(user_params)
    authorize! :create_users, current_user
    if @user.save
      @user.deliver_activation_instructions!
      add_to_recent_user(@user)
      flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
      redirect_to admin_users_url
    else
      form_info
      render action: :new
    end
 
 site_name 
 stylesheet_link_tag "normalize.css" 
 stylesheet_link_tag "application.css" 
 stylesheet_link_tag 'admin/app.css' 
 stylesheet_link_tag "admin/ie.css" 
 csrf_meta_tag 
 yield :head 
 if notice || alert 
 !!alert ? 'alert' : 'warning' 
 if alert 
 alert 
 elsif notice 
 notice 
 end 
 end 
 render :partial => "shared/admin/header_bar" 
 if content_for? :header_sub_bar 
 yield :header_sub_bar 
 end 
 if content_for?(:sidemenu) 
 yield 
 yield :sidemenu 
 else 
 yield 
 end 
 site_name 
 link_to "RoR eCommerce", "http://ror-e.com" 
 RoReCommerce::Version 
 javascript_include_tag 'application' 
 yield :bottom 
 if Rails.env.development? 
 end 
 yield :below_body 

 end

  def edit
    @user = User.includes(:roles).find(params[:id])
    authorize! :create_users, current_user
    form_info
  end

  def update
    params[:user][:role_ids] ||= []
    @user = User.includes(:roles).find(params[:id])
    authorize! :create_users, current_user
    if @user.update_attributes(user_params)
      flash[:notice] = "#{@user.name} has been updated."
      redirect_to admin_users_url
    else
      form_info
      render :action => :edit
    end
 
 site_name 
 stylesheet_link_tag "normalize.css" 
 stylesheet_link_tag "application.css" 
 stylesheet_link_tag 'admin/app.css' 
 stylesheet_link_tag "admin/ie.css" 
 csrf_meta_tag 
 yield :head 
 if notice || alert 
 !!alert ? 'alert' : 'warning' 
 if alert 
 alert 
 elsif notice 
 notice 
 end 
 end 
 render :partial => "shared/admin/header_bar" 
 if content_for? :header_sub_bar 
 yield :header_sub_bar 
 end 
 if content_for?(:sidemenu) 
 yield 
 yield :sidemenu 
 else 
 yield 
 end 
 site_name 
 link_to "RoR eCommerce", "http://ror-e.com" 
 RoReCommerce::Version 
 javascript_include_tag 'application' 
 yield :bottom 
 if Rails.env.development? 
 end 
 yield :below_body 

 @user.name 
 link_to "Show #{@user.name}", admin_user_path(@user), class: 'tiny success button' 
 form_for @user, url: admin_user_path(@user)  do |form| 
 render partial: '/admin/users/form', locals: { form: form } 
 form.submit "Update", class: 'button' 
 end 

 end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :first_name, :last_name, :email, :state, :role_ids => [])
  end

  def form_info
    @all_roles = Role.all
    @states    = ['inactive', 'active', 'canceled']
  end

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "first_name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end

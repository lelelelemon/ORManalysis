class Admin::Config::AccountsController < Admin::Config::BaseController
  # GET /accounts
  def index
    @accounts = Account.all
  end

  # GET /accounts/1
  def show
    @account = Account.find(params[:id])
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
    @account = Account.find(params[:id])
  end

  # POST /accounts
  def create
    @account = Account.new(allowed_params)

    if @account.save
      redirect_to(admin_config_accounts_url(), :notice => 'Account was successfully created.')
    else
      render :action => "new"
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

 form_for( @account, url: admin_config_accounts_path) do |f| 
 render partial: 'form', locals: { f: f } 
 f.submit "Create", class: "button" 
 end 
 link_to 'Back', admin_config_accounts_path, class: 'button secondary' 

 end

  # PUT /accounts/1
  def update
    @account = Account.find(params[:id])

      if @account.update_attributes(allowed_params)
        redirect_to(admin_config_accounts_url(), :notice => 'Account was successfully updated.')
      else
        render :action => "edit"
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

 form_for( @account, url: admin_config_account_path(@account)) do |f| 
 render partial: 'form', locals: { f: f } 
 end 
 link_to 'Back', admin_config_accounts_path, class: 'button secondary' 

 end

  # DELETE /accounts/1
  def destroy
    @account = Account.find(params[:id])
    @account.destroy
    redirect_to(admin_config_accounts_url)
  end

  private

  def allowed_params
    params.require(:account).permit(:name, :account_type, :monthly_charge, :active)
  end
end

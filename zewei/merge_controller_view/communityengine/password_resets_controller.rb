class PasswordResetsController < BaseController
  before_action :require_no_user
  before_action :load_user_using_perishable_token, :only => [ :edit, :update ]

  def new
 @page_title=:forgot_your_password.l 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 widget do 
 :help.l 
 :dont_have_an_account.l 
 link_to :click_here_to_sign_up.l, signup_path 
 :forgot_your_password.l 
 link_to :click_here_to_retrieve_it.l, forgot_password_url 
 :forgot_your_username.l 
 link_to :click_here_to_retrieve_it.l, forgot_username_url 
 end 


end

 
 bootstrap_form_tag :url => password_resets_path, :layout => :horizontal do |f| 
 f.email_field :email, :label => :enter_your_email_address.l 
 f.form_group :submit_group do 
 f.primary :reset_my_password.l 
 end 
 end 

  end

  def create
    @user = User.where("lower(email) = ?", params[:email].downcase).first
    if @user
      @user.deliver_password_reset_instructions!

      flash[:notice] = :your_password_reset_instructions_have_been_emailed_to_you.l

      redirect_to login_path
    else
      flash[:error] = :sorry_we_dont_recognize_that_email_address.l

      render :action => :new
    end
  end

  def edit
 @page_title=:forgot_your_password.l 
 bootstrap_form_tag :url => password_reset_path, :method => :put, :layout => :horizontal do |f| 
 f.password_field :password 
 f.password_field :password_confirmation, :label => :confirm_password.l 
 f.form_group :submit_group do 
 f.primary :reset_my_password.l 
 end 
 end 

  end

  def update
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]

    if @user.save
      flash[:notice] = :your_changes_were_saved.l

      redirect_to dashboard_user_path(@user)
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render :action => :edit
    end
  end


  private

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:error] = :an_error_occurred.l
      redirect_to login_path
    end
  end

end

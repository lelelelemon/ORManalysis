class SignupController < ApplicationController
  before_filter :require_logged_in_user, :only => :invite

  def index
    if @user
      flash[:error] = "You are already signed up."
      return redirect_to "/"
    end

    @title = "Signup"
 if Rails.application.allow_invitation_requests? 
 else 
 end 

  end


  def invite
    @title = "Pass Along an Invitation"
 @user.invited_by_user.try(:username) 
  form_tag "/invitations", :method => :post do |f| 
 if defined?(return_home) && return_home 
 hidden_field_tag :return_home, 1 
 end 
 label_tag :email, "E-mail Address:", :class => "required" 
 text_field_tag :email, "", :size => 30, :autocomplete => "off" 
 label_tag :memo, "Memo to User:", :class => "required" 
 text_field_tag :memo, "", :size => 60 
 submit_tag "Send Invitation" 
 end 
 
 button_to "Skip", "/", :method => :get 

  end


  def invited
    if @user
      flash[:error] = "You are already signed up."
      return redirect_to "/"
    end

    if !(@invitation = Invitation.where(:code => params[:invitation_code].to_s).first)
      flash[:error] = "Invalid or expired invitation"
      return redirect_to "/signup"
    end

    @title = "Signup"

    @new_user = User.new
    @new_user.email = @invitation.email

    render :action => "invited"
  end

  def signup
    if !(@invitation = Invitation.where(:code => params[:invitation_code].to_s).first)
      flash[:error] = "Invalid or expired invitation."
      return redirect_to "/signup"
    end

    @title = "Signup"

    @new_user = User.new(user_params)
    @new_user.invited_by_user_id = @invitation.user_id

    if @new_user.save
      @invitation.destroy
      session[:u] = @new_user.session_token
      flash[:success] = "Welcome to #{Rails.application.name}, " <<
        "#{@new_user.username}!"

      Countinual.count!("#{Rails.application.shortname}.users.created", "+1")

      return redirect_to "/signup/invite"
    else
      render :action => "invited"
    end
  end

private
  def user_params
    params.require(:user).permit(
      :username, :email, :password, :password_confirmation, :about,
    )
  end

end
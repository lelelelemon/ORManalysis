class InvitationsController < BaseController
  before_action :login_required

  def index
    @user = current_user
    @invitations = @user.invitations

    respond_to do |format|
      format.html
    end
 @page_title = :listing_invitations.l 
 for invitation in @invitations 
 invitation.email_addresses 
 end 
 link_to fa_icon('plus-circle', :text => :new_invitation.l), new_user_invitation_path 

  end

  def new
    @user = current_user
    @invitation = Invitation.new
 @page_title=:invite_your_friends_to_join.l 
 widget do 
 :spread_the_word.l 
 :invite_message.l(:site => configatron.community_name) 
 :people_who_sign_up_using_your_invitation_will_automatically_be_added_as_your_friends_on.l 
 configatron.community_name 
 end 
 bootstrap_form_for [@user, @invitation], :layout => :horizontal do |f| 
 :add_from_my_address_book.l 
 f.text_area :email_addresses , :rows => "5", :label => :enter_e_mail_addresses.l, :help => :comma_separated.l 
 f.text_area :message, :rows => "5", :label => :write_a_message.l 
 f.form_group :submit_group do 
 f.primary :send_invitations.l 
 end 
 end 

  end


  def edit
    @invitation = Invitation.find(params[:id])
  end


  def create
    @user = current_user

    @invitation = Invitation.new(invitation_params)
    @invitation.user = @user

    respond_to do |format|
      if @invitation.save
        flash[:notice] = :invitation_was_successfully_created.l
        format.html {
          unless params[:welcome]
            redirect_to user_path(@invitation.user)
          else
            redirect_to welcome_complete_user_path(@invitation.user)
          end
        }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 @page_title=:invite_your_friends_to_join.l 
 widget do 
 :spread_the_word.l 
 :invite_message.l(:site => configatron.community_name) 
 :people_who_sign_up_using_your_invitation_will_automatically_be_added_as_your_friends_on.l 
 configatron.community_name 
 end 
 bootstrap_form_for [@user, @invitation], :layout => :horizontal do |f| 
 :add_from_my_address_book.l 
 f.text_area :email_addresses , :rows => "5", :label => :enter_e_mail_addresses.l, :help => :comma_separated.l 
 f.text_area :message, :rows => "5", :label => :write_a_message.l 
 f.form_group :submit_group do 
 f.primary :send_invitations.l 
 end 
 end 


end

 }
      end
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:email_addresses, :message)
  end

end

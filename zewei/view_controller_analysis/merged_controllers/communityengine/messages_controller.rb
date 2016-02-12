class MessagesController < BaseController
  before_action :find_user
  before_action :login_required
  before_action :require_ownership_or_moderator, :except => [:auto_complete_for_username]

  skip_before_action :verify_authenticity_token, :only => [:auto_complete_for_username]

  uses_tiny_mce do
    {:options => configatron.default_mce_options}
  end

  def auto_complete_for_username
    @usernames = User.active.where.not(login: @user.login).pluck(:login)
    respond_to do |format|
      format.json {render :inline => @usernames.to_json}
    end
  end

  def index
    if params[:mailbox] == "sent"
      @messages = @user.sent_messages.page(params[:page]).per(20)
    else
      @messages = @user.message_threads_as_recipient.order('updated_at DESC').page(params[:page]).per(20)
    end
  widget do 
 :links.l 
 user_messages_path(@user) 
 :inbox.l 
 if @user.unread_messages? 
 "#{@user.unread_message_count}" 
 fa_icon "envelope inverse" 
 end 
 link_to :sent_messages.l, user_messages_path(@user, :mailbox => :sent) 
 link_to :compose.l, new_user_message_path(@user) 
 end 
 
 if params[:mailbox] == "sent" 
 bootstrap_form_tag :url => delete_selected_user_messages_path(@user) do 
  @page_title = :sent_messages.l 
 if @messages.empty? 
 :no_messages.l 
 else 
 @messages.each do |message| 
 check_box_tag "delete[]", message.id 
 :to.l 
 link_to h(message.recipient.login), user_path(message.recipient) 
 link_to image_tag( message.recipient.avatar_photo_url(:thumb), :alt => message.recipient.login , :class => 'thumbnail'), user_path(message.recipient), :title => :users_profile.l(:user => message.recipient.login) 
 link_to h(message.subject), user_message_path(message.sender, message) 
 time_ago_in_words_or_date(message.created_at) 
 end 
 submit_tag :delete_selected.l, :class => 'btn btn-danger' 
 paginate @messages, :theme => 'bootstrap' 
 end 
 
 end 
 else 
 bootstrap_form_tag :url => delete_message_threads_user_messages_path(@user) do 
  
 end 
 end 

  end

  def show
    @message = Message.read(params[:id], @user)
    @message_thread = MessageThread.for(@message, (admin? ? @message.recipient : current_user ))
    @reply = Message.new_reply(@user, @message_thread, params)
 if @message_thread 
 @page_title = @message_thread.parent_message.sender.login + ':' + @message_thread.parent_message.subject 
 else 
 @page_title= @message.subject 
 end 
  widget do 
 :links.l 
 user_messages_path(@user) 
 :inbox.l 
 if @user.unread_messages? 
 "#{@user.unread_message_count}" 
 fa_icon "envelope inverse" 
 end 
 link_to :sent_messages.l, user_messages_path(@user, :mailbox => :sent) 
 link_to :compose.l, new_user_message_path(@user) 
 end 
 
 unless @message_thread 
 h I18n.l(@message.created_at, :format => :literal_date)             
 auto_link @message.body       
 else 
 h I18n.l(@message_thread.parent_message.created_at, :format => :literal_date)                   
 auto_link @message_thread.parent_message.body 
 children = @message_thread.parent_message.children 
 children.each do |child|       
 h I18n.l(child.created_at, :format => :literal_date) 
 child.sender.login 
 auto_link child.body 
 end 
 end 
 if @reply     
 link_to :reply.l, new_user_message_path(@user, :reply_to => @message), :onclick => "$('#reply').toggle(); $('#dummy_reply').toggle(); $('#message_body').focus(); $('.sent').toggle(); return false;" 
  bootstrap_form_for [user, message], :layout => :horizontal do |f| 
 if message.reply_to 
 f.hidden_field :to 
 f.hidden_field :parent_id 
 else 
 f.text_field :to, :required => true, :autocomplete => "off", :id => "message_to", :label => :to.l, :placeholder => :type_a_username.l 
 content_for :end_javascript do 
 tag_auto_complete_field 'message_to', {:url => { :controller => "messages", :action => 'auto_complete_for_username'}, :tokens => [','], :tagLimit => 1 } 
 end 
 end 
 if @reply   
 f.hidden_field :subject   
 else 
 f.text_field :subject 
 end 
 f.text_area :body, :label => :message.l, :rows => 10, :class => "col-sm-6" 
 f.primary :send.l 
 end 
 
 end 

  end

  def new
    if params[:reply_to]
      in_reply_to = Message.find_by_id(params[:reply_to])
      message_thread = MessageThread.for(in_reply_to, current_user)
    end
    @message = Message.new_reply(@user, message_thread, params)
 @page_title= :compose_message.l 
  widget do 
 :links.l 
 user_messages_path(@user) 
 :inbox.l 
 if @user.unread_messages? 
 "#{@user.unread_message_count}" 
 fa_icon "envelope inverse" 
 end 
 link_to :sent_messages.l, user_messages_path(@user, :mailbox => :sent) 
 link_to :compose.l, new_user_message_path(@user) 
 end 
 
  bootstrap_form_for [user, message], :layout => :horizontal do |f| 
 if message.reply_to 
 f.hidden_field :to 
 f.hidden_field :parent_id 
 else 
 f.text_field :to, :required => true, :autocomplete => "off", :id => "message_to", :label => :to.l, :placeholder => :type_a_username.l 
 content_for :end_javascript do 
 tag_auto_complete_field 'message_to', {:url => { :controller => "messages", :action => 'auto_complete_for_username'}, :tokens => [','], :tagLimit => 1 } 
 end 
 end 
 if @reply   
 f.hidden_field :subject   
 else 
 f.text_field :subject 
 end 
 f.text_area :body, :label => :message.l, :rows => 10, :class => "col-sm-6" 
 f.primary :send.l 
 end 
 

  end

  def create
    messages = []

    if params.require(:message)[:to].blank?
      # If 'to' field is empty, call validations to catch other errors
      @message = Message.new(message_params)
      @message.valid?
      render :action => :new and return
    else
      @message = Message.new(message_params)
      @message.recipient= User.where('lower(login) = ?', params.require(:message)[:to].strip.downcase).first
      @message.sender = @user
      unless @message.valid?
        render :action => :new and return
      else
        @message.save!
      end
      flash[:notice] = :message_sent.l
      redirect_to user_messages_path(@user) and return
    end
  end

  def delete_selected
    if request.post?
      if params[:delete]
        params[:delete].each { |id|
          @message = Message.where("messages.id = ? AND (sender_id = ? OR recipient_id = ?)", id, @user, @user).first
          @message.mark_deleted(@user) unless @message.nil?
        }
        flash[:notice] = :messages_deleted.l
      end
      redirect_to user_messages_path(@user)
    end
  end

  def delete_message_threads
    if request.post?
      if params[:delete]
        params[:delete].each { |id|
          message_thread = MessageThread.find_by_id_and_recipient_id(id, @user.id)
          message_thread.destroy if message_thread
        }
        flash[:notice] = :messages_deleted.l
      end
      redirect_to user_messages_path(@user)
    end

  end

  private
    def find_user
      @user = User.find(params[:user_id])
    end

    def require_ownership_or_moderator
      unless admin? || moderator? || (@user && (@user.eql?(current_user)))
        redirect_to :controller => 'sessions', :action => 'new' and return false
      end
      return @user
    end

  def message_params
    params.require(:message).permit(:to, :subject, :body,  :recipient_id, :sender_id, :parent_id)
  end
end

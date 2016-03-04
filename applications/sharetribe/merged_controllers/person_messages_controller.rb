class PersonMessagesController < ApplicationController

  before_filter do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_send_a_message")
  end

  before_filter :fetch_recipient

  def new
    @conversation = Conversation.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :javascript do 
 end 
 t("conversations.new.send_message_to_user", :person => @recipient.given_name_or_username) 
 form_for @conversation, :url => person_person_messages_path(:person => @recipient) do |form| 
 fields_for "conversation[message_attributes]", Message.new do |message_form| 
 message_form.label :content, t('conversations.new.message') 
 message_form.text_area :content, :class => "text_area" 
 message_form.hidden_field :sender_id, :value => @current_user.id 
 end 
 form.button t("conversations.new.send_message"), :class => "send_button" 
 end 

end

  end

  def create
    @conversation = new_conversation
    if @conversation.save
      flash[:notice] = t("layouts.notifications.message_sent")
      Delayed::Job.enqueue(MessageSentJob.new(@conversation.messages.last.id, @current_community.id))
      redirect_to @recipient
    else
      flash[:error] = "Sending the message failed. Please try again."
      redirect_to root
    end
  end

  private

  def new_conversation
    conversation = Conversation.new(params[:conversation].merge(community: @current_community))
    conversation.build_starter_participation(@current_user)
    conversation.build_participation(@recipient)
    conversation
  end

  def fetch_recipient
    @recipient = Person.find(params[:person_id])
    if @current_user == @recipient
      flash[:error] = t("layouts.notifications.you_cannot_send_message_to_yourself")
      redirect_to root
    end
  end
end

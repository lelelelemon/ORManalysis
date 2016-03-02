class MessagesController < ApplicationController
  MessageEntity = MarketplaceService::Conversation::Entity::Message
  PersonEntity = MarketplaceService::Person::Entity

  before_filter do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_send_a_message")
  end

  before_filter do |controller|
    controller.ensure_authorized t("layouts.notifications.you_are_not_authorized_to_do_this")
  end

  def create
    unless is_participant?(@current_user, params[:message][:conversation_id])
      flash[:error] = t("layouts.notifications.you_are_not_authorized_to_do_this")
      return redirect_to root
    end

    @message = Message.new(params[:message])
    if @message.save
      Delayed::Job.enqueue(MessageSentJob.new(@message.id, @current_community.id))
    else
      flash[:error] = "reply_cannot_be_empty"
    end

    # TODO This is somewhat copy-paste
    message = MessageEntity[@message].merge({mood: :neutral}).merge(sender: person_entity_with_display_name(PersonEntity.person(@current_user, @current_community.id)))

    respond_to do |format|
      format.html { redirect_to single_conversation_path(:conversation_type => "received", :person_id => @current_user.id, :id => params[:message][:conversation_id]) }
      format.js { render :layout => false, locals: { message: message } }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t("layouts.notifications.#{flash[:message_notice]}") 
  avatar_side = message_or_action[:sender][:id] == @current_user.id ? "left" : "right" 
 avatar_side 
 image_tag(message_or_action[:sender][:avatar], :class => "message-avatar-image") 
 avatar_side 
 avatar_side 
 link_to_unless message_or_action[:sender][:is_deleted], message_or_action[:sender][:display_name], person_path(id: message_or_action[:sender][:username]) 
 time_ago(message_or_action[:created_at]) 
 avatar_side 
 message_or_action[:type] 
 message_or_action[:mood] 
 text_with_line_breaks do 
 message_or_action[:content] 
 end 
 @message.id.to_s 
 t("conversations.show.send_reply") 

end

  end

  private

  def person_entity_with_display_name(person_entity)
    person_display_entity = person_entity.merge(
      display_name: PersonViewUtils.person_entity_display_name(person_entity, @current_community.name_display_type)
    )
  end

  def is_participant?(person, conversation_id)
    Conversation.find(conversation_id).participant?(person)
  end

end

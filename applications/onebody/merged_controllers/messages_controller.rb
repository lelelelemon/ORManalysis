class MessagesController < ApplicationController

  load_and_authorize_parent :group, only: [:index, :new, :create], optional: true
  load_and_authorize_resource except: [:index, :new]

  def index
    if @logged_in.member_of?(@group) and @group.email?
      @messages = messages.order(created_at: :desc).page(params[:page])
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('messages.messages_in_html', url: group_path(@group), name: @group.name) 
 if @group.can_post?(@logged_in) 
 link_to new_group_message_path(@group), class: 'btn btn-success' do 
 icon 'fa fa-plus' 
 t('messages.new.button') 
 end 
 end 
 pagination @messages 
 @messages.each do |message| 
 link_to message.subject, message 
 if message.attachments.any? 
 link_to message, class: 'btn btn-xs btn-info' do 
 icon 'fa fa-link' 
 end 
 end 
 render_message_body message 
 link_to t('messages.read_more'), message, class: 'btn btn-info btn-xs' 
 t('messages.sent_at_html', when: message.created_at.to_s(:full), who: link_to(message.person.try(:name), message.person)) 
 end 
 pagination @messages 

end

  end

  def new
    if @group
      @message = @group.messages.new
    elsif params[:to_person_id] and @person = Person.find(params[:to_person_id])
      @message = Message.new(to_person_id: @person.id, subject: params[:subject])
    elsif params[:parent_id] and @parent = Message.find(params[:parent_id])
      @message = Message.new(parent: @parent, group_id: @parent.group_id, subject: "Re: #{@parent.subject}")
    end
    Authority.enforce(:create, @message, current_user)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @message.to 
 @title = t('messages.private.heading') 
 content_for :sub_title, link_to(@message.to.name, @message.to) 
 t('messages.private.description_html', person: link_to(@message.to.name, @message.to)) 
 elsif @message.group 
 @title = t('messages.group.heading') 
 content_for :sub_title, link_to(@message.group.name, @message.group) 
 t('messages.group.description_html', group: link_to(@message.group.name, @message.group)) 
 end 
  

end

  end

  def create
    if m = params[:message]
      if m[:to_person_id].to_i > 0
        create_private_message
      elsif m[:group_id].to_i > 0
        create_group_message
      else
        raise t('messages.unknown_type')
      end
    else
      raise t('messages.missing_param')
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @preview 
 escape_javascript t('messages.from') + ': ' + h(@preview.from) 
 escape_javascript t('messages.subject') + ': ' + h(@preview.subject) 
 escape_javascript simple_format(auto_link(h(get_email_body(@preview)))) 
 end 

end

  end

  def show
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = @message.subject 
 link_to @message.person do 
 avatar_tag @message.person, class: 'fit-width' 
 end 
 t('messages.sent_at_html', when: @message.created_at.to_s(:full), who: link_to(@message.person.try(:name), @message.person)) 
 if @message.to 
 t('messages.sent_to_html', who: link_to(@message.to.try(:name), @message.to)) 
 elsif @message.group 
 t('messages.sent_to_html', who: link_to(@message.group.try(:name), @message.group)) 
 end 
 if @logged_in.can_update?(@message) 
 link_to @message, data: { method: 'delete', confirm: t('are_you_sure') }, class: 'btn btn-delete' do 
 icon 'fa fa-trash-o' 
 t('messages.delete.button') 
 end 
 end 
 if @message.parent 
 t('messages.in_reply_to_html', message: link_to(@message.parent.try(:subject), @message.parent)) 
 end 
 render_message_body(@message) 
  if message.attachments.any? 
 t('messages.attachments') 
 message.attachments.images.each do |attachment| 
 link_to [message, attachment] do 
 image_tag attachment.file.url, style: 'width: 75px', class: 'thumbnail' 
 end 
 end 
 message.attachments.non_images.each do |attachment| 
 link_to [message, attachment] do 
 icon 'fa fa-file-o' 
 end 
 link_to attachment.name, [message, attachment] 
 end 
 end 
 
 if @message.children.any? 
 t('messages.replies.heading') 
 @message.children.each do |reply| 
 render_message_body(reply) 
 link_to reply.person do 
 avatar_tag(reply.person) 
 end 
 link_to reply.person.try(:name), reply.person 
 reply.created_at.to_s(:full) 
 if reply.attachments.any? 
 link_to reply, class: 'btn btn-xs btn-info' do 
 icon 'fa fa-link' 
 end 
 end 
 link_to t('messages.read_more'), reply, class: 'btn btn-info btn-xs' 
 end 
 end 
 if @message.group and @message.group.can_post? @logged_in 
 link_to new_message_path(parent_id: @message.id), remote: true, method: :get, class: 'btn btn-info' do 
 icon 'fa fa-reply-all' 
 t('messages.reply_all.button') 
 end 
 end 

end

  end

  def destroy
    @message.destroy
    redirect_to @message.group ? @message.group : stream_path
  end

  private

  def message_params
    params.require(:message).permit(:group_id, :to_person_id, :parent_id, :subject, :body)
  end

  def create_private_message
    @person = Person.find(params[:message][:to_person_id])
    if @person.email and @logged_in.can_read?(@person)
      if send_message
        unless @preview
          render text: t('messages.sent'), layout: true
        end
      end
    else
      render text: t('messages.no_email_for_person', name: @person.name), layout: true, status: 500
    end
  end

  def create_group_message
    @group = Group.find(params[:message][:group_id])
    if @group.can_post? @logged_in
      if send_message
        unless @preview
          flash[:notice] = t('messages.sent')
          redirect_to @group
        end
      end
    else
      render text: t('not_authorized'), layout: true, status: 500
    end
  end

  def send_message
    attributes = message_params.merge(person: @logged_in)
    if attributes[:parent_id].present? and not @logged_in.can_read?(Message.find(attributes[:parent_id]))
      render text: 'unauthorized', status: :unauthorized
      return
    end
    if params[:preview]
      @preview = Message.preview(attributes)
    else
      @message = Message.create_with_attachments(attributes, params[:files].to_a)
      if @message.errors.any?
        if @message.errors[:base] and @message.errors[:base].include?('already saved')
          @message.errors[:base].delete('already saved')
        end
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @message.to 
 @title = t('messages.private.heading') 
 content_for :sub_title, link_to(@message.to.name, @message.to) 
 t('messages.private.description_html', person: link_to(@message.to.name, @message.to)) 
 elsif @message.group 
 @title = t('messages.group.heading') 
 content_for :sub_title, link_to(@message.group.name, @message.group) 
 t('messages.group.description_html', group: link_to(@message.group.name, @message.group)) 
 end 
  

end

        false
      else
        true
      end
    end
  end
end

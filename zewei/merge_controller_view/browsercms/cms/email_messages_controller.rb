module Cms
  class EmailMessagesController < Cms::BaseController

    include Cms::AdminTab

    check_permissions :administrate

    def index
      @messages = EmailMessage.paginate(:page => params[:page])
 use_page_title "Email Messages" 
 render layout: 'page_title' do
end 
 render layout: 'main_content' do 
 @messages.each do |message| 
 link_to truncate(message.recipients), message 
 message.subject 
 h time_on_date(message.delivered_at) 
 end 
 if @messages.empty? 
 end 
 end 
 if @messages.total_pages > 1 
 render_pagination @messages, Cms::EmailMessage 
 end 

    end

    def show
      @message = EmailMessage.find(params[:id])
 content_for :functions do 
 link_to span_tag("List All"), cms.email_messages_path, :class => "button" 
 end 
 use_page_title "Email Message" 
 render layout: 'page_title' do 
 link_to "Email Messages", cms.email_messages_path, :class => "btn btn-primary right btn-small" 
 end 
 render layout: 'main_with_sidebar' do 
 time_on_date(@message.delivered_at) 
 unless @message.content_type.blank? 
 h @message.content_type 
 end 
 h @message.sender 
 h @message.recipients 
 unless @message.cc.blank? 
 h @message.cc 
 end 
 unless @message.bcc.blank? 
 h @message.bcc 
 end 
 h @message.subject 
 h @message.body 
 end 

    end

    private
    def set_menu_section
      @menu_section = 'email_messages'
    end
  end
end
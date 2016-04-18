class MessagesController < ApplicationController
  def batch_delete
    params.each do |k, v|
      message = Message.where(:short_id => k[1])
      if message.author_user_id == @user.id
        message.deleted_by_author = true
      end
      if message.recipient_user_id == @user.id
        message.deleted_by_recipient = true
      end
    end
  end
end

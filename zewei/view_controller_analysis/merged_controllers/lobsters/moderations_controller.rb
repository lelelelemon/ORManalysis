class ModerationsController < ApplicationController
  def index
    @title = "Moderation Log"

    @page = params[:page] ? params[:page].to_i : 0
    @pages = (Moderation.count / 50).ceil

    if @page < 1
      @page = 1
    elsif @page > @pages
      @page = @pages
    end

    @moderations = Moderation.order("id desc").limit(50).offset((@page - 1) *
      50)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 bit = 0 
 @moderations.each do |mod| 
 bit 
 mod.created_at.strftime("%Y-%m-%d %H:%M:%S") 
 if mod.moderator 
 mod.moderator.try(:username) 

          mod.moderator.try(:username) 
 elsif mod.is_from_suggestions? 
 end 
 if mod.story 
 mod.story.comments_path 
 mod.story.title
            
 elsif mod.comment 
 mod.comment.url 

            mod.comment.story.title 
 elsif mod.user_id 
 if mod.user 
 mod.user.username 
 mod.user.username 
 else 
 mod.user_id 
 end 
 end 
 bit 
 mod.reason.present?? "nobottom" : "" 
 mod.action 
 if mod.reason.present? 
 bit 
 mod.reason 
 end 
 bit = (bit == 1 ? 0 : 1) 
 end 
 if @page > 1 
 @page - 1 
 @page - 1 
 end 
 if @pages > 1 && @page < @pages 
 if @page > 1 
 end 
 @page + 1 
 @page + 1
      
 end 

end

  end
end

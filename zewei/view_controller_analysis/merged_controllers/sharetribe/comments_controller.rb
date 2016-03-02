class CommentsController < ApplicationController

  before_filter do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_send_a_comment")
  end

  before_filter :ensure_authorized_to_comment, only: [:create]

  def create
    if @comment.save
      @comment.reload # reload is needed, as create.js.erb refers the model directly
      Delayed::Job.enqueue(CommentCreatedJob.new(@comment.id, @current_community.id))
    else
      flash[:error] = t("layouts.notifications.comment_cannot_be_empty")
    end
    respond_to do |format|
      format.html { redirect_to listing_path(params[:comment][:listing_id]) }
      format.js { render :layout => false }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t("layouts.notifications.#{flash[:comment_notice]}") 
  comment.id.to_s 
 small_avatar_thumb(comment.author) 
 link_to_unless comment.author.deleted?, PersonViewUtils.person_display_name(comment.author, @current_community), comment.author 
 time_ago(comment.created_at) 
 if @current_user && (current_user?(comment.author) || @current_user.has_admin_rights_in?(@current_community)) 
 link_to t('listings.comment.delete'), listing_comment_path(:listing_id => comment.listing.id, :id => comment.id), {method: :delete, confirm: t('listings.comment.are_you_sure'), :remote => :true} 
 end 
 text_with_line_breaks do 
 comment.content 
 end 
 @comment.id.to_s 
 @comment.listing.comments_count 
 t("listings.comment_form.send_comment") 
  if @current_user 
 if @current_user.is_following?(@listing || @comment.listing) 
 link_to t(".unfollow"), unfollow_listing_path(@listing || @comment.listing), :class => "unfollow_listing", :method => :delete, :remote => :true 
 else 
 link_to t(".follow"), follow_listing_path(@listing || @comment.listing), :class => "follow_listing", :method => :post, :remote => :true 
 end 
 end 

end

  end

  def destroy
    @comment = Comment.find(params[:id])
    if current_user?(@comment.author) || @current_user.has_admin_rights_in?(@current_community)
      @comment.destroy
      respond_to do |format|
        format.html { redirect_to listing_path(params[:listing_id]) }
        format.js { render :layout => false }
      end
    else
      flash[:error] = t("layouts.notifications.you_are_not_authorized_to_do_this")
      redirect_to listing_path(params[:listing_id])
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @comment.id.to_s 
 @comment.listing.comments_count - 1 

end

  end

  # Ensure that only users with appropriate visibility settings can reply to the listing
  def ensure_authorized_to_comment
    @comment = Comment.new(params[:comment])
    unless @comment.listing.visible_to?(@current_user, @current_community) || @current_user.has_admin_rights_in?(@current_community)
      flash[:error] = t("layouts.notifications.you_are_not_authorized_to_view_this_content")
      redirect_to root and return
    end
  end

end

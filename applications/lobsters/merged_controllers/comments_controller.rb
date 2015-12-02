class CommentsController < ApplicationController
  COMMENTS_PER_PAGE = 20

  # for rss feeds, load the user's tag filters if a token is passed
  before_filter :find_user_from_rss_token, :only => [ :index ]
  before_filter :require_logged_in_user_or_400,
    :only => [ :create, :preview, :upvote, :downvote, :unvote ]

  # for rss feeds, load the user's tag filters if a token is passed
  before_filter :find_user_from_rss_token, :only => [ :index ]

  def create
    if !(story = Story.where(:short_id => params[:story_id]).first) ||
    story.is_gone?
      return render :text => "can't find story", :status => 400
    end

    comment = story.comments.build
    comment.comment = params[:comment].to_s
    comment.user = @user

    if params[:hat_id] && @user.hats.where(:id => params[:hat_id])
      comment.hat_id = params[:hat_id]
    end

    if params[:parent_comment_short_id].present?
      if pc = Comment.where(:story_id => story.id, :short_id =>
      params[:parent_comment_short_id]).first
        comment.parent_comment = pc
      else
        return render :json => { :error => "invalid parent comment",
          :status => 400 }
      end
    end

    # prevent double-clicks of the post button
    if params[:preview].blank? &&
    (pc = Comment.where(:story_id => story.id, :user_id => @user.id,
      :parent_comment_id => comment.parent_comment_id).first)
      if (Time.now - pc.created_at) < 5.minutes
        comment.errors.add(:comment, "^You have already posted a comment " <<
          "here recently.")

        ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 comment.short_id if comment.persisted? 
 form_for comment,
:html => { :id => "edit_comment_#{comment.short_id}" } do |f| 
 if comment.errors.any? 
 errors_for comment 
 end 
 hidden_field_tag "story_id", comment.story.short_id 
 if comment.parent_comment 
 hidden_field_tag "parent_comment_short_id",
      comment.parent_comment.short_id 
 end 
 text_area_tag "comment", comment.comment, :rows => 5,
      :style => "width: 100%;", :autocomplete => "off", :disabled => !@user,
      :placeholder => (@user ? "" : "You must be logged in to leave a comment.")
      
 if @user 
 end 
 button_tag "#{comment.new_record?? "Post" : "Update"}",
        :class => "comment-post", :type => "button",
        :disabled => !@user 
 button_tag "Preview", :class => "comment-preview",
        :type => "button", :disabled => !@user 
 if comment.persisted? || comment.parent_comment_id 
 button_tag "Cancel", :class => "comment-cancel",
          :type => "button" 
 end 
 if @user && @user.hats.any? 
 select_tag "hat_id",
          options_from_collection_for_select(@user.hats, "id", "hat",
          comment.hat_id), :include_blank => true 
 end 
 if @user 
 render :partial => "global/markdownhelp" 
 end 
 end 
 if defined?(show_comment) && show_comment.valid? 
 render "comments/comment", :comment => show_comment 
 end 

end
      end
    end

    if comment.valid? && params[:preview].blank? && comment.save
      comment.current_vote = { :vote => 1 }

      ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 render "comments/comment", :comment => comment 

end
    else
      comment.upvotes = 1
      comment.current_vote = { :vote => 1 }

      preview comment
    end
  end

  def show
    if !((comment = find_comment) && comment.is_editable_by_user?(@user))
      return render :text => "can't find comment", :status => 400
    end

    ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 comment.short_id 
 comment.short_id if comment.persisted? 
 comment.current_vote ? (comment.current_vote[:vote] == 1 ?
"upvoted" : "downvoted") : "" 
 comment.highlighted ? "highlighted" : "" 
 comment.score <= 0 ? "negative" : "" 
 comment.score <= -1 ? "negative_1" : "" 
 comment.score <= -3 ? "negative_3" : "" 
 comment.score <= -5 ? "negative_5" : "" 
 if !comment.is_gone? 
 if @user 
 else 
 link_to "", login_path, :class => "upvoter" 
 end 
 comment.score 
 if @user && @user.can_downvote?(comment) 
 else 
 end 
 end 
 comment.short_id 
 if @user 
 end 
 if @user && @user.show_avatars? 
 comment.user.username 
 comment.user.avatar_url(16) 
 end 
 if defined?(was_merged) && was_merged 
 end 
 comment.user.username 
 if !comment.user.is_active? 
 elsif comment.user.is_new? 
 end 
 comment.user.username 
 if comment.hat 
 comment.hat.to_html_label 
 end 
 if comment.previewing 
 else 
 if comment.has_been_edited? 
 elsif comment.is_from_email? 
 end 
 time_ago_in_words_label((comment.has_been_edited? ?
          comment.updated_at : comment.created_at), :strip_about => true) 
 end 
 if !comment.previewing 
 comment.url 
 if comment.is_editable_by_user?(@user) 
 end 
 if comment.is_gone? && comment.is_undeletable_by_user?(@user) 
 elsif !comment.is_gone? && comment.is_deletable_by_user?(@user) 
 end 
 if @user && !comment.story.is_gone? && !comment.is_gone? 
 end 
 if comment.downvotes > 0 &&
          ((comment.score <= 0 && comment.user_id == @user.try(:id)) ||
          @user.try("is_moderator?")) 
 comment.vote_summary.downcase 
 elsif comment.current_vote && comment.current_vote[:vote] == -1 
 Vote::COMMENT_REASONS[comment.current_vote[:reason]].downcase 
 end 
 end 
 if defined?(show_story) && show_story 
 comment.story.comments_path 
 comment.story.title
          
 end 
 if comment.is_gone? 
 comment.gone_text 
 else 
 raw comment.markeddown_comment 
 end 

end
  end

  def show_short_id
    if !(comment = find_comment)
      return render :text => "can't find comment", :status => 400
    end

    render :json => comment.as_json
  end

  def redirect_from_short_id
    if comment = find_comment
      return redirect_to comment.url
    else
      return render :text => "can't find comment", :status => 400
    end
  end

  def edit
    if !((comment = find_comment) && comment.is_editable_by_user?(@user))
      return render :text => "can't find comment", :status => 400
    end

    ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 comment.short_id if comment.persisted? 
 form_for comment,
:html => { :id => "edit_comment_#{comment.short_id}" } do |f| 
 if comment.errors.any? 
 errors_for comment 
 end 
 hidden_field_tag "story_id", comment.story.short_id 
 if comment.parent_comment 
 hidden_field_tag "parent_comment_short_id",
      comment.parent_comment.short_id 
 end 
 text_area_tag "comment", comment.comment, :rows => 5,
      :style => "width: 100%;", :autocomplete => "off", :disabled => !@user,
      :placeholder => (@user ? "" : "You must be logged in to leave a comment.")
      
 if @user 
 end 
 button_tag "#{comment.new_record?? "Post" : "Update"}",
        :class => "comment-post", :type => "button",
        :disabled => !@user 
 button_tag "Preview", :class => "comment-preview",
        :type => "button", :disabled => !@user 
 if comment.persisted? || comment.parent_comment_id 
 button_tag "Cancel", :class => "comment-cancel",
          :type => "button" 
 end 
 if @user && @user.hats.any? 
 select_tag "hat_id",
          options_from_collection_for_select(@user.hats, "id", "hat",
          comment.hat_id), :include_blank => true 
 end 
 if @user 
 render :partial => "global/markdownhelp" 
 end 
 end 
 if defined?(show_comment) && show_comment.valid? 
 render "comments/comment", :comment => show_comment 
 end 

end
  end

  def reply
    if !(parent_comment = find_comment)
      return render :text => "can't find comment", :status => 400
    end

    comment = Comment.new
    comment.story = parent_comment.story
    comment.parent_comment = parent_comment

    ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 comment.short_id if comment.persisted? 
 form_for comment,
:html => { :id => "edit_comment_#{comment.short_id}" } do |f| 
 if comment.errors.any? 
 errors_for comment 
 end 
 hidden_field_tag "story_id", comment.story.short_id 
 if comment.parent_comment 
 hidden_field_tag "parent_comment_short_id",
      comment.parent_comment.short_id 
 end 
 text_area_tag "comment", comment.comment, :rows => 5,
      :style => "width: 100%;", :autocomplete => "off", :disabled => !@user,
      :placeholder => (@user ? "" : "You must be logged in to leave a comment.")
      
 if @user 
 end 
 button_tag "#{comment.new_record?? "Post" : "Update"}",
        :class => "comment-post", :type => "button",
        :disabled => !@user 
 button_tag "Preview", :class => "comment-preview",
        :type => "button", :disabled => !@user 
 if comment.persisted? || comment.parent_comment_id 
 button_tag "Cancel", :class => "comment-cancel",
          :type => "button" 
 end 
 if @user && @user.hats.any? 
 select_tag "hat_id",
          options_from_collection_for_select(@user.hats, "id", "hat",
          comment.hat_id), :include_blank => true 
 end 
 if @user 
 render :partial => "global/markdownhelp" 
 end 
 end 
 if defined?(show_comment) && show_comment.valid? 
 render "comments/comment", :comment => show_comment 
 end 

end
  end

  def delete
    if !((comment = find_comment) && comment.is_deletable_by_user?(@user))
      return render :text => "can't find comment", :status => 400
    end

    comment.delete_for_user(@user)

    ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 comment.short_id 
 comment.short_id if comment.persisted? 
 comment.current_vote ? (comment.current_vote[:vote] == 1 ?
"upvoted" : "downvoted") : "" 
 comment.highlighted ? "highlighted" : "" 
 comment.score <= 0 ? "negative" : "" 
 comment.score <= -1 ? "negative_1" : "" 
 comment.score <= -3 ? "negative_3" : "" 
 comment.score <= -5 ? "negative_5" : "" 
 if !comment.is_gone? 
 if @user 
 else 
 link_to "", login_path, :class => "upvoter" 
 end 
 comment.score 
 if @user && @user.can_downvote?(comment) 
 else 
 end 
 end 
 comment.short_id 
 if @user 
 end 
 if @user && @user.show_avatars? 
 comment.user.username 
 comment.user.avatar_url(16) 
 end 
 if defined?(was_merged) && was_merged 
 end 
 comment.user.username 
 if !comment.user.is_active? 
 elsif comment.user.is_new? 
 end 
 comment.user.username 
 if comment.hat 
 comment.hat.to_html_label 
 end 
 if comment.previewing 
 else 
 if comment.has_been_edited? 
 elsif comment.is_from_email? 
 end 
 time_ago_in_words_label((comment.has_been_edited? ?
          comment.updated_at : comment.created_at), :strip_about => true) 
 end 
 if !comment.previewing 
 comment.url 
 if comment.is_editable_by_user?(@user) 
 end 
 if comment.is_gone? && comment.is_undeletable_by_user?(@user) 
 elsif !comment.is_gone? && comment.is_deletable_by_user?(@user) 
 end 
 if @user && !comment.story.is_gone? && !comment.is_gone? 
 end 
 if comment.downvotes > 0 &&
          ((comment.score <= 0 && comment.user_id == @user.try(:id)) ||
          @user.try("is_moderator?")) 
 comment.vote_summary.downcase 
 elsif comment.current_vote && comment.current_vote[:vote] == -1 
 Vote::COMMENT_REASONS[comment.current_vote[:reason]].downcase 
 end 
 end 
 if defined?(show_story) && show_story 
 comment.story.comments_path 
 comment.story.title
          
 end 
 if comment.is_gone? 
 comment.gone_text 
 else 
 raw comment.markeddown_comment 
 end 

end
  end

  def undelete
    if !((comment = find_comment) && comment.is_undeletable_by_user?(@user))
      return render :text => "can't find comment", :status => 400
    end

    comment.undelete_for_user(@user)

    ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 comment.short_id 
 comment.short_id if comment.persisted? 
 comment.current_vote ? (comment.current_vote[:vote] == 1 ?
"upvoted" : "downvoted") : "" 
 comment.highlighted ? "highlighted" : "" 
 comment.score <= 0 ? "negative" : "" 
 comment.score <= -1 ? "negative_1" : "" 
 comment.score <= -3 ? "negative_3" : "" 
 comment.score <= -5 ? "negative_5" : "" 
 if !comment.is_gone? 
 if @user 
 else 
 link_to "", login_path, :class => "upvoter" 
 end 
 comment.score 
 if @user && @user.can_downvote?(comment) 
 else 
 end 
 end 
 comment.short_id 
 if @user 
 end 
 if @user && @user.show_avatars? 
 comment.user.username 
 comment.user.avatar_url(16) 
 end 
 if defined?(was_merged) && was_merged 
 end 
 comment.user.username 
 if !comment.user.is_active? 
 elsif comment.user.is_new? 
 end 
 comment.user.username 
 if comment.hat 
 comment.hat.to_html_label 
 end 
 if comment.previewing 
 else 
 if comment.has_been_edited? 
 elsif comment.is_from_email? 
 end 
 time_ago_in_words_label((comment.has_been_edited? ?
          comment.updated_at : comment.created_at), :strip_about => true) 
 end 
 if !comment.previewing 
 comment.url 
 if comment.is_editable_by_user?(@user) 
 end 
 if comment.is_gone? && comment.is_undeletable_by_user?(@user) 
 elsif !comment.is_gone? && comment.is_deletable_by_user?(@user) 
 end 
 if @user && !comment.story.is_gone? && !comment.is_gone? 
 end 
 if comment.downvotes > 0 &&
          ((comment.score <= 0 && comment.user_id == @user.try(:id)) ||
          @user.try("is_moderator?")) 
 comment.vote_summary.downcase 
 elsif comment.current_vote && comment.current_vote[:vote] == -1 
 Vote::COMMENT_REASONS[comment.current_vote[:reason]].downcase 
 end 
 end 
 if defined?(show_story) && show_story 
 comment.story.comments_path 
 comment.story.title
          
 end 
 if comment.is_gone? 
 comment.gone_text 
 else 
 raw comment.markeddown_comment 
 end 

end
  end

  def update
    if !((comment = find_comment) && comment.is_editable_by_user?(@user))
      return render :text => "can't find comment", :status => 400
    end

    comment.comment = params[:comment]
    comment.hat_id = nil
    if params[:hat_id] && @user.hats.where(:id => params[:hat_id])
      comment.hat_id = params[:hat_id]
    end

    if params[:preview].blank? && comment.save
      votes = Vote.comment_votes_by_user_for_comment_ids_hash(@user.id,
        [comment.id])
      comment.current_vote = votes[comment.id]

      ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 comment.short_id 
 comment.short_id if comment.persisted? 
 comment.current_vote ? (comment.current_vote[:vote] == 1 ?
"upvoted" : "downvoted") : "" 
 comment.highlighted ? "highlighted" : "" 
 comment.score <= 0 ? "negative" : "" 
 comment.score <= -1 ? "negative_1" : "" 
 comment.score <= -3 ? "negative_3" : "" 
 comment.score <= -5 ? "negative_5" : "" 
 if !comment.is_gone? 
 if @user 
 else 
 link_to "", login_path, :class => "upvoter" 
 end 
 comment.score 
 if @user && @user.can_downvote?(comment) 
 else 
 end 
 end 
 comment.short_id 
 if @user 
 end 
 if @user && @user.show_avatars? 
 comment.user.username 
 comment.user.avatar_url(16) 
 end 
 if defined?(was_merged) && was_merged 
 end 
 comment.user.username 
 if !comment.user.is_active? 
 elsif comment.user.is_new? 
 end 
 comment.user.username 
 if comment.hat 
 comment.hat.to_html_label 
 end 
 if comment.previewing 
 else 
 if comment.has_been_edited? 
 elsif comment.is_from_email? 
 end 
 time_ago_in_words_label((comment.has_been_edited? ?
          comment.updated_at : comment.created_at), :strip_about => true) 
 end 
 if !comment.previewing 
 comment.url 
 if comment.is_editable_by_user?(@user) 
 end 
 if comment.is_gone? && comment.is_undeletable_by_user?(@user) 
 elsif !comment.is_gone? && comment.is_deletable_by_user?(@user) 
 end 
 if @user && !comment.story.is_gone? && !comment.is_gone? 
 end 
 if comment.downvotes > 0 &&
          ((comment.score <= 0 && comment.user_id == @user.try(:id)) ||
          @user.try("is_moderator?")) 
 comment.vote_summary.downcase 
 elsif comment.current_vote && comment.current_vote[:vote] == -1 
 Vote::COMMENT_REASONS[comment.current_vote[:reason]].downcase 
 end 
 end 
 if defined?(show_story) && show_story 
 comment.story.comments_path 
 comment.story.title
          
 end 
 if comment.is_gone? 
 comment.gone_text 
 else 
 raw comment.markeddown_comment 
 end 

end
    else
      comment.current_vote = { :vote => 1 }

      preview comment
    end
  end

  def unvote
    if !(comment = find_comment)
      return render :text => "can't find comment", :status => 400
    end

    Vote.vote_thusly_on_story_or_comment_for_user_because(0, comment.story_id,
      comment.id, @user.id, nil)

    render :text => "ok"
  end

  def upvote
    if !(comment = find_comment)
      return render :text => "can't find comment", :status => 400
    end

    Vote.vote_thusly_on_story_or_comment_for_user_because(1, comment.story_id,
      comment.id, @user.id, params[:reason])

    render :text => "ok"
  end

  def downvote
    if !(comment = find_comment)
      return render :text => "can't find comment", :status => 400
    end

    if !Vote::COMMENT_REASONS[params[:reason]]
      return render :text => "invalid reason", :status => 400
    end

    if !@user.can_downvote?(comment)
      return render :text => "not permitted to downvote", :status => 400
    end

    Vote.vote_thusly_on_story_or_comment_for_user_because(-1, comment.story_id,
      comment.id, @user.id, params[:reason])

    render :text => "ok"
  end

  def index
    @rss_link ||= { :title => "RSS 2.0 - Newest Comments",
      :href => "/comments.rss#{@user ? "?token=#{@user.rss_token}" : ""}" }

    @heading = @title = "Newest Comments"
    @cur_url = "/comments"

    @page = 1
    if params[:page].to_i > 0
      @page = params[:page].to_i
    end

    @comments = Comment.where(
      :is_deleted => false, :is_moderated => false
    ).order(
      "created_at DESC"
    ).offset(
      (@page - 1) * COMMENTS_PER_PAGE
    ).limit(
      COMMENTS_PER_PAGE
    ).includes(
      :user, :story
    )

    if @user
      @comments = @comments.where("story_id NOT IN (SELECT story_id FROM " <<
        "hidden_stories WHERE user_id = ?)", @user.id)

      @votes = Vote.comment_votes_by_user_for_comment_ids_hash(@user.id,
        @comments.map{|c| c.id })

      @comments.each do |c|
        if @votes[c.id]
          c.current_vote = @votes[c.id]
        end
      end
    end

    respond_to do |format|
      format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 @comments.each do |comment| 
 render "comments/comment", :comment => comment,
      :show_story => true 
 end 
 if @page && @page > 1 
 @page == 2 ? "" : "/page/#{@page - 1}" 
 @page - 1 
 end 
 if @comments.any? 
 if @page && @page > 1 
 end 
 @page + 1 
 @page + 1 
 end 

end }
      format.rss {
        if @user && params[:token].present?
          @title = "Private comments feed for #{@user.username}"
        end

        render :action => "index.rss", :layout => false
      }
    end
  end

  def threads
    if params[:user]
      @showing_user = User.where(:username => params[:user]).first!
      @heading = @title = "Threads for #{@showing_user.username}"
      @cur_url = "/threads/#{@showing_user.username}"
    elsif !@user
      # TODO: show all recent threads
      return redirect_to "/login"
    else
      @showing_user = @user
      @heading = @title = "Your Threads"
      @cur_url = "/threads"
    end

    thread_ids = @showing_user.recent_threads(20)

    comments = Comment.where(
      :thread_id => thread_ids
    ).includes(
      :user, :story
    ).arrange_for_user(
      @showing_user
    )

    comments_by_thread_id = comments.group_by(&:thread_id)
    @threads = comments_by_thread_id.values_at(*thread_ids).compact

    if @user && (@showing_user.id == @user.id)
      @votes = Vote.comment_votes_by_user_for_story_hash(@user.id,
        comments.map(&:story_id).uniq)

      comments.each do |c|
        if @votes[c.id]
          c.current_vote = @votes[c.id]
        end
      end
    end

    # trim each thread to this user's first response
    # XXX: busted
    #@threads.each do |th|
    #  th.each do |c|
    #    if c.user_id == @user.id
    #      break
    #    else
    #      th.shift
    #    end
    #  end
    #end
  end

private

  def preview(comment)
    comment.previewing = true
    comment.is_deleted = false # show normal preview for deleted comments

    ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 comment.short_id if comment.persisted? 
 form_for comment,
:html => { :id => "edit_comment_#{comment.short_id}" } do |f| 
 if comment.errors.any? 
 errors_for comment 
 end 
 hidden_field_tag "story_id", comment.story.short_id 
 if comment.parent_comment 
 hidden_field_tag "parent_comment_short_id",
      comment.parent_comment.short_id 
 end 
 text_area_tag "comment", comment.comment, :rows => 5,
      :style => "width: 100%;", :autocomplete => "off", :disabled => !@user,
      :placeholder => (@user ? "" : "You must be logged in to leave a comment.")
      
 if @user 
 end 
 button_tag "#{comment.new_record?? "Post" : "Update"}",
        :class => "comment-post", :type => "button",
        :disabled => !@user 
 button_tag "Preview", :class => "comment-preview",
        :type => "button", :disabled => !@user 
 if comment.persisted? || comment.parent_comment_id 
 button_tag "Cancel", :class => "comment-cancel",
          :type => "button" 
 end 
 if @user && @user.hats.any? 
 select_tag "hat_id",
          options_from_collection_for_select(@user.hats, "id", "hat",
          comment.hat_id), :include_blank => true 
 end 
 if @user 
 render :partial => "global/markdownhelp" 
 end 
 end 
 if defined?(show_comment) && show_comment.valid? 
 render "comments/comment", :comment => show_comment 
 end 

end
  end

  def find_comment
    comment = Comment.where(:short_id => params[:id]).first
    if @user && comment
      comment.current_vote = Vote.where(:user_id => @user.id,
        :story_id => comment.story_id, :comment_id => comment.id).first
    end

    comment
  end
end

class UsersController < ApplicationController
  before_filter :require_logged_in_moderator, :only => [ :ban, :unban ]

  def show
    @showing_user = User.where(:username => params[:username]).first!
    @title = "User #{@showing_user.username}"

    respond_to do |format|
      format.html {  if !@showing_user.is_active? 
 elsif @showing_user.is_new? 
 else 
 end 
 @showing_user.username 
 if @user && @showing_user.is_active? 
 @showing_user.username 
 end 
 if @showing_user.is_active? 
 @showing_user.avatar_url 
 end 
 @showing_user.is_banned? ? raw("style=\"color: red;\"") : "" 
 if @showing_user.is_banned? 
 elsif !@showing_user.is_active? 
 else 
 end 
 @showing_user.is_admin? ? "administrator" :
      (@showing_user.is_moderator? ? "moderator" : "user") 
 time_ago_in_words_label(@showing_user.created_at) 
 if @showing_user.invited_by_user 
 link_to @showing_user.invited_by_user.try(:username),
        @showing_user.invited_by_user 
 end 
 if @showing_user.is_banned? 
 time_ago_in_words_label(@showing_user.banned_at) 
 if @showing_user.banned_by_user 
 link_to @showing_user.banned_by_user.try(:username),
          @showing_user.banned_by_user 
 @showing_user.banned_reason 
 end 
 end 
 if @showing_user.hats.any? 
 @showing_user.hats.each do |hat| 
 hat.to_html_label 
 end 
 end 
 if @showing_user.deleted_at? 
 time_ago_in_words_label(@showing_user.deleted_at) 
 end 
 if !@showing_user.is_admin? 
 @showing_user.karma 

        number_with_precision(@showing_user.average_karma, :precision => 2) 
 end 
 tag = @showing_user.most_common_story_tag 
 @showing_user.username 

      @showing_user.stories_submitted_count 
 tag ? ", " : "" 
 if tag 
 tag_path(tag.tag) 
 tag.css_class 
 tag.description 

        tag.tag 
 end 
 @showing_user.username 

      @showing_user.comments_posted_count 
 if @showing_user.is_active? 
 if @showing_user.about.present? 
 raw @showing_user.linkified_about 
 else 
 end 
 end 
 if @user && @user.is_admin? && !@showing_user.is_moderator? 
 @showing_user.email 
 @showing_user.votes_for_others.limit(10).each do |v| 
 if v.vote == 1 
 else 
 v.vote 
 if v.comment_id 
 Vote::COMMENT_REASONS[v.reason] 
 else 
 Vote::STORY_REASONS[v.reason] 
 end 
 end 
 if v.comment_id 
 v.comment.short_id_url 
 v.comment.user.try(:username) 
 
            v.comment.user.try(:username) 
 v.story.short_id_url 
 v.story.title 
 elsif v.story_id && !v.comment_id 
 v.story.short_id_url 
 v.story.title 
 v.story.user.try(:username) 

            v.story.user.try(:username) 
 end 
 end 
 if @user.is_banned? 
 form_tag user_unban_path, :method => :post do 
 submit_tag "Unban User" 
 end 
 else 
 form_tag user_ban_path, :method => :post do 
 label_tag :reason, "Reason:", :class => "required" 
 text_field_tag :reason, "", :size => 40 
 submit_tag "Ban User" 
 end 
 end 
 end 
 }
      format.json { render :json => @showing_user }
    end
  end

  def tree
    @title = "Users"

    if params[:by].to_s == "karma"
      @users = User.order("karma DESC, id ASC").to_a
      @user_count = @users.length
      @title << " By Karma"
       @title 
 @user_count 
 @users.each do |user| 
 user.username 
 if !user.is_active? 
 elsif user.is_new? 
 end 
 user.username 
 if user.is_admin? 
 else 
 user.karma 
 if user.is_moderator? 
 end 
 end 
 end 

    elsif params[:moderators]
      @users = User.where("is_admin = 1 OR is_moderator = 1").
        order("id ASC").to_a
      @user_count = @users.length
      @title = "Moderators and Administrators"
       @title 
 @user_count 
 @users.each do |user| 
 user.username 
 if !user.is_active? 
 elsif user.is_new? 
 end 
 user.username 
 if user.is_admin? 
 else 
 user.karma 
 if user.is_moderator? 
 end 
 end 
 end 

    else
      users = User.order("id DESC").to_a
      @user_count = users.length
      @users_by_parent = users.group_by(&:invited_by_user_id)
      @newest = User.order("id DESC").limit(10)
    end
  end

  def invite
    @title = "Pass Along an Invitation"
  end

  def ban
    buser = User.where(:username => params[:username]).first
    if !buser
      flash[:error] = "Invalid user."
      return redirect_to "/"
    end

    if !params[:reason].present?
      flash[:error] = "You must give a reason for the ban."
      return redirect_to user_path(:user => buser.username)
    end

    buser.ban_by_user_for_reason!(@user, params[:reason])

    flash[:success] = "User has been banned."
    return redirect_to user_path(:user => buser.username)
  end

  def unban
    buser = User.where(:username => params[:username]).first
    if !buser
      flash[:error] = "Invalid user."
      return redirect_to "/"
    end

    buser.unban_by_user!(@user)

    flash[:success] = "User has been unbanned."
    return redirect_to user_path(:user => buser.username)
  end
end

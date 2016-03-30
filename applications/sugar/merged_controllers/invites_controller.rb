# encoding: utf-8

class InvitesController < ApplicationController
  requires_authentication except: [:accept]
  requires_user except: [:accept]
  requires_user_admin only: [:all]

  respond_to :html, :mobile, :xml, :json

  before_action :find_invite, only: [:show, :edit, :update, :destroy]
  before_action :verify_available_invites, only: [:new, :create]

  def index
    respond_with(@invites = current_user.invites.active)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 [@page_title,Sugar.config.forum_name].compact.join(' - ') 
 stylesheet_link_tag "application" 
 if current_user? && current_user.mobile_stylesheet_url? 
 stylesheet_link_tag current_user.mobile_stylesheet_url 
 else 
 stylesheet_link_tag @theme.mobile_stylesheet_path 
 end 
 icon_tags 
 csrf_meta_tag 
 link_to "", "#", class: (current_user? && current_user.unread_conversations? ? 'new toggle-navigation' : 'toggle-navigation') 
 if @page_title 
 link_to "#{Sugar.config.forum_short_name}:", discussions_path 
 @page_title 
 else 
 link_to "#{Sugar.config.forum_short_name}", discussions_path 
 end 
 if current_user? || Sugar.public_browsing? 
 link_to "Discussions", discussions_path 
 if current_user? 
 link_to "Popular", popular_discussions_path 
 link_to "Following", following_discussions_path 
 link_to "Favorites", favorites_discussions_path 
 if current_user.unread_conversations? 
 link_to "Conversations", conversations_path 
 else 
 link_to "Conversations", conversations_path 
 end 
 end 
 link_to "Users", users_path 
 if current_user? 
 link_to "New discussion", new_discussion_path 
 if @exchange && !@exchange.new_record? && @exchange.editable_by?(current_user) 
 link_to "Edit discussion", edit_discussion_path(@exchange) 
 end 
 link_to "Log out", logout_users_path, confirm: "Are you sure you want to log out?" 
 end 
 form_tag((@search_path || search_path), method: 'get') do 
 text_field_tag 'q', @search_query, class: :query 
 select_tag 'search_mode', options_for_select(
            search_mode_options,
            @search_path || search_path
          ) 
 submit_tag "Go", name: nil 
 end 
 end 
 if flash[:notice] 
 raw flash[:notice] 
 end 
 
  add_body_class "invites"
  @page_title = "Invites"

 link_to "Invites", invites_path 
 if current_user.available_invites? 
 if current_user.user_admin? 
 link_to "invite as many people as you like", new_invite_path 
 link_to "Click here to view everyone's invites", all_invites_path 
 elsif current_user.available_invites? 
 if current_user.available_invites == 1 
 link_to "click here to use it", new_invite_path 
 else 
 current_user.available_invites 
 link_to "click here to invite someone", new_invite_path 
 end 
 end 
 else 
 if current_user.invites? 
 end 
 end 
 if @invites && @invites.length > 0 
 @invites.each do |invite| 
 invite.email 
 time_tag invite.created_at, class: 'relative' 
 invite.expires_at.strftime("%b %d, %Y") 
 link_to "Cancel", invite_path(invite), class: :delete, method: :delete, confirm: 'Are you sure that you want to cancel this invite?' 
 end 
 end 
 link_to "Discussions", discussions_path 
 if current_user? 
 link_to "Following", following_discussions_path 
 link_to "Favorites", favorites_discussions_path 
 end 
 link_to "Regular site", {mobile_format: 'html'}, class: 'regular_site' 
 javascript_include_tag "mobile" 
 frontend_configuration.to_json.html_safe 
 if @posts && @posts.any? 
 end 
 if Sugar.config.google_analytics 
 Sugar.config.google_analytics 
 end 

end

  end

  def all
    respond_with(@invites = Invite.active)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 [@page_title,Sugar.config.forum_name].compact.join(' - ') 
 stylesheet_link_tag "application" 
 if current_user? && current_user.mobile_stylesheet_url? 
 stylesheet_link_tag current_user.mobile_stylesheet_url 
 else 
 stylesheet_link_tag @theme.mobile_stylesheet_path 
 end 
 icon_tags 
 csrf_meta_tag 
 link_to "", "#", class: (current_user? && current_user.unread_conversations? ? 'new toggle-navigation' : 'toggle-navigation') 
 if @page_title 
 link_to "#{Sugar.config.forum_short_name}:", discussions_path 
 @page_title 
 else 
 link_to "#{Sugar.config.forum_short_name}", discussions_path 
 end 
 if current_user? || Sugar.public_browsing? 
 link_to "Discussions", discussions_path 
 if current_user? 
 link_to "Popular", popular_discussions_path 
 link_to "Following", following_discussions_path 
 link_to "Favorites", favorites_discussions_path 
 if current_user.unread_conversations? 
 link_to "Conversations", conversations_path 
 else 
 link_to "Conversations", conversations_path 
 end 
 end 
 link_to "Users", users_path 
 if current_user? 
 link_to "New discussion", new_discussion_path 
 if @exchange && !@exchange.new_record? && @exchange.editable_by?(current_user) 
 link_to "Edit discussion", edit_discussion_path(@exchange) 
 end 
 link_to "Log out", logout_users_path, confirm: "Are you sure you want to log out?" 
 end 
 form_tag((@search_path || search_path), method: 'get') do 
 text_field_tag 'q', @search_query, class: :query 
 select_tag 'search_mode', options_for_select(
            search_mode_options,
            @search_path || search_path
          ) 
 submit_tag "Go", name: nil 
 end 
 end 
 if flash[:notice] 
 raw flash[:notice] 
 end 
 
  add_body_class "invites"
  @page_title = "Invites"

 link_to "Invites", invites_path 
 link_to "All", all_invites_path 
 if @invites && @invites.length > 0 
 @invites.each do |invite| 
 invite.email 
 profile_link(invite.user) 
 time_tag invite.created_at, class: 'relative' 
 invite.expires_at.strftime("%b %d, %Y") 
 link_to "Cancel", invite_path(invite), class: :delete, method: :delete, confirm: 'Are you sure that you want to cancel this invite?' 
 end 
 else 
 end 
 link_to "Discussions", discussions_path 
 if current_user? 
 link_to "Following", following_discussions_path 
 link_to "Favorites", favorites_discussions_path 
 end 
 link_to "Regular site", {mobile_format: 'html'}, class: 'regular_site' 
 javascript_include_tag "mobile" 
 frontend_configuration.to_json.html_safe 
 if @posts && @posts.any? 
 end 
 if Sugar.config.google_analytics 
 Sugar.config.google_analytics 
 end 

end

  end

  def accept
    @invite = Invite.find_by_token(params[:id])
    session[:invite_token] = nil
    if @invite && @invite.expired?
      @invite.destroy
      flash[:notice] ||= "Your invite has expired!"
    elsif @invite
      session[:invite_token] = @invite.token
      redirect_to new_user_by_token_url(token: @invite.token)
      return
    else
      flash[:notice] ||= "That's not a valid invite!"
    end
    redirect_to login_users_url
  end

  def new
    respond_with(@invite = current_user.invites.new)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 [@page_title,Sugar.config.forum_name].compact.join(' - ') 
 stylesheet_link_tag "application" 
 if current_user? && current_user.mobile_stylesheet_url? 
 stylesheet_link_tag current_user.mobile_stylesheet_url 
 else 
 stylesheet_link_tag @theme.mobile_stylesheet_path 
 end 
 icon_tags 
 csrf_meta_tag 
 link_to "", "#", class: (current_user? && current_user.unread_conversations? ? 'new toggle-navigation' : 'toggle-navigation') 
 if @page_title 
 link_to "#{Sugar.config.forum_short_name}:", discussions_path 
 @page_title 
 else 
 link_to "#{Sugar.config.forum_short_name}", discussions_path 
 end 
 if current_user? || Sugar.public_browsing? 
 link_to "Discussions", discussions_path 
 if current_user? 
 link_to "Popular", popular_discussions_path 
 link_to "Following", following_discussions_path 
 link_to "Favorites", favorites_discussions_path 
 if current_user.unread_conversations? 
 link_to "Conversations", conversations_path 
 else 
 link_to "Conversations", conversations_path 
 end 
 end 
 link_to "Users", users_path 
 if current_user? 
 link_to "New discussion", new_discussion_path 
 if @exchange && !@exchange.new_record? && @exchange.editable_by?(current_user) 
 link_to "Edit discussion", edit_discussion_path(@exchange) 
 end 
 link_to "Log out", logout_users_path, confirm: "Are you sure you want to log out?" 
 end 
 form_tag((@search_path || search_path), method: 'get') do 
 text_field_tag 'q', @search_query, class: :query 
 select_tag 'search_mode', options_for_select(
            search_mode_options,
            @search_path || search_path
          ) 
 submit_tag "Go", name: nil 
 end 
 end 
 if flash[:notice] 
 raw flash[:notice] 
 end 
 
  add_body_class "new_invite"
  @page_title = t('invite.new_invite')

 link_to t('invites.invites'), invites_path 
 link_to t('new'), new_invite_path 
 form_for @invite, builder: Sugar::FormBuilder do |f| 
 f.labelled_text_field :email, size: 60 
 f.labelled_text_area :message, cols: 60, rows: 10, description: t('invite.message_description') 
 t('invite.send_invite') 
 end 
 link_to "Discussions", discussions_path 
 if current_user? 
 link_to "Following", following_discussions_path 
 link_to "Favorites", favorites_discussions_path 
 end 
 link_to "Regular site", {mobile_format: 'html'}, class: 'regular_site' 
 javascript_include_tag "mobile" 
 frontend_configuration.to_json.html_safe 
 if @posts && @posts.any? 
 end 
 if Sugar.config.google_analytics 
 Sugar.config.google_analytics 
 end 

end

  end

  def create
    @invite = current_user.invites.create(invite_params)
    if @invite.valid?
      begin
        Mailer.invite(@invite, accept_invite_url(id: @invite.token)).deliver_now
        flash[:notice] = "Your invite has been sent to #{@invite.email}"
      rescue Net::SMTPFatalError, Net::SMTPSyntaxError
        flash[:notice] = "There was a problem sending your invite to " +
          "#{@invite.email}, it has been cancelled."
        @invite.destroy
      end
      redirect_to invites_url
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 [@page_title,Sugar.config.forum_name].compact.join(' - ') 
 stylesheet_link_tag "application" 
 if current_user? && current_user.mobile_stylesheet_url? 
 stylesheet_link_tag current_user.mobile_stylesheet_url 
 else 
 stylesheet_link_tag @theme.mobile_stylesheet_path 
 end 
 icon_tags 
 csrf_meta_tag 
 link_to "", "#", class: (current_user? && current_user.unread_conversations? ? 'new toggle-navigation' : 'toggle-navigation') 
 if @page_title 
 link_to "#{Sugar.config.forum_short_name}:", discussions_path 
 @page_title 
 else 
 link_to "#{Sugar.config.forum_short_name}", discussions_path 
 end 
 if current_user? || Sugar.public_browsing? 
 link_to "Discussions", discussions_path 
 if current_user? 
 link_to "Popular", popular_discussions_path 
 link_to "Following", following_discussions_path 
 link_to "Favorites", favorites_discussions_path 
 if current_user.unread_conversations? 
 link_to "Conversations", conversations_path 
 else 
 link_to "Conversations", conversations_path 
 end 
 end 
 link_to "Users", users_path 
 if current_user? 
 link_to "New discussion", new_discussion_path 
 if @exchange && !@exchange.new_record? && @exchange.editable_by?(current_user) 
 link_to "Edit discussion", edit_discussion_path(@exchange) 
 end 
 link_to "Log out", logout_users_path, confirm: "Are you sure you want to log out?" 
 end 
 form_tag((@search_path || search_path), method: 'get') do 
 text_field_tag 'q', @search_query, class: :query 
 select_tag 'search_mode', options_for_select(
            search_mode_options,
            @search_path || search_path
          ) 
 submit_tag "Go", name: nil 
 end 
 end 
 if flash[:notice] 
 raw flash[:notice] 
 end 
 
  add_body_class "new_invite"
  @page_title = t('invite.new_invite')

 link_to t('invites.invites'), invites_path 
 link_to t('new'), new_invite_path 
 form_for @invite, builder: Sugar::FormBuilder do |f| 
 f.labelled_text_field :email, size: 60 
 f.labelled_text_area :message, cols: 60, rows: 10, description: t('invite.message_description') 
 t('invite.send_invite') 
 end 
 link_to "Discussions", discussions_path 
 if current_user? 
 link_to "Following", following_discussions_path 
 link_to "Favorites", favorites_discussions_path 
 end 
 link_to "Regular site", {mobile_format: 'html'}, class: 'regular_site' 
 javascript_include_tag "mobile" 
 frontend_configuration.to_json.html_safe 
 if @posts && @posts.any? 
 end 
 if Sugar.config.google_analytics 
 Sugar.config.google_analytics 
 end 

end

    end
  end

  def destroy
    if verify_user(user: @invite.user, user_admin: true)
      @invite.destroy
      flash[:notice] = "Your invite has been cancelled."
      redirect_to invites_url
    end
  end

  private

  def invite_params
    params.require(:invite).permit(:email, :message)
  end

  # Finds the requested invite
  def find_invite
    @invite = Invite.find(params[:id])
  end

  def verify_available_invites
    unless current_user? && current_user.available_invites?
      respond_to do |format|
        format.any(:html, :mobile) do
          flash[:notice] = "You don't have any invites!"
          redirect_to online_users_url
        end
        format.any(:xml, :json) do
          render(
            text: "You don't have any invites!",
            status: :method_not_allowed
          )
        end
      end
    end
  end
end

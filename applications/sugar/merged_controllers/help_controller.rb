# encoding: utf-8

class HelpController < ApplicationController
  def index
    redirect_to help_page_path("keyboard")
  end

  def show
    case params[:page]
    when "keyboard"
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
 
  @page_title = 'Keyboard shortcuts'

 link_to 'Help', help_path 
 link_to @page_title, help_page_path(@page) 
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
end

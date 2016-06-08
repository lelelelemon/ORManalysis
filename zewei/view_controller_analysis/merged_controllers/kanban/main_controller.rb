class MainController < ApplicationController

  def index
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 favicon_link_tag "/favicon.ico" 
 stylesheet_link_tag "application", media: "all" 
 javascript_include_tag "application" 
 csrf_meta_tags 
 if logged_in? 
 link_to image_tag(current_user.gravatar_url(30), class: "avatar"), "#" 
 link_to "logout", logout_url 
 else 
 link_to "login", login_url 
 end 

end
end
end

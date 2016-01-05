require "fileutils"

ApplicationController.allow_forgery_protection = false
app.post('/login', {:email => "test", :password => "test"})

urls = [
"/s/z7cdwv", #stories#show
"/rss",
"/hottest", 
"/page/1",
"/newest",
"/newest/page/1",
"/newest/1",
"/newest/1/page/1",
"/recent",
"/recent/page/1",
"/hidden",
"/hidden/page/1",
"/upvoted(.format)",
"/upvoted/page/1",
"/top",
"/top/page/1",
"/top/1",
"/top/1/page/1",
=begin
    get "/threads" => "comments#threads"
    get "/threads/:user" => "comments#threads"

    get "/login" => "login#index"
    post "/login" => "login#login"
    post "/logout" => "login#logout"

    get "/signup" => "signup#index"
    post "/signup" => "signup#signup"
    get "/signup/invite" => "signup#invite"

    get "/login/forgot_password" => "login#forgot_password",
      :as => "forgot_password"
    post "/login/reset_password" => "login#reset_password",
      :as => "reset_password"
    match "/login/set_new_password" => "login#set_new_password",
      :as => "set_new_password", :via => [:get, :post]

    get "/t/:tag" => "home#tagged", :as => "tag", :format => /html|rss|json/
    get "/t/:tag/page/:page" => "home#tagged"

    get "/search" => "search#index"
    get "/search/:q" => "search#index"
=end
"/stories/new",
"/stories/z7cdwv",
"/stories/z7cdwv/suggest",
=begin
    resources :stories do
      post "upvote"
      post "downvote"
      post "unvote"
      post "undelete"
      post "hide"
      post "unhide"
      get "suggest"
      post "suggest", :action => "submit_suggestions"
    end
    post "/stories/fetch_url_attributes", :format => "json"
    post "/stories/preview" => "stories#preview"
=end
"/comments/hmjnmu",
#"/comments/hmjnmu/reply",
=begin
    resources :comments do
      member do
        get "reply"
        post "upvote"
        post "downvote"
        post "unvote"

        post "delete"
        post "undelete"
      end
    end
    get "/comments/page/:page" => "comments#index"
    get "/comments" => "comments#index", :format => /html|rss/
=end
"/messages/sent",
=begin
    post "/messages/batch_delete" => "messages#batch_delete",
      :as => "batch_delete_messages"
    resources :messages do
      post "keep_as_new"
    end

    get "/s/:id/:title/comments/:comment_short_id" => "stories#show"
    get "/s/:id/(:title)" => "stories#show", :format => /html|json/

    get "/c/:id" => "comments#redirect_from_short_id"
    get "/c/:id.json" => "comments#show_short_id", :format => "json"

    get "/u" => "users#tree"
    get "/u/:username" => "users#show", :as => "user", :format => /html|json/

    post "/users/:username/ban" => "users#ban", :as => "user_ban"
    post "/users/:username/unban" => "users#unban", :as => "user_unban"

    get "/settings" => "settings#index"
    post "/settings" => "settings#update"
    post "/settings/pushover" => "settings#pushover"
    get "/settings/pushover_callback" => "settings#pushover_callback"
    post "/settings/delete_account" => "settings#delete_account",
      :as => "delete_account"

    get "/filters" => "filters#index"
    post "/filters" => "filters#update"

    get "/tags" => "tags#index"
    get "/tags.json" => "tags#index", :format => "json"

    post "/invitations" => "invitations#create"
=end
"/invitations",
"/invitations/request",
=begin
    post "/invitations/create_by_request" => "invitations#create_by_request",
      :as => "create_invitation_by_request"
    get "/invitations/confirm/:code" => "invitations#confirm_email"
    post "/invitations/send_for_request" => "invitations#send_for_request",
      :as => "send_invitation_for_request"
    get "/invitations/:invitation_code" => "signup#invited"
    post "/invitations/delete_request" => "invitations#delete_request",
      :as => "delete_invitation_request"

    get "/moderations" => "moderations#index"
    get "/moderations/page/:page" => "moderations#index"

    get "/privacy" => "home#privacy"
    get "/about" => "home#about"
    get "/chat" => "home#chat"
=end
]

targetdir = Dir.pwd + "/target"

urls.each do |url|	
	begin
		puts url
		app.get url
		dirname = File.dirname(url)
		unless File.directory?(targetdir + dirname)
			FileUtils.mkdir_p(targetdir + dirname)
		end
	#	$stdout = File.new(targetdir + url, "w")
	#	$stdout.sync = true

		target = open(targetdir + url + ".rb", "w")
		target.write(app.response.body)
		target.close()
	rescue
	end
end


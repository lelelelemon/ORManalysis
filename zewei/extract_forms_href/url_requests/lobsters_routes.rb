require "fileutils"

ApplicationController.allow_forgery_protection = false
app.post('/login', {:email => "test", :password => "test"})

urls = [
["get", "/s/z7cdwv", {}], #stories#show
["get", "/rss", {}],
["get", "/hottest", {}], 
["get", "/page/1", {}],
["get", "/newest", {}],
["get", "/newest/page/1", {}],
["get", "/newest/1", {}],
["get", "/newest/1/page/1", {}],
["get", "/recent", {}],
["get", "/recent/page/1", {}],
["get", "/hidden", {}],
["get", "/hidden/page/1", {}],
["get", "/upvoted(.format)", {}],
["get", "/upvoted/page/1", {}],
["get", "/top", {}],
["get", "/top/page/1", {}],
["get", "/top/1", {}],
["get", "/top/1/page/1", {}],
["get", "/threads", {}],
["get", "/threads/1", {}],
#["get", "/login", {}],
["post", "/login", {:email => "test", :password => "test"}],
["post", "/logout", {}],
["get", "/signup", {}],
["get", "/signup", {}],
["get", "/signup/invite", {}],
["get", "/login/forgot_password", {}],
=begin
      :as => "forgot_password"
    post "/login/reset_password" => "login#reset_password",
      :as => "reset_password"
    match "/login/set_new_password" => "login#set_new_password",
      :as => "set_new_password", :via => [:get, :post]
=end

["get", "/t/test", {}],
["get", "/t/test/page/1", {}],
["get", "/search", {}],
["get", "/search/aaa", {}],
["get", "/stories/new", {}],
["get", "/stories/z7cdwv", {}],
["get", "/stories/z7cdwv/suggest", {}],
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
["get", "/comments/hmjnmu", {}],
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
["get", "/messages/sent", {}],
["post", "/messages/batch_delete", {}],
=begin
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
["get", "/invitations", {}],
["get", "/invitations/request", {}],
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

urls.each do |(method, url, params)|	
		puts url
		
		if method == "get"
			app.get url, params
		elsif method == "post"
			app.post url, params
		end
		dirname = File.dirname(url)
		unless File.directory?(targetdir + dirname)
			FileUtils.mkdir_p(targetdir + dirname)
		end
	#	$stdout = File.new(targetdir + url, "w")
	#	$stdout.sync = true

		target_file = targetdir + url + ".html"
		ActiveRecord::Base.logger = Logger.new(target_file + ".sql")

		target = open(target_file, "w")
		target.write(app.response.body)
		target.close()
end


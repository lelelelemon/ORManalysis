Lobsters::Application.routes.draw do
	
		get "comments#reply"
		get "comments#upvote"
		get "comments#downvote"
		get "comments#unvote"
		get "comments#delete"
		get "comments#undelete"

    get "/comments/page/:page" => "comments#index"

		get "messages#create"
		get "messages#index"
		

end

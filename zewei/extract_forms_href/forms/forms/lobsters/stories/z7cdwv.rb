route = Rails.application.routes
route.recognize_path "/comments", {:method => "post"}
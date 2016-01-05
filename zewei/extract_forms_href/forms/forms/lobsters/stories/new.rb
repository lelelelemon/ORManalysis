route = Rails.application.routes
route.recognize_path "/stories", {:method => "post"}
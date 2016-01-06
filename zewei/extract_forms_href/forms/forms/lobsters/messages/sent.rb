route = Rails.application.routes
route.recognize_path "/messages", {:method => "post"}
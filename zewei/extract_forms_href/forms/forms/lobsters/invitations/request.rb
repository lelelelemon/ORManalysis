route = Rails.application.routes
route.recognize_path /invitations/create_by_request, {:method => post}
named_routes = Rails.application.routes.named_routes

named_routes.each do |name, route|
	puts name, route.defaults
end

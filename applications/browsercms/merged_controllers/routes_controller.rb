class RoutesController < BaseController
  
  
  def index

    unless params[:path].blank?
      @path = params[:path]
      @route = Rails.application.routes.recognize_path(@path)
    end
    
    @routes = Rails.application.routes.routes.collect do |route|
      name = route.name.to_s
      verb = route.verb
      segs = route.path.spec
      reqs = route.requirements.empty? ? "" : route.requirements.inspect
      {:name => name, :verb => verb, :segs => segs, :reqs => reqs}
    end
    
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Rails Routes" 
 render layout: 'page_title' do 
 link_to "Page Routes", page_routes_path, class: 'btn btn-primary right' 
 end 
 form_tag routes_path, :method => :get do 
 text_field_tag :path, @path, :size => 50 
 unless @route.blank? 
h @route.inspect 
 end 
 end 
 render layout: 'main_content' do 
 for route in @routes 
h route[:name] 
h route[:verb] 
h route[:segs] 
h route[:reqs] 
 end 
 end 

end

  end
end
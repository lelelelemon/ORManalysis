  class PageRoutesController < BaseController

    before_filter :load_page_route, :only => [:edit, :update, :destroy]

    def index
      @page_routes = PageRoute.paginate(:page => params[:page]).order("name")
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Page Routes" 
 render layout: 'page_title' do 
 button_menu :top do 
 link_to("View Rails Routes", routes_path, :class => "btn btn-primary btn-small") 
 link_to "Add", new_page_route_path, class: 'btn btn-primary btn-small right' 
 end 
 end 
 render layout: 'main_content' do 
 @page_routes.each do |page_route| 
 page_route.name 
 page_route.pattern 
 link_to "Edit", edit_polymorphic_path(page_route), class: "btn btn-mini" 
 link_to "Delete", polymorphic_path(page_route), class: "btn btn-mini btn-danger", method: 'delete',  data:{confirm: 'Are you sure you want to delete this route?'} 
 end 
 end 
 if @page_routes.total_pages > 1 
 render_pagination @page_routes, PageRoute 
 end 

end

    end

    def new
      @page_route = PageRoute.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Add a New Page Route" 
  content_for :buttons, 'save_buttons' 
 simple_form_for(@page_route) do |f| 
 render layout: 'form_with_buttons', locals: {f: f} do 
 f.association :page,
                          collection: Page.order(:path),
                          include_blank: false,
                          label_method: lambda { |p| "#{p.path} (#{p.name})" } 
 f.input :name 
 f.input :pattern 
 f.input :code, as: :text, input_html: {style: "height: 200px"} 
 end 
 end 
 

end

    end

    def create
      @page_route = PageRoute.new(page_route_params)
      if @page_route.save
        flash[:notice] = "Page Route Created"
        redirect_to page_routes_path
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Add a New Page Route" 
  content_for :buttons, 'save_buttons' 
 simple_form_for(@page_route) do |f| 
 render layout: 'form_with_buttons', locals: {f: f} do 
 f.association :page,
                          collection: Page.order(:path),
                          include_blank: false,
                          label_method: lambda { |p| "#{p.path} (#{p.name})" } 
 f.input :name 
 f.input :pattern 
 f.input :code, as: :text, input_html: {style: "height: 200px"} 
 end 
 end 
 

end

      end
    end

    def update
      if @page_route.update(page_route_params)
        flash[:notice] = "Page Route Updated"
        redirect_to page_routes_path
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Add a New Page Route" 
  content_for :buttons, 'save_buttons' 
 simple_form_for(@page_route) do |f| 
 render layout: 'form_with_buttons', locals: {f: f} do 
 f.association :page,
                          collection: Page.order(:path),
                          include_blank: false,
                          label_method: lambda { |p| "#{p.path} (#{p.name})" } 
 f.input :name 
 f.input :pattern 
 f.input :code, as: :text, input_html: {style: "height: 200px"} 
 end 
 end 
 

end

      end

    end

    def destroy
      @page_route.destroy
      flash[:notice] = "Page Route Deleted"
      redirect_to page_routes_url
    end

    protected
    def load_page_route
      @page_route = PageRoute.find(params[:id])
    end

    private
    def page_route_params
      params.require(:page_route).permit(PageRoute.permitted_params)
    end

  end

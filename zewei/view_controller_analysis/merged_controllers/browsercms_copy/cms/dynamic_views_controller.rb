module Cms
  class DynamicViewsController < Cms::BaseController

    include Cms::AdminTab
    check_permissions :administrate

    before_filter :load_view, :only => [:show, :edit, :update, :destroy]

    helper_method :dynamic_view_type

    def index
      @views = dynamic_view_type.paginate(:page => params[:page]).order("name")
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "#{dynamic_view_type.name.demodulize.titleize.pluralize}" 
 render layout: 'page_title' do 
 link_to "Add", new_engine_aware_path(dynamic_view_type), class: 'btn btn-primary btn-small right' 
 end 
 render layout: 'main_content' do 
 @views.each do |view| 
 view.display_name 
 view.path 
 view.updated_at && view.updated_at.to_s(:date) 
 link_to "Edit", edit_polymorphic_path(view), class: "btn btn-mini" 
 link_to "Delete", polymorphic_path(view), class: "btn btn-mini btn-danger", method: 'delete',  data: {confirm: 'Are you sure you want to delete this view?'} 
 end 
 end 
 if @views.size == 0 && params[:key_word]
 params[:key_word] 
 elsif @views.total_pages > 1 
 render_pagination @views, dynamic_view_type 
 end 

end

    end

    def new
      @view = dynamic_view_type.new_with_defaults
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "New #{dynamic_view_type.title}" 
  content_for :buttons, 'save_buttons'  
 simple_form_for(@view) do |f| 
 render layout: 'form_with_buttons', locals: {f: f} do 
 f.input :name, hint: @view.hint, placeholder: @view.placeholder 
 f.input :format 
 f.input :handler, collection: ActionView::Template.template_handler_extensions, default: "erb" 
 f.input :body, as: :text, input_html: {:style => "height: 500px", :cols => 80} 
 end 
 end 
 

end

    end

    def create
      @view = dynamic_view_type.new(dynamic_view_params)
      if @view.save
        flash[:notice] = "#{dynamic_view_type} '#{@view.name}' was created"
        redirect_to engine_aware_path(dynamic_view_type)
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "New #{dynamic_view_type.title}" 
  content_for :buttons, 'save_buttons'  
 simple_form_for(@view) do |f| 
 render layout: 'form_with_buttons', locals: {f: f} do 
 f.input :name, hint: @view.hint, placeholder: @view.placeholder 
 f.input :format 
 f.input :handler, collection: ActionView::Template.template_handler_extensions, default: "erb" 
 f.input :body, as: :text, input_html: {:style => "height: 500px", :cols => 80} 
 end 
 end 
 

end

      end
    end

    def show
      redirect_to [:edit, @view]
    end

    def update
      if @view.update(dynamic_view_params)
        flash[:notice] = "#{dynamic_view_type} '#{@view.name}' was updated"
        redirect_to engine_aware_path(dynamic_view_type)
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Edit '#{@view.name}' #{dynamic_view_type.title}" 
  content_for :buttons, 'save_buttons'  
 simple_form_for(@view) do |f| 
 render layout: 'form_with_buttons', locals: {f: f} do 
 f.input :name, hint: @view.hint, placeholder: @view.placeholder 
 f.input :format 
 f.input :handler, collection: ActionView::Template.template_handler_extensions, default: "erb" 
 f.input :body, as: :text, input_html: {:style => "height: 500px", :cols => 80} 
 end 
 end 
 

end

      end
    end

    def destroy
      @view.destroy
      flash[:notice] = "#{dynamic_view_type} '#{@view.name}' was deleted"
      redirect_to engine_aware_path(dynamic_view_type)
    end

    protected

    def dynamic_view_params
      params.require(view_param_name).permit(dynamic_view_type.permitted_params)
    end

    def view_param_name
      dynamic_view_type.model_name.param_key
    end

    def dynamic_view_type
      @dynamic_view_type ||= begin
        url = request.path.sub(/\?.*/, '')
        type_name = url.split('/')[2].classify
        begin
          type = "Cms::#{type_name}".constantize
        rescue NameError
          type = type_name.constantize rescue nil
        end
        raise "Invalid Type" unless type.ancestors.include?(DynamicView)
        type
      end
    end

    def set_menu_section
      @menu_section = dynamic_view_type.name.underscore.pluralize
    end

    def load_view
      @view = dynamic_view_type.find(params[:id])
    end

  end
end

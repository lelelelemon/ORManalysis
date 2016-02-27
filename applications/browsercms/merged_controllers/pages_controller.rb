  class PagesController < BaseController

    helper RenderingHelper

    before_filter :load_section, :only => [:new, :create]
    before_filter :load_page, :only => [:versions, :version, :revert_to, :destroy]
    before_filter :load_draft_page, :only => [:edit, :update]
    before_filter :hide_toolbar, :only => [:new, :create]
    before_action :strip_visibility_params, :only => [:create, :update]

    include PublishWorkflow

    def resource
      @page
    end

    def resource_param
      :page
    end

    def new
      @page = Page.new(:section => @section, :cacheable => true)
      if @section.child_nodes.count < 1
        @page.name = "Overview"
        @page.path = @section.path
      end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :html_head do 
 @page.section.name.to_json.html_safe 
 @page.section.path.to_json.html_safe 
 end 
 use_page_title "Add A New Page" 
  simple_form_for(@page) do |f| 
 page_title_with_buttons f 
 render layout: 'main_with_sidebar' do 
 hidden_field_tag :section_id, @page.section_id 
 render :partial => 'main_form', :locals => {:f => f} 
 content_for :sidebar do 
 draft_icon_tag(@block, force: true) 
 if current_user.able_to?(:publish_content) 
 f.input :visibility, label: false, collection: @page.visibilities, prompt: false, input_html: {class: 'input-block-level'} 
 end 
 f.input :cacheable, label: "Allow Caching?", hint: "Uncheck to allow for personalized content." 
 end 
 end 
 bottom_buttons f 
 end 
 

end

    end

    def show
      redirect_to Page.find(params[:id]).path
    end

    def create
      @page = Page.new(page_params)
      @page.section = @section
      if @page.save
        flash[:notice] = "Page was '#{@page.name}' created."
        redirect_to @page
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :html_head do 
 @page.section.name.to_json.html_safe 
 @page.section.path.to_json.html_safe 
 end 
 use_page_title "Add A New Page" 
  simple_form_for(@page) do |f| 
 page_title_with_buttons f 
 render layout: 'main_with_sidebar' do 
 hidden_field_tag :section_id, @page.section_id 
 render :partial => 'main_form', :locals => {:f => f} 
 content_for :sidebar do 
 draft_icon_tag(@block, force: true) 
 if current_user.able_to?(:publish_content) 
 f.input :visibility, label: false, collection: @page.visibilities, prompt: false, input_html: {class: 'input-block-level'} 
 end 
 f.input :cacheable, label: "Allow Caching?", hint: "Uncheck to allow for personalized content." 
 end 
 end 
 bottom_buttons f 
 end 
 

end

      end
    end

    def update
      if @page.update(page_params)
        flash[:notice] = "Page was '#{@page.name}' updated."
        redirect_to @page
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Configure Page" 
  simple_form_for(@page) do |f| 
 page_title_with_buttons f 
 render layout: 'main_with_sidebar' do 
 hidden_field_tag :section_id, @page.section_id 
 render :partial => 'main_form', :locals => {:f => f} 
 content_for :sidebar do 
 draft_icon_tag(@block, force: true) 
 if current_user.able_to?(:publish_content) 
 f.input :visibility, label: false, collection: @page.visibilities, prompt: false, input_html: {class: 'input-block-level'} 
 end 
 f.input :cacheable, label: "Allow Caching?", hint: "Uncheck to allow for personalized content." 
 end 
 end 
 bottom_buttons f 
 end 
 

end

      end
    rescue ActiveRecord::StaleObjectError => e
      @other_version = @page.class.find(@page.id)
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Configure Page" 
  simple_form_for(@page) do |f| 
 page_title_with_buttons f 
 render layout: 'main_with_sidebar' do 
 hidden_field_tag :section_id, @page.section_id 
 render :partial => 'main_form', :locals => {:f => f} 
 content_for :sidebar do 
 draft_icon_tag(@block, force: true) 
 if current_user.able_to?(:publish_content) 
 f.input :visibility, label: false, collection: @page.visibilities, prompt: false, input_html: {class: 'input-block-level'} 
 end 
 f.input :cacheable, label: "Allow Caching?", hint: "Uncheck to allow for personalized content." 
 end 
 end 
 bottom_buttons f 
 end 
 

end

    end

    def destroy
      respond_to do |format|
        if @page.destroy
          message = "Page '#{@page.name}' was deleted."
          format.html { flash[:notice] = message; redirect_to(sitemap_url) }
          format.json { render :json => {:success => true, :message => message} }
        else
          message = "Page '#{@page.name}' could not be deleted"
          format.html { flash[:error] = message; redirect_to(sitemap_url) }
          format.json { render :json => {:success => false, :message => message} }
        end
      end
    end

    #status actions
    {:publish => "published", :hide => "hidden", :archive => "archived"}.each do |status, verb|
      define_method status do
        if params[:page_ids]
          @pages = params[:page_ids].map { |id| Page.find(id) }
          raise Errors::AccessDenied unless @pages.all? { |page| current_user.able_to_edit?(page) }
          @pages.each { |page| page.send(status) }
          flash[:notice] = "#{params[:page_ids].size} pages #{verb}"
          redirect_to dashboard_url
        else
          load_page
          if @page.send(status)
            flash[:notice] = "Page '#{@page.name}' was #{verb}"
          end
          redirect_to @page.path
        end
      end
    end

    def version
      @page = @page.as_of_version(params[:version])
      @show_toolbar = true
      @show_page_toolbar = true
      @_connectors = @page.current_connectors
      @_connectables = @page.contents
      render :layout => @page.layout, :template => 'cms/content/show'
    end

    def revert_to
      if @page.revert_to(params[:version])
        flash[:notice] = "Page '#{@page.name}' was reverted to version #{params[:version]}"
      end

      respond_to do |format|
        format.html { redirect_to @page.path }
        format.js { render :template => 'cms/shared/show_notice' }
      end
    end

    protected


    private

    def page_params
      params.require(:page).permit(Page.permitted_params)
    end

    def strip_visibility_params
      unless current_user.able_to?(:publish_content)
        params[:page].delete :hidden
        params[:page].delete :archived
        params[:page].delete :visibility
      end
    end

    def load_page
      @page = Page.find(params[:id])
      raise Errors::AccessDenied unless current_user.able_to_edit?(@page)
    end

    def load_draft_page
      load_page
      @page = @page.as_of_draft_version
    end

    def load_section
      @section = Section.find(params[:section_id])
      raise Errors::AccessDenied unless current_user.able_to_edit?(@section)
    end

    def hide_toolbar
      @hide_page_toolbar = true
    end

    def load_templates
      @templates = PageTemplate.options
    end

  end

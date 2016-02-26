module Cms
  class LinksController < Cms::BaseController

    before_filter :load_section, :only => [:new, :create, :move_to]
    before_filter :load_link, :only => [:destroy, :update]
    before_filter :load_draft_link, :only => [:edit]

    include Cms::PublishWorkflow

    def resource
      @link
    end

    def resource_param
      :link
    end

    def show
      redirect_to sitemap_path
    end

    def new
      @link = Link.new(:section => @section)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Add a New Link" 
 simple_form_for(@link) do |f| 
 hidden_field_tag :section_id, @link.section_id 
  page_title_with_buttons f 
 f.input :name 
 f.input :url 
 f.input :new_window, label: "Open In New Window?" 
 bottom_buttons f 
 
 end 

end

    end

    def create
      @link = Link.new(link_params)
      @link.section = @section
      if @link.save
        flash[:notice] = "Link was '#{@link.name}' created."
        redirect_to @section
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Add a New Link" 
 simple_form_for(@link) do |f| 
 hidden_field_tag :section_id, @link.section_id 
  page_title_with_buttons f 
 f.input :name 
 f.input :url 
 f.input :new_window, label: "Open In New Window?" 
 bottom_buttons f 
 
 end 

end

      end
    end

    def update
      if @link.update_attributes(link_params)
        flash[:notice] = "Link '#{@link.name}' was updated"
        redirect_to @link.section
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Edit Link" 
 simple_form_for(@link) do |f| 
  page_title_with_buttons f 
 f.input :name 
 f.input :url 
 f.input :new_window, label: "Open In New Window?" 
 bottom_buttons f 
 
 end 

end

      end
    end

    def destroy
      respond_to do |format|
        if @link.destroy
          message = "Link '#{@link.name}' was deleted."
          format.html { flash[:notice] = message; redirect_to(sitemap_url) }
          format.json { render :json => {:success => true, :message => message} }
        else
          message = "Link '#{@link.name}' could not be deleted"
          format.html { flash[:error] = message; redirect_to(sitemap_url) }
          format.json { render :json => {:success => false, :message => message} }
        end
      end
    end

    protected
    def link_params
      params.require(:link).permit(Cms::Link.permitted_params)
    end

    def load_section
      @section = Section.find(params[:section_id])
      raise Cms::Errors::AccessDenied unless current_user.able_to_edit?(@section)
    end

    def load_link
      @link = Link.find(params[:id])
      raise Cms::Errors::AccessDenied unless current_user.able_to_edit?(@link)
    end

    def load_draft_link
      load_link
      @link = @link.as_of_draft_version
    end

  end
end
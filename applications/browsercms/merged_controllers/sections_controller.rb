  class SectionsController < BaseController

    before_filter :load_parent, :only => [:new, :create]
    before_filter :load_section, :only => [:edit, :update, :destroy, :move]

    helper_method :public_groups
    helper_method :cms_groups

    def resource
      @section
    end

    def index
      redirect_to cms.sitemap_path
    end

    def show
      redirect_to cms.sitemap_path
    end

    def new
      @section = @parent.build_section
      @section.groups = @parent.groups
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Add a New Section" 
 simple_form_for(@section, :id => 'section_form') do |f| 
 hidden_field_tag :section_id, @parent.id 
  page_title_with_buttons f 
 f.input :name, slug_source_if(f.object.new_record?) 
 f.input :path, input_html: {class: 'slug-dest', data: {prefix: parent.path}} if parent 
 f.input :hidden, label: "Hide from menus?" if parent 
 able_to?(:administrate) do 
 f.association :groups,
                        collection: public_groups,
                        as: :check_boxes,
                        label: 'Public Permissions',
                        input_html: {class: "public_group_ids"},
                        hint: 'Which "Public" groups can view pages in this section?'
      
 check_uncheck_tag 'input.public_group_ids' 
 f.association :groups,
                        collection: cms_groups,
                        as: :check_boxes,
                        label: 'CMS Permissions',
                        input_html: {class: "cms_group_ids"},
                        hint: 'Which "CMS" groups can edit pages and content in this section?'
      
 check_uncheck_tag 'input.cms_group_ids' 
 end 
 bottom_buttons f 
 
 end 

end

    end

    def create
      @section = Section.new(section_params)
      @section.parent = @parent
      @section.groups = @section.parent.groups unless current_user.able_to?(:administrate)
      if @section.save
        flash[:notice] = "Section '#{@section.name}' was created"
        redirect_to @section
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Add a New Section" 
 simple_form_for(@section, :id => 'section_form') do |f| 
 hidden_field_tag :section_id, @parent.id 
  page_title_with_buttons f 
 f.input :name, slug_source_if(f.object.new_record?) 
 f.input :path, input_html: {class: 'slug-dest', data: {prefix: parent.path}} if parent 
 f.input :hidden, label: "Hide from menus?" if parent 
 able_to?(:administrate) do 
 f.association :groups,
                        collection: public_groups,
                        as: :check_boxes,
                        label: 'Public Permissions',
                        input_html: {class: "public_group_ids"},
                        hint: 'Which "Public" groups can view pages in this section?'
      
 check_uncheck_tag 'input.public_group_ids' 
 f.association :groups,
                        collection: cms_groups,
                        as: :check_boxes,
                        label: 'CMS Permissions',
                        input_html: {class: "cms_group_ids"},
                        hint: 'Which "CMS" groups can edit pages and content in this section?'
      
 check_uncheck_tag 'input.cms_group_ids' 
 end 
 bottom_buttons f 
 
 end 

end

      end
    end

    def edit
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Edit Section" 
 simple_form_for(@section) do |f| 
  page_title_with_buttons f 
 f.input :name, slug_source_if(f.object.new_record?) 
 f.input :path, input_html: {class: 'slug-dest', data: {prefix: parent.path}} if parent 
 f.input :hidden, label: "Hide from menus?" if parent 
 able_to?(:administrate) do 
 f.association :groups,
                        collection: public_groups,
                        as: :check_boxes,
                        label: 'Public Permissions',
                        input_html: {class: "public_group_ids"},
                        hint: 'Which "Public" groups can view pages in this section?'
      
 check_uncheck_tag 'input.public_group_ids' 
 f.association :groups,
                        collection: cms_groups,
                        as: :check_boxes,
                        label: 'CMS Permissions',
                        input_html: {class: "cms_group_ids"},
                        hint: 'Which "CMS" groups can edit pages and content in this section?'
      
 check_uncheck_tag 'input.cms_group_ids' 
 end 
 bottom_buttons f 
 
 end 

end

    end

    def update
      params[:section].delete('group_ids') if params[:section] && !current_user.able_to?(:administrate)
      @section.attributes = section_params()
      if @section.save
        flash[:notice] = "Section '#{@section.name}' was updated"
        redirect_to @section
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Edit Section" 
 simple_form_for(@section) do |f| 
  page_title_with_buttons f 
 f.input :name, slug_source_if(f.object.new_record?) 
 f.input :path, input_html: {class: 'slug-dest', data: {prefix: parent.path}} if parent 
 f.input :hidden, label: "Hide from menus?" if parent 
 able_to?(:administrate) do 
 f.association :groups,
                        collection: public_groups,
                        as: :check_boxes,
                        label: 'Public Permissions',
                        input_html: {class: "public_group_ids"},
                        hint: 'Which "Public" groups can view pages in this section?'
      
 check_uncheck_tag 'input.public_group_ids' 
 f.association :groups,
                        collection: cms_groups,
                        as: :check_boxes,
                        label: 'CMS Permissions',
                        input_html: {class: "cms_group_ids"},
                        hint: 'Which "CMS" groups can edit pages and content in this section?'
      
 check_uncheck_tag 'input.cms_group_ids' 
 end 
 bottom_buttons f 
 
 end 

end

      end
    end

    def destroy
      respond_to do |format|
        if @section.deletable? && @section.destroy
          message = "Section '#{@section.name}' was deleted."
          format.html { flash[:notice] = message; redirect_to(sitemap_url) }
          format.json { render :json => {:success => true, :message => message} }
        else
          message = "Section '#{@section.name}' could not be deleted"
          format.html { flash[:error] = message; redirect_to(sitemap_url) }
          format.json { render :json => {:success => false, :message => message} }
        end
      end
    end

    def move
      if params[:section_id]
        @move_to = Section.find(params[:section_id])
      else
        @move_to = Section.root.first
      end
    end

    protected

    def section_params
      params.require(:section).permit(Section.permitted_params)
    end

    def load_parent
      @parent = Section.find(params[:section_id])
      raise Errors::AccessDenied unless current_user.able_to_edit?(@parent)
    end

    def load_section
      @section = Section.find(params[:id])
      raise Errors::AccessDenied unless current_user.able_to_edit?(@section)
    end

    def public_groups
      @public_groups ||= Group.public.order("#{Group.table_name}.name")
    end

    def cms_groups
      @cms_groups ||= Group.cms_access.order( "#{Group.table_name}.name")
    end

  end

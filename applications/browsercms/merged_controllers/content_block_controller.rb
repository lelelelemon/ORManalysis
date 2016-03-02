require 'cms/category_type'
# This is not called directly
# This is the base class for other content blocks
  class ContentBlockController < BaseController
    include ContentRenderingSupport

    allow_guests_to [:show_via_slug]

    helper_method :block_form, :content_type
    helper RenderingHelper
    helper do

      # Addressable content types don't allow for Mobile Optimized templates.
      def mobile_template_exists?(block)
        false
      end
    end
    include PublishWorkflow

    def index
      load_blocks
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Assets - #{content_type.display_name_plural}" 
 form_for @search_filter, url: engine(content_type).url_for({}), html: {class: 'form-search'}, method: :get do |f| 
 f.text_field :term, class: "span6 search-query right", placeholder: "Search #{content_type.display_name_plural}" 
 end 
 form_tag engine_aware_path(@search_filter.path), method: :put do 
 content_type.display_name_plural 
  id 
 if library 
 nav_link_to "Text", cms.content_library_path 
 divider_tag 
 end 
 modules = ContentType.available_by_module
     modules.keys.sort.each_with_index do |module_name, i| 
 divider_tag(i) 
 modules[module_name].each do |type| 
 nav_link_to h(type.display_name), engine_aware_path(type) 
 end 
 end 
 
 submit_tag "Publish", class: "right btn btn-small btn-primary primary-cta" if content_type.model_class.publishable? 
 submit_tag "Delete", class: 'btn btn-small', data: {confirm: 'Are you sure you want to delete all these records?'} 
 yield :bulk_actions if content_for?(:bulk_actions) 
 @total_number_of_items 
 content_type.columns_for_index.each_with_index do |column, i| 
 if column[:order] 
 link_to column[:label], sortable_column_path(content_type, column[:order]) 
 else 
 column[:label] 
 end 
 end 
 if (content_type.model_class.respond_to?(:created_by)) 
 end 
 if content_type.model_class.connectable? 
 end 
 @blocks.each do |block| 
 check_box_tag 'content_id[]', block.id 
 content_type.columns_for_index.each_with_index do |column, i| 
 link_to_if(i == 0, block.send(column[:method]), edit_engine_aware_path(block)) 
 draft_icon_tag(block) if i == 0 
 end 
 if (content_type.model_class.respond_to?(:created_by)) 
 block.created_by.try(:full_name) 
 end 
 if content_type.model_class.connectable? 
 block.connected_pages.size 
 end 
 end 
 end 
 if !@search_filter.term.blank? && @blocks.size == 0 
 @search_filter.term 
 elsif @blocks.total_pages > 1 
 render_pagination @blocks, content_type, :order => params[:order], "search_filter[term]" => @search_filter.term 
 end 

end

    end

    def bulk_update
      ids = params[:content_id] || []
      models = ids.collect do |id|
        model_class.find(id.to_i)
      end
      if params[:commit] == 'Delete'
        deleted = models.select do |m|
          m.destroy
        end
        flash[:notice] = "Deleted #{deleted.size} records."
      else
        # Need to do these one at a time since the code logic is more complex than single UPDATE.
        published = models.select do |m|
          m.publish!
        end

        flash[:notice] = "Published #{published.size} records."
      end

      redirect_to action: :index
    end

    # Getting content by its path  (i.e. /products/:slug)
    def show_via_slug
      @block = model_class.with_slug(params[:slug])
      unless @block
        raise Errors::ContentNotFound.new("No Content at #{model_class.calculate_path(params[:slug])}")
      end
      render_block_in_main_container
    end

    # Getting content by its id (i.e. /products/:id)
    # Logged in editors will get the editing frame.
    def show
      load_block_draft
      render_editing_frame_or_block_in_main_container
    end

    # Getting the content for the editing frame.
    def inline
      load_block_draft
      render_block_in_main_container
    end

    def new
      build_block
      set_default_category
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Add a New #{content_type.display_name}" 
  content_block_form_for(@block) do |f| 
 page_title_with_buttons f 
 render 'form_errors', form: f 
 render 'exception', :object => @exception if @exception 
 render :partial => 'version_conflict_error', :locals => {:other_version => @other_version, :your_version => @block} if @other_version 
  if params[:_redirect_to] 
 hidden_field_tag :_redirect_to, params[:_redirect_to] 
 end 
 if @block.respond_to?(:lock_version) 
 f.hidden_field :lock_version, :value => (@other_version ? @other_version.lock_version : @block.lock_version) 
 end 
 if @block.class.connectable? 
 f.hidden_field :connect_to_page_id 
 f.hidden_field :connect_to_container 
 end 
 if @parent 
 hidden_field_tag :parent, @parent.id 
 end 
 
 render block_form, f: f 
  if @block.class.publishable? 
 draft_icon_tag(@block, force: true) 
 end 
 if @block.class.connectable? 
 if @block.connected_pages.empty? 
 else 
 @block.connected_pages.each do |page| 
 link_to page.name, cms.page_path(page), target: "_blank" 
 end 
 end 
 if @block.respond_to?(:draft_version?) && !@block.draft_version? 
 @block.version 
 link_to "Current", engine_aware_path(@block) 
 end 
 end 
  yield :sidebar_actions if content_for(:sidebar_actions)
 link_to "View", engine_aware_path(@block), class: "btn btn-small" 
 link_to("Preview", @block.path, id: "preview_button", target: "_blank", class: "btn btn-small") if @block.class.addressable? 
 link_to "Versions", engine(@block).polymorphic_path([:versions, @block]), class: "btn btn-small" if @block.class.versioned? 
 link_to "Delete", engine_aware_path(@block), class: "btn btn-small btn-danger confirm_with_title http_delete", title: "Are you sure you want to delete this content?" 
 yield :sidebar_after if content_for(:sidebar_after)
 
 render :partial => "version_conflict_diff", :locals => {:other_version => @other_version, :your_version => @block} if @other_version 
 bottom_buttons f 
 end 
 

end

    end

    def create
      if create_block
        after_create_on_success
      else
        after_create_on_failure
      end
    rescue Exception => @exception
      raise @exception if @exception.is_a?(Errors::AccessDenied)
      after_create_on_error
    end

    def edit
      load_block_draft
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Edit #{content_type.display_name}" 
  content_block_form_for(@block) do |f| 
 page_title_with_buttons f 
 render 'form_errors', form: f 
 render 'exception', :object => @exception if @exception 
 render :partial => 'version_conflict_error', :locals => {:other_version => @other_version, :your_version => @block} if @other_version 
  if params[:_redirect_to] 
 hidden_field_tag :_redirect_to, params[:_redirect_to] 
 end 
 if @block.respond_to?(:lock_version) 
 f.hidden_field :lock_version, :value => (@other_version ? @other_version.lock_version : @block.lock_version) 
 end 
 if @block.class.connectable? 
 f.hidden_field :connect_to_page_id 
 f.hidden_field :connect_to_container 
 end 
 if @parent 
 hidden_field_tag :parent, @parent.id 
 end 
 
 render block_form, f: f 
  if @block.class.publishable? 
 draft_icon_tag(@block, force: true) 
 end 
 if @block.class.connectable? 
 if @block.connected_pages.empty? 
 else 
 @block.connected_pages.each do |page| 
 link_to page.name, cms.page_path(page), target: "_blank" 
 end 
 end 
 if @block.respond_to?(:draft_version?) && !@block.draft_version? 
 @block.version 
 link_to "Current", engine_aware_path(@block) 
 end 
 end 
  yield :sidebar_actions if content_for(:sidebar_actions)
 link_to "View", engine_aware_path(@block), class: "btn btn-small" 
 link_to("Preview", @block.path, id: "preview_button", target: "_blank", class: "btn btn-small") if @block.class.addressable? 
 link_to "Versions", engine(@block).polymorphic_path([:versions, @block]), class: "btn btn-small" if @block.class.versioned? 
 link_to "Delete", engine_aware_path(@block), class: "btn btn-small btn-danger confirm_with_title http_delete", title: "Are you sure you want to delete this content?" 
 yield :sidebar_after if content_for(:sidebar_after)
 
 render :partial => "version_conflict_diff", :locals => {:other_version => @other_version, :your_version => @block} if @other_version 
 bottom_buttons f 
 end 
 

end

    end

    def update
      if update_block
        after_update_on_success
      else
        after_update_on_failure
      end
    rescue ActiveRecord::StaleObjectError => @exception
      after_update_on_edit_conflict
    rescue Exception => @exception
      raise @exception if @exception.is_a?(Errors::AccessDenied)
      after_update_on_error
    end

    def destroy
      do_command("deleted") { @block.destroy }
      respond_to do |format|
        format.html { redirect_to_first params[:_redirect_to], engine_aware_path(@block.class) }
        format.json { render :json => {:success => true} }
      end

    end

    # Additional CMS Action

    def publish
      do_command("published") { @block.publish! }
      redirect_to_first params[:_redirect_to], engine_aware_path(@block, nil)
    end

    def revert_to
      do_command("reverted to version #{params[:version]}") do
        revert_block(params[:version])
      end
      redirect_to_first params[:_redirect_to], engine_aware_path(@block, nil)
    end

    def version
      load_block
      if params[:version]
        @block = @block.as_of_version(params[:version])
      end
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "View #{content_type.display_name}" 
 render layout: 'page_title' do 
 link_to 'Edit', edit_engine_aware_path(@block), class: 'btn btn-primary btn-small right' 
 end 
 content_for :sidebar,  if @block.class.publishable? 
 draft_icon_tag(@block, force: true) 
 end 
 if @block.class.connectable? 
 if @block.connected_pages.empty? 
 else 
 @block.connected_pages.each do |page| 
 link_to page.name, cms.page_path(page), target: "_blank" 
 end 
 end 
 if @block.respond_to?(:draft_version?) && !@block.draft_version? 
 @block.version 
 link_to "Current", engine_aware_path(@block) 
 end 
 end 
  yield :sidebar_actions if content_for(:sidebar_actions)
 link_to "View", engine_aware_path(@block), class: "btn btn-small" 
 link_to("Preview", @block.path, id: "preview_button", target: "_blank", class: "btn btn-small") if @block.class.addressable? 
 link_to "Versions", engine(@block).polymorphic_path([:versions, @block]), class: "btn btn-small" if @block.class.versioned? 
 link_to "Delete", engine_aware_path(@block), class: "btn btn-small btn-danger confirm_with_title http_delete", title: "Are you sure you want to delete this content?" 
 yield :sidebar_after if content_for(:sidebar_after)
 
 render layout: 'main_with_sidebar' do 
 if @block.respond_to?(:deleted) && @block.deleted 
 @block.class.name 
 end 
 if @block.class.renderable? 
 render_connectable(@block) 
 end 
 end 

end

    end

    def versions
      if model_class.versioned?
        load_block
      else
        render :text => "Not Implemented", :status => :not_implemented
      end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Versions: '#{@block.name}'" 
 render layout: 'page_title' do 
 link_to "Back", :back, class: 'btn btn-small right' 
 end 
 render layout: 'main_content' do 
 @block.versions.order("version desc").each_with_index do |r, i| 
 render partial: 'version', locals: {revision: r, original: @block,  i: i} 
 end 
 end 

end

    end

    def new_button_path
      new_engine_aware_path(content_type)
    end

    protected

    def content_type_name
      self.class.name.sub(/Controller/, '').singularize
    end

    def content_type
      @content_type ||= ContentType.find_by_key(content_type_name)
    end

    def model_class
      content_type.model_class
    end

    def model_form_name
      content_type.param_key
    end
    alias :resource_param :model_form_name

    def resource
      @block ||= find_block
    end

    # methods for loading one or a collection of blocks

    def load_blocks
      @search_filter = SearchFilter.build(params[:search_filter], model_class)

      options = {}

      options[:page] = params[:page]
      options[:order] = model_class.default_order if model_class.respond_to?(:default_order)
      options[:order] = params[:order] unless params[:order].blank?

      scope = model_class.respond_to?(:list) ? model_class.list : model_class
      if scope.searchable?
        scope = scope.search(@search_filter.term)
      end
      if params[:section_id] && model_class.respond_to?(:with_parent_id)
        scope = scope.with_parent_id(params[:section_id])
      end
      @total_number_of_items = scope.count
      @blocks = scope.paginate(options)
      check_permissions

    end

    def load_block
      find_block
      check_permissions
    end

    def find_block
      @block = model_class.find(params[:id])
    end

    def load_block_draft
      find_block
      @block = @block.as_of_draft_version if model_class.versioned?
      check_permissions
    end

    # path related methods - available in the view as helpers

    # This is the partial that will be used in the form
    def block_form
      @content_type.form
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_block_form_for(@block) do |f| 
 page_title_with_buttons f 
 render 'form_errors', form: f 
 render 'exception', :object => @exception if @exception 
 render :partial => 'version_conflict_error', :locals => {:other_version => @other_version, :your_version => @block} if @other_version 
  if params[:_redirect_to] 
 hidden_field_tag :_redirect_to, params[:_redirect_to] 
 end 
 if @block.respond_to?(:lock_version) 
 f.hidden_field :lock_version, :value => (@other_version ? @other_version.lock_version : @block.lock_version) 
 end 
 if @block.class.connectable? 
 f.hidden_field :connect_to_page_id 
 f.hidden_field :connect_to_container 
 end 
 if @parent 
 hidden_field_tag :parent, @parent.id 
 end 
 
 render block_form, f: f 
  if @block.class.publishable? 
 draft_icon_tag(@block, force: true) 
 end 
 if @block.class.connectable? 
 if @block.connected_pages.empty? 
 else 
 @block.connected_pages.each do |page| 
 link_to page.name, cms.page_path(page), target: "_blank" 
 end 
 end 
 if @block.respond_to?(:draft_version?) && !@block.draft_version? 
 @block.version 
 link_to "Current", engine_aware_path(@block) 
 end 
 end 
  yield :sidebar_actions if content_for(:sidebar_actions)
 link_to "View", engine_aware_path(@block), class: "btn btn-small" 
 link_to("Preview", @block.path, id: "preview_button", target: "_blank", class: "btn btn-small") if @block.class.addressable? 
 link_to "Versions", engine(@block).polymorphic_path([:versions, @block]), class: "btn btn-small" if @block.class.versioned? 
 link_to "Delete", engine_aware_path(@block), class: "btn btn-small btn-danger confirm_with_title http_delete", title: "Are you sure you want to delete this content?" 
 yield :sidebar_after if content_for(:sidebar_after)
 
 render :partial => "version_conflict_diff", :locals => {:other_version => @other_version, :your_version => @block} if @other_version 
 bottom_buttons f 
 end 

end

    end


    def build_block
      if params[model_form_name]
        @block = model_class.new(model_params)
      else
        # Need to make sure @block exists for form helpers to correctly generate paths
        @block = model_class.new unless @block
      end
      check_permissions
    end

    def set_default_category
      if @last_block = model_class.last
        @block.category = @last_block.category if @block.respond_to?(:category=)
      end
    end

    def create_block
      build_block
      @block.save
    end

    def after_create_on_success
      block = @block.class.versioned? ? @block.draft : @block
      flash[:notice] = "#{content_type.display_name} '#{block.name}' was created"
      if @block.class.connectable? && @block.connected_page
        redirect_to @block.connected_page.path
      else
        redirect_to_first params[:_redirect_to], engine_aware_path(@block)
      end
    end

    def after_create_on_failure
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Add a New #{content_type.display_name}" 
  content_block_form_for(@block) do |f| 
 page_title_with_buttons f 
 render 'form_errors', form: f 
 render 'exception', :object => @exception if @exception 
 render :partial => 'version_conflict_error', :locals => {:other_version => @other_version, :your_version => @block} if @other_version 
  if params[:_redirect_to] 
 hidden_field_tag :_redirect_to, params[:_redirect_to] 
 end 
 if @block.respond_to?(:lock_version) 
 f.hidden_field :lock_version, :value => (@other_version ? @other_version.lock_version : @block.lock_version) 
 end 
 if @block.class.connectable? 
 f.hidden_field :connect_to_page_id 
 f.hidden_field :connect_to_container 
 end 
 if @parent 
 hidden_field_tag :parent, @parent.id 
 end 
 
 render block_form, f: f 
  if @block.class.publishable? 
 draft_icon_tag(@block, force: true) 
 end 
 if @block.class.connectable? 
 if @block.connected_pages.empty? 
 else 
 @block.connected_pages.each do |page| 
 link_to page.name, cms.page_path(page), target: "_blank" 
 end 
 end 
 if @block.respond_to?(:draft_version?) && !@block.draft_version? 
 @block.version 
 link_to "Current", engine_aware_path(@block) 
 end 
 end 
  yield :sidebar_actions if content_for(:sidebar_actions)
 link_to "View", engine_aware_path(@block), class: "btn btn-small" 
 link_to("Preview", @block.path, id: "preview_button", target: "_blank", class: "btn btn-small") if @block.class.addressable? 
 link_to "Versions", engine(@block).polymorphic_path([:versions, @block]), class: "btn btn-small" if @block.class.versioned? 
 link_to "Delete", engine_aware_path(@block), class: "btn btn-small btn-danger confirm_with_title http_delete", title: "Are you sure you want to delete this content?" 
 yield :sidebar_after if content_for(:sidebar_after)
 
 render :partial => "version_conflict_diff", :locals => {:other_version => @other_version, :your_version => @block} if @other_version 
 bottom_buttons f 
 end 
 

end
end

    def after_create_on_error
      log_complete_stacktrace(@exception)
      after_create_on_failure
    end

    def after_update_on_error
      log_complete_stacktrace(@exception)
      after_update_on_failure
    end


    # update related methods
    def update_block
      load_block
      @block.update_attributes(model_params())
    end

    # Returns the parameters for the block to be saved.
    # Handles defaults as well as eventually 'strong_params'
    def model_params
      defaults = {"publish_on_save" => false}
      model_params = params[model_form_name]
      defaults.merge(model_params)
    end

    def after_update_on_success
      flash[:notice] = "#{content_type_name.demodulize.titleize} '#{@block.name}' was updated"
      redirect_to_first params[:_redirect_to], engine_aware_path(@block)
    end

    def after_update_on_failure
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Edit #{content_type.display_name}" 
  content_block_form_for(@block) do |f| 
 page_title_with_buttons f 
 render 'form_errors', form: f 
 render 'exception', :object => @exception if @exception 
 render :partial => 'version_conflict_error', :locals => {:other_version => @other_version, :your_version => @block} if @other_version 
  if params[:_redirect_to] 
 hidden_field_tag :_redirect_to, params[:_redirect_to] 
 end 
 if @block.respond_to?(:lock_version) 
 f.hidden_field :lock_version, :value => (@other_version ? @other_version.lock_version : @block.lock_version) 
 end 
 if @block.class.connectable? 
 f.hidden_field :connect_to_page_id 
 f.hidden_field :connect_to_container 
 end 
 if @parent 
 hidden_field_tag :parent, @parent.id 
 end 
 
 render block_form, f: f 
  if @block.class.publishable? 
 draft_icon_tag(@block, force: true) 
 end 
 if @block.class.connectable? 
 if @block.connected_pages.empty? 
 else 
 @block.connected_pages.each do |page| 
 link_to page.name, cms.page_path(page), target: "_blank" 
 end 
 end 
 if @block.respond_to?(:draft_version?) && !@block.draft_version? 
 @block.version 
 link_to "Current", engine_aware_path(@block) 
 end 
 end 
  yield :sidebar_actions if content_for(:sidebar_actions)
 link_to "View", engine_aware_path(@block), class: "btn btn-small" 
 link_to("Preview", @block.path, id: "preview_button", target: "_blank", class: "btn btn-small") if @block.class.addressable? 
 link_to "Versions", engine(@block).polymorphic_path([:versions, @block]), class: "btn btn-small" if @block.class.versioned? 
 link_to "Delete", engine_aware_path(@block), class: "btn btn-small btn-danger confirm_with_title http_delete", title: "Are you sure you want to delete this content?" 
 yield :sidebar_after if content_for(:sidebar_after)
 
 render :partial => "version_conflict_diff", :locals => {:other_version => @other_version, :your_version => @block} if @other_version 
 bottom_buttons f 
 end 
 

end
end

    def after_update_on_edit_conflict
      @other_version = @block.class.find(@block.id)
      after_update_on_failure
    end


    # A "command" is when you want to perform an action on a content block
    # You pass a ruby block to this method, this calls it
    # and then sets a flash message based on success or failure
    def do_command(result)
      load_block
      if yield
        flash[:notice] = "#{content_type_name.demodulize.titleize} '#{@block.name}' was #{result}" unless request.xhr?
      else
        flash[:error] = "#{content_type_name.demodulize.titleize} '#{@block.name}' could not be #{result}" unless request.xhr?
      end

    end

    def revert_block(to_version)
      begin
        @block.revert_to(to_version)
      rescue Exception => @exception
        logger.warn "Could not revert #{@block.inspect} to version #{to_version}"
        logger.warn "#{@exception.message}\n:#{@exception.backtrace.join("\n")}"
        false
      end
    end

    # Use a "whitelist" approach to access to avoid mistakes
    # By default everyone can create new block and view them and their properties,
    # but blocks can only be modified based on the permissions of the pages they
    # are connected to.
    def check_permissions
      case action_name
        when "index", "show", "new", "create", "version", "versions"
          # Allow
        when "edit", "update", "inline"
          raise Errors::AccessDenied unless current_user.able_to_edit?(@block)
        when "destroy", "publish", "revert_to"
          raise Errors::AccessDenied unless current_user.able_to_publish?(@block)
        else
          raise Errors::AccessDenied
      end
    end

    private

    def render_block_in_main_container
      ensure_current_user_can_view(@block)
      show_content_as_page(@block)
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if current_user.able_to_edit?(@block) 
 content_for :html_head do 
 javascript_include_tag 'cms/page_editor' 
 stylesheet_link_tag 'cms/page_content_editing' 
 csrf_meta_tags 
 end 
 end 
 content_for :main do 
 render file: @block.class.template_path 
 end 

end

    end

    def render_block_in_content_library
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "View #{content_type.display_name}" 
 render layout: 'page_title' do 
 link_to 'Edit', edit_engine_aware_path(@block), class: 'btn btn-primary btn-small right' 
 end 
 content_for :sidebar,  if @block.class.publishable? 
 draft_icon_tag(@block, force: true) 
 end 
 if @block.class.connectable? 
 if @block.connected_pages.empty? 
 else 
 @block.connected_pages.each do |page| 
 link_to page.name, cms.page_path(page), target: "_blank" 
 end 
 end 
 if @block.respond_to?(:draft_version?) && !@block.draft_version? 
 @block.version 
 link_to "Current", engine_aware_path(@block) 
 end 
 end 
  yield :sidebar_actions if content_for(:sidebar_actions)
 link_to "View", engine_aware_path(@block), class: "btn btn-small" 
 link_to("Preview", @block.path, id: "preview_button", target: "_blank", class: "btn btn-small") if @block.class.addressable? 
 link_to "Versions", engine(@block).polymorphic_path([:versions, @block]), class: "btn btn-small" if @block.class.versioned? 
 link_to "Delete", engine_aware_path(@block), class: "btn btn-small btn-danger confirm_with_title http_delete", title: "Are you sure you want to delete this content?" 
 yield :sidebar_after if content_for(:sidebar_after)
 
 render layout: 'main_with_sidebar' do 
 if @block.respond_to?(:deleted) && @block.deleted 
 @block.class.name 
 end 
 if @block.class.renderable? 
 render_connectable(@block) 
 end 
 end 

end
end

    def render_editing_frame_or_block_in_main_container
      if @block.class.addressable?
        if current_user.able_to_edit?(@block)
          render_toolbar_and_iframe
        else
          render_block_in_main_container
        end
      else
        render_block_in_content_library
      end
    end

    def render_toolbar_and_iframe
      @page = @block
      @page_title = @block.page_title
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 page_content_iframe(url_for engine_aware_path(@block, :inline)) 

end

    end
  end

class Skyline::Content::Editors::JoinableListController < Skyline::Skyline2Controller

  helper "skyline/content"
  before_filter :get_classes
  
  def index
    @filter = filter_from_params_or_default
    @elements = @target_klass.paginate_for_cms(:page => params[:page], :per_page => 10, :self_referential => false, :filter => @filter).all
    @title_field = @target_klass.fields[@target_klass.settings.title_field]
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 params[:association] 
  link_to(
	      t(:close_window, :scope => [:content, :global]),
	      {:action => "cancel"},
	      :remote => true,
	      :class => "cancel")
	      #TODO - link_to :remote => true,  has not been tested 
  
 t(:add_a_to_b, :scope => [:content, :edit], :a => @target_klass.plural_name.capitalize, :b => @source_klass.singular_name) 
 if @target_klass.filterable? 
 @target_klass.to_s.underscore 
 fields = @target_klass.filterable_fields 
 l(:content, :list, :filter) 
 fields.each do |field_name| 
 field = @target_klass.fields[field_name] 
 field.name 
 field.singular_title 
 end 
 fields.each do |field_name| 
 field = @target_klass.fields[field_name] 
 select_tag("filter[#{field.name}]", options_for_select([[l(:content,:list,:filter_none),nil]] + field.unique_values.map{|k| k.kind_of?(Array) ? [k.first,k.last.to_s] : k.to_s},@filter[field.name].to_s), :id => "filter_#{field.name}") 
 end 
 image_submit_to_remote "buttons/filter.gif",'filter_apply', l(:content, :list, :filter_apply), :url => {}, :with => "Form.serialize('filter_#{@target_klass.to_s.underscore}')" 
 end 
 if @elements.respond_to?(:total_entries) && @elements.total_entries > @elements.per_page 
 l :global,:pagination,:number_of, [@target_klass.plural_name] 
 @elements.total_entries 
 l :global, :pagination, :pages 
 will_paginate @elements, :renderer => RemoteLinkRenderer, :params => params 
 end 
 @elements.each do |obj| 
 cycle "odd","even" 
 h @title_field.value(obj) 
 link_to( 
			      t(:add_to, :scope => [:content, :editors, :joinable_list], :class => @source_klass.singular_name), 
					  {:action => "new", :target_id => obj.id},
					  :remote => true,
  					:with => "'add_multiple=' + $('element_skyline_#{params[:association]}_add_multiple').checked",
  					:loading => "toggle_spin('element_skyline_#{params[:association]}_add_#{obj.id}','#{t(:adding, :scope => [:content, :editors, :joinable_list], :class => @target_klass.singular_name.capitalize)}');",
  					:complete => "toggle_spin('element_skyline_#{params[:association]}_add_#{obj.id}')",
					  :class => "add", :id => "element_skyline_#{params[:association]}_add_#{obj.id}") 
					#TODO - link_to :remote => true,  has not been tested 
			
 end 
 link_to(
	      t(:close_window, :scope => [:content, :global]),
	      {:action => "cancel"},
	      :remote => true,
	      :class => "cancel")
	      #TODO - link_to :remote => true,  has not been tested 
  
 "element_skyline_#{params[:association]}_add_multiple" 
 check_box_tag :add_multiple, "1", params[:add_multiple], :id => "element_skyline_#{params[:association]}_add_multiple", :class => "checkbox" 
 t(:add_multiple, :scope => [:content, :edit]) 
 

end

  end
  
  def new
    if @assoc.through_reflection
      @target = @target_klass.find(params[:target_id])
      @object = @source_object.send(@assoc.through_reflection.name).build(@assoc.source_reflection.name => @target)
    else
      @object = @target_klass.find(params[:target_id])
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 editor = Skyline::Editors::JoinableList.new(["element"],@source_object,@source_klass.fields[params[:association].to_sym],@template) 
 editor.js_object_name 
 escape_javascript editor.render_row(@object) 
 if params[:add_multiple] != "true" 
 params[:association] 
  link_to( 
      t(:add_more, :scope => [:content], :class => target_class.plural_name), 
      {
        :controller => "skyline/content/editors/joinable_list", 
        :action => "index", 
        :source_type => source_object.class.to_s.demodulize.underscore, 
        :source_id => source_object,
        :association => association
      },
      :remote => true,
			:loading => "toggle_spin('element_skyline_#{association}_add_more','#{t(:loading, :scope => [:content, :global])}')",
			:complete => "toggle_spin('element_skyline_#{association}_add_more')", 
			:class => "add",
			:id => "element_skyline_#{association}_add_more"
			)
			
	 #TODO - link_to :remote => true,  has not been tested 
 
 
 end 

end

  end
  
  def cancel
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 params[:association] 
  link_to( 
      t(:add_more, :scope => [:content], :class => target_class.plural_name), 
      {
        :controller => "skyline/content/editors/joinable_list", 
        :action => "index", 
        :source_type => source_object.class.to_s.demodulize.underscore, 
        :source_id => source_object,
        :association => association
      },
      :remote => true,
			:loading => "toggle_spin('element_skyline_#{association}_add_more','#{t(:loading, :scope => [:content, :global])}')",
			:complete => "toggle_spin('element_skyline_#{association}_add_more')", 
			:class => "add",
			:id => "element_skyline_#{association}_add_more"
			)
			
	 #TODO - link_to :remote => true,  has not been tested 
 
 

end

  end

  protected
  
  def get_classes
    @source_klass = @implementation.content_class(params[:source_type])
    @source_object = @source_klass.find_by_id(params[:source_id]) || @source_klass.new    
    @assoc = @source_klass.reflect_on_association(params[:association].to_sym)
    @target_klass = @assoc.klass    
  end
  
  def default_url_options(options)
    options.update(:source_type => params[:source_type], :source_id => params[:source_id], :association => params[:association])
  end

  # GEt filter from params, or use default if defined
  def filter_from_params_or_default
    # First priority is params
    return params[:filter] if params.has_key?(:filter) || params.has_key?("filter")
    
    # Field
    field = @source_klass.fields[@assoc.name]
    return {} if !field || field.default_filter.blank?
    
    if field.default_filter.kind_of?(Proc)
      filter = field.default_filter.call(@source_object)
    else
      filter = field.default_filter
    end
    filter || {}
  end
    
  
end

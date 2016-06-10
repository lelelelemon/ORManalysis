class Skyline::SectionsController < Skyline::ApplicationController
  before_filter :find_renderable_scope
    
  def new
    return unless request.xhr?
    
    @section = Skyline::Section.new
    @section.sectionable = params[:sectionable_type].constantize.new
    @section_guid = Guid.new    
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if params[:after_section]
  pos, id = :after, params[:after_section]          
else
  pos, id = :bottom, "contentlist"
end 
 skyline_fields_for params[:object_name] do |variant_form| 
 id 
 pos 
  sectionable_type = section.sectionable.andand.class.to_s.demodulize.underscore 
guid
 sectionable_type.camelcase(:lower) 
 section.sectionable.andand.errors.any? ? "invalid" : "" 
 variant_form.fields_for "sections_attributes", section, :index => guid do |section_form| 
 section_form.hidden_field :id unless section_form.object.new_record? 
 section_form.hidden_field :_destroy, :class => "delete" 
 section_form.positioning_field 
 section_form.fields_for "sectionable_attributes", section_form.object.sectionable do |sectionable_form| 
 sectionable_form.hidden_field :id unless sectionable_form.object.new_record? 
 sectionable_form.hidden_field :class if sectionable_form.object.new_record? 
 link_to_function button_text(:undo), "PageHelper.unDestroy('section_#{guid}')", :class => "undo button small" 
 t(:will_be_destroyed, :section => section.sectionable.class.model_name.human, :scope => [:section, :form]) 
 if section.sectionable.default_interface 
 renderable_templates_select(section.sectionable, section_form) 
 section.sectionable.class.model_name.human 
 render :partial => "skyline/sections/#{sectionable_type}", :locals => {:section_form => section_form, :sectionable_form => sectionable_form, :guid => guid} 
 else 
 render :partial => "skyline/sections/#{sectionable_type}", :locals => {:section_form => section_form, :sectionable_form => sectionable_form, :guid => guid} 
 end 
 end 
 end 
 link_to_function(image_tag("#{Skyline::Configuration.url_prefix}/images/buttons/section-delete.gif", :alt => t(:delete, :scope => [:section, :form])), "PageHelper.destroy('section_#{guid}')", :class => "delete") 
 javascript_tag "PageHelper.destroy('section_#{guid}');" if section.marked_for_destruction? 
 
 end 
 @section_guid 
 @section_guid 

end

  end
  
  protected
  def find_renderable_scope
    @renderable_scope = Skyline::Rendering::Scopes::Interface.unserialize(params[:renderable_scope]) if params[:renderable_scope]
    raise "Can't load renderable_scope from params[:renderable_scope]: '#{params[:renderable_scope]}'" unless @renderable_scope
  end
end
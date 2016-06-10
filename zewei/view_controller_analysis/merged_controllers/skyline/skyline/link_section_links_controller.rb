class Skyline::LinkSectionLinksController < Skyline::ApplicationController
  def new
    @link = Skyline::LinkSectionLink.new
    @link_guid = Guid.new    
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 skyline_fields_for params[:object_name], @link do |sectionable_form| 
 params[:guid] 
  linked_object = link.linked || link.build_linked 
 link_guid 
 ref_object_css_class(linked_object.andand.referable) 
 sectionable_form.fields_for "links_attributes", link, :index => link_guid do |l| 
 l.hidden_field :id unless link.new_record? 
 l.hidden_field :_destroy, :class => "delete" 
 l.positioning_field 
 link_to_function button_text(:undo), "PageHelper.unDestroy('link_section_#{link_guid}')", :class => "button small undo" 
 t(:will_be_destroyed, :link => link.title, :scope => [:link_section, :form]) 
 l.text_field :title, :class => "link_title full" 
 link_browser(l, :linked, {:object => linked_object, :container => "link_section_#{link_guid}"}) 
 link_to_function(image_tag("#{Skyline::Configuration.url_prefix}/images/buttons/section-delete.gif", :alt => t(:delete, :scope => [:section, :form])), "PageHelper.destroy('link_section_#{link_guid}')", :class => "delete") 
 end 
 javascript_tag "PageHelper.destroy('link_section_#{link_guid}');" if link.marked_for_destruction? 
 
 params[:guid].to_s.gsub("-","") 
 @link_guid 
 end 

end

  end
end
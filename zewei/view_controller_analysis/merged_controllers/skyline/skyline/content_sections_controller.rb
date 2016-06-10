class Skyline::ContentSectionsController < Skyline::ApplicationController
  def new
    if params[:taggable_type].present?
      @taggable = params[:taggable_type].constantize
      @tags = @taggable.available_tags
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @tags.present? 
 params[:guid] 
  skyline_fields_for "article[variants_attributes][1][sections_attributes][#{guid}][sectionable_attributes]", sectionable do |s| 
guid
s.label :raw_tags, Skyline::MediaFile.human_attribute_name("file_tags")
 s.text_area :raw_tags, :rows => nil 
t(:available_tags, :scope => [:tags, :index])
  (local_assigns.has_key?(:tags) ? local_assigns[:tags] : @tags).each do |t|
t.tag
 end 

 s.dom_id :raw_tags 
guid
 end 

 else 
 params[:guid] 
 end 

end

  end
end
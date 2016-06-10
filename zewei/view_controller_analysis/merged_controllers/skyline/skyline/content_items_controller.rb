class Skyline::ContentItemsController < Skyline::ApplicationController
  def new
    return unless request.xhr?
    if params[:content_item_type].present?
      @content_item_class = params[:content_item_type].constantize
    end    
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @content_item_class.present? 
 params[:guid] 
  skyline_fields_for "article[variants_attributes][1][sections_attributes][#{guid}][sectionable_attributes]", sectionable do |s| 
 s.select :content_item_id, [["",""]] + @content_item_class.for_content_item_section.collect{|item| [item.respond_to?(:human_id) ? item.human_id : item.title, item.id]}
 end 
 
 else 
 params[:guid] 
 end 

end

  end
end
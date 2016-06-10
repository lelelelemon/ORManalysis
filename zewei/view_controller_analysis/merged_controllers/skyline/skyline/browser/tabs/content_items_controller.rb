class Skyline::Browser::Tabs::ContentItemsController < Skyline::ApplicationController
  
  def show
    @content_type = params[:id].singularize.camelize.constantize
    @content_items = @content_type.published
    @selected_item = @content_type.find_by_id(params[:referable_id])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @content_type 
 Skyline::Page::Data.human_attribute_name(:title) 
 if @content_items.present? 
 selected_row = nil 
 @content_items.each do |content_item| 
 selected_row = "content_#{content_item.id}" if content_item == @selected_item 
 cycle("odd","even") 
 "selected" if content_item == @selected_item 
 content_item.id 
 content_item.url || content_item.id 
 content_item.id 
 content_item.class.name 
 content_item.title 
 tick_image(content_item.published?) 
 content_item.published_publication_data.title.blank? ? "&nbsp;" : content_item.published_publication_data.title 
 end 
 end 
 if selected_row 
 selected_row 
 end 
 

end

  end
  
end
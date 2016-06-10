class Skyline::Browser::ContentController < Skyline::ApplicationController
  def index
    if @content_selection = extract_valid_selection(params[:content_selection])
      
      if params[:referable_id].present?
        @content_type = params[:referable_type].constantize
        @selected_item = @content_type.find_by_id(params[:referable_id])
        @content_items = @content_type.published
      else
        @content_type = @content_selection.first
        @content_items = @content_type.published
      end
      
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 tabs = ["Skyline::Content"] 
 tabs.each do |tab| 
 "active" if @active_tab == tab 
 t(tab, :scope => [:browser,:tabs]) 
 end 
  @content_item.andand.id 
 @content_item.andand.class.andand.name 
 @content_selection.each do |content_class| 
 active = content_class == @content_type 
 content_class.to_s 
 link_to content_class.model_name.human(:count => 2), skyline_browser_tabs_content_item_path(content_class, :referable_id => params[:referable_id]), :class => (active ? "active" : nil), :remote => true 
 end 
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
 
 
 link_to_function t(:cancel, :scope => [:buttons]), "Skyline.Dialog.current.cancel()", :class => "cancel" 
 link_to_function button_text(:ok), "Skyline.Dialog.current.select()", :class => "button small green" 
 t(:dialog_title, :scope => [:browser,:content]) 

end

    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 tabs = ["Skyline::Content"] 
 tabs.each do |tab| 
 "active" if @active_tab == tab 
 t(tab, :scope => [:browser,:tabs]) 
 end 
 t('error', :scope => [:browser, :content])
 link_to_function t(:cancel, :scope => [:buttons]), "Skyline.Dialog.current.cancel()", :class => "cancel" 

end

    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 tabs = ["Skyline::Content"] 
 tabs.each do |tab| 
 "active" if @active_tab == tab 
 t(tab, :scope => [:browser,:tabs]) 
 end 
  @content_item.andand.id 
 @content_item.andand.class.andand.name 
 @content_selection.each do |content_class| 
 active = content_class == @content_type 
 content_class.to_s 
 link_to content_class.model_name.human(:count => 2), skyline_browser_tabs_content_item_path(content_class, :referable_id => params[:referable_id]), :class => (active ? "active" : nil), :remote => true 
 end 
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
 
 
 link_to_function t(:cancel, :scope => [:buttons]), "Skyline.Dialog.current.cancel()", :class => "cancel" 
 link_to_function button_text(:ok), "Skyline.Dialog.current.select()", :class => "button small green" 
 t(:dialog_title, :scope => [:browser,:content]) 

end

  end
  
  protected
  
  def extract_valid_selection(content_selection)
    return Skyline::Configuration.articles unless content_selection.present?
    
    result = []
    content_selection.split(',').each do |content|
      begin
        class_name = content.constantize
        result << class_name if Skyline::Configuration.articles.include? class_name
      rescue NameError
        return false
      end
    end
    
    result.any? ? result : false
  end
end
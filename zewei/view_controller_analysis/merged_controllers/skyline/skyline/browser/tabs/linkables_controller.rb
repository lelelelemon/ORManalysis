class Skyline::Browser::Tabs::LinkablesController < Skyline::ApplicationController
  
  def show
    @linkable_type = Skyline::Linkable.linkables.find{|l| l.name == params[:id]}
    @linkables = @linkable_type.all
    @linkable = @linkable_type.find_by_id(params[:referable_id])    
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @linkable_type.name 
 @linkable_type.human_attribute_name(:title) if @linkable_type 
 if @linkables.present? 
 selected_row = nil 
 @linkables.each do |linkable| 
 selected_row = "linkable_#{linkable.id}" if linkable == @linkable 
 cycle("odd","even") 
 "selected" if linkable == @linkable 
 linkable.id 
 linkable.url(:mode => :cms) || linkable.id 
 linkable.id 
 linkable.class.name 
 linkable.title 
 tick_image(linkable.published?) 
 linkable.title.blank? ? "&nbsp;" : linkable.title 
 end 
 end 
 if selected_row 
 selected_row 
 end 
 

end

  end
  
end
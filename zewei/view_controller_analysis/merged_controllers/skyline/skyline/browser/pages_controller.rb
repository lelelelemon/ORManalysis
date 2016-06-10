class Skyline::Browser::PagesController < Skyline::ApplicationController
  def index
    @pages = Skyline::Page.group_by_parent_id
    
    @active_tab = "Skyline::Page"
    @page = Skyline::Page.find_by_id(params[:referable_id]) if params[:referable_id].present?
    
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 ["Skyline::Page"].each do |tab| 
 "active" if @active_tab == tab 
 t(tab, :scope => [:browser,:tabs]) 
 end 
  page_tree(@pages,@pages[nil],
            :node_url => Proc.new{|p| skyline_article_article_version_url(p.id, p["default_variant_id"]) },
            :selected => @page, 
            :id_prefix => "browser_page") 
 @page && @page.id 
hidden_field_tag "browser[referable_title]", @page && @page.default_variant_data.andand.navigation_title || "", :id => "browser_page_referable_title" 
 @page && @page.id 
 @page && skyline_article_article_version_url(@page, @page.default_variant) || "javascript:''"  
 
 link_to_function t(:cancel, :scope => [:buttons]), "Skyline.Dialog.current.cancel()", :class => "cancel" 
 link_to_function button_text(:ok), "Skyline.Dialog.current.select()", :class => "button small green" 
 t(:dialog_title, :scope => [:browser,:page]) 

end

  end
end
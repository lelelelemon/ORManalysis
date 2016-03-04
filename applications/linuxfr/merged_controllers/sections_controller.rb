# encoding: utf-8
class SectionsController < ApplicationController

  def index
    @sections = Section.published
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Les sections" 
 @sections.each do |section| 
 div_for section do 
 link_to section do 
 image_tag section.image, alt: section.title, title: section.title 
 section.title 
 end 
 end 
 end 

end

  end

  def show
    @section  = Section.find(params[:id])
    path      = section_path(id: @section, format: params[:format])
    redirect_to path, status: 301 and return if request.path != path
    @sections = Section.published
    @order    = params[:order]
    @order    = "created_at" unless VALID_ORDERS.include?(@order)
    @news     = @section.news.with_node_ordered_by(@order).page(params[:page])
    respond_to do |wants|
      wants.html
      wants.atom
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :column do 
  link_to "Les sections", '/sections' 
 list_of(@sections) do |section| 
 link_to section.title, section 
 end 
 
 end 
 h1 @section.title 
 feed "Flux Atom des dpches de #{@section.title}" 
 paginated_contents @news, link_to("Proposer une dpche", "/news/nouveau") 

end

  end

end

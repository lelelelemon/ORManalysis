# encoding: UTF-8
class Admin::SectionsController < AdminController
  before_action :find_section, only: [:edit, :update, :destroy]

  def index
    @sections = Section.all
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Les sections" 
 link_to "Crer une section", new_admin_section_path 
 if @sections.empty? 
 else 
 @sections.each do |section| 
 link_to section.title, section 
 image_tag(section.image, alt: section.title) 
 section.state == "published" ? "publie" : "archive" 
 link_to "Modifier", edit_admin_section_path(section) 
 button_to "Archiver", [:admin, section], method: :delete, data: { confirm: "Archiver la section ?" }, class: "delete_button" 
 end 
 end 

end

  end

  def new
    @section = Section.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Nouvelle section" 
 form_for [:admin, @section] do |form| 
 render form 
 end 

end

  end

  def create
    @section = Section.new(params[:section])
    if @section.save
      redirect_to admin_sections_url, notice: 'Nouvelle section créée.'
    else
      flash.now[:alert] = "Impossible d'enregistrer cette section"
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Nouvelle section" 
 form_for [:admin, @section] do |form| 
 render form 
 end 

end

    end
  end

  def edit
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Modifier cette section" 
 form_for [:admin, @section] do |form| 
 render form 
 end 

end

  end

  def update
    @section.attributes = params[:section]
    if @section.save
      redirect_to admin_sections_url, notice: 'Section mise à jour.'
    else
      flash.now[:alert] = "Impossible d'enregistrer cette section"
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Modifier cette section" 
 form_for [:admin, @section] do |form| 
 render form 
 end 

end

    end
  end

  def destroy
    @section.archive
    redirect_to admin_sections_url, notice: 'Section supprimée'
  end

protected

  def find_section
    @section = Section.find(params[:id])
  end

end

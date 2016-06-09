# encoding: UTF-8
class Admin::SectionsController < AdminController
  before_action :find_section, only: [:edit, :update, :destroy]

  def index
    @sections = Section.all
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def new
    @section = Section.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def create
    @section = Section.new(params[:section])
    if @section.save
      redirect_to admin_sections_url, notice: 'Nouvelle section créée.'
    else
      flash.now[:alert] = "Impossible d'enregistrer cette section"
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

    end
  end

  def edit
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def update
    @section.attributes = params[:section]
    if @section.save
      redirect_to admin_sections_url, notice: 'Section mise à jour.'
    else
      flash.now[:alert] = "Impossible d'enregistrer cette section"
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|

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

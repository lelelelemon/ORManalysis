# encoding: UTF-8
class Admin::PagesController < AdminController
  before_action :find_page, only: [:edit, :update, :destroy]

  def index
    @pages = Page.all
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def new
    @page = Page.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def create
    @page = Page.new(params[:page])
    if @page.save
      redirect_to admin_pages_url, notice: 'Nouvelle page créée.'
    else
      flash.now[:alert] = "Impossible d'enregistrer cette page"
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

    end
  end

  def edit
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def update
    @page.attributes = params[:page]
    if @page.save
      redirect_to admin_pages_url, notice: 'Page mise à jour.'
    else
      flash.now[:alert] = "Impossible d'enregistrer cette page"
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

    end
  end

  def destroy
    @page.destroy
    redirect_to admin_pages_url, notice: 'Page supprimée'
  end

protected

  def find_page
    @page = Page.find_by(slug: params[:id])
  end
end

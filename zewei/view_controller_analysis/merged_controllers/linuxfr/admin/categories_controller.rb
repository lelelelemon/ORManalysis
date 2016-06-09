# encoding: UTF-8
class Admin::CategoriesController < AdminController
  before_action :load_category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.all
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def new
    @category = Category.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect_to admin_categories_url, notice: 'Nouvelle catégorie créée.'
    else
      flash.now[:alert] = "Impossible d'enregistrer cette catégorie"
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

    end
  end

  def edit
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def update
    @category.attributes = params[:category]
    if @category.save
      redirect_to admin_categories_url, notice: 'Catégorie mise à jour.'
    else
      flash.now[:alert] = "Impossible d'enregistrer cette catégorie"
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

    end
  end

  def destroy
    @category.delete
    redirect_to admin_categories_url, notice: 'Catégorie supprimée'
  end

protected

  def load_category
    @category = Category.find(params[:id])
  end

end

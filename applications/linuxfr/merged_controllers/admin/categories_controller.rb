# encoding: UTF-8
class Admin::CategoriesController < AdminController
  before_action :load_category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.all
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Les catgories" 
 link_to "Crer une catgorie", new_admin_category_path 
 if @categories.empty? 
 else 
 @categories.each do |category| 
 category.title 
 link_to "Modifier", edit_admin_category_path(category) 
 button_to "Supprimer", [:admin, category], method: :delete, data: { confirm: "Supprimer la catgorie ?" }, class: "delete_button" 
 end 
 end 

end

  end

  def new
    @category = Category.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Nouvelle catgorie" 
 form_for [:admin, @category] do |form| 
 render form 
 end 

end

  end

  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect_to admin_categories_url, notice: 'Nouvelle catégorie créée.'
    else
      flash.now[:alert] = "Impossible d'enregistrer cette catégorie"
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Nouvelle catgorie" 
 form_for [:admin, @category] do |form| 
 render form 
 end 

end

    end
  end

  def edit
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Modifier cette catgorie" 
 form_for [:admin, @category] do |form| 
 render form 
 end 

end

  end

  def update
    @category.attributes = params[:category]
    if @category.save
      redirect_to admin_categories_url, notice: 'Catégorie mise à jour.'
    else
      flash.now[:alert] = "Impossible d'enregistrer cette catégorie"
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Modifier cette catgorie" 
 form_for [:admin, @category] do |form| 
 render form 
 end 

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

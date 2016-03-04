# encoding: UTF-8
class Admin::BannersController < AdminController
  before_action :load_banner, only: [:update, :destroy]

  def index
    @banners = Banner.all
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Bannire de la page d'accueil" 
 if @banners.empty? 
 else 
 @banners.each do |banner| 
 banner.title 
 banner.content 
 banner.active ? "Oui" : "Non" 
 link_to "Modifier", edit_admin_banner_path(banner) 
 button_to "Supprimer", [:admin, banner], method: :delete, data: { confirm: "Supprimer la bannire ?" }, class: "delete_button" 
 end 
 end 
 link_to "Ajouter une bannire", new_admin_banner_path 

end

  end

  def new
    @banner = Banner.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Nouvelle bannire" 
  
 if @preview_mode 
 @banner.content 
 end 
 form_for [:admin, @banner] do |form| 
 render form 
 end 

end

  end

  def create
    @banner = Banner.new(params[:banner])
    if !preview_mode && @banner.save
      redirect_to admin_banners_url, notice: 'Nouvelle bannière créée.'
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Nouvelle bannire" 
  
 if @preview_mode 
 @banner.content 
 end 
 form_for [:admin, @banner] do |form| 
 render form 
 end 

end

    end
  end

  def edit
    @banner = Banner.find(params[:id])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Modifier cette bannire" 
  
 @banner.content 
 form_for [:admin, @banner] do |form| 
 render form 
 end 

end

  end

  def update
    @banner.attributes = params[:banner]
    if !preview_mode && @banner.save
      redirect_to admin_banners_url, notice: 'Bannière mise à jour.'
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Modifier cette bannire" 
  
 @banner.content 
 form_for [:admin, @banner] do |form| 
 render form 
 end 

end

    end
  end

  def destroy
    @banner.destroy
    redirect_to admin_banners_url, notice: 'Bannière supprimée'
  end

protected

  def load_banner
    @banner = Banner.find(params[:id])
  end

end

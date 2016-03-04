# encoding: UTF-8
class StylesheetsController < ApplicationController
  before_action :authenticate_account!
  before_action :load_account

  def create
    @account.uploaded_stylesheet = params[:uploaded_stylesheet]
    if @account.save
      Rails.logger.info @account.uploaded_stylesheet
      msg = { notice: "Feuille de style enregistrée" }
    else
      msg = { alert: "Erreur lors de l'enregistrement de la feuille de style" }
    end
    redirect_to edit_stylesheet_url, msg
  end

  def edit
    @stylesheets = Stylesheet.all
    @current = @account.stylesheet
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Feuilles de style alternatives" 
 button_to "CSS par dfaut", "/stylesheet", method: :delete, class: "ok_button" 
 form_tag "/stylesheet", method: :put do 
 @stylesheets.each do |css| 
 css.name 
 css.url 
 css.name 
 css.image 
 end 
 end 
 form_tag "/stylesheet", method: :put do 
 label_tag :stylesheet, "Pour utiliser une feuille de style externe, veuillez saisir son URL :" 
 text_field_tag :stylesheet 
 submit_tag 'OK' 
 end 
 form_tag "/stylesheet", multipart: true do 
 label_tag :uploaded_stylesheet, "Pour utiliser une feuille de style prsente sur votre ordinateur, veuillez l'uploader :" 
 file_field_tag :uploaded_stylesheet 
 submit_tag 'OK' 
 end 

end

  end

  def update
    if params[:css_session] == "current"
      cookies[:stylesheet] = params[:stylesheet]
      msg = { notice: "Feuille de style définie pour cette session uniquement" }
    else
      cookies.delete(:stylesheet)
      @account.stylesheet = params[:stylesheet]
      if @account.save
        @account.remove_uploaded_stylesheet!
        msg = { notice: "Feuille de style enregistrée" }
      else
        msg = { alert: "Cette feuille de style n'est pas valide" }
      end
    end
    redirect_to edit_stylesheet_url, msg
  end

  def destroy
    cookies.delete(:stylesheet)
    @account.remove_uploaded_stylesheet!
    @account.stylesheet = nil
    @account.save
    redirect_to edit_stylesheet_url, notice: "Feuille de style par défaut"
  end

protected

  def load_account
    @account = current_account
  end

end

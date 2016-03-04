# encoding: UTF-8
class Admin::StylesheetsController < AdminController

  def show
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Feuilles de style" 
 form_tag admin_stylesheet_path do 
 end 

end

  end

  def create
    Stylesheet.temporary(current_account, params[:url]) do
      redirect_to "/" + Stylesheet.capture("http://#{MY_DOMAIN}/", cookies)
    end
  end

end

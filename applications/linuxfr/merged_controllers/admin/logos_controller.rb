# encoding: UTF-8
class Admin::LogosController < AdminController

  def show
    @logos   = Logo.all
    @current = Logo.image
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Changer de logo" 
 form_tag admin_logo_path do 
 @logos.each do |logo| 
 end 
 end 

end

  end

  def create
    Logo.image = params[:logo]
    redirect_to admin_logo_url, notice: "Changement de logo enregistré"
  end

end

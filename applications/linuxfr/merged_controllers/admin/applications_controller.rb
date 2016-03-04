# encoding: UTF-8
class Admin::ApplicationsController < AdminController
  before_action :load_application, only: [:show, :edit, :update, :destroy]

  def index
    @applications = Doorkeeper::Application.page(params[:page])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Les applications pour l'API" 
 @applications.each do |app| 
 app.name 
 app.redirect_uri 
 link_to "Afficher", [:admin, app], class: "show_client_app" 
 link_to "Modifier", edit_admin_application_path(app), class: "edit_client_app" 
 button_to "Supprimer", [:admin, app], method: :delete, class: "delete_button", data: { confirm: "tes-vous sr de vouloir supprimer cette application ?" } 
 end 
 paginate @applications 

end

  end

  def show
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Application #{@application.name}" 
 link_to "Revenir  la liste des applications", admin_applications_path 

end

  end

  def edit
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Modifier cette application" 
 form_for [:admin, @application] do |form| 
 render form 
 end 

end

  end

  def update
    @application.attributes = params[:application]
    if @application.save
      redirect_to admin_applications_url, notice: 'Application mise à jour.'
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Modifier cette application" 
 form_for [:admin, @application] do |form| 
 render form 
 end 

end

    end
  end

  def destroy
    @application.destroy
    redirect_to admin_applications_url, notice: 'Application supprimée'
  end

protected

  def load_application
    @application = Doorkeeper::Application.find(params[:id])
  end

end

# encoding: UTF-8
class Admin::ApplicationsController < AdminController
  before_action :load_application, only: [:show, :edit, :update, :destroy]

  def index
    @applications = Doorkeeper::Application.page(params[:page])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def show
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def edit
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def update
    @application.attributes = params[:application]
    if @application.save
      redirect_to admin_applications_url, notice: 'Application mise à jour.'
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|

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

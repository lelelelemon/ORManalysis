# encoding: UTF-8
class Admin::ResponsesController < AdminController
  before_action :find_response, only: [:edit, :update, :destroy]

  def index
    @responses = Response.all
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def new
    @response = Response.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def create
    @response = Response.new(params[:response])
    if @response.save
      redirect_to admin_responses_url, notice: 'Nouvelle réponse créée.'
    else
      flash.now[:alert] = "Impossible d'enregistrer cette réponse"
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

    end
  end

  def edit
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def update
    @response.attributes = params[:response]
    if @response.save
      redirect_to admin_responses_url, notice: 'Réponse mise à jour.'
    else
      flash.now[:alert] = "Impossible d'enregistrer cette réponse"
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

    end
  end

  def destroy
    @response.destroy
    redirect_to admin_responses_url, notice: 'Réponse supprimée'
  end

protected

  def find_response
    @response = Response.find(params[:id])
  end

end

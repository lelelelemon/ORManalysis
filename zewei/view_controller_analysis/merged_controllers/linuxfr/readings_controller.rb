# encoding: utf-8
#
class ReadingsController < ApplicationController
  before_action :authenticate_account!
  before_action :find_node, only: [:destroy]

  def index
    @order = params[:order]
    @order = "last_commented_at" unless VALID_ORDERS.include?(@order)
    @nodes = Node.readings_of(current_account.id).order("#{@order} DESC").page(params[:page])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :column do 
 button_to "Tout oublier", readings_path, method: :delete, class: "delete_button" 
 end 
 h1 "Les derniers contenus que j'ai lus" 
 paginated_section @nodes do 
 render @nodes.map(&:content) 
 end 

end

  end

  def destroy
    @node.unread_by(current_account.id)
    respond_to do |wants|
     wants.json { render json: { notice: "Ce contenu n'est plus marqué comme lu" } }
     wants.html { redirect_to_content @node.content }
    end
  end

  def destroy_all
    Node.unread_all_by(current_account.id)
    redirect_to readings_path
  end

protected

  def find_node
    @node = Node.find(params[:id])
    enforce_view_permission(@node.content)
  end

end

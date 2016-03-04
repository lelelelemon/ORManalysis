# encoding: utf-8
class HomeController < ApplicationController
  before_action :google_plus

  DEFAULT_TYPES = %w(News Poll)

  def index
    @sections = Section.published
    @types  = current_account.try(:types_on_home)
    @types  = DEFAULT_TYPES if @types.blank?
    default = current_account.try(:sort_by_date_on_home) ? "created_at" : "interest"
    @order  = params[:order]
    @order  = default unless VALID_ORDERS.include?(@order)
    @ppp    = Node.ppp
    @banner = Banner.random
    @poll   = Poll.current
    @nodes  = Node.public_listing(@types, @order).page(params[:page])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :column do 
  if @poll 
 link_to @poll.title, controller: "polls", action: "show", id: @poll.to_param, results: 1 
 render("polls/answers_#{poll_current_or_archived @poll}", poll: @poll, id_suffix: "_sidebar") 
 end 
 
 end 
 feed "Flux Atom des dpches", "/news.atom" 
 title "Accueil" 
 cache_unless account_signed_in?, "home/#{@order}/#{@nodes.current_page}", expires_in: 1.minute do 
 if @ppp 
 render @ppp 
 end 
 if @banner 
 @banner 
 end 
 paginated_section @nodes, link_to("Proposer une dpche", "/news/nouveau") do 
 render @nodes.map(&:content) 
 end 
 end 

end

  end

protected

  def google_plus
    @google_plus = true
  end

end

# encoding: utf-8
class ForumsController < ApplicationController
  before_action :find_forums
  before_action :get_order
  caches_page   :index, if: Proc.new { |c| c.request.format.atom? && !c.request.ssl? }
  caches_page   :show,  if: Proc.new { |c| c.request.format.atom? && !c.request.ssl? }

  def index
    @nodes = Node.public_listing(Post, @order).page(params[:page])
    respond_to do |wants|
      wants.html
      wants.atom
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :column do 
  @forums.group_by(&:first_level).each do |title,forums| 
 title 
 forums.each do |forum| 
 link_to (forum.active? ? forum.second_level : "("+forum.second_level+")" ), forum 
 end 
 end 
 
 end 
 h1 "Les forums" 
 feed "Flux Atom des forums" 
 new_content_link = link_to("Poster dans les forums", "/posts/nouveau") if current_account 
 paginated_nodes @nodes, new_content_link 

end

  end

  def show
    @forum = Forum.find(params[:id])
    @posts = @forum.posts.with_node_ordered_by(@order).page(params[:page])
    flash.now[:alert] = "Attention, ce forum a été archivé et n'accueille plus de nouvelles discussions." unless @forum.active?
    respond_to do |wants|
      wants.html
      wants.atom
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :column do 
  @forums.group_by(&:first_level).each do |title,forums| 
 title 
 forums.each do |forum| 
 link_to (forum.active? ? forum.second_level : "("+forum.second_level+")" ), forum 
 end 
 end 
 
 end 
 h1 "Les messages du forum #{@forum.title}" 
 feed "Flux Atom du forum #{@forum.title}", "/forums/#{@forum.to_param}.atom" 
 new_content_link = link_to("Poster dans les forums", controller: 'posts', action: 'new', forum_id: @forum.id) if current_account 
 paginated_contents @posts, new_content_link 

end

  end

protected

  def find_forums
    @forums = Forum.sorted
  end

  def get_order
    @order = params[:order]
    @order = "created_at" unless VALID_ORDERS.include?(@order)
  end

end

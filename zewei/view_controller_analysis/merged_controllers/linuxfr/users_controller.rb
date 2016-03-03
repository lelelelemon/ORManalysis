# encoding: utf-8
class UsersController < ApplicationController
  before_action :find_user

  def show
    path = user_path(id: @user, format: params[:format])
    redirect_to path, status: 301 and return if request.path != path
    find_nodes([News, Diary])
    respond_to do |wants|
      wants.html
      wants.atom
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :column do 
  
 end 
 h1 "#{@user.name} a crit #{pluralize @nodes.total_count, "contenu"}" 
 feed "Flux Atom de #{@user.name}", "/users/#{@user.to_param}.atom" 
 paginated_nodes @nodes 

end

  end

  def news
    path = news_user_path(id: @user, format: params[:format])
    redirect_to path, status: 301 and return if request.path != path
    find_nodes(News)
    respond_to do |wants|
      wants.html
      wants.atom { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Les dpches" 
 feed "Flux Atom des dpches" 
 paginated_nodes @nodes, link_to("Proposer une dpche", "/news/nouveau") 

end
 }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :column do 
  
 end 
 h1 "#{@user.name} a crit #{pluralize @nodes.total_count, "dpche"}" 
 feed "Flux Atom des dpches de #{@user.name}" 
 paginated_nodes @nodes 

end

  end

  def journaux
    path = journaux_user_path(id: @user, format: params[:format])
    redirect_to path, status: 301 and return if request.path != path
    find_nodes(Diary)
    respond_to do |wants|
      wants.html
      wants.atom { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Les journaux" 
 feed "Flux Atom des journaux" 
 new_content_link = link_to("crire un journal", "/journaux/nouveau") if current_account 
 paginated_nodes @nodes, new_content_link 

end
 }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :column do 
  
 end 
 h1 "#{@user.name} a crit #{pluralize @nodes.total_count, "journal"}" 
 feed "Flux Atom des journaux de #{@user.name}" 
 paginated_nodes @nodes 

end

  end

  def posts
    path = posts_user_path(id: @user, format: params[:format])
    redirect_to path, status: 301 and return if request.path != path
    find_nodes(Post)
    respond_to do |wants|
      wants.html
      wants.atom { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :column do 
  
 end 
 h1 "#{@user.name} a crit #{pluralize @nodes.total_count, "post"}" 
 feed "Flux Atom des posts de #{@user.name}" 
 paginated_nodes @nodes 

end

  end

  def suivi
    path = suivi_user_path(id: @user, format: params[:format])
    redirect_to path, status: 301 and return if request.path != path
    find_nodes(Tracker)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :column do 
  
 end 
 h1 "#{@user.name} a crit #{pluralize @nodes.total_count, "entre"} sur le suivi" 
 paginated_nodes @nodes 

end

  end

  def wiki
    path = wiki_user_path(id: @user, format: params[:format])
    redirect_to path, status: 301 and return if request.path != path
    @versions = @user.wiki_versions.order("created_at DESC").page(params[:page])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def comments
    path = comments_user_path(id: @user, format: params[:format])
    redirect_to path, status: 301 and return if request.path != path
    @dont_index = true
    @comments = @user.comments.published.order('created_at DESC').page(params[:page])
    respond_to do |wants|
      wants.html
      wants.atom { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Les commentaires" 
 @comments.each do |comment| 
 render comment 
 end 

end
 }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :column do 
  
 end 
 h1 "#{@user.name} a crit #{pluralize @comments.total_count, "commentaire"}" 
 feed "Flux Atom des commentaires de #{@user.name}" 
 paginate @comments 
 @comments.each do |comment| 
 render comment 
 end 
 paginate @comments 

end

  end

protected

  def find_user
    @user = User.find(params[:id])
    raise ActiveRecord::RecordNotFound.new unless @user
    @contents = @user.nodes.visible.by_date.limit(20)
  end

  def find_nodes(klass)
    @dont_index = params.has_key?(:page)
    @order = params[:order]
    @order = "created_at" unless VALID_ORDERS.include?(@order)
    @nodes = Node.public_listing(klass, @order).where("nodes.user_id" => @user.id).page(params[:page])
  end

end

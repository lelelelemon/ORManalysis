# encoding: UTF-8
class Admin::ForumsController < AdminController
  before_action :find_forum, except: [:index, :new, :create]

  def index
    @forums = Forum.sorted.all
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Les forums" 
 link_to "Crer un forum", new_admin_forum_path 
 if @forums.empty? 
 else 
 @forums.each do |forum| 
 link_to forum.title, forum 
 button_to "&uarr;".html_safe, higher_admin_forum_path(forum) 
 button_to "&darr;".html_safe, lower_admin_forum_path(forum) 
 link_to "Modifier", edit_admin_forum_path(forum) 
 if forum.active? 
 button_to "Archiver", archive_admin_forum_path(forum), data: { confirm: "Archiver le forum ?" }, class: "archive_button" 
 else 
 button_to "R-ouvrir", reopen_admin_forum_path(forum), data: { confirm: "R-ouvrir le forum ?" }, class: "reopen_button" 
 end 
 button_to "Supprimer", [:admin, forum], method: :delete, data: { confirm: "Supprimer le forum ?" }, class: "delete_button" 
 end 
 end 

end

  end

  def new
    @forum = Forum.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Crer un nouveau forum" 
 form_for [:admin, @forum] do |form| 
 render form 
 end 

end

  end

  def create
    @forum = Forum.new
    @forum.attributes = params[:forum]
    if @forum.save
      @forum.move_to_bottom
      redirect_to admin_forums_url, notice: "Forum créé"
    else
      flash.now[:alert] = "Impossible d'enregistrer ce forum"
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Crer un nouveau forum" 
 form_for [:admin, @forum] do |form| 
 render form 
 end 

end

    end
  end

  def edit
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Modifier un forum" 
 form_for [:admin, @forum] do |form| 
 render form 
 end 

end

  end

  def update
    @forum.attributes = params[:forum]
    if @forum.save
      redirect_to admin_forums_url, notice: "Forum modifié"
    else
      flash.now[:alert] = "Impossible d'enregistrer ce forum"
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Modifier un forum" 
 form_for [:admin, @forum] do |form| 
 render form 
 end 

end

    end
  end

  def archive
    @forum.archive
    redirect_to admin_forums_url, notice: "Forum archivé"
  end

  def reopen
    @forum.reopen
    redirect_to admin_forums_url, notice: "Forum ré-ouvert"
  end

  def destroy
    @forum.destroy
    redirect_to admin_forums_url, notice: "Forum supprimé"
  end

  def lower
    @forum.move_lower
    redirect_to admin_forums_url
  end

  def higher
    @forum.move_higher
    redirect_to admin_forums_url
  end

protected

  def find_forum
    @forum = Forum.find(params[:id])
  end

end

# encoding: UTF-8
class Admin::ForumsController < AdminController
  before_action :find_forum, except: [:index, :new, :create]

  def index
    @forums = Forum.sorted.all
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def new
    @forum = Forum.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

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

end

    end
  end

  def edit
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def update
    @forum.attributes = params[:forum]
    if @forum.save
      redirect_to admin_forums_url, notice: "Forum modifié"
    else
      flash.now[:alert] = "Impossible d'enregistrer ce forum"
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|

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

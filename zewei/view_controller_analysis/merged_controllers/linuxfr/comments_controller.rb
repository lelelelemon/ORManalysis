# encoding: UTF-8
class CommentsController < ApplicationController
  before_action :authenticate_account!, except: [:index, :show]
  before_action :find_node, except: [:templeet]
  before_action :find_comment, except: [:index, :new, :answer, :create, :templeet]

  def index
    @comments = @node.comments.published.order('id DESC')
    respond_to do |wants|
      wants.html
      wants.atom
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Les commentaires" 
 @comments.each do |comment| 
 render comment 
 end 

end

  end

  def show
    enforce_view_permission(@comment)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def new
    @comment = @node.comments.build
    enforce_create_permission(@comment)
  rescue Canable::Transgression
    if current_account.blocked?
      flash[:alert] = "L'équipe de modération a temporairement bloqué vos commentaires sur le site"
    else
      flash[:alert] = "Impossible de commenter un contenu vieux de plus de 3 mois"
    end
    redirect_to_content @node.content
  end

  def answer
    new
    @comment.parent_id = params[:id]
    render :new if current_account.can_create?(@comment)
  end

  def create
    @comment = @node.comments.build
    enforce_create_permission(@comment)
    @comment.attributes = comment_params
    @comment.user = current_account.user
    @comment.default_score
    if !preview_mode && @comment.save
      flash[:notice] = "Votre commentaire a bien été posté"
      redirect_to url_for_content(@node.content) + "#comment-#{@comment.id}"
    else
      @comment.valid?
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

    end
  end

  def edit
    enforce_update_permission(@comment)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "diter un commentaire" 
  link_to spellcheck(preview.title), "#", class: "title" 
 posted_by(preview) 
 avatar_img(current_user) 
 spellcheck(preview.body) 
 if current_user.signature.present? && !current_account.try(:hide_signature?) 
 current_user.signature 
 end 
 if preview.parent.try(:user_id) == current_account.user_id 
 image_tag "/images/dessins/geekscottes_005.png", alt: "Autosatisfaction rcursive", title: "Autosatisfaction rcursive -  Johann 'nojhan' Dro : 2005-03-25 - Licence CC By-Sa 2.5" 
 elsif preview.parent.try(:depth).to_i > 10 
 image_tag "/images/dessins/discussion.png", alt: "Discussion", title: "Discussion -  Boug metoogotmy.net : 2012 - Licence CC By-Sa 2.0 Fr" 
 end 
 
 form_for [@comment.node, @comment] do |form| 
 render form 
 end 
 if current_account && current_account.can_destroy?(@comment) 
 button_to "Supprimer ce commentaire", [@comment.node, @comment], method: :delete, data: { confirm: "tes-vous sr de vouloir supprimer ce commentaire ?" }, class: "delete_button" 
 end 
  image_tag "/images/markdown.png", alt: "Markdown", title: "Ce site prend en charge la syntaxe Markdown", class: "markdown" 
 

end

  end

  def update
    enforce_update_permission(@comment)
    @comment.attributes = comment_params
    if !preview_mode && @comment.save
      flash[:notice] = "Votre commentaire a bien été modifié"
      redirect_to_content @node.content
    else
      flash.now[:alert] = "Impossible d'enregistrer ce commentaire" if @comment.invalid?
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "diter un commentaire" 
  link_to spellcheck(preview.title), "#", class: "title" 
 posted_by(preview) 
 avatar_img(current_user) 
 spellcheck(preview.body) 
 if current_user.signature.present? && !current_account.try(:hide_signature?) 
 current_user.signature 
 end 
 if preview.parent.try(:user_id) == current_account.user_id 
 image_tag "/images/dessins/geekscottes_005.png", alt: "Autosatisfaction rcursive", title: "Autosatisfaction rcursive -  Johann 'nojhan' Dro : 2005-03-25 - Licence CC By-Sa 2.5" 
 elsif preview.parent.try(:depth).to_i > 10 
 image_tag "/images/dessins/discussion.png", alt: "Discussion", title: "Discussion -  Boug metoogotmy.net : 2012 - Licence CC By-Sa 2.0 Fr" 
 end 
 
 form_for [@comment.node, @comment] do |form| 
 render form 
 end 
 if current_account && current_account.can_destroy?(@comment) 
 button_to "Supprimer ce commentaire", [@comment.node, @comment], method: :delete, data: { confirm: "tes-vous sr de vouloir supprimer ce commentaire ?" }, class: "delete_button" 
 end 
  image_tag "/images/markdown.png", alt: "Markdown", title: "Ce site prend en charge la syntaxe Markdown", class: "markdown" 
 

end

    end
  end

  def destroy
    enforce_destroy_permission(@comment)
    @comment.mark_as_deleted
    flash[:notice] = "Votre commentaire a bien été supprimé"
    redirect_to_content @node.content
  end

  def templeet
    comment = Comment.find(params[:id])
    redirect_to [comment.node, comment], status: :moved_permanently
  end

protected

  def comment_params
    params.require(:comment).permit(:title, :wiki_body, :node_id, :parent_id)
  end

  def find_node
    @node = Node.find(params[:node_id])
  end

  def find_comment
    @comment = @node.comments.find(params[:id])
  end
end

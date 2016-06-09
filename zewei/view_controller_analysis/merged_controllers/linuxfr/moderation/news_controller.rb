# encoding: UTF-8
class Moderation::NewsController < ModerationController
  before_action :find_news, except: [:index]
  after_action  :expire_cache, only: [:update, :accept]
  after_action  :marked_as_read, only: [:show, :update, :vote]
  respond_to :html, :md

  def index
    @news    = News.candidate.sorted
    @drafts  = News.draft.sorted
    @refused = News.refused.order("updated_at DESC").limit(15)
    @polls   = Poll.draft
    @boards  = Board.all(Board.amr)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def show
    enforce_view_permission(@news)
    path = moderation_news_path(@news, format: params[:format])
    redirect_to path, status: 301 and return if request.path != path
    @boards = Board.all(Board.news, @news.id)
    headers["Cache-Control"] = "no-cache, no-store, must-revalidate, max-age=0"
    flash.now[:alert] = "Attention, cette dépêche a été supprimée et n'est visible que par les modérateurs" if @news.deleted?
    flash.now[:alert] = "Attention, cette dépêche a été refusée et n'est visible que par les modérateurs" if @news.refused?
    respond_to do |wants|
      wants.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 title @news.title 
 content_for :chat do 
  if @news.urgent? 
 end 
 @news.voters_for 
 @news.voters_against 
 if current_account.can_vote?(@news) 
 button_to "Pour", "/nodes//vote/for", remote: true, class: "vote_for" 
 button_to "Contre", "/nodes//vote/against", remote: :true, class: "vote_against" 
 end 
 if @news.published? 
 if @news.on_ppp? 
 elsif current_account.can_ppp?(@news) 
 button_to "Mettre en phare", ppp_moderation_news_path(@news), class: "ppp_news" 
 end 
 elsif @news.refused? 
 else 
 if @news.acceptable? && current_account.can_accept?(@news) 
 button_to "Publier", accept_moderation_news_path(@news), class: "publish_news" 
 elsif @news.refusable? && current_account.can_refuse?(@news) 
 button_to "Refuser", refuse_moderation_news_path(@news), class: "refuse_news" 
 if @news.node.cc_licensed? 
 button_to "Re-rdaction", rewrite_moderation_news_path(@news), class: "rewrite_news" 
 end 
 elsif current_account.admin? 
 button_to "Publier", accept_moderation_news_path(@news), class: "publish_news" 
 button_to "Refuser", refuse_moderation_news_path(@news), class: "refuse_news" 
 button_to "Revoter", reset_moderation_news_path(@news), class: "reset_news" 
 if @news.node.cc_licensed? 
 button_to "Re-rdaction", rewrite_moderation_news_path(@news), class: "rewrite_news" 
 end 
 end 
 end 
 
 end 
 if @news.paragraphs.any? 
 article_for @news do |c| 
 c.title = capture do 
  @news.section.title 
 @news.title 
 
 end 
 c.meta  = news_posted_by(@news) 
 c.image = link_to(image_tag(@news.section.image, alt: @news.section.title), @news.section) 
 c.body  = capture do 
  paragraph.body 
 user_id = paragraph.locked_by 
 if user_id && user_id.to_i != current_account.user_id 
 u = User.find(user_id) 
 u.avatar_url 
 end 
 
 end 
 end 
 link_to "Rorganiser", reorganize_redaction_news_path(@news), class: "reorganize" 
 if @news.urgent? 
 button_to "Enlever l'urgence", cancel_urgent_redaction_news_path(@news), class: "urgent_news" 
 else 
 button_to "Marquer comme urgent", urgent_redaction_news_path(@news), class: "urgent_news", data: { confirm: "Cette dpche est urgente et doit tre publie au plus tt ?" } 
 end 
 else 
 form_for [:moderation, @news] do |form| 
 form.label :title, "Titre de la dpche" 
 form.text_field :title, autocomplete: 'off', required: 'required', spellcheck: 'true' 
 form.label :section_id, "Section de la dpche" 
 form.collection_select :section_id, Section.published, :id, :title 
 form.label :body, "Contenu de la dpche (<strong>HTML, pas de syntaxe wiki</strong>)".html_safe 
 form.text_area :body, required: 'required', spellcheck: 'true', class: 'markItUp' 
 form.fields_for :links do |lform| 
 lform.text_field :title 
 lform.url_field :url 
 lform.select :lang, Lang.all 
 end 
 form.label :second_part, "Seconde partie" 
 form.text_area :second_part, spellcheck: 'true', class: 'markItUp' 
 form.submit "Enregistrer" 
 end 
 end 
 image_tag "/images/icones/edit-cut.png", alt: "Suggestion de dcoupe" 
  image_tag "/images/markdown.png", alt: "Markdown", title: "Ce site prend en charge la syntaxe Markdown", class: "markdown" 
 

end
 }
      wants.js { ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end
 }
      wants.md { @news.put_paragraphs_together }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def edit
    enforce_update_permission(@news)
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def update
    enforce_update_permission(@news)
    @news.attributes = news_params
    @news.editor = current_account
    @news.save
    if request.xhr?
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

    else
      redirect_to @news, notice: "Modification enregistrée"
    end
  end

  def accept
    enforce_accept_permission(@news)
    if @news.unlocked?
      @news.moderator_id = current_user.id
      @news.accept!
      NewsNotifications.accept(@news).deliver
      redirect_to @news, alert: "Dépêche acceptée"
    else
      redirect_to [:moderation, @news], alert: "Impossible de modérer la dépêche tant que quelqu'un est en train de la modifier"
    end
  end

  def refuse
    enforce_refuse_permission(@news)
    if params[:message]
      @news.moderator_id = current_user.id
      @news.put_paragraphs_together
      @news.refuse!
      notif = NewsNotifications.refuse_with_message(@news, params[:message], params[:template])
      notif.deliver if notif
      redirect_to '/'
    elsif @news.unlocked?
      @boards = Board.all(Board.news, @news.id)
    else
      redirect_to [:moderation, @news], alert: "Impossible de modérer la dépêche tant que quelqu'un est train de la modifier"
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def rewrite
    enforce_rewrite_permission(@news)
    if @news.unlocked?
      @news.moderator_id = current_user.id
      @news.rewrite!
      NewsNotifications.rewrite(@news).deliver
      redirect_to @news, alert: "Dépêche renvoyée en rédaction"
    else
      redirect_to [:moderation, @news], alert: "Impossible de modérer la dépêche tant que quelqu'un est en train de la modifier"
    end
  end

  def reset
    enforce_reset_permission(@news)
    @news.reset_votes
    redirect_to [:moderation, @news], notice: "Votes remis à zéro"
  end

  def ppp
    enforce_ppp_permission(@news)
    @news.set_on_ppp
    redirect_to [:moderation, @news], notice: "Cette dépêche est maintenant affichée en phare"
  end

  def vote
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end
end

protected

  def news_params
    params.require(:news).permit(:title, :section_id, :wiki_body, :wiki_second_part, :body, :second_part,
                                 links_attributes: [Link::Accessible])
  end

  def find_news
    @news = News.find(params[:id])
  end

  def marked_as_read
    current_account.read(@news.node) unless params[:format] == "md"
  end

  def expire_cache
    return if @news.state == "candidate"
    expire_page controller: '/news', action: :index, format: :atom
  end
end

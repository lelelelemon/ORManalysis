# encoding: UTF-8
class Redaction::NewsController < RedactionController
  skip_before_action :authenticate_account!, only: [:index, :moderation]
  before_action :load_news, except: [:index, :moderation, :create, :revision, :reorganize, :reorganized, :reassign, :urgent, :cancel_urgent]
  before_action :load_news2, only: [:revision, :reorganize, :reorganized, :reassign, :urgent, :cancel_urgent]
  before_action :load_board, only: [:show, :reorganize]
  after_action  :marked_as_read, only: [:show, :update]
  respond_to :html, :atom, :md

  def index
    @news = News.draft.sorted
    respond_with @news
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Nouvelles dpches" 
 if @news.empty? 
 else 
 render @news 
 end 
 button_to "Commencer une nouvelle dpche", '/redaction/news', class: "create_news" 

end

  end

  def moderation
    @news = News.candidate.sorted
    respond_with @news
  end

  def create
    @news = News.create_for_redaction(current_account)
    path = redaction_news_path(@news)
    redirect_to path, status: 301 if request.path != path
  end

  def show
    path = redaction_news_path(@news, format: params[:format])
    redirect_to [:redaction, @news], status: 301 and return if request.path != path
    headers["Cache-Control"] = "no-cache, no-store, must-revalidate, max-age=0"
    @news.put_paragraphs_together if params[:format] == "md"
    respond_with @news, layout: 'chat_n_edit'
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 title @news.title 
 content_for :chat do 
 link_to "Retourner sur la liste des dpches en cours de rdaction", '/redaction' 
 if @news.urgent? 
 end 
   board = boards.build 
 Push.private_key(board.meta) 
 if current_account && current_account.can_post_on_board? 
  form_tag "/board", class: 'chat' do 
 hidden_field :board, :object_type, value: form.object_type 
 hidden_field :board, :object_id, value: form.object_id 
 text_field :board, :message, value: '', size: 80, autocomplete: 'off', required: 'required', spellcheck: 'true', autofocus: (form.object_type == Board.free) 
 submit_tag 'Envoyer', class: "submit_board" 
 end 
 
 end 
  board.id 
 board.user_agent 
 board.created_at.iso8601 
 norloge(board, box) 
 board.user_link 
 board.message 
 
 
 
  list_of(attendees) do |a| 
 link_to a.name, a, title: pluralize(a.nb_editions, "dition") 
 if current_account.can_reassign?(@news) 
 button_to "Rattribuer", reassign_redaction_news_path(user_id: a.id), class: "reassign_news", title: "Rattribuer la paternit de cette dpche" 
 end 
 end 
 if current_account.can_reassign?(@news) 
 button_to "Rattribuer", reassign_redaction_news_path(user_id: User.collective.id), class: "reassign_news", title: "Rattribuer la paternit de cette dpche" 
 end 
 
  Push.private_key(news) 
 list_of(news.versions) do |v| 
 link_to "#{v.author_name}&nbsp;: #{v.message} - #{l v.created_at}".html_safe, "/redaction/news/#{news.to_param}/revisions/#{v.version}" 
 end 
 
 end 
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
 u.name 
 paragraph.id 
 u.avatar_url 
 u.name 
 end 
 
 end 
 end 
 link_to "Rorganiser", reorganize_redaction_news_path(@news), class: "reorganize" 
 if current_account.amr? || current_account.editor? || @news.submitted_by?(current_account) 
 button_to "Soumettre la dpche", submit_redaction_news_path(@news), class: "submit_news" 
 if @news.urgent? 
 button_to "Enlever l'urgence", cancel_urgent_redaction_news_path(@news), class: "urgent_news" 
 else 
 button_to "Marquer comme urgent", urgent_redaction_news_path(@news), class: "urgent_news", data: { confirm: "Cette dpche est urgente et doit tre publie au plus tt ?" } 
 end 
 end 
 if current_account.can_erase? @news 
 button_to "Effacer la dpche", erase_redaction_news_path(@news), class: "erase_news", data: { confirm: "Effacer cette dpche cre par erreur ?" } 
 end 
 if current_account.can_followup? @news 
 form_tag followup_redaction_news_path(@news) do 
 text_area_tag :message, nil, rows: 10 
 submit_tag 'Envoyer' 
 end 
 end 
  image_tag "/images/markdown.png", alt: "Markdown", title: "Ce site prend en charge la syntaxe Markdown", class: "markdown" 
 

end

  end

  def revision
    @version  = @news.versions.find_by!(version: params[:revision])
    @previous = @version.higher_item || NewsVersion.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def edit
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_for [:redaction, @news] do |form| 
 form.label :section_id, "Section" 
 form.collection_select :section_id, Section.published, :id, :title 
 form.label :title, "Titre" 
 form.text_field :title, autocomplete: 'off', required: 'required', spellcheck: 'true', maxlength: 100 
 form.submit "OK" 
 end 

end
end

  def update
    @news.attributes = news_params
    @news.editor = current_account
    @news.save
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @news.section.title 
 @news.title 

end

  end

  def reassign
    enforce_reassign_permission(@news)
    @news.reassign_to params[:user_id], current_user.name
    namespace = @news.draft? ? :redaction : :moderation
    redirect_to [namespace, @news], notice: "L'auteur initial de la dépêche a été changé"
  end

  def reorganize
    if @news.lock_by(current_user)
      @news.put_paragraphs_together
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 title @news.title 
 content_for :chat do 
   board = boards.build 
 Push.private_key(board.meta) 
 if current_account && current_account.can_post_on_board? 
  form_tag "/board", class: 'chat' do 
 hidden_field :board, :object_type, value: form.object_type 
 hidden_field :board, :object_id, value: form.object_id 
 text_field :board, :message, value: '', size: 80, autocomplete: 'off', required: 'required', spellcheck: 'true', autofocus: (form.object_type == Board.free) 
 submit_tag 'Envoyer', class: "submit_board" 
 end 
 
 end 
  board.id 
 board.user_agent 
 board.created_at.iso8601 
 norloge(board, box) 
 board.user_link 
 board.message 
 
 
 
 end 
 form_for @news, url: reorganized_redaction_news_path(@news), method: :put do |form| 
 form.label :section_id, "Section" 
 form.collection_select :section_id, Section.published, :id, :title 
 form.label :title, "Titre" 
 form.text_field :title, autocomplete: 'off', required: 'required', spellcheck: 'true', maxlength: 100 
 form.label :wiki_body, "Contenu de la dpche" 
 form.text_area :wiki_body, required: 'required', spellcheck: 'true', class: 'markItUp' 
 form.fields_for :links do |lform| 
 lform.text_field :title 
 lform.url_field :url 
 lform.select :lang, Lang.all 
 end 
 form.label :wiki_second_part, "Seconde partie" 
 form.text_area :wiki_second_part, spellcheck: 'true', class: 'markItUp' 
 form.submit "OK" 
 end 
  image_tag "/images/markdown.png", alt: "Markdown", title: "Ce site prend en charge la syntaxe Markdown", class: "markdown" 
 

end

    else
      render status: :forbidden, text: "Désolé, un verrou a déjà été posé sur cette dépêche !"
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 title @news.title 
 content_for :chat do 
   board = boards.build 
 Push.private_key(board.meta) 
 if current_account && current_account.can_post_on_board? 
  form_tag "/board", class: 'chat' do 
 hidden_field :board, :object_type, value: form.object_type 
 hidden_field :board, :object_id, value: form.object_id 
 text_field :board, :message, value: '', size: 80, autocomplete: 'off', required: 'required', spellcheck: 'true', autofocus: (form.object_type == Board.free) 
 submit_tag 'Envoyer', class: "submit_board" 
 end 
 
 end 
  board.id 
 board.user_agent 
 board.created_at.iso8601 
 norloge(board, box) 
 board.user_link 
 board.message 
 
 
 
 end 
 form_for @news, url: reorganized_redaction_news_path(@news), method: :put do |form| 
 form.label :section_id, "Section" 
 form.collection_select :section_id, Section.published, :id, :title 
 form.label :title, "Titre" 
 form.text_field :title, autocomplete: 'off', required: 'required', spellcheck: 'true', maxlength: 100 
 form.label :wiki_body, "Contenu de la dpche" 
 form.text_area :wiki_body, required: 'required', spellcheck: 'true', class: 'markItUp' 
 form.fields_for :links do |lform| 
 lform.text_field :title 
 lform.url_field :url 
 lform.select :lang, Lang.all 
 end 
 form.label :wiki_second_part, "Seconde partie" 
 form.text_area :wiki_second_part, spellcheck: 'true', class: 'markItUp' 
 form.submit "OK" 
 end 
  image_tag "/images/markdown.png", alt: "Markdown", title: "Ce site prend en charge la syntaxe Markdown", class: "markdown" 
 

end

  end

  def reorganized
    @news.editor = current_account
    @news.reorganize news_params
    redirect_to [@news.draft? ? :redaction : :moderation, @news]
  end

  def followup
    enforce_followup_permission(@news)
    NewsNotifications.followup(@news, params[:message]).deliver
    redirect_to [:redaction, @news], notice: "Courriel de relance envoyé"
  end

  def submit
    if @news.unlocked?
      @news.submit_and_notify(current_user)
      redirect_to '/redaction', notice: "Dépêche soumise à la modération"
    else
      redirect_to [:redaction, @news], alert: "Impossible de soumettre la dépêche car quelqu'un est encore en train de la modifier"
    end
  end

  def erase
    enforce_erase_permission(@news)
    @news.erase!
    redirect_to '/redaction', notice: "Dépêche effacée"
  end

  def urgent
    @news.urgent!
    namespace = @news.draft? ? :redaction : :moderation
    redirect_to [namespace, @news]
  end

  def cancel_urgent
    @news.no_more_urgent!
    namespace = @news.draft? ? :redaction : :moderation
    redirect_to [namespace, @news]
  end

protected

  def news_params
    params.require(:news).permit(:title, :section_id, :wiki_body, :wiki_second_part,
                                 links_attributes: [Link::Accessible])
  end

  def load_news
    @news = News.draft.find(params[:id])
    enforce_update_permission(@news)
  end

  def load_news2
    @news = News.find(params[:id])
    enforce_update_permission(@news)
  end

  def load_board
    @boards = Board.all(Board.news, @news.id)
  end

  def marked_as_read
    current_account.read(@news.node) unless params[:format] == "md"
  end
end

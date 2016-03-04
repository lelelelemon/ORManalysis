# encoding: utf-8
class RedactionController < ApplicationController
  before_action :authenticate_account!
  append_view_path NoNamespaceResolver.new

  def index
    @boards = Board.all(Board.writing)
    @board  = @boards.build
    @drafts = News.draft.sorted
    @news   = News.candidate.sorted
    @stats  = Statistics::Redaction.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 link_to "tes-vous inscrit  la liste de diffusion des rdacteurs ?", "/news/une-liste-de-diffusion-pour-les-redacteurs-de-linuxfr-org" 
 link_to "Avez-vous lu la page d'aide  la rdaction ?", "/wiki/redaction" 
 h1 "Tribune rdacteurs" 
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
 
 
 list_of @stats.top_month do |stat| 
 end 
 link_to "Autres statistiques sur la rdaction", "/statistiques/redaction" 
 feed "Flux atom des dpches en cours de rdaction", "/redaction/news.atom" 
 button_to "Commencer une nouvelle dpche", "/redaction/news", class: "create_news" 
 link_to "Rgles de modration", "/regles_de_moderation" 
 if @drafts.empty? 
 else 
 link_to "Afficher toutes les dpches", "/redaction/news" 
 list_of @drafts do |n| 
 if n.node.board_status(current_account) == :new_board 
 image_tag "/images/icones/chat.svg", alt: "Nouveaux !", title: "Il y a de l'activit sur cette dpche", width: "16px" 
 end 
 link_to n.title, [:redaction, n] 
 end 
 end 
 feed "Flux atom des dpches en cours de modration", "/redaction/news/moderation.atom" 
 if @news.empty? 
 else 
 list_of @news do |n| 
 n.title 
 end 
 end 

end

  end
end

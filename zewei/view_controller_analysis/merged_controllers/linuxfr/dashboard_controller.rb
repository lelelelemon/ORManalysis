# encoding: utf-8
class DashboardController < ApplicationController
  before_action :authenticate_account!
  before_action :reset_notifications, only: [:index]

  def index
    @self_answer = params[:self] == "1"
    @comments = current_user.comments.on_dashboard.limit(30)
    @comments = @comments.where(answered_to_self: false) unless @self_answer
    @posts    = Node.where(user_id: current_user.id).on_dashboard(Post).limit(10)
    @trackers = Node.where(user_id: current_user.id).on_dashboard(Tracker).limit(10)
    @news     = News.where(author_email: current_account.email).candidate
    @drafts   = News.where(author_email: current_account.email).draft
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Votre tableau de bord" 
  if @drafts.empty? 
 else 
 @drafts.each do |news| 
 news.section.title 
 link_to news.title, [:redaction, news] 
 l news.created_at 
 end 
 end 
 
  if @news.empty? 
 else 
 @news.each do |news| 
 news.section.title 
 if current_account.amr? 
 link_to news.title, [:moderation, news] 
 else 
 news.title 
 end 
 l news.node.created_at 
 end 
 end 
 
  if @comments.empty? 
 else 
 if @self_answer 
 link_to "Ne pas inclure les rponses  mes commentaires", self: nil 
 else 
 link_to "Inclure les rponses  mes commentaires", self: "1" 
 end 
 @comments.each do |comment| 
 next if comment.node.nil? 
 answer = comment.last_answer 
 link_to comment.title, path_for_content(comment.node.content) + "#comment-#{comment.id}" 
 comment.created_at.to_s(:posted) 
 comment.bound_score 
 if answer && !answer.read_by?(current_account) 
 image_tag "/images/icones/comment.png", alt: "Nouveaux commentaires !", class: "thread-new-comments" 
 end 
 comment.nb_answers 
 answer ? answer.created_at.to_s(:posted) : "&nbsp;".html_safe 
 end 
 end 
 
  if @posts.empty? 
 else 
 @posts.each do |node| 
 post = node.content 
 post.forum.title 
 link_to post.title, [post.forum, post] 
 node.score 
 node.comments.count 
 post.created_at.to_s(:posted) 
 end 
 end 
 
  if @trackers.empty? 
 else 
 @trackers.each do |node| 
 tracker = node.content 
 tracker.state 
 tracker.category.title 
 link_to tracker.title, tracker 
 tracker.state_name 
 node.score 
 node.comments.count 
 tracker.created_at.to_s(:posted) 
 end 
 end 
 

end

  end

  def answers
    render json: { node_ids: current_account.answers_node_id }
  end

protected

  def reset_notifications
    current_account.reset_answers_notifications
  end

end

# encoding: UTF-8
class PollsController < ApplicationController
  skip_before_action :verify_authenticity_token , only: [:vote]
  before_action :verify_referer_or_authenticity_token, only: [:vote]
  before_action :authenticate_account!, only: [:new, :create]
  before_action :find_poll, only: [:show, :vote]
  after_action  :marked_as_read, only: [:show], if: :account_signed_in?
  caches_page   :index, if: Proc.new { |c| c.request.format.atom? && !c.request.ssl? }
  respond_to :html, :atom, :md

  def index
    @order = params[:order]
    @order = "created_at" unless VALID_ORDERS.include?(@order)
    @polls = Poll.archived.joins(:node).order("nodes.#{@order} DESC").page(params[:page])
    if on_the_first_page?
      poll = Poll.current
      @polls.unshift(poll) if poll
    end
    respond_with(@polls)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Les sondages" 
 feed "Flux Atom des sondages" 
 new_content_link = link_to("Proposer un sondage", "/sondages/nouveau") if current_account 
 paginated_contents @polls, new_content_link 

end

  end

  def show
    enforce_view_permission(@poll)
    redirect_to [:moderation, @poll] unless @poll.published? || @poll.archived?
    @poll.state = 'archived' if params.has_key? :results
    path = poll_path(@poll, format: params[:format])
    headers['Link'] = %(<#{poll_url @poll}>; rel="canonical")
    redirect_to path, status: 301 and return if request.path != path
  end

  def new
    @poll = Poll.new
    enforce_create_permission(@poll)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Suggrer un sondage" 
  article_for preview do |c| 
 c.title = "#{link_to "Sondage", "/sondages", class: "topic"} #{link_to spellcheck(preview.title), "#"}".html_safe 
 c.body  = capture do 
 if preview.explanations 
 preview.explanations 
 end 
  form_tag "/sondages/#{poll.new_record? ? 0 : poll.to_param}/vote", id: "#{dom_id poll}#{id_suffix}" do 
 poll.answers.each_with_index do |answer,index| 
 radio_button_tag :position, answer.position, false, id: "position_#{index}#{id_suffix}" 
 label_tag "position_#{index}#{id_suffix}", answer.formatted 
 end 
 pluralize poll.total_votes, "vote" 
 submit_tag "Voter" if poll.published? 
 end 
 
 end 
 end 
 
 form_for setup_poll(@poll) do |form| 
 render form 
 end 

end

  end

  def create
    @poll = Poll.new
    enforce_create_permission(@poll)
    @poll.attributes = poll_params
    @poll.tmp_owner_id = current_account.user_id
    if !preview_mode && @poll.save
      redirect_to polls_url, notice: "L'équipe de modération de LinuxFr.org vous remercie pour votre proposition de sondage"
    else
      @poll.node = Node.new
      @poll.valid?
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Suggrer un sondage" 
  article_for preview do |c| 
 c.title = "#{link_to "Sondage", "/sondages", class: "topic"} #{link_to spellcheck(preview.title), "#"}".html_safe 
 c.body  = capture do 
 if preview.explanations 
 preview.explanations 
 end 
  form_tag "/sondages/#{poll.new_record? ? 0 : poll.to_param}/vote", id: "#{dom_id poll}#{id_suffix}" do 
 poll.answers.each_with_index do |answer,index| 
 radio_button_tag :position, answer.position, false, id: "position_#{index}#{id_suffix}" 
 label_tag "position_#{index}#{id_suffix}", answer.formatted 
 end 
 pluralize poll.total_votes, "vote" 
 submit_tag "Voter" if poll.published? 
 end 
 
 end 
 end 
 
 form_for setup_poll(@poll) do |form| 
 render form 
 end 

end

    end
  end

  def vote
    enforce_answer_permission(@poll)
    @answer = @poll.answers.where(position: params[:position]).first
    if @answer
      @answer.vote(request.remote_ip)
      redirect_to @poll, notice: "Merci d'avoir voté pour ce sondage"
    else
      redirect_to @poll, alert: "Veuillez choisir une proposition avant de voter"
    end
  end

protected

  def poll_params
    params.require(:poll).permit(:title, :wiki_explanations, :cc_licensed,
                                 answers_attributes: [:answer])
  end

  def on_the_first_page?
    params[:page].to_i <= 1
  end

  def find_poll
    @poll = Poll.find(params[:id])
  end

  def marked_as_read
    current_account.read(@poll.node) unless params[:format] == "md"
  end

  def enforce_answer_permission(poll)
    raise Canable::Transgression unless poll.answerable_by?(request.remote_ip)
  end
end

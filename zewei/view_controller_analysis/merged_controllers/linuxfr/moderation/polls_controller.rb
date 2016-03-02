# encoding: UTF-8
class Moderation::PollsController < ModerationController
  before_action :find_poll, except: [:index]
  after_action  :expire_cache, only: [:update, :accept]

  def index
    @polls = Poll.draft.order("id DESC")
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Nouveaux sondages" 
 if @polls.empty? 
 link_to "En proposer un.", new_poll_path 
 else 
 render @polls 
 end 

end

  end

  def show
    enforce_view_permission(@poll)
    flash.now[:alert] = "Attention, ce sondage a été supprimé et n'est visible que par les modérateurs" if @poll.deleted?
    flash.now[:alert] = "Attention, ce sondage a été refusé et n'est visible que par les modérateurs" if @poll.refused?
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 title @poll.title 
 content_for :column do 
  link_to "Modifier", edit_moderation_poll_path(id: @poll) 
 button_to "Publier", accept_moderation_poll_path(@poll), data: { confirm: "Publier le sondage ?" }, class: "ok_button" 
 button_to "Refuser", refuse_moderation_poll_path(@poll), data: { confirm: "Refuser le sondage ?" }, class: "delete_button" 
 
 end 
 render @poll 
 render @poll.node 

end

  end

  def accept
    enforce_accept_permission(@poll)
    @poll.accept!
    redirect_to @poll, notice: "Sondage accepté"
  end

  def refuse
    enforce_refuse_permission(@poll)
    @poll.refuse!
    redirect_to moderation_polls_url, notice: "Sondage refusé"
  end

  def edit
    enforce_update_permission(@poll)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "diter un sondage" 
 if @poll.draft? 
 button_to "Publier", accept_moderation_poll_path(@poll), data: { confirm: "Publier le sondage ?" }, class: "ok_button" 
 button_to "Refuser", refuse_moderation_poll_path(@poll), data: { confirm: "Refuser le sondage ?" }, class: "delete_button" 
 else 
 button_to "Mettre en phare", ppp_moderation_poll_path(@poll), class: "ppp_poll" 
 end 
 form_for [:moderation, setup_poll(@poll)] do |form| 
 render form 
 end 

end

  end

  def update
    enforce_update_permission(@poll)
    @poll.attributes = poll_params
    if @poll.save
      redirect_to [:moderation, @poll], notice: "Modification enregistrée"
    else
      flash.now[:alert] = "Impossible d'enregistrer ce sondage"
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "diter un sondage" 
 if @poll.draft? 
 button_to "Publier", accept_moderation_poll_path(@poll), data: { confirm: "Publier le sondage ?" }, class: "ok_button" 
 button_to "Refuser", refuse_moderation_poll_path(@poll), data: { confirm: "Refuser le sondage ?" }, class: "delete_button" 
 else 
 button_to "Mettre en phare", ppp_moderation_poll_path(@poll), class: "ppp_poll" 
 end 
 form_for [:moderation, setup_poll(@poll)] do |form| 
 render form 
 end 

end

    end
  end

  def ppp
    enforce_accept_permission(@poll)
    @poll.set_on_ppp
    redirect_to root_url, notice: "Le sondage a bien été mis en phare"
  end

protected

  def poll_params
    params.require(:poll).permit!
  end

  def find_poll
    @poll = Poll.find(params[:id])
  end

  def expire_cache
    return if @poll.state == "draft"
    expire_page controller: '/polls', action: :index, format: :atom
  end
end

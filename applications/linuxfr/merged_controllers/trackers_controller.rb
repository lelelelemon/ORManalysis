# encoding: UTF-8
class TrackersController < ApplicationController
  before_action :honeypot, only: [:create]
  before_action :authenticate_account!, only: [:edit, :update, :destroy]
  before_action :load_tracker, only: [:show, :edit, :update, :destroy]
  after_action  :marked_as_read, only: [:show], if: :account_signed_in?
  respond_to :html, :md

  def index
    @attrs    = {"state" => "opened"}.merge(params[:tracker] || {})
    @order    = params[:order]
    @order    = "created_at" unless VALID_ORDERS.include?(@order)
    @trackers = Tracker.all
    if @order == "created_at"
      @trackers = @trackers.order("#{@order} DESC")
    else
      @trackers = @trackers.joins(:node).order("nodes.#{@order} DESC")
    end
    @tracker  = Tracker.new(@attrs.except("state"))
    @tracker.state = @attrs["state"]
    @trackers = @trackers.where(state: @tracker.state)       if @attrs["state"].present?
    @trackers = @trackers.where(category_id: @tracker.category_id) if @attrs["category_id"].present?
    if @attrs["assigned_to_user_id"] == 0
      @trackers = @trackers.where(assigned_to_user_id: nil)
    elsif @attrs["assigned_to_user_id"].present?
      @trackers = @trackers.where(assigned_to_user_id: @tracker.assigned_to_user_id)
    end
    respond_to do |wants|
      wants.html { @trackers = @trackers.page(params[:page]).per(100) }
      wants.atom
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Le suivi des suggestions et bugs concernant le site" 
 feed "Flux Atom du suivi" 
 feed "Flux Atom des commentaires", "/suivi/comments.atom" 
 link_to "Flux Atom du suivi", "/suivi.atom" 
 link_to "Proposer une entre", "/suivi/nouveau" 
 form_for @tracker, url: trackers_path, method: :get do |f| 
 f.label :state, "tat&nbsp;: ".html_safe 
 f.select :state, Tracker::States.invert, include_blank: true 
 f.label :category_id, "Catgorie&nbsp;: ".html_safe 
 f.collection_select :category_id, Category.all, :id, :title, include_blank: true 
 f.label :assigned_to_user_id, "Assign &nbsp;: ".html_safe 
 f.collection_select :assigned_to_user_id, Account.admin, :id, :name, include_blank: true 
 label_tag :order, "Trier par&nbsp;: ".html_safe 
 select_tag :order, options_for_select({ "Date d'ouverture" => "created_at", "Note" => "score", "Nombre de commentaires" => "comments_count", "Dernier commentaire" => "last_commented_at" }, @order) 
 submit_tag "Filtrer" 
 end 
 if @trackers.empty? 
 else 
 @trackers.each do |tracker| 
 tracker.state 
 link_to tracker.id, tracker 
 link_to tracker.title, tracker 
 tracker.created_at.to_s(:posted) 
 tracker.assigned_to 
 tracker.user ? link_to(tracker.user.name, tracker.user) : "Anonyme" 
 link_to tracker.category_title, "/suivi?tracker%5Bcategory_id%5D=#{tracker.category_id}" 
 tracker.state_name 
 tracker.score 
 tracker.comments.count 
 if current_account && current_account.can_update?(tracker) 
 link_to "Modifier", "/suivi/#{tracker.to_param}/modifier" 
 else 
 end 
 end 
 paginate @trackers 
 end 

end

  end

  def comments
    @comments = Comment.published.joins(:node).where('nodes.content_type' => 'Tracker').order('created_at DESC').limit(20)
    respond_to do |wants|
      wants.atom
    end
  end

  def show
    enforce_view_permission(@tracker)
    path = tracker_path(@tracker, format: params[:format])
    headers['Link'] = %(<#{tracker_url @tracker}>; rel="canonical")
    redirect_to path, status: 301 if request.path != path
  end

  def new
    @tracker = Tracker.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Signaler un bug ou proposer une suggestion dans le suivi" 
 if @preview_mode 
  article_for preview do |c| 
 c.title = "#{link_to "Suivi - #{preview.category_title}", "/suivi", class: "topic"} #{link_to spellcheck(preview.title), preview}".html_safe 
 c.body  = spellcheck(preview.body) 
 end 
 
 else 
 image_tag "/images/dessins/geekscottes_068.png", alt: "Tu coderas pour moi !", title: "Tu coderas pour moi ! -  Johann 'nojhan' Dro : 2007-11-07 - Licence CC By-Sa 2.5" 
 end 
 form_for @tracker do |form| 
 render form 
 end 
  image_tag "/images/markdown.png", alt: "Markdown", title: "Ce site prend en charge la syntaxe Markdown", class: "markdown" 
 

end

  end

  def create
    @tracker = Tracker.new tracker_params
    @tracker.tmp_owner_id = current_user.try(:id)
    if !preview_mode && @tracker.save
      redirect_to @tracker, notice: "Votre entrée a bien été créée dans le suivi"
    else
      @tracker.node = Node.new
      @tracker.valid?
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Signaler un bug ou proposer une suggestion dans le suivi" 
 if @preview_mode 
  article_for preview do |c| 
 c.title = "#{link_to "Suivi - #{preview.category_title}", "/suivi", class: "topic"} #{link_to spellcheck(preview.title), preview}".html_safe 
 c.body  = spellcheck(preview.body) 
 end 
 
 else 
 image_tag "/images/dessins/geekscottes_068.png", alt: "Tu coderas pour moi !", title: "Tu coderas pour moi ! -  Johann 'nojhan' Dro : 2007-11-07 - Licence CC By-Sa 2.5" 
 end 
 form_for @tracker do |form| 
 render form 
 end 
  image_tag "/images/markdown.png", alt: "Markdown", title: "Ce site prend en charge la syntaxe Markdown", class: "markdown" 
 

end

    end
  end

  def edit
    enforce_update_permission(@tracker)
    @tracker.assigned_to_user ||= current_user
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Modifier une entre dans le suivi" 
  article_for preview do |c| 
 c.title = "#{link_to "Suivi - #{preview.category_title}", "/suivi", class: "topic"} #{link_to spellcheck(preview.title), preview}".html_safe 
 c.body  = spellcheck(preview.body) 
 end 
 
 form_for @tracker do |form| 
 render form 
 end 
 button_to "Supprimer", @tracker, method: :delete, data: { confirm: "tes-vous sr de vouloir supprimer cette entre du tracker ?" }, class: "delete_button" 
  image_tag "/images/markdown.png", alt: "Markdown", title: "Ce site prend en charge la syntaxe Markdown", class: "markdown" 
 

end

  end

  def update
    enforce_update_permission(@tracker)
    @tracker.attributes = tracker_params
    if !preview_mode && @tracker.save
      redirect_to @tracker, notice: "Entrée du suivi modifiée"
    else
      flash.now[:alert] = "Impossible d'enregistrer cette entrée de suivi" unless @tracker.valid?
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Modifier une entre dans le suivi" 
  article_for preview do |c| 
 c.title = "#{link_to "Suivi - #{preview.category_title}", "/suivi", class: "topic"} #{link_to spellcheck(preview.title), preview}".html_safe 
 c.body  = spellcheck(preview.body) 
 end 
 
 form_for @tracker do |form| 
 render form 
 end 
 button_to "Supprimer", @tracker, method: :delete, data: { confirm: "tes-vous sr de vouloir supprimer cette entre du tracker ?" }, class: "delete_button" 
  image_tag "/images/markdown.png", alt: "Markdown", title: "Ce site prend en charge la syntaxe Markdown", class: "markdown" 
 

end

    end
  end

  def destroy
    enforce_destroy_permission(@tracker)
    @tracker.mark_as_deleted
    redirect_to trackers_url, notice: "Entrée du suivi supprimée"
  end

protected

  def tracker_params
    if current_account.try(:admin?)
      params.require(:tracker).permit!
    else
      params.require(:tracker).permit(:title, :wiki_body, :category_id, :state)
    end
  end

  def honeypot
    honeypot = params[:tracker].delete(:pot_de_miel)
    render nothing: true if honeypot.present?
  end

  def marked_as_read
    current_account.read(@tracker.node) unless params[:format] == "md"
  end

  def load_tracker
    @tracker = Tracker.find(params[:id])
  end
end

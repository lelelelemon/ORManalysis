# encoding: UTF-8
class WikiPagesController < ApplicationController
  before_action :authenticate_account!, except: [:index, :show, :revision, :changes, :pages]
  before_action :load_wiki_page, only: [:edit, :update, :destroy, :revision]
  after_action  :marked_as_read, only: [:show], if: :account_signed_in?
  after_action  :expire_cache, only: [:create, :update, :destroy]
  caches_page   :index,   if: Proc.new { |c| c.request.format.atom? && !c.request.ssl? }
  caches_page   :changes, if: Proc.new { |c| c.request.format.atom? && !c.request.ssl? }
  respond_to    :html, :md

  def index
    respond_to do |wants|
      wants.html { redirect_to WikiPage.home_page }
      wants.atom { @wiki_pages = Node.public_listing(WikiPage, "created_at").map(&:content) }
    end
  end

  def show
    @wiki_page = WikiPage.find(params[:id])
    enforce_view_permission(@wiki_page)
    path = wiki_page_path(@wiki_page, format: params[:format])
    redirect_to path, status: 301 and return if request.path != path
    headers['Link'] = %(<#{wiki_page_url @wiki_page}>; rel="canonical")
    flash.now[:alert] = "Attention, cette page a été supprimée et n'est visible que par les admins" unless @wiki_page.visible?
    respond_with @wiki_page
  rescue ActiveRecord::RecordNotFound
    if current_account
      redirect_to new_wiki_page_url(title: params[:id])
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Page de wiki absente" 

end

    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :column do 
 if @wiki_page.home_page? 
  link_to "Afficher la liste des pages du wiki", "/wiki/pages" 
 link_to "Afficher les dernires modifications du wiki", "/wiki/modifications" 
 
 end 
  link_to "diter", "/wiki/#{edition.to_param}/modifier" 
 l edition.versions.first.created_at.to_date 
 list_of(edition.versions) do |v| 
 link_to "#{v.author_name}&nbsp;: #{v.message}".html_safe, "/wiki/#{edition.to_param}/revisions/#{v.version}" 
 end 
 
 end 
 title @wiki_page.title 
 meta_for @wiki_page 
 if @wiki_page.home_page? 
 feed "Flux Atom du wiki", "/wiki.atom" 
 end 
 render @wiki_page 
 render @wiki_page.node 

end

  end

  def new
    @wiki_page = WikiPage.new
    @wiki_page.title = params[:title]
    enforce_create_permission(@wiki_page)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Crer une page de wiki" 
  article_for preview do |c| 
 c.meta  = "" 
 c.title = "#{link_to "Wiki", "/wiki", class: "topic"} #{spellcheck h preview.title}".html_safe 
 c.body  = spellcheck(preview.body) 
 end 
 
 form_for @wiki_page do |form| 
 messages_on_error @wiki_page 
 form.label :title, "Titre" 
 form.text_field :title, autocomplete: 'off', required: 'required', spellcheck: 'true', maxlength: 100 
 render form 
 end 
  image_tag "/images/markdown.png", alt: "Markdown", title: "Ce site prend en charge la syntaxe Markdown", class: "markdown" 
 

end

  end

  def create
    @wiki_page = WikiPage.new
    @wiki_page.attributes = wiki_params :title
    @wiki_page.user_id = current_account.user_id
    enforce_create_permission(@wiki_page)
    if !preview_mode && @wiki_page.save
      redirect_to @wiki_page, notice: "Nouvelle page de wiki créée"
    else
      @wiki_page.node = Node.new
      @wiki_page.valid?
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Crer une page de wiki" 
  article_for preview do |c| 
 c.meta  = "" 
 c.title = "#{link_to "Wiki", "/wiki", class: "topic"} #{spellcheck h preview.title}".html_safe 
 c.body  = spellcheck(preview.body) 
 end 
 
 form_for @wiki_page do |form| 
 messages_on_error @wiki_page 
 form.label :title, "Titre" 
 form.text_field :title, autocomplete: 'off', required: 'required', spellcheck: 'true', maxlength: 100 
 render form 
 end 
  image_tag "/images/markdown.png", alt: "Markdown", title: "Ce site prend en charge la syntaxe Markdown", class: "markdown" 
 

end

    end
  end

  def edit
    @wiki_page.wiki_body = @wiki_page.versions.first.body
    enforce_update_permission(@wiki_page)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Modifier une page de wiki" 
  article_for preview do |c| 
 c.meta  = "" 
 c.title = "#{link_to "Wiki", "/wiki", class: "topic"} #{spellcheck h preview.title}".html_safe 
 c.body  = spellcheck(preview.body) 
 end 
 
 form_for @wiki_page do |form| 
 messages_on_error @wiki_page 
 render form 
 end 
 if current_account && current_account.can_destroy?(@wiki_page) 
 button_to "Supprimer", [@wiki_page], method: :delete, data: { confirm: "tes-vous sr de vouloir supprimer cette page de wiki ?" }, class: "delete_button" 
 end 
  image_tag "/images/markdown.png", alt: "Markdown", title: "Ce site prend en charge la syntaxe Markdown", class: "markdown" 
 

end

  end

  def update
    enforce_update_permission(@wiki_page)
    @wiki_page.attributes = wiki_params
    @wiki_page.user_id = current_account.user_id
    if !preview_mode && @wiki_page.save
      redirect_to @wiki_page, notice: "Modification enregistrée"
    else
      flash.now[:alert] = "Impossible d'enregistrer cette page de wiki" if @wiki_page.invalid?
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Modifier une page de wiki" 
  article_for preview do |c| 
 c.meta  = "" 
 c.title = "#{link_to "Wiki", "/wiki", class: "topic"} #{spellcheck h preview.title}".html_safe 
 c.body  = spellcheck(preview.body) 
 end 
 
 form_for @wiki_page do |form| 
 messages_on_error @wiki_page 
 render form 
 end 
 if current_account && current_account.can_destroy?(@wiki_page) 
 button_to "Supprimer", [@wiki_page], method: :delete, data: { confirm: "tes-vous sr de vouloir supprimer cette page de wiki ?" }, class: "delete_button" 
 end 
  image_tag "/images/markdown.png", alt: "Markdown", title: "Ce site prend en charge la syntaxe Markdown", class: "markdown" 
 

end

    end
  end

  def destroy
    enforce_destroy_permission(@wiki_page)
    @wiki_page.mark_as_deleted
    redirect_to WikiPage.home_page, notice: "Page de wiki supprimée"
  end

  def revision
    @dont_index = true
    enforce_view_permission(@wiki_page)
    @version = @wiki_page.versions.find_by_version!(params[:revision])
    previous = @version.higher_item
    @was     = previous ? previous.body : ''
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def changes
    @dont_index = true
    @versions = WikiVersion.order("created_at DESC")
                           .joins(:node)
                           .where("nodes.public" => true)
                           .page(params[:page])
    respond_to do |wants|
      wants.html
      wants.atom
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def pages
    @order = params[:order]
    @order = "created_at" unless VALID_ORDERS.include?(@order)
    @nodes = Node.public_listing(WikiPage, @order).page(params[:page])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Les pages du wiki" 
 feed "Flux Atom du wiki", "/wiki.atom" 
 new_content_link = link_to("crire une page de wiki", "/wiki/nouveau") if current_account 
 paginated_nodes @nodes, new_content_link 

end

  end

protected

  def wiki_params(*more)
    params.require(:wiki_page).permit(:wiki_body, :message, *more)
  end

  def marked_as_read
    current_account.read(@wiki_page.node) if @wiki_page.try(:node)
  end

  def load_wiki_page
    @wiki_page = WikiPage.find(params[:id])
  end

  def expire_cache
    return if @wiki_page.new_record?
    expire_page action: :index,   format: :atom
    expire_page action: :changes, format: :atom
  end
end

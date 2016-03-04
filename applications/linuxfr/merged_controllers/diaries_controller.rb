# encoding: UTF-8
class DiariesController < ApplicationController
  before_action :authenticate_account!, except: [:index, :show]
  before_action :find_diary, except: [:index, :new, :create]
  after_action  :marked_as_read, only: [:show], if: :account_signed_in?
  after_action  :expire_cache, only: [:create, :update, :destroy, :move]
  caches_page   :index, if: Proc.new { |c| c.request.format.atom? && !c.request.ssl? }
  respond_to :html, :atom, :md

### Global ###

  def index
    @order = params[:order]
    @order = "created_at" unless VALID_ORDERS.include?(@order)
    @nodes = Node.public_listing(Diary, @order).page(params[:page])
    respond_with(@nodes)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Les journaux" 
 feed "Flux Atom des journaux" 
 new_content_link = link_to("crire un journal", "/journaux/nouveau") if current_account 
 paginated_nodes @nodes, new_content_link 

end

  end

  def new
    @diary = current_user.diaries.build
    @diary.cc_licensed = true
    enforce_create_permission(@diary)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "crire un journal" 
  article_for preview do |c| 
 c.title = "#{link_to "Journal", "/journaux", class: "topic"} #{link_to spellcheck(preview.title), "#"}".html_safe 
 c.image = avatar_img(preview.node.user) 
 c.body  = spellcheck(preview.body) 
 end 
 
 form_for @diary do |form| 
 render form 
 end 
  image_tag "/images/markdown.png", alt: "Markdown", title: "Ce site prend en charge la syntaxe Markdown", class: "markdown" 
 

end

  end

  def create
    @diary = current_user.diaries.build
    enforce_create_permission(@diary)
    @diary.attributes = diary_params
    if !preview_mode && @diary.save
      current_account.tag(@diary.node, params[:tags])
      redirect_to [@diary.owner, @diary], notice: "Votre journal a bien été créé"
    else
      @diary.node = Node.new(user_id: current_user.id)
      @diary.valid?
      flash.now[:alert] = "Votre journal ne contient pas de liens. Êtes-vous sûr ?" unless @diary.body =~ /<a /
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "crire un journal" 
  article_for preview do |c| 
 c.title = "#{link_to "Journal", "/journaux", class: "topic"} #{link_to spellcheck(preview.title), "#"}".html_safe 
 c.image = avatar_img(preview.node.user) 
 c.body  = spellcheck(preview.body) 
 end 
 
 form_for @diary do |form| 
 render form 
 end 
  image_tag "/images/markdown.png", alt: "Markdown", title: "Ce site prend en charge la syntaxe Markdown", class: "markdown" 
 

end

    end
  end

### By user ###

  def show
    enforce_view_permission(@diary)
    path = user_diary_path(@user, @diary, format: params[:format])
    redirect_to path, status: 301 if request.path != path
    headers['Link'] = %(<#{user_diary_url @user, @diary}>; rel="canonical")
    flash.now[:alert] = "Attention, ce journal a été supprimé et n'est visible que par les admins" unless @diary.visible?
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 title @diary.title 
 meta_for @diary 
 render @diary 
 render @diary.node 

end

  end

  def edit
    enforce_update_permission(@diary)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "diter un journal" 
  article_for preview do |c| 
 c.title = "#{link_to "Journal", "/journaux", class: "topic"} #{link_to spellcheck(preview.title), "#"}".html_safe 
 c.image = avatar_img(preview.node.user) 
 c.body  = spellcheck(preview.body) 
 end 
 
 form_for [@diary.owner, @diary] do |form| 
 render form 
 end 
 form_for Post.new, url: move_user_diary_path(user_id: @diary.owner, id: @diary) do |form| 
 form.label :forum_id, "Forum" 
 form.select :forum_id, forums_select_list, { include_blank: true }, { required: "required" } 
 form.submit "Dplacer vers les forums", data: { confirm: "tes-vous sr de vouloir dplacer ce journal ?" } 
 end 
 button_to "Proposer en dpche", convert_user_diary_path(user_id: @diary.owner, id: @diary), class: "ok_button" 
 button_to "Supprimer", [@diary.owner, @diary], method: :delete, data: { confirm: "tes-vous sr de vouloir supprimer ce journal ?" }, class: "delete_button" 
  image_tag "/images/markdown.png", alt: "Markdown", title: "Ce site prend en charge la syntaxe Markdown", class: "markdown" 
 

end

  end

  def update
    enforce_update_permission(@diary)
    @diary.attributes = diary_params
    if !preview_mode && @diary.save
      redirect_to [@user, @diary], notice: "Le journal a bien été modifié"
    else
      flash.now[:alert] = "Impossible d'enregistrer ce journal" if @diary.invalid?
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "diter un journal" 
  article_for preview do |c| 
 c.title = "#{link_to "Journal", "/journaux", class: "topic"} #{link_to spellcheck(preview.title), "#"}".html_safe 
 c.image = avatar_img(preview.node.user) 
 c.body  = spellcheck(preview.body) 
 end 
 
 form_for [@diary.owner, @diary] do |form| 
 render form 
 end 
 form_for Post.new, url: move_user_diary_path(user_id: @diary.owner, id: @diary) do |form| 
 form.label :forum_id, "Forum" 
 form.select :forum_id, forums_select_list, { include_blank: true }, { required: "required" } 
 form.submit "Dplacer vers les forums", data: { confirm: "tes-vous sr de vouloir dplacer ce journal ?" } 
 end 
 button_to "Proposer en dpche", convert_user_diary_path(user_id: @diary.owner, id: @diary), class: "ok_button" 
 button_to "Supprimer", [@diary.owner, @diary], method: :delete, data: { confirm: "tes-vous sr de vouloir supprimer ce journal ?" }, class: "delete_button" 
  image_tag "/images/markdown.png", alt: "Markdown", title: "Ce site prend en charge la syntaxe Markdown", class: "markdown" 
 

end

    end
  end

  def destroy
    enforce_destroy_permission(@diary)
    @diary.mark_as_deleted
    redirect_to diaries_url, notice: "Le journal a bien été supprimé"
  end

  def convert
    enforce_update_permission(@diary)
    if @news = @diary.convert
      if current_account.amr?
        redirect_to [:moderation, @news]
      else
        redirect_to "/", notice: "Merci d'avoir proposé ce journal en dépêche"
      end
    else
      flash.now[:alert] = "Impossible de proposer ce journal en dépêche"
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "diter un journal" 
  article_for preview do |c| 
 c.title = "#{link_to "Journal", "/journaux", class: "topic"} #{link_to spellcheck(preview.title), "#"}".html_safe 
 c.image = avatar_img(preview.node.user) 
 c.body  = spellcheck(preview.body) 
 end 
 
 form_for [@diary.owner, @diary] do |form| 
 render form 
 end 
 form_for Post.new, url: move_user_diary_path(user_id: @diary.owner, id: @diary) do |form| 
 form.label :forum_id, "Forum" 
 form.select :forum_id, forums_select_list, { include_blank: true }, { required: "required" } 
 form.submit "Dplacer vers les forums", data: { confirm: "tes-vous sr de vouloir dplacer ce journal ?" } 
 end 
 button_to "Proposer en dpche", convert_user_diary_path(user_id: @diary.owner, id: @diary), class: "ok_button" 
 button_to "Supprimer", [@diary.owner, @diary], method: :delete, data: { confirm: "tes-vous sr de vouloir supprimer ce journal ?" }, class: "delete_button" 
  image_tag "/images/markdown.png", alt: "Markdown", title: "Ce site prend en charge la syntaxe Markdown", class: "markdown" 
 

end

    end
  end

  def move
    enforce_destroy_permission(@diary)
    if @diary.move_to_forum params.require(:post).permit(:forum_id)
      redirect_to diaries_url, notice: "Le journal a bien été déplacé vers les forums"
    else
      flash.now[:alert] = "Impossible de déplacer ce journal. Avez-vous bien choisi un forum ?"
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "diter un journal" 
  article_for preview do |c| 
 c.title = "#{link_to "Journal", "/journaux", class: "topic"} #{link_to spellcheck(preview.title), "#"}".html_safe 
 c.image = avatar_img(preview.node.user) 
 c.body  = spellcheck(preview.body) 
 end 
 
 form_for [@diary.owner, @diary] do |form| 
 render form 
 end 
 form_for Post.new, url: move_user_diary_path(user_id: @diary.owner, id: @diary) do |form| 
 form.label :forum_id, "Forum" 
 form.select :forum_id, forums_select_list, { include_blank: true }, { required: "required" } 
 form.submit "Dplacer vers les forums", data: { confirm: "tes-vous sr de vouloir dplacer ce journal ?" } 
 end 
 button_to "Proposer en dpche", convert_user_diary_path(user_id: @diary.owner, id: @diary), class: "ok_button" 
 button_to "Supprimer", [@diary.owner, @diary], method: :delete, data: { confirm: "tes-vous sr de vouloir supprimer ce journal ?" }, class: "delete_button" 
  image_tag "/images/markdown.png", alt: "Markdown", title: "Ce site prend en charge la syntaxe Markdown", class: "markdown" 
 

end

    end
  end

protected

  def diary_params
    params.require(:diary).permit(:title, :wiki_body, :cc_licensed)
  end

  def find_diary
    @user  = User.find(params[:user_id])
    @diary = @user.diaries.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    diary = Diary.find(params[:id])
    redirect_to [diary.owner, diary]
  end

  def marked_as_read
    current_account.read(@diary.node) unless params[:format] == "md"
  end

  def expire_cache
    return if @diary.new_record?
    expire_page action: :index, format: :atom
  end
end

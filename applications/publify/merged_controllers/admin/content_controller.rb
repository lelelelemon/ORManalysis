require 'base64'

class Admin::ContentController < Admin::BaseController
  layout :get_layout

  cache_sweeper :blog_sweeper

  def index
    @search = params[:search] ? params[:search] : {}
    @articles = this_blog.articles.search_with(@search).page(params[:page]).per(this_blog.admin_display_elements)

    if request.xhr?
      respond_to do |format|
        format.js {}
      end
    else
      @article = Article.new(params[:article])
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :page_heading do 
 t('.manage_articles') 
 link_to(t('.new_article'), {controller: 'content', action: 'new'}, id: 'dialog-link', class: 'btn btn-info pull-right') 
 end 
 form_tag({action: 'index'}, {method: :get, name: 'article', remote: true, class: 'form-inline spinnable', :"data-update-success" => 'articleList'}) do 
 if params[:search] and params[:search]['state'] 
 params[:search]['state'] 
 end 
 link_to(t('.all_articles'), {action: 'index'}, {class: 'label label-default'}) 
 link_to(t('.published'), {action: 'index', search: {state: 'published'}}, {class: 'label label-success'}) 
 link_to(t('.withdrawn'), {action: 'index', search: {state: 'withdrawn'}}, {class: 'label label-danger'}) 
 link_to(t('.drafts'), {action: 'index', search: {state: 'drafts'}}, {class: 'label label-info'}) 
 link_to(t('.publication_pending'), {action: 'index', search: {state: 'pending'}}, {class: 'label label-warning'}) 
 select_tag('search[user_id]', options_from_collection_for_select(User.all, 'id', 'name'), {prompt: t('.select_an_author'), class: 'form-control'}) 
 select_tag('search[published_at]', options_for_select(Article.find_by_published_at), {prompt: t('.publication_date'), class: 'form-control'}) 
 submit_tag(t('.search'), {class: 'btn btn-success'}) 
 image_tag('spinner.gif') 
  if @articles.empty? 
 t('.no_articles') 
 end 
 for article in @articles 
 if article.published 
 link_to_permalink(article, article.title, nil, 'published')
 else 
 link_to(article.title, {controller: '/articles', action: "preview", id: article.id}, {class: 'unpublished', target: '_new'}) 
 end 
 show_actions article 
 author_link(article)
 l(article.published_at) 
 (article.allow_comments?) ? link_to("#{article.comments.ham.size.to_s} <i class='glyphicon glyphicon-comment'></i>".html_safe, controller: '/admin/feedback', id: article.id, action: 'article') : '-' 
 end 
 display_pagination(@articles, 5, 'first', 'last')
 
 end 

end

  end

  def new
    @article = Article::Factory.new(this_blog, current_user).default
    load_resources
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_tag({action: 'create'}, id: 'article_form', multipart: true, class: 'autosave') do 
  hidden_field_tag 'user_textfilter', current_user.text_filter_name 
 hidden_field_tag('article[id]', @article.id) if @article.present? 
 link_to(t('.cancel'), {action: 'index'}, {class: 'btn btn-default'}) 
 link_to(t('.preview'), {controller: '/articles', action: 'preview', id: @article.id}, {target: 'new', class: 'btn btn-default'}) if @article.id 
 t('.save_as_draft') 
 controller.action_name == 'new' ? t('.publish') : t('.save') 
  if flash 
 flash.each do |alert_level, message| 
 flash[:error] ? 'danger' : 'success'
 alert_level.to_s.downcase 
 message 
 end 
 end 
 
 error_messages_for 'article' 
 @article.text_filter 
 text_field 'article', 'title', class: 'form-control', placeholder: t('.title') 
 text_area('article', 'body_and_extended', {class: 'form-control ', style: 'height: 360px', placeholder: t('.type_your_post'), :"data-widearea" => "enable"}) 
 t('.publish') 
 submit_tag(t('.publish'), class: 'btn btn-success pull-right') 
 t('.tags') 
 text_field 'article', 'keywords', {autocomplete: 'off', class: 'form-control tm-input'} 
t('.tags_explaination') 
 post_types = @post_types || [] 
 if post_types.size.zero? 
 hidden_field_tag 'article[post_type]', 'read' 
 else 
 t('.article_type') 
 select :article, :post_type, post_types.map{|pt| [pt.name, pt.permalink]}, {include_blank: t('.default')} 
 end 
 t('.publish_settings') 
 t('.permalink') 
 toggle_element('permalink') 
 text_field 'article', 'permalink', {autocomplete: 'off', class: 'form-control'} 
 toggle_element('permalink', t('.ok')) 
 t('.status') 
 @article.state.to_s.downcase 
 toggle_element('status') 
 check_box 'article', 'published'  
 t('.published') 
 toggle_element('status', t('.ok')) 
 t('.allowed_comments_and_trackbacks_html', allow_comment: content_tag(:strong, t('.allow_comments_status', count: @article.allow_comments ? 1 : 0)), allow_trackback: content_tag(:strong, t('.allow_pings_status', count: @article.allow_pings ? 1 : 0))) 
 toggle_element('conversation') 
 check_box 'article', 'allow_pings' 
 t('.allow_trackbacks') 
 check_box 'article', 'allow_comments' 
 t('.allow_comments') 
 toggle_element('conversation', t('.ok')) 
 t('.published') 
 if @article.published 
 display_date_and_time(@article.published_at) 
 else 
 t('.now') 
 end 
 toggle_element('publish') 
 text_field 'article', 'published_at' 
 toggle_element('publish', t('.ok')) 
 t('.visibility') 
 @article.password.blank? ? t('.public') : t('.protected') 
 toggle_element('visibility') 
 t('.password') 
 text_field 'article', 'password', class: 'form-control' 
 toggle_element('visibility', t('.ok')) 
 t('.cancel') 
 submit_tag(t('.publish'), class: 'btn btn-success') 
 
 end 

end

  end

  def edit
    return unless access_granted?(params[:id])
    @article = Article.find(params[:id])
    @article.text_filter ||= current_user.default_text_filter
    @article.keywords = Tag.collection_to_string @article.tags
    load_resources
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_tag({action: 'update', id: @article.id}, method: :put, multipart: true, id: "article_form", class: 'autosave') do 
  hidden_field_tag 'user_textfilter', current_user.text_filter_name 
 hidden_field_tag('article[id]', @article.id) if @article.present? 
 link_to(t('.cancel'), {action: 'index'}, {class: 'btn btn-default'}) 
 link_to(t('.preview'), {controller: '/articles', action: 'preview', id: @article.id}, {target: 'new', class: 'btn btn-default'}) if @article.id 
 t('.save_as_draft') 
 controller.action_name == 'new' ? t('.publish') : t('.save') 
  if flash 
 flash.each do |alert_level, message| 
 flash[:error] ? 'danger' : 'success'
 alert_level.to_s.downcase 
 message 
 end 
 end 
 
 error_messages_for 'article' 
 @article.text_filter 
 text_field 'article', 'title', class: 'form-control', placeholder: t('.title') 
 text_area('article', 'body_and_extended', {class: 'form-control ', style: 'height: 360px', placeholder: t('.type_your_post'), :"data-widearea" => "enable"}) 
 t('.publish') 
 submit_tag(t('.publish'), class: 'btn btn-success pull-right') 
 t('.tags') 
 text_field 'article', 'keywords', {autocomplete: 'off', class: 'form-control tm-input'} 
t('.tags_explaination') 
 post_types = @post_types || [] 
 if post_types.size.zero? 
 hidden_field_tag 'article[post_type]', 'read' 
 else 
 t('.article_type') 
 select :article, :post_type, post_types.map{|pt| [pt.name, pt.permalink]}, {include_blank: t('.default')} 
 end 
 t('.publish_settings') 
 t('.permalink') 
 toggle_element('permalink') 
 text_field 'article', 'permalink', {autocomplete: 'off', class: 'form-control'} 
 toggle_element('permalink', t('.ok')) 
 t('.status') 
 @article.state.to_s.downcase 
 toggle_element('status') 
 check_box 'article', 'published'  
 t('.published') 
 toggle_element('status', t('.ok')) 
 t('.allowed_comments_and_trackbacks_html', allow_comment: content_tag(:strong, t('.allow_comments_status', count: @article.allow_comments ? 1 : 0)), allow_trackback: content_tag(:strong, t('.allow_pings_status', count: @article.allow_pings ? 1 : 0))) 
 toggle_element('conversation') 
 check_box 'article', 'allow_pings' 
 t('.allow_trackbacks') 
 check_box 'article', 'allow_comments' 
 t('.allow_comments') 
 toggle_element('conversation', t('.ok')) 
 t('.published') 
 if @article.published 
 display_date_and_time(@article.published_at) 
 else 
 t('.now') 
 end 
 toggle_element('publish') 
 text_field 'article', 'published_at' 
 toggle_element('publish', t('.ok')) 
 t('.visibility') 
 @article.password.blank? ? t('.public') : t('.protected') 
 toggle_element('visibility') 
 t('.password') 
 text_field 'article', 'password', class: 'form-control' 
 toggle_element('visibility', t('.ok')) 
 t('.cancel') 
 submit_tag(t('.publish'), class: 'btn btn-success') 
 
 end 

end

  end

  def create
    article_factory = Article::Factory.new(this_blog, current_user)
    @article = article_factory.get_or_build_from(params[:article][:id])

    update_article_attributes

    if @article.save
      flash[:success] = I18n.t('admin.content.create.success')
      redirect_to action: 'index'
    else
      @article.keywords = Tag.collection_to_string @article.tags
      load_resources
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_tag({action: 'create'}, id: 'article_form', multipart: true, class: 'autosave') do 
  hidden_field_tag 'user_textfilter', current_user.text_filter_name 
 hidden_field_tag('article[id]', @article.id) if @article.present? 
 link_to(t('.cancel'), {action: 'index'}, {class: 'btn btn-default'}) 
 link_to(t('.preview'), {controller: '/articles', action: 'preview', id: @article.id}, {target: 'new', class: 'btn btn-default'}) if @article.id 
 t('.save_as_draft') 
 controller.action_name == 'new' ? t('.publish') : t('.save') 
  if flash 
 flash.each do |alert_level, message| 
 flash[:error] ? 'danger' : 'success'
 alert_level.to_s.downcase 
 message 
 end 
 end 
 
 error_messages_for 'article' 
 @article.text_filter 
 text_field 'article', 'title', class: 'form-control', placeholder: t('.title') 
 text_area('article', 'body_and_extended', {class: 'form-control ', style: 'height: 360px', placeholder: t('.type_your_post'), :"data-widearea" => "enable"}) 
 t('.publish') 
 submit_tag(t('.publish'), class: 'btn btn-success pull-right') 
 t('.tags') 
 text_field 'article', 'keywords', {autocomplete: 'off', class: 'form-control tm-input'} 
t('.tags_explaination') 
 post_types = @post_types || [] 
 if post_types.size.zero? 
 hidden_field_tag 'article[post_type]', 'read' 
 else 
 t('.article_type') 
 select :article, :post_type, post_types.map{|pt| [pt.name, pt.permalink]}, {include_blank: t('.default')} 
 end 
 t('.publish_settings') 
 t('.permalink') 
 toggle_element('permalink') 
 text_field 'article', 'permalink', {autocomplete: 'off', class: 'form-control'} 
 toggle_element('permalink', t('.ok')) 
 t('.status') 
 @article.state.to_s.downcase 
 toggle_element('status') 
 check_box 'article', 'published'  
 t('.published') 
 toggle_element('status', t('.ok')) 
 t('.allowed_comments_and_trackbacks_html', allow_comment: content_tag(:strong, t('.allow_comments_status', count: @article.allow_comments ? 1 : 0)), allow_trackback: content_tag(:strong, t('.allow_pings_status', count: @article.allow_pings ? 1 : 0))) 
 toggle_element('conversation') 
 check_box 'article', 'allow_pings' 
 t('.allow_trackbacks') 
 check_box 'article', 'allow_comments' 
 t('.allow_comments') 
 toggle_element('conversation', t('.ok')) 
 t('.published') 
 if @article.published 
 display_date_and_time(@article.published_at) 
 else 
 t('.now') 
 end 
 toggle_element('publish') 
 text_field 'article', 'published_at' 
 toggle_element('publish', t('.ok')) 
 t('.visibility') 
 @article.password.blank? ? t('.public') : t('.protected') 
 toggle_element('visibility') 
 t('.password') 
 text_field 'article', 'password', class: 'form-control' 
 toggle_element('visibility', t('.ok')) 
 t('.cancel') 
 submit_tag(t('.publish'), class: 'btn btn-success') 
 
 end 

end

    end
  end

  def update
    return unless access_granted?(params[:id])
    id = params[:article][:id] || params[:id]
    @article = Article.find(id)

    if params[:article][:draft]
      get_fresh_or_existing_draft_for_article
    else
      @article = Article.find(@article.parent_id) unless @article.parent_id.nil?
    end

    update_article_attributes

    if @article.save
      Article.where(parent_id: @article.id).map(&:destroy) unless @article.draft
      flash[:success] = I18n.t('admin.content.update.success')
      redirect_to action: 'index'
    else
      @article.keywords = Tag.collection_to_string @article.tags
      load_resources
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_tag({action: 'update', id: @article.id}, method: :put, multipart: true, id: "article_form", class: 'autosave') do 
  hidden_field_tag 'user_textfilter', current_user.text_filter_name 
 hidden_field_tag('article[id]', @article.id) if @article.present? 
 link_to(t('.cancel'), {action: 'index'}, {class: 'btn btn-default'}) 
 link_to(t('.preview'), {controller: '/articles', action: 'preview', id: @article.id}, {target: 'new', class: 'btn btn-default'}) if @article.id 
 t('.save_as_draft') 
 controller.action_name == 'new' ? t('.publish') : t('.save') 
  if flash 
 flash.each do |alert_level, message| 
 flash[:error] ? 'danger' : 'success'
 alert_level.to_s.downcase 
 message 
 end 
 end 
 
 error_messages_for 'article' 
 @article.text_filter 
 text_field 'article', 'title', class: 'form-control', placeholder: t('.title') 
 text_area('article', 'body_and_extended', {class: 'form-control ', style: 'height: 360px', placeholder: t('.type_your_post'), :"data-widearea" => "enable"}) 
 t('.publish') 
 submit_tag(t('.publish'), class: 'btn btn-success pull-right') 
 t('.tags') 
 text_field 'article', 'keywords', {autocomplete: 'off', class: 'form-control tm-input'} 
t('.tags_explaination') 
 post_types = @post_types || [] 
 if post_types.size.zero? 
 hidden_field_tag 'article[post_type]', 'read' 
 else 
 t('.article_type') 
 select :article, :post_type, post_types.map{|pt| [pt.name, pt.permalink]}, {include_blank: t('.default')} 
 end 
 t('.publish_settings') 
 t('.permalink') 
 toggle_element('permalink') 
 text_field 'article', 'permalink', {autocomplete: 'off', class: 'form-control'} 
 toggle_element('permalink', t('.ok')) 
 t('.status') 
 @article.state.to_s.downcase 
 toggle_element('status') 
 check_box 'article', 'published'  
 t('.published') 
 toggle_element('status', t('.ok')) 
 t('.allowed_comments_and_trackbacks_html', allow_comment: content_tag(:strong, t('.allow_comments_status', count: @article.allow_comments ? 1 : 0)), allow_trackback: content_tag(:strong, t('.allow_pings_status', count: @article.allow_pings ? 1 : 0))) 
 toggle_element('conversation') 
 check_box 'article', 'allow_pings' 
 t('.allow_trackbacks') 
 check_box 'article', 'allow_comments' 
 t('.allow_comments') 
 toggle_element('conversation', t('.ok')) 
 t('.published') 
 if @article.published 
 display_date_and_time(@article.published_at) 
 else 
 t('.now') 
 end 
 toggle_element('publish') 
 text_field 'article', 'published_at' 
 toggle_element('publish', t('.ok')) 
 t('.visibility') 
 @article.password.blank? ? t('.public') : t('.protected') 
 toggle_element('visibility') 
 t('.password') 
 text_field 'article', 'password', class: 'form-control' 
 toggle_element('visibility', t('.ok')) 
 t('.cancel') 
 submit_tag(t('.publish'), class: 'btn btn-success') 
 
 end 

end

    end
  end

  def destroy
    destroy_a(Article)
  end

  def auto_complete_for_article_keywords
    @items = Tag.select(:display_name).order(:display_name).map(&:display_name)
    render json: @items
  end

  def autosave
    return false unless request.xhr?

    id = params[:article][:id] || params[:id]

    article_factory = Article::Factory.new(this_blog, current_user)
    @article = article_factory.get_or_build_from(id)

    get_fresh_or_existing_draft_for_article

    @article.attributes = params[:article].permit!

    @article.published = false
    @article.author = current_user
    @article.save_attachments!(params[:attachments])
    @article.state = 'draft' unless @article.state == 'withdrawn'
    @article.text_filter ||= current_user.default_text_filter

    if @article.title.blank?
      lastid = Article.order('id desc').first.id
      @article.title = 'Draft article ' + lastid.to_s
    end

    if @article.save
      flash[:success] = I18n.t('admin.content.autosave.success')
      @must_update_calendar = (params[:article][:published_at] and params[:article][:published_at].to_time.to_i < Time.now.to_time.to_i and @article.parent_id.nil?)
      respond_to do |format|
        format.js
      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 hidden_field_tag('article[id]', @article.id) 
 link_to('Preview', {:controller => '/articles', :action => 'preview', :id => @article.id}, {:target => 'new', :class => 'btn btn-default'}); 
 if @article.state.to_s.downcase == "draft" 
 Time.now() 
 end 

end

  end

  protected

  def get_fresh_or_existing_draft_for_article
    if @article.published && @article.id
      parent_id = @article.id
      @article =
        this_blog.articles.drafts.child_of(parent_id).first || this_blog.articles.build
      @article.allow_comments = this_blog.default_allow_comments
      @article.allow_pings = this_blog.default_allow_pings
      @article.parent_id = parent_id
    end
  end

  attr_accessor :resources, :resource

  private

  def load_resources
    @post_types = PostType.all
    @images = Resource.images_by_created_at.page(params[:page]).per(10)
    @resources = Resource.without_images_by_filename
    @macros = TextFilter.macro_filters
  end

  def access_granted?(article_id)
    article = Article.find(article_id)
    if article.access_by? current_user
      return true
    else
      flash[:error] = I18n.t('admin.content.access_granted.error')
      redirect_to action: 'index'
      return false
    end
  end

  def update_article_attributes
    @article.attributes = update_params
    @article.published_at = parse_date_time params[:article][:published_at]
    @article.author = current_user
    @article.save_attachments!(params[:attachments])
    @article.state = 'draft' if @article.draft
    @article.text_filter ||= current_user.default_text_filter
  end

  def update_params
    params.require(:article).except(:id).permit!
  end

  def get_layout
    case action_name
    when 'new', 'edit', 'create'
      'editor'
    when 'show', 'autosave'
      nil
    else
      'administration'
    end
  end
end

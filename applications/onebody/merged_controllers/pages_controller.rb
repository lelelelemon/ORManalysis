class PagesController < ApplicationController
  skip_before_filter :authenticate_user, only: %w(show_for_public)
  skip_before_filter :feature_enabled?
  before_filter :get_path
  before_filter :get_page, :get_user, only: %w(show_for_public)
  before_filter :feature_enabled?, only: %w(show_for_public) # must follow get_page

  def index
    @pages = Page.where(system: true, published: true).order(:title)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('.heading') 
 t('.intro') 
 t('.name') 
 t('.description') 
 @pages.each do |page| 
 link_to page.title, edit_page_path(page) 
 t(page.slug, scope: 'pages.descriptions', default: '') # notest 
 link_to t('.edit_button'), edit_page_path(page), class: 'btn btn-info btn-xs' 
 end 

end

  end

  def show_for_public
    if @page
      if @page.published?
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = @page.name 
 sanitize_html @page.body 

end

      else
        render text: t('pages.not_found'), status: 404
      end
    else
      render text: t('pages.not_found'), status: 404
    end
  end

  def show
    @page = Page.find(params[:id])
    unless @logged_in.admin?(:edit_pages)
      redirect_to page_for_public_path(path: @page.path)
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = @page.name 
 sanitize_html @page.body 

end

  end

  def edit
    @page = Page.find(params[:id])
    unless @logged_in.can_update?(@page)
      render text: t('not_authorized'), layout: true, status: 401
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('pages.edit_page') 
  form_for @page do |form| 
 error_messages_for(form) 
 form.label :title, t('pages.title') 
 form.text_field :title, class: 'form-control' 
 form.label :body, t('pages.body') 
 form.text_area :body, rows: 20, cols: 80, class: 'form-control editor-control' 
 form.button t('save'), class: 'btn btn-success' 
 link_to t('pages.view_page'), page_path(@page), class: 'btn btn-info' 
 end 
 content_for :css do 
 stylesheet_link_tag 'editor' 
 end 
 content_for :js do 
 javascript_include_tag 'editor' 
 end 
 

end

  end

  def update
    @page = Page.find(params[:id])
    if @logged_in.can_update?(@page)
      if @page.update_attributes(page_params)
        flash[:notice] = t('pages.saved')
        redirect_to pages_path
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('pages.edit_page') 
  form_for @page do |form| 
 error_messages_for(form) 
 form.label :title, t('pages.title') 
 form.text_field :title, class: 'form-control' 
 form.label :body, t('pages.body') 
 form.text_area :body, rows: 20, cols: 80, class: 'form-control editor-control' 
 form.button t('save'), class: 'btn btn-success' 
 link_to t('pages.view_page'), page_path(@page), class: 'btn btn-info' 
 end 
 content_for :css do 
 stylesheet_link_tag 'editor' 
 end 
 content_for :js do 
 javascript_include_tag 'editor' 
 end 
 

end

      end
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
  end

  private

  def page_params
    params.require(:page).permit(:title, :slug, :body)
  end

  def get_path
    @path = [*params[:path]].join('/')
    if @path.sub!(%r{/edit$}, '')
      redirect_to edit_page_path(Page.find(@path))
      return false
    end
  end

  def get_page
    @page = Page.find_by_id_or_path(@path)
  end

  def feature_enabled?
    unless @page and @page.system? and !@page.home?
      redirect_to stream_path
      false
    end
  end

end

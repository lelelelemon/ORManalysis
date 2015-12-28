# coding: utf-8
require 'base64'

class Admin::PagesController < Admin::BaseController
  before_action :set_images, only: [:new, :edit]
  before_action :set_macro, only: [:new, :edit]
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  layout :get_layout
  cache_sweeper :blog_sweeper

  def index
    @search = params[:search] ? params[:search] : {}
    @pages = Page.search_with(@search).page(params[:page]).per(this_blog.admin_display_elements)
 content_for :page_heading do 
 t(".manage_pages") 
 link_to(t(".new_page"), {controller: 'pages', action: 'new'}, id: 'dialog-link', class: 'btn btn-info pull-right') 
 end 
 t(".title") 
 t(".author")
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 if @pages.empty? 
 t(".no_pages") 
 end 
 for page in @pages 
 link_to_permalink(page, page.title) 
 show_actions page 
 author_link(page) 
 l(page.created_at) 
 end 
 display_pagination(@pages, 5) 

end
 

  end

  def new
    @page = Page.new
    @page.text_filter ||= default_textfilter
    @page.published = true
    @page.user_id = current_user.id
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 form_for([:admin, @page]) do |f| 
 if @page.errors.any? 
 pluralize(@page.errors.count, "error") 
 @page.errors.full_messages.each do |message| 
 message 
 end 
 end 
 current_user.text_filter_name 
 link_to(t('.cancel'), {action: 'index'}, {class: 'btn btn-default'}) 
 controller.action_name == "new" ? t(".publish") : t(".save") 
 error_messages_for 'page' 
 @page.text_filter 
 text_field 'page', 'title', :class => 'form-control', :placeholder => t('.title')  
 text_area('page', 'body', {:class => 'form-control ', style: 'height: 360px', :rows => '20', placeholder: t('.type_your_post'), :"data-widearea" => "enable"}) 
 t('.publish') 
 submit_tag( t(".publish"), class: 'btn btn-success pull-right') 
 t(".permanent_link")
 text_field 'page', 'name', :class => 'form-control' 
 t(".publish_settings") 
 t(".status") 
 (@page.published) ? t(".published") : t(".offline") 
 toggle_element('status') 
 check_box 'page', 'published'  
 t(".online")
 toggle_element 'status', "OK" 
 t(".article_filter") 
 @page.text_filter.description 
 toggle_element 'text_filter' 
 options_for_select text_filter_options, @page.text_filter 
 toggle_element 'text_filter', "OK" 
 submit_tag( t(".publish"), class: 'btn btn-success') 
 end 

end
 

  end

  def edit
    @page.text_filter ||= default_textfilter
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 form_for([:admin, @page]) do |f| 
 if @page.errors.any? 
 pluralize(@page.errors.count, "error") 
 @page.errors.full_messages.each do |message| 
 message 
 end 
 end 
 current_user.text_filter_name 
 link_to(t('.cancel'), {action: 'index'}, {class: 'btn btn-default'}) 
 controller.action_name == "new" ? t(".publish") : t(".save") 
 error_messages_for 'page' 
 @page.text_filter 
 text_field 'page', 'title', :class => 'form-control', :placeholder => t('.title')  
 text_area('page', 'body', {:class => 'form-control ', style: 'height: 360px', :rows => '20', placeholder: t('.type_your_post'), :"data-widearea" => "enable"}) 
 t('.publish') 
 submit_tag( t(".publish"), class: 'btn btn-success pull-right') 
 t(".permanent_link")
 text_field 'page', 'name', :class => 'form-control' 
 t(".publish_settings") 
 t(".status") 
 (@page.published) ? t(".published") : t(".offline") 
 toggle_element('status') 
 check_box 'page', 'published'  
 t(".online")
 toggle_element 'status', "OK" 
 t(".article_filter") 
 @page.text_filter.description 
 toggle_element 'text_filter' 
 options_for_select text_filter_options, @page.text_filter 
 toggle_element 'text_filter', "OK" 
 submit_tag( t(".publish"), class: 'btn btn-success') 
 end 

end
 

  end

  def create
    @page = Page.new(page_params)
    @page.published_at = Time.now
    @page.user_id = current_user.id

    if @page.save
      redirect_to admin_pages_url, notice: I18n.t('admin.pages.new.success')
    else
      render :new
    end
  end

  def update
    @page.text_filter ||= default_textfilter
    if @page.update(page_params)
      redirect_to admin_pages_url, notice: I18n.t('admin.pages.edit.success')
    else
      render :edit
    end
  end

  def destroy
    destroy_a(Page)
  end

  private

  def default_textfilter
    current_user.text_filter || blog.text_filter
  end

  def set_macro
    @macros = TextFilter.macro_filters
  end

  def set_images
    @images = Resource.images.by_created_at.page(1).per(10)
  end

  def get_layout
    case action_name
    when 'new', 'edit', 'create'
      'editor'
    when 'show'
      nil
    else
      'administration'
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_page
    @page = Page.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def page_params
    params.require(:page).permit(:title, :body, :name, :published, :text_filter)
  end
end

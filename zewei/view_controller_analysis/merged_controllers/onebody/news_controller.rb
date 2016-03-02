class NewsController < ApplicationController

  skip_before_filter :authenticate_user, only: %w(index)
  before_filter :authenticate_user_with_code_or_session, only: %w(index)

  def index
    respond_to do |format|
      format.html do
        if Setting.get(:features, :news_page)
          @news_items = NewsItem.active.order('published desc').includes(:person).page(params[:page])
        else
          if the_url = Setting.get(:url, :news)
            redirect_to the_url
          else
            render text: t('feature_unavailable')
          end
        end
      end
      format.xml do
        if Setting.get(:features, :news_page)
          @news_items = NewsItem.where(active: true).includes(:person).limit(30).order('published desc')
          render layout: false
        else
          if the_url = Setting.get(:url, :news)
            redirect_to the_url
          else
            render text: t('feature_unavailable')
          end
        end
      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :meta do 
 news_url(format: 'xml', code: @logged_in.feed_code) 
 t('news.news_feed') 
 end 
 @title = t('news.heading') 
 t('news.welcome_to_the_place') 
 if Setting.get(:features, :news_by_users) 
 t('news.if_you_have_something_to_share_html', url: new_news_item_path) 
 end 
 t('news.subscribe.description') 
 link_to news_path(format: 'xml', code: @logged_in.feed_code), class: 'btn bg-orange' do 
 icon 'fa fa-rss' 
 t('news.subscribe.button') 
 end 
 pagination @news_items 
  link_to news_item.title, news_item, class: 'no-underline' 
 if @logged_in.can_update?(news_item) 
 link_to edit_news_item_path(news_item), class: 'btn bg-gray btn-xs' do 
 icon 'fa fa-pencil' 
 end 
 end 
 sanitize_html news_item.body 
  if news_item.person 
 elsif news_item.link.present? 
 end 
 
 
 pagination @news_items 
 unless @news_items.any? 
 t('news.no_news_is_available') 
 end 

end

  end

  def show
    if Setting.get(:features, :news_page)
      @news_item = NewsItem.find(params[:id])
      respond_to do |format|
        format.html
      end
    else
      respond_to do |format|
        format.html do
          if the_url = Setting.get(:url, :news)
            redirect_to the_url
          else
            render text: t('feature_unavailable')
          end
        end
      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = @news_item.title 
 if @logged_in.can_update?(@news_item) 
 link_to edit_news_item_path(@news_item), class: 'btn btn-xs btn-info' do 
 icon 'fa fa-pencil' 
 t('news.edit_button') 
 end 
 link_to news_item_path(@news_item), class: 'btn btn-xs bg-gray text-red', method: 'delete', confirm: t('are_you_sure') do 
 icon 'fa fa-trash-o' 
 t('news.delete_button') 
 end 
 end 
  if news_item.person 
 elsif news_item.link.present? 
 end 
 
 sanitize_html @news_item.body 
 t('Comments') 
  if object.comments.any? 
 object.comments.each do |comment| 
 link_to comment.person do 
 avatar_tag comment.person 
 end 
 link_to comment.person.name, comment.person 
 comment.created_at.to_s(:full) 
 if @logged_in.can_update?(comment) 
 link_to comment_path(comment), class: 'btn btn-xs bg-gray text-red', method: 'delete', data: { confirm: t('are_you_sure') } do 
 icon 'fa fa-trash-o' 
 end 
 end 
 preserve_breaks comment.text 
 end 
 else 
 t('comments.none_yet') 
 end 
 t('comments.add_a_comment') 
 form_for Comment.new, html: {style: 'border:none;'} do |form| 
 hidden_field_tag 'comment[commentable_type]', object.class 
 hidden_field_tag 'comment[commentable_id]', object.id 
 hidden_field_tag :return_to, request.fullpath 
 text_area_tag 'comment[text]', '', rows: 3, cols: 40, id: 'new_comment_textarea', class: 'form-control' 
 form.submit t('comments.save'), class: 'btn btn-success' 
 end 
 

end

  end

  def new
    if @logged_in.admin?(:manage_news) or Setting.get(:features, :news_by_users)
      @news_item = NewsItem.new
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('news.submit_news') 
  form_for @news_item do |form| 
 error_messages_for(form) 
 form.label :title, t('news.title_description') 
 form.text_field :title, class: 'form-control' 
 form.label :body, t('news.body_description') 
 form.text_area :body, rows: 20, cols: 100, class: 'form-control editor-control' 
 if @logged_in.can_update?(@news_item) and @news_item.persisted? 
 link_to @news_item, method: 'delete', data: { confirm: t('are_you_sure') }, class: 'btn btn-danger' do 
 icon 'fa fa-trash-o' 
 t('news.delete_button') 
 end 
 end 
 button_tag class: 'btn btn-success' do 
 @news_item.new_record? ? t('news.submit_news') : t('news.save_news') 
 end 
 end 
 content_for :css do 
 stylesheet_link_tag 'editor' 
 end 
 content_for :js do 
 javascript_include_tag 'editor' 
 end 
 

end

  end

  def create
    if @logged_in.admin?(:manage_news) or Setting.get(:features, :news_by_users)
      @news_item = NewsItem.new(news_item_params)
      @news_item.person = @logged_in
      @news_item.source = 'user'
      if @news_item.save
        respond_to do |format|
          format.html do
            flash[:notice] = t('news.saved')
            redirect_to params[:redirect_to] || @news_item
          end
        end
      else
        respond_to do |format|
          format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('news.submit_news') 
  form_for @news_item do |form| 
 error_messages_for(form) 
 form.label :title, t('news.title_description') 
 form.text_field :title, class: 'form-control' 
 form.label :body, t('news.body_description') 
 form.text_area :body, rows: 20, cols: 100, class: 'form-control editor-control' 
 if @logged_in.can_update?(@news_item) and @news_item.persisted? 
 link_to @news_item, method: 'delete', data: { confirm: t('are_you_sure') }, class: 'btn btn-danger' do 
 icon 'fa fa-trash-o' 
 t('news.delete_button') 
 end 
 end 
 button_tag class: 'btn btn-success' do 
 @news_item.new_record? ? t('news.submit_news') : t('news.save_news') 
 end 
 end 
 content_for :css do 
 stylesheet_link_tag 'editor' 
 end 
 content_for :js do 
 javascript_include_tag 'editor' 
 end 
 

end
 }
        end
      end
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
  end

  def edit
    @news_item = NewsItem.find(params[:id])
    unless @logged_in.can_update?(@news_item)
      render text: t('not_authorized'), layout: true, status: 401
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('news.edit.heading') 
  form_for @news_item do |form| 
 error_messages_for(form) 
 form.label :title, t('news.title_description') 
 form.text_field :title, class: 'form-control' 
 form.label :body, t('news.body_description') 
 form.text_area :body, rows: 20, cols: 100, class: 'form-control editor-control' 
 if @logged_in.can_update?(@news_item) and @news_item.persisted? 
 link_to @news_item, method: 'delete', data: { confirm: t('are_you_sure') }, class: 'btn btn-danger' do 
 icon 'fa fa-trash-o' 
 t('news.delete_button') 
 end 
 end 
 button_tag class: 'btn btn-success' do 
 @news_item.new_record? ? t('news.submit_news') : t('news.save_news') 
 end 
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
    @news_item = NewsItem.find(params[:id])
    if @logged_in.can_update?(@news_item)
      if @news_item.update_attributes(news_item_params)
        respond_to do |format|
          format.html { flash[:notice] = t('news.saved'); redirect_to @news_item }
        end
      else
        respond_to do |format|
          format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('news.edit.heading') 
  form_for @news_item do |form| 
 error_messages_for(form) 
 form.label :title, t('news.title_description') 
 form.text_field :title, class: 'form-control' 
 form.label :body, t('news.body_description') 
 form.text_area :body, rows: 20, cols: 100, class: 'form-control editor-control' 
 if @logged_in.can_update?(@news_item) and @news_item.persisted? 
 link_to @news_item, method: 'delete', data: { confirm: t('are_you_sure') }, class: 'btn btn-danger' do 
 icon 'fa fa-trash-o' 
 t('news.delete_button') 
 end 
 end 
 button_tag class: 'btn btn-success' do 
 @news_item.new_record? ? t('news.submit_news') : t('news.save_news') 
 end 
 end 
 content_for :css do 
 stylesheet_link_tag 'editor' 
 end 
 content_for :js do 
 javascript_include_tag 'editor' 
 end 
 

end
 }
        end
      end
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
  end

  def destroy
    @news_item = NewsItem.find(params[:id])
    if @logged_in.can_update?(@news_item)
      @news_item.destroy
      respond_to do |format|
        format.html { flash[:notice] = t('news.deleted'); redirect_to news_path }
      end
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
  end

  private

  def news_item_params
    params.require(:news_item).permit(:title, :body)
  end
end

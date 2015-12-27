class ArticlesController < ContentController
  before_action :login_required, only: [:preview, :preview_page]
  before_action :auto_discovery_feed, only: [:show, :index]
  before_action :verify_config

  layout :theme_layout, except: [:trackback]

  cache_sweeper :blog_sweeper
  caches_page :index, :archives, :read, :view_page, :redirect, if: proc { |c| c.request.query_string == '' }

  helper :'admin/base'

  def index
    conditions = (Blog.default.statuses_in_timeline) ? ['type in (?, ?)', 'Article', 'Note'] : ['type = ?', 'Article']

    limit = this_blog.per_page(params[:format])
    if params[:year].blank?
      @articles = Content.published.where(conditions).page(params[:page]).per(limit)
    else
      @articles = Content.published_at(params.values_at(:year, :month, :day)).where(conditions).page(params[:page]).per(limit)
    end

    @page_title = this_blog.home_title_template
    @description = this_blog.home_desc_template
    if params[:year]
      @page_title = this_blog.archives_title_template
      @description = this_blog.archives_desc_template
    elsif params[:page]
      @page_title = this_blog.paginated_title_template
      @description = this_blog.paginated_desc_template
    end
    @page_title = @page_title.to_title(@articles, this_blog, params)
    @description = @description.to_title(@articles, this_blog, params)

    @keywords = this_blog.meta_keywords

    respond_to do |format|
      format.html { render_paginated_index }
      format.atom do
        render_articles_feed('atom')
      end
      format.rss do
        auto_discovery_feed(only_path: false)
        render_articles_feed('rss')
      end
    end
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 for article in articles 
 render article 
 render 'articles/article_links', article: article 
 end 
 paginate articles, next_label: "#{t(".next_page")} &raquo;", previous_label: "&laquo; #{t('.previous_page')}" 

end
 

  end

  def search
    @articles = this_blog.articles_matching(params[:q], page: params[:page], per_page: this_blog.per_page(params[:format]))
    return error! if @articles.empty?
    @page_title = this_blog.search_title_template.to_title(@articles, this_blog, params)
    @description = this_blog.search_desc_template.to_title(@articles, this_blog, params)
    respond_to do |format|
      format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 for article in @articles 
 link_to_permalink article,article.title 
 article.html(:body).gsub(/<\/?[^>]*>/, "").slice(0..300) 
 end 
 paginate @articles, :next_label => "#{t(".next_page")} &raquo;", :previous_label => "&laquo; #{t('.previous_page')}" 

end
 }
      format.rss { render 'index_rss_feed', layout: false }
      format.atom { render 'index_atom_feed', layout: false }
    end
  end

  def live_search
    @search = params[:q]
    @articles = Article.search(@search)
    render :live_search, layout: false
  end

  def preview
    @article = Article.last_draft(params[:id])
    @page_title = this_blog.article_title_template.to_title(@article, this_blog, params)
    ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 if @article.allow_pings? 
 @article.trackback_url 
 end 
h @article.title.gsub(/-+/, '-') 
 @article.permalink_url 
h (html(@article).strip_html[0..255]).gsub(/-+/, '-') 
 h @article.author 
 @article.updated_at.xmlschema 
 onhover_show_admin_tools(:article) 
 link_to(t(".edit"), { controller: "admin/content", action: "edit", id: @article.id }, class: "admintools", style: "display: none", id: "admin_article") 
 render @article 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 t(".tags") + " " + article.tags.map { |tag| link_to tag.display_name, tag.permalink_url(nil, true), rel: "tag"}.sort.join(", ") if article.tags.any? 
 link_to(t('.comments', count: article.published_comments.size), article.permalink_url('comments', true)) if article.allow_comments? 
 link_to(t('.trackbacks', count: article.published_trackbacks.size), article.permalink_url('trackbacks', true)) if article.allow_pings? 

end
 
 if @article.allow_comments? or @article.published_comments.size > 0 
 t('.comments') 
 unless @article.comments_closed? 
 t(".leave_a_response")
 end 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 if @article.published_comments.any? 
 render @article.published_comments 
 end 

end
 
 end 
 if @article.allow_pings? 
 t(".trackbacks")
 t(".use_the_following_link_to_trackback")
 @article.trackback_url 
 unless @article.published_trackbacks.blank? 
 render(partial: "trackback", collection: @article.published_trackbacks) 
 end 
 end 
 @article.feed_url('rss') 
 t(".rss_feed")
 if @article.allow_pings? 
 @article.trackback_url 
 t(".trackback_uri")
 end 
 unless @article.comments_closed? 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 form_tag @article.comment_url, id: 'comment_form', remote: true do 
 t(".your_name")
 text_field "comment", "author", size: 20 
 link_to '#', onclick: "$('.optional_field').fadeToggle();return false" do 
 t(".leave_url_email") 
 end 
 t(".your_blog")
 text_field "comment", "url" 
 t(".your_email")
 text_field "comment", "email" 
 t(".your_message")
 text_area "comment", "body" 
 if this_blog.use_recaptcha 
 recaptcha_tags ajax: true 
 end 
 markup_help_popup TextFilter.find_by_name(this_blog.comment_text_filter), t(".comment_markup_help") 
 @article.preview_comment_url 
 t(".preview_comment")
 end 

end
 
 else 
 t(".comments_are_disabled")
 end 

end

  end

  def check_password
    return unless request.xhr?
    @article = Article.find(params[:article][:id])
    if @article.password == params[:article][:password]
      render partial: 'articles/full_article_content', locals: { article: @article }
    else
      render partial: 'articles/password_form', locals: { article: @article }
    end
  end

  def redirect
    from = extract_feed_format(params[:from])
    factory = Article::Factory.new(this_blog, current_user)

    @article = factory.match_permalink_format(from, this_blog.permalink_format)
    return show_article if @article

    # Redirect old version with /:year/:month/:day/:title to new format,
    # because it's changed
    ['%year%/%month%/%day%/%title%', 'articles/%year%/%month%/%day%/%title%'].each do |part|
      @article = factory.match_permalink_format(from, part)
      return redirect_to URI.parse(@article.permalink_url).path, status: 301 if @article
    end

    r = Redirect.find_by_from_path(from)
    return redirect_to r.full_to_path, status: 301 if r # Let redirection made outside of the blog on purpose (deal with it, Brakeman!)

    ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 t(".page_not_found") 
 t(".the_page_you_are_looking_for") 

end

  end

  def archives
    limit = this_blog.limit_archives_display
    @articles = Article.published.page(params[:page]).per(limit)
    @page_title = this_blog.archives_title_template.to_title(@articles, this_blog, params)
    @keywords = this_blog.meta_keywords
    @description = this_blog.archives_desc_template.to_title(@articles, this_blog, params)
 if @articles.empty? 
 t(".no_articles_found")
 else
currentmonth = 0
currentyear = 0
for article in @articles
  if (article.published_at.month != currentmonth || article.published_at.year != currentyear)
    currentmonth = article.published_at.month
    currentyear = article.published_at.year 
 l(article.published_at, format: :letters_month_with_year) 
 end 
 article.published_at.mday 
 link_to_permalink(article,h(article.title)) 
 if !article.tags.empty? 
 t(".posted_in") 
 article.tags.collect {|t| link_to_permalink t,t.display_name }.join(", ") 
 end 
 end 
 end 
 paginate @articles, next_label: "#{t(".next_page")} &raquo;", previous_label: "&laquo; #{t('.previous_page')}" 

  end

  def tag
    redirect_to tags_path, status: 301
  end

  def preview_page
    @page = Page.find(params[:id])
    ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 html @page 

end

  end

  def view_page
    if (@page = Page.find_by_name(Array(params[:name]).join('/'))) && @page.published?
      @page_title = @page.title
      @description = this_blog.meta_description
      @keywords = this_blog.meta_keywords
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 t(".page_not_found") 
 t(".the_page_you_are_looking_for") 

end

    end
  end

  # TODO: Move to TextfilterController?
  def markup_help
    render text: TextFilter.find(params[:id]).commenthelp
  end

  private

  def verify_config
    if !this_blog.configured?
      redirect_to controller: 'setup', action: 'index'
    elsif User.count == 0
      redirect_to controller: 'accounts', action: 'signup'
    else
      return true
    end
  end

  # See an article We need define @article before
  def show_article
    @comment = Comment.new
    @page_title = this_blog.article_title_template.to_title(@article, this_blog, params)
    @description = this_blog.article_desc_template.to_title(@article, this_blog, params)
    groupings = @article.tags
    @keywords = groupings.map(&:name).join(', ')

    auto_discovery_feed
    respond_to do |format|
      format.html { render "articles/#{@article.post_type}" }
      format.atom { render_feedback_feed('atom') }
      format.rss { render_feedback_feed('rss') }
      format.xml { render_feedback_feed('atom') }
    end
  rescue ActiveRecord::RecordNotFound
    error!
  end

  def render_articles_feed(format)
    if this_blog.feedburner_url.empty? || request.env['HTTP_USER_AGENT'] =~ /FeedBurner/i
      render "index_#{format}_feed", layout: false
    else
      redirect_to "http://feeds2.feedburner.com/#{this_blog.feedburner_url}"
    end
  end

  def render_feedback_feed(format)
    @feedback = @article.published_feedback
    render "feedback_#{format}_feed", layout: false
  end

  def render_paginated_index
    return error! if @articles.empty?
    if this_blog.feedburner_url.empty?
      auto_discovery_feed(only_path: false)
    else
      @auto_discovery_url_rss = "http://feeds2.feedburner.com/#{this_blog.feedburner_url}"
      @auto_discovery_url_atom = "http://feeds2.feedburner.com/#{this_blog.feedburner_url}"
    end
    ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 for article in articles 
 render article 
 render 'articles/article_links', article: article 
 end 
 paginate articles, next_label: "#{t(".next_page")} &raquo;", previous_label: "&laquo; #{t('.previous_page')}" 

end
 

end

  end

  def extract_feed_format(from)
    if from =~ /^.*\.rss$/
      request.format = 'rss'
      from = from.gsub(/\.rss/, '')
    elsif from =~ /^.*\.atom$/
      request.format = 'atom'
      from = from.gsub(/\.atom$/, '')
    end
    from
  end

  def error!
    @message = I18n.t('errors.no_posts_found')
    ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 @message 

end

  end
end

class TagsController < ContentController
  before_action :auto_discovery_feed, only: [:show, :index]
  layout :theme_layout
  cache_sweeper :blog_sweeper

  caches_page :index, :show, if: proc {|c|
    c.request.query_string == ''
  }

  def index
    @tags = Tag.page(params[:page]).per(100)
    @page_title = controller_name.capitalize
    @keywords = ''
    @description = "#{self.class.to_s.sub(/Controller$/, '')} for #{this_blog.blog_name}"
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title 
 unless @tags.empty? 
 for tag in @tags.sort_by{|grp|grp.display_name} 
 link_to_permalink(tag, tag.display_name) 
 end 
 else 
 t(".there_is_no_tags") 
 end 
 paginate(@tags, right: "#{t(".next_page")} &raquo;", left: "&laquo; #{t('.previous_page')}") 

end

  end

  def show
    @grouping = Tag.find_by_permalink(params[:id])
    if @grouping.nil?
      @articles = []
    else
      @page_title = this_blog.tag_title_template.to_title(@grouping, this_blog, params)
      @description = @grouping.description.to_s
      @keywords = ''
      @keywords << @grouping.keywords unless @grouping.keywords.blank?
      @keywords << this_blog.meta_keywords unless this_blog.meta_keywords.blank?
      @articles = @grouping.articles.published.page(params[:page]).per(10)
    end
    respond_to do |format|
      format.html do
        if @articles.empty?
          ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t(".page_not_found") 
 t(".the_page_you_are_looking_for") 

end

        else
          render template_name(params[:id])
        end
      end

      format.atom do
        @articles = @articles[0, this_blog.limit_rss_display]
        render 'articles/index_atom_feed', layout: false
      end

      format.rss do
        @articles = @articles[0, this_blog.limit_rss_display]
        render 'articles/index_rss_feed', layout: false
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

  private

  def template_name(value)
    template_exists?("tags/#{value}") ? value : :show
  end
end

# coding: utf-8
class Admin::DashboardController < Admin::BaseController
  require 'open-uri'
  require 'time'
  require 'rexml/document'

  def index
    t = Time.new
    today = t.strftime('%Y-%m-%d 00:00')

    # Since last venue
    @newposts_count = Article.published_since(current_user.last_venue).count
    @newcomments_count = Feedback.published_since(current_user.last_venue).count

    # Today
    @statposts = Article.published.where('published_at > ?', today).count
    @statsdrafts = Article.drafts.where('created_at > ?', today).count
    @statspages = Page.where('published_at > ?', today).count
    @statuses = Note.where('published_at > ?', today).count
    @statuserposts = Article.published.where('published_at > ?', today).count(conditions: { user_id: current_user.id })
    @statcomments = Comment.where('created_at > ?', today).count
    @presumedspam = Comment.presumed_spam.where('created_at > ?', today).count
    @confirmed = Comment.ham.where('created_at > ?', today).count
    @unconfirmed = Comment.unconfirmed.where('created_at > ?', today).count

    @comments = Comment.last_published
    @drafts = Article.drafts.where('user_id = ?', current_user.id).limit(5)

    @statspam = Comment.spam.count
    @inbound_links = inbound_links
    @publify_links = publify_dev
    publify_version
 content_for :page_heading do 
 t(".welcome_back", user_name: current_user.name) 
 end 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 t(".dashboard_explain_html", available_actions: dashboard_action_links) 
 if current_user.can_access_to_themes? 
 t(".customization_explain_html", theme_link: link_to(t(".change_your_blog_presentation"), controller: 'themes'), sidebar_link: link_to(t(".enable_plugins"), controller: 'sidebar')) 
 end 
 t(".help_explain_html", doc_link: link_to(t('.read_our_documentation'), 'http://publify.co')) 

end
 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 t(".today") 
 t(".articles_and_comments_count_since", articles_count: @newposts_count, comments_count: @newcomments_count) 
 t(".running_publify", version: PUBLIFY_VERSION) 
 @version_message 
 if current_user.can_access_to_articles? 
 t(".content") 
 link_to(t(".articles_count", count: @statposts), controller: 'admin/content') 
 link_to(t(".your_articles_count", count: @statuserposts), controller: 'admin/content', "search[user_id]" => current_user.id) 
 link_to(t(".drafts_count", count: @statsdrafts), controller: 'admin/content', "search[state]" => "drafts") 
 link_to(t(".pages_count", count: @statspages), controller: 'admin/pages') 
 link_to(t(".notes_count", count: @statuses), controller: 'admin/notes') 
 end 
  if current_user.can_access_to_feedback? 
 t(".feedback") 
 link_to(t('.comments_count', count: @statcomments), controller: 'admin/feedback') 
 link_to(t('.approved_count', count: @confirmed), controller: 'admin/feedback', only: 'ham') 
 link_to(t('.unconfirmed_count', count: @unconfirmed), controller: 'admin/feedback', only: 'unapproved') 
 link_to(t(".spam_count", count: @statspam), controller: 'admin/feedback', only: 'spam') 
 end 

end
 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 t(".latest_comments") 
 render partial: "comment" 

end
 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 t(".your_drafts") 
 if @drafts.empty? 
 link_to t(".no_drafts_yet"), controller: 'content', action: 'new' 
 else 
 for post in @drafts 
 link_to(post.title, controller: "admin/content", action: "edit", id: post.id) 
 display_date_and_time(post.created_at) 
 post.body.strip_html.slice(0,300) if post.body 
 end 
 end 

end
 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 t(".inbound_links") 
 if @inbound_links.nil? 
 t('.you_have_no_internet_connection') 
 else 
 if @inbound_links.empty? 
 t(".no_one_made_link_to_you_yet") 
 else 
 for link in @inbound_links 
 link_date = link.date 
 sprintf("%s %s %s %s %s", link_to(link.author, link.link), t(".made_a_link_to_you_on"), link_date && link_date.strftime(this_blog.date_format) || t('.at_an_unknown_date'), link_date && t(".at") || '', link_date && link_date.strftime(this_blog.time_format)) || '' 
 link.description.strip_html.slice(0, 300) 
 end 
 end 
 end 

end
 

  end

  def publify_version
    version = nil
    begin
      open(PUBLIFY_VERSION_URL) do |http|
        publify_version = http.read[0..5]
        version = publify_version.split('.')
      end
    rescue
      return
    end
    if version[0].to_i > TYPO_MAJOR.to_i
      flash[:error] = I18n.t('admin.dashboard.publify_version.error')
    elsif version[1].to_i > TYPO_SUB.to_i
      flash[:warning] = I18n.t('admin.dashboard.publify_version.warning')
    elsif version[2].to_i > TYPO_MINOR.to_i
      flash[:notice] = I18n.t('admin.dashboard.publify_version.notice')
    end
  end

  private

  def inbound_links
    host = URI.parse(this_blog.base_url).host
    return [] if Rails.env.development?
    url = "http://www.google.com/search?q=link:#{host}&tbm=blg&output=rss"
    parse(url).reverse.compact
  end

  def publify_dev
    url = 'http://blog.publify.co/articles.rss'
    parse(url)[0..2]
  end

  def parse(url)
    open(url) do |http|
      return parse_rss(http.read)
    end
  rescue
    []
  end

  RssItem = Struct.new(:link, :title, :description, :description_link, :date, :author) do
    def to_s
      title
    end
  end

  def parse_rss(body)
    xml = REXML::Document.new(body.force_encoding('ISO-8859-1').encode('UTF-8'))

    items = []

    REXML::XPath.each(xml, '//item/') do |elem|
      item = RssItem.new
      item.title = REXML::XPath.match(elem, 'title/text()').first.value rescue ''
      item.link = REXML::XPath.match(elem, 'link/text()').first.value rescue ''
      item.description = REXML::XPath.match(elem, 'description/text()').first.value rescue ''
      item.author = REXML::XPath.match(elem, 'dc:publisher/text()').first.value rescue ''
      item.date = Time.mktime(*ParseDate.parsedate(REXML::XPath.match(elem, 'dc:date/text()').first.value)) rescue Date.parse(REXML::XPath.match(elem, 'pubDate/text()').first.value) rescue Time.now

      item.description_link = item.description
      item.description.gsub!(/<\/?a\b.*?>/, '') # remove all <a> tags
      items << item
    end

    items
  end
end

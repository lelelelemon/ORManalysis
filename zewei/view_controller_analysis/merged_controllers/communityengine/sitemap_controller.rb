class SitemapController < BaseController
  layout false
  caches_action :index

  def index
    @users = User.active.select('id', 'login', 'updated_at', 'login_slug')
    @posts = Post.select('posts.id', 'posts.user_id', 'posts.published_as', 'posts.published_at', 'users.id', 'users.login_slug').joins(:user)   #"LEFT JOIN users ON users.id = posts.user_id")

    @categories = Category.all

    respond_to do |format|
      format.html {
        render :layout => 'application'
      }
      format.xml
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title= "#{configatron.community_name} Sitemap" 
 box do 
 @categories.each do |c| 
 link_to c.name, category_path(c) 
 end 
 :pages.l 
 link_to :home.l, '/' 
 link_to t('sitemaps.index.users'), users_path 
 Page.all.each do |page| 
 if (logged_in? || page.page_public) 
 link_to page.title, pages_path(page) 
 end 
 end 
 link_to :log_in.l, '/login' 
 end 

end

  end



end

class CategoriesController < BaseController
  before_action :login_required, :except => [:show, :most_viewed, :rss]
  before_action :admin_required, :only => [:new, :edit, :update, :create, :destroy, :index]

  cache_sweeper :category_sweeper, :only => [:create, :update, :destroy]

  # GET /categories
  # GET /categories.xml
  def index
    @categories = Category.all

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @categories.to_xml }
    end
  end

  # GET /categories/1
  # GET /categories/1.xml
  def show
    @category = Category.find(params[:id])

    order = (params[:popular] ? "view_count #{params[:popular].eql?('DESC') ? 'DESC' : 'ASC'}": "published_at DESC")

    @posts = Post.includes(:tags).where('category_id = ?', @category.id).order(order).page(params[:page])

    @popular_posts = @category.posts.order("view_count DESC").limit(10)
    @popular_polls = Poll.find_popular_in_category(@category)

    @rss_title = "#{configatron.community_name}: #{@category.name} "+:posts.l
    @rss_url = category_path(@category, :format => :rss)

    @active_users = User.includes(:posts).where("posts.category_id = ? AND posts.published_at > ?", @category.id, 14.days.ago).references(:posts).limit(5).order("users.view_count DESC").to_a

    respond_to do |format|
      format.html # show.rhtml
      format.rss {
        render_rss_feed_for(@posts, {:feed => {:title => "#{configatron.community_name}: #{@category.name} "+:posts.l, :link => category_url(@category)},
          :item => {:title => :title,
                    :link =>  Proc.new {|post| user_post_url(post.user, post)},
                    :description => :post,
                    :pub_date => :published_at} })
      }
    end
 @meta = { :description => "#{@category.name} posts.",:keywords => "#{@category.name}"} 
 @section = @category.name 
 unless @active_users.empty? 
 widget do 
 :top_writers.l 
 @active_users.each do |user| 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 link_to image_tag(user.avatar_photo_url(:thumb), :alt => "#{user.login}"), user_path(user) 
 link_to user.login, user_path(user), :class => 'url' 
 if user.description 
 truncate_words( user.description, 10, '...') 
 end 


end

  
 end 
 end 
 end 
 unless @popular_posts.empty? 
 widget do 
 :popular_category.l(:name => @category.name) 
 @popular_posts.each do |post| 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 link_to truncate(post.title, :length => 75), user_post_path(post.user, post) 


end

 
 end 
 end 
 end 
 if logged_in? 
 :have_something_to_contribute.l 
 link_to fa_icon('check', :text => @category.display_new_post_text() || :write_new_post.l(:category=>@category.name)), new_user_post_path({:user_id => current_user, :category_id => @category.id}) 
 else 
 @category.display_new_post_text() || :write_new_post.l(:category=>@category.name) 
 link_to fa_icon('check', :text => :sign_up_for_an_account.l), signup_url 
 :have_an_account.l 
 link_to fa_icon('arrow-right', :text => :login.l), login_url 
 end 
 :show_category.l :category => @category.name 
 link_to :recent.l, category_path(@category), {:class => (params[:popular] ? '' : 'active')} 
 link_to :popular.l, category_path(@category, :popular => 'DESC'), {:class => (params[:popular] ? 'active' : '')}   
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 



end

       
 paginate @posts, :theme => 'bootstrap' 

  end

  # GET /categories/new
  def new
    @category = Category.new
 @page_title= :new_category.l 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 widget do 
 :admin.l 
 link_to_unless_current :features.l, homepage_features_path 
 link_to_unless_current :categories.l, categories_path 
 link_to_unless_current :metro_areas.l, metro_areas_path 
 link_to_unless_current :events.l, admin_events_path 
 link_to_unless_current :statistics.l, statistics_path 
 link_to_unless_current :ads.l, ads_path 
 link_to_unless_current :comments.l, admin_comments_path 
 link_to_unless_current :tags.l, admin_tags_path 
 link_to_unless_current :admin_pages.l, admin_pages_path 
 link_to_unless_current :members.l, admin_users_path 
 if @admin_nav_links.any? 
 @admin_nav_links.each do |link| 
 link_to link[:name], link[:url] 
 end 
 end 
 link_to :cache_clear_link.l, admin_clear_cache_path, data: { confirm: :are_you_sure.l } 
 end 


end

 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 bootstrap_form_for(@category, :layout => :horizontal) do |f| 
 f.text_field :name 
 f.text_area :tips, :rows => 3, :help => 'Encourages people to add to this category' 
 f.text_field :new_post_text, :help => 'Text For New Post Link' 
 f.text_field :nav_text, :help => 'Text for Nav Link' 
 f.form_group :submit_group do 
 f.primary :save.l 
 end 
 end 


end

 

  end

  # GET /categories/1;edit
  def edit
    @category = Category.find(params[:id])
 @page_title = :editing_category.l 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 widget do 
 :admin.l 
 link_to_unless_current :features.l, homepage_features_path 
 link_to_unless_current :categories.l, categories_path 
 link_to_unless_current :metro_areas.l, metro_areas_path 
 link_to_unless_current :events.l, admin_events_path 
 link_to_unless_current :statistics.l, statistics_path 
 link_to_unless_current :ads.l, ads_path 
 link_to_unless_current :comments.l, admin_comments_path 
 link_to_unless_current :tags.l, admin_tags_path 
 link_to_unless_current :admin_pages.l, admin_pages_path 
 link_to_unless_current :members.l, admin_users_path 
 if @admin_nav_links.any? 
 @admin_nav_links.each do |link| 
 link_to link[:name], link[:url] 
 end 
 end 
 link_to :cache_clear_link.l, admin_clear_cache_path, data: { confirm: :are_you_sure.l } 
 end 


end

 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 bootstrap_form_for(@category, :layout => :horizontal) do |f| 
 f.text_field :name 
 f.text_area :tips, :rows => 3, :help => 'Encourages people to add to this category' 
 f.text_field :new_post_text, :help => 'Text For New Post Link' 
 f.text_field :nav_text, :help => 'Text for Nav Link' 
 f.form_group :submit_group do 
 f.primary :save.l 
 end 
 end 


end

 

  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        flash[:notice] = :category_was_successfully_created.l

        format.html { redirect_to category_url(@category) }
        format.xml do
          headers["Location"] = category_url(@category)
          render :nothing => true, :status => "201 Created"
        end
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 @page_title= :new_category.l 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 widget do 
 :admin.l 
 link_to_unless_current :features.l, homepage_features_path 
 link_to_unless_current :categories.l, categories_path 
 link_to_unless_current :metro_areas.l, metro_areas_path 
 link_to_unless_current :events.l, admin_events_path 
 link_to_unless_current :statistics.l, statistics_path 
 link_to_unless_current :ads.l, ads_path 
 link_to_unless_current :comments.l, admin_comments_path 
 link_to_unless_current :tags.l, admin_tags_path 
 link_to_unless_current :admin_pages.l, admin_pages_path 
 link_to_unless_current :members.l, admin_users_path 
 if @admin_nav_links.any? 
 @admin_nav_links.each do |link| 
 link_to link[:name], link[:url] 
 end 
 end 
 link_to :cache_clear_link.l, admin_clear_cache_path, data: { confirm: :are_you_sure.l } 
 end 


end

 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 bootstrap_form_for(@category, :layout => :horizontal) do |f| 
 f.text_field :name 
 f.text_area :tips, :rows => 3, :help => 'Encourages people to add to this category' 
 f.text_field :new_post_text, :help => 'Text For New Post Link' 
 f.text_field :nav_text, :help => 'Text for Nav Link' 
 f.form_group :submit_group do 
 f.primary :save.l 
 end 
 end 


end

 


end

 }
        format.xml  { render :xml => @category.errors.to_xml }
      end
    end
  end

  # patch /categories/1
  # patch /categories/1.xml
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(category_params)
        format.html { redirect_to category_url(@category) }
        format.xml  { render :nothing => true }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 @page_title = :editing_category.l 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 widget do 
 :admin.l 
 link_to_unless_current :features.l, homepage_features_path 
 link_to_unless_current :categories.l, categories_path 
 link_to_unless_current :metro_areas.l, metro_areas_path 
 link_to_unless_current :events.l, admin_events_path 
 link_to_unless_current :statistics.l, statistics_path 
 link_to_unless_current :ads.l, ads_path 
 link_to_unless_current :comments.l, admin_comments_path 
 link_to_unless_current :tags.l, admin_tags_path 
 link_to_unless_current :admin_pages.l, admin_pages_path 
 link_to_unless_current :members.l, admin_users_path 
 if @admin_nav_links.any? 
 @admin_nav_links.each do |link| 
 link_to link[:name], link[:url] 
 end 
 end 
 link_to :cache_clear_link.l, admin_clear_cache_path, data: { confirm: :are_you_sure.l } 
 end 


end

 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 bootstrap_form_for(@category, :layout => :horizontal) do |f| 
 f.text_field :name 
 f.text_area :tips, :rows => 3, :help => 'Encourages people to add to this category' 
 f.text_field :new_post_text, :help => 'Text For New Post Link' 
 f.text_field :nav_text, :help => 'Text for Nav Link' 
 f.form_group :submit_group do 
 f.primary :save.l 
 end 
 end 


end

 


end

 }
        format.xml  { render :xml => @category.errors.to_xml }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to categories_url   }
      format.xml  { render :nothing => true }
    end
  end

  def show_tips
    @category = Category.find(params[:id] )
    render :partial => "/categories/tips", :locals => {:category => @category}
  rescue ActiveRecord::RecordNotFound
    render :partial => "/categories/tips", :locals => {:category => nil}
  end


  private

  def category_params
    params[:category].permit(:name, :tips, :new_post_text, :nav_text)
  end

end
class PagesController < BaseController
  uses_tiny_mce do
    {:only => [:new, :edit, :update, :create ], :options => configatron.default_mce_options}
  end

  cache_sweeper :page_sweeper, :only => [:create, :update, :destroy]
  caches_action :show, :if => Proc.new{|c| c.cache_action? }

  def cache_action?
    !logged_in? && controller_name.eql?('pages')
  end

  before_action :login_required, :only => [:index, :new, :edit, :update, :destroy, :create, :preview]
  before_action :require_moderator, :only => [:index, :new, :edit, :update, :destroy, :create, :preview]

  def index
    @pages = Page.unscoped.order('created_at DESC').page(params[:page])
 @page_title=:manage_pages.l 
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
 
 widget do 
 :tips.l 
 :page_tips.l 
 end 
 :pages_saved_with_draft_status_wont_appear_on_the_site_until_you_publish_them.l 
 :title.l 
 :public.l 
 :status.l 
 :actions.l 
 @pages.each do |page| 
 link_to page.title, edit_admin_page_path(page) 
 if page.is_public? 
 t(:yes) 
 else 
 t(:no) 
 end 
 page.is_live? ? link_to(:published.l, pages_path(page)) : :draft.l 
 link_to :show.l, pages_path(page), :class => 'btn btn-primary' 
 unless page.is_live? 
 link_to :preview.l, preview_admin_page_path(page), :class => 'btn btn-default' 
 end 
 link_to :edit.l, edit_admin_page_path(page), :class => 'btn btn-warning' 
 link_to :delete.l, pages_path(page), :method => 'delete', data: { confirm: :are_you_sure.l }, :class => 'btn btn-danger' 
 end 
 paginate @pages, :theme => 'bootstrap' 
 link_to :new_page.l, new_admin_page_path, :class => 'btn btn-success' 

  end

  def preview
    @page = Page.unscoped.find(params[:id])
    
  end

  def show
    @page = Page.live.find(params[:id])
    unless logged_in? || @page.page_public
      flash[:error] = :page_not_public_warning.l
      redirect_to :controller => 'sessions', :action => 'new'
    end
  rescue
    flash[:error] = :page_not_found.l
    redirect_to home_path
  end
  
  def new
    @page = Page.new
 @page_title= :new_page.l 
 link_to :back.l, admin_pages_path, :class => 'btn btn-default' 
  if @page.new_record? 
 url = admin_pages_path 
 else 
 url = admin_page_path(@page) 
 end 
 bootstrap_form_for @page, :url => url, :layout => :horizontal do |f| 
 f.text_field :title 
 f.text_area :body, :class => "rich_text_editor" 
 f.form_group :public do 
 f.check_box :page_public, :label => :make_page_public.l 
 :when_checked_this_page_will_be_visible_to_anyone.l 
 :when_unchecked_this_page_will_only_be_visible_to_people_who_are_logged_in_to.l 
 configatron.community_name 
 end 
 f.select :published_as, [[:published.l, 'live'], [:draft.l, 'draft']], :label => :save_page_as.l 
 f.form_group :submit_group do 
 f.primary :save.l 
 end 
 end 
 

  end 
  
  def edit
    @page = Page.unscoped.find(params[:id])
 @page_title= :edit_page.l 
  if @page.new_record? 
 url = admin_pages_path 
 else 
 url = admin_page_path(@page) 
 end 
 bootstrap_form_for @page, :url => url, :layout => :horizontal do |f| 
 f.text_field :title 
 f.text_area :body, :class => "rich_text_editor" 
 f.form_group :public do 
 f.check_box :page_public, :label => :make_page_public.l 
 :when_checked_this_page_will_be_visible_to_anyone.l 
 :when_unchecked_this_page_will_only_be_visible_to_people_who_are_logged_in_to.l 
 configatron.community_name 
 end 
 f.select :published_as, [[:published.l, 'live'], [:draft.l, 'draft']], :label => :save_page_as.l 
 f.form_group :submit_group do 
 f.primary :save.l 
 end 
 end 
 

  end

  def create
    @page = Page.new(page_params)
    if @page.save
      flash[:notice] = :page_was_successfully_created.l
      redirect_to admin_pages_path
    else
       @page_title= :new_page.l 
 link_to :back.l, admin_pages_path, :class => 'btn btn-default' 
  if @page.new_record? 
 url = admin_pages_path 
 else 
 url = admin_page_path(@page) 
 end 
 bootstrap_form_for @page, :url => url, :layout => :horizontal do |f| 
 f.text_field :title 
 f.text_area :body, :class => "rich_text_editor" 
 f.form_group :public do 
 f.check_box :page_public, :label => :make_page_public.l 
 :when_checked_this_page_will_be_visible_to_anyone.l 
 :when_unchecked_this_page_will_only_be_visible_to_people_who_are_logged_in_to.l 
 configatron.community_name 
 end 
 f.select :published_as, [[:published.l, 'live'], [:draft.l, 'draft']], :label => :save_page_as.l 
 f.form_group :submit_group do 
 f.primary :save.l 
 end 
 end 
 

    end
  end

  def update
    if @page.update_attributes(page_params)
      flash[:notice] = :page_was_successfully_updated.l
      redirect_to admin_pages_path
    else
       @page_title= :edit_page.l 
  if @page.new_record? 
 url = admin_pages_path 
 else 
 url = admin_page_path(@page) 
 end 
 bootstrap_form_for @page, :url => url, :layout => :horizontal do |f| 
 f.text_field :title 
 f.text_area :body, :class => "rich_text_editor" 
 f.form_group :public do 
 f.check_box :page_public, :label => :make_page_public.l 
 :when_checked_this_page_will_be_visible_to_anyone.l 
 :when_unchecked_this_page_will_only_be_visible_to_people_who_are_logged_in_to.l 
 configatron.community_name 
 end 
 f.select :published_as, [[:published.l, 'live'], [:draft.l, 'draft']], :label => :save_page_as.l 
 f.form_group :submit_group do 
 f.primary :save.l 
 end 
 end 
 

    end
  end

  def destroy
    @page.destroy
    flash[:notice] = :page_was_successfully_deleted.l
    redirect_to admin_pages_path
  end

  private

  def require_moderator
    @page ||= Page.unscoped.find(params[:id]) if params[:id]
    unless admin? || moderator?
      redirect_to :controller => 'sessions', :action => 'new' and return false
    end
  end

  def page_params
    params.require(:page).permit(:title, :body, :published_as, :page_public)
  end

end

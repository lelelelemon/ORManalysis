class HomepageFeaturesController < BaseController
  uses_tiny_mce do
    {:only => [:new, :edit, :create, :update ], :options => configatron.default_mce_options}
  end

  before_action :login_required
  before_action :admin_required

  def index
    @search = HomepageFeature.search(params[:q])
    @homepage_features = @search.result
    @homepage_features = @homepage_features.order('created_at DESC').page(params[:page]).per(100)
    respond_to do |format|
      format.html
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title = :homepage_features.l 
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
 
 :date_title.l 
 :title.l 
 :description.l 
 :image.l 
 :actions.l 
 for homepage_feature in @homepage_features 
 h I18n.l(homepage_feature.created_at, :format => :short_published_date) 
 h homepage_feature.url 
 h homepage_feature.title 
 h truncate(homepage_feature.description, :length => 250).html_safe 
 image_tag homepage_feature.image.url(:thumb) 
 link_to :show.l, homepage_feature_path(homepage_feature), :class => 'btn btn-default' 
 link_to :edit.l, edit_homepage_feature_path(homepage_feature), :class => 'btn btn-warning' 
 link_to :delete.l, homepage_feature_path(homepage_feature), data: { confirm: :are_you_sure.l }, :method => :delete, :class => 'btn btn-danger' 
 end 
 link_to :new_homepage_feature.l, new_homepage_feature_path, :class => 'btn btn-success' 

end

  end
  
  def show
    @homepage_feature = HomepageFeature.find(params[:id])
    
    respond_to do |format|
      format.html 
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title = @homepage_feature.title 
 link_to :back.l, homepage_features_path, :class => 'btn btn-default' 
 link_to :edit.l, edit_homepage_feature_path(@homepage_feature), :class => 'btn btn-warning' 
 link_to :delete.l, homepage_feature_path(@homepage_feature), data: { confirm: :are_you_sure.l }, :method => :delete, :class => 'btn btn-danger' 
 unless @homepage_feature.url.blank? 
 :url.l 
 h @homepage_feature.url 
 end 
 unless @homepage_feature.title.blank? 
 :title.l 
 h @homepage_feature.title 
 end 
 unless @homepage_feature.description.blank? 
 :description.l 
 @homepage_feature.description.html_safe 
 end 
 :created_at.l 
 h @homepage_feature.created_at 
 :updated_at.l 
 h @homepage_feature.updated_at 
 image_tag @homepage_feature.image.url(:large), :class => 'thumbnail' 

end

  end
  
  def new
    @homepage_feature = HomepageFeature.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title = :new_homepage_feature.l 
  bootstrap_form_for(@homepage_feature, :html => {:multipart => true}, :layout => :horizontal) do |f| 
 f.text_field :url 
 f.text_field :title 
 f.text_area :description, :rows => 10, :class => "rich_text_editor" 
 f.file_field :image, :required => true 
 f.primary :save.l 
 end 
 

end

  end
  
  def edit
    @homepage_feature = HomepageFeature.find(params[:id])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 link_to :back.l, homepage_features_path, :class => 'btn btn-default' 
 link_to :show.l, homepage_feature_path(@homepage_feature), :class => 'btn btn-primary' 
 link_to :delete.l, homepage_feature_path(@homepage_feature), data: { confirm: :are_you_sure.l }, :method => :delete, :class => 'btn btn-danger' 
  bootstrap_form_for(@homepage_feature, :html => {:multipart => true}, :layout => :horizontal) do |f| 
 f.text_field :url 
 f.text_field :title 
 f.text_area :description, :rows => 10, :class => "rich_text_editor" 
 f.file_field :image, :required => true 
 f.primary :save.l 
 end 
 

end

  end

  def create
    @homepage_feature = HomepageFeature.new(homepage_feature_params)
    
    respond_to do |format|
      if @homepage_feature.save
        flash[:notice] = :homepage_feature_created.l
        
        format.html { redirect_to homepage_feature_url(@homepage_feature) }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title = :new_homepage_feature.l 
  bootstrap_form_for(@homepage_feature, :html => {:multipart => true}, :layout => :horizontal) do |f| 
 f.text_field :url 
 f.text_field :title 
 f.text_area :description, :rows => 10, :class => "rich_text_editor" 
 f.file_field :image, :required => true 
 f.primary :save.l 
 end 
 

end
 }
      end
    end
  end
  
  def update
    @homepage_feature = HomepageFeature.find(params[:id])
    
    respond_to do |format|
      if @homepage_feature.update_attributes(homepage_feature_params)
        format.html { redirect_to homepage_feature_url(@homepage_feature) }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 link_to :back.l, homepage_features_path, :class => 'btn btn-default' 
 link_to :show.l, homepage_feature_path(@homepage_feature), :class => 'btn btn-primary' 
 link_to :delete.l, homepage_feature_path(@homepage_feature), data: { confirm: :are_you_sure.l }, :method => :delete, :class => 'btn btn-danger' 
  bootstrap_form_for(@homepage_feature, :html => {:multipart => true}, :layout => :horizontal) do |f| 
 f.text_field :url 
 f.text_field :title 
 f.text_area :description, :rows => 10, :class => "rich_text_editor" 
 f.file_field :image, :required => true 
 f.primary :save.l 
 end 
 

end
 }
      end
    end
  end
  
  def destroy
    @homepage_feature = HomepageFeature.find(params[:id])
    @homepage_feature.destroy
    
    respond_to do |format|
      format.html { redirect_to homepage_features_url   }
    end
  end

  private

  def homepage_feature_params
    params[:homepage_feature].permit(:url, :title, :description, :image)
  end
end
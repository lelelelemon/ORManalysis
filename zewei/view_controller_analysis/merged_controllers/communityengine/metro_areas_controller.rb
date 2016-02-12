class MetroAreasController < BaseController
  before_action :login_required
  before_action :admin_required

  def index
    @metro_areas = MetroArea.includes(:country).order("countries.name, metro_areas.name DESC").references(:countries).page(params[:page])
 @page_title = :metro_areas.l 
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
 
 :name.l 
 :state.l 
 :country.l 
 :actions.l 
 for metro_area in @metro_areas 
 link_to metro_area.name, metro_area 
 metro_area.state.name if metro_area.state 
 metro_area.country.name 
 link_to :show.l, metro_area_path(metro_area), :class => 'btn btn-default' 
 link_to :edit.l, edit_metro_area_path(metro_area), :class => 'btn btn-warning' 
 link_to :delete.l, metro_area_path(metro_area), data: { confirm: :are_you_sure.l }, :method => :delete, :class => 'btn btn-danger' 
 end 
 paginate @metro_areas, :theme => 'bootstrap' 
 link_to :new_metro_area.l, new_metro_area_path, :class => 'btn btn-success' 

  end
  
  def show
    @metro_area = MetroArea.find(params[:id])
    
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @metro_area.to_xml }
    end
 @page_title=:showing_metro_area_details.l 
 link_to :back.l, metro_areas_path, :class => 'btn btn-default' 
 link_to :edit.l, edit_metro_area_path(@metro_area), :class => 'btn btn-warning' 
 link_to :delete.l, metro_area_path(@metro_area), data: { confirm: :are_you_sure.l }, :method => :delete, :class => 'btn btn-danger' 
 :country.l 
 h @metro_area.country.name 
 if @metro_area.state 
 :state.l 
 @metro_area.state.name 
 end 
 :name.l 
 @metro_area.name 

  end
  
  def new
    @metro_area = MetroArea.new
 @page_title= :new_metro_area.l 
 link_to :back.l, metro_areas_path, :class => 'btn btn-default' 
  bootstrap_form_for @metro_area, :layout => :horizontal do |f| 
 f.collection_select :country_id, Country.order('name ASC'), :id, :name 
 f.collection_select :state_id, State.all, :id, :name, :include_blank => true 
 f.text_field :name 
 f.form_group :submit_group do 
 f.primary :save.l 
 end 
 end 
 

  end
  
  def edit
    @metro_area = MetroArea.find(params[:id])
 @page_title= :editing_metro_area.l 
 link_to :back.l, metro_areas_path, :class => 'btn btn-default' 
 link_to :show.l, metro_area_path(@metro_area), :class => 'btn btn-primary' 
 link_to :delete.l, metro_area_path(@metro_area), data: { confirm: :are_you_sure.l }, :method => :delete, :class => 'btn btn-danger' 
  bootstrap_form_for @metro_area, :layout => :horizontal do |f| 
 f.collection_select :country_id, Country.order('name ASC'), :id, :name 
 f.collection_select :state_id, State.all, :id, :name, :include_blank => true 
 f.text_field :name 
 f.form_group :submit_group do 
 f.primary :save.l 
 end 
 end 
 

  end

  def create
    @metro_area = MetroArea.new(metro_area_params)
    
    respond_to do |format|
      if @metro_area.save
        flash[:notice] = :metro_area_was_successfully_created.l
        
        format.html { redirect_to metro_area_url(@metro_area) }
        format.xml do
          headers["Location"] = metro_area_url(@metro_area)
          render :nothing => true, :status => "201 Created"
        end
      else
        format.html {  @page_title= :new_metro_area.l 
 link_to :back.l, metro_areas_path, :class => 'btn btn-default' 
  bootstrap_form_for @metro_area, :layout => :horizontal do |f| 
 f.collection_select :country_id, Country.order('name ASC'), :id, :name 
 f.collection_select :state_id, State.all, :id, :name, :include_blank => true 
 f.text_field :name 
 f.form_group :submit_group do 
 f.primary :save.l 
 end 
 end 
 
 }
        format.xml  { render :xml => @metro_area.errors.to_xml }
      end
    end
  end
  
  def update
    @metro_area = MetroArea.find(params[:id])
    
    respond_to do |format|
      if @metro_area.update_attributes(metro_area_params)
        format.html { redirect_to metro_area_url(@metro_area) }
        format.xml  { render :nothing => true }
      else
        format.html {  @page_title= :editing_metro_area.l 
 link_to :back.l, metro_areas_path, :class => 'btn btn-default' 
 link_to :show.l, metro_area_path(@metro_area), :class => 'btn btn-primary' 
 link_to :delete.l, metro_area_path(@metro_area), data: { confirm: :are_you_sure.l }, :method => :delete, :class => 'btn btn-danger' 
  bootstrap_form_for @metro_area, :layout => :horizontal do |f| 
 f.collection_select :country_id, Country.order('name ASC'), :id, :name 
 f.collection_select :state_id, State.all, :id, :name, :include_blank => true 
 f.text_field :name 
 f.form_group :submit_group do 
 f.primary :save.l 
 end 
 end 
 
 }
        format.xml  { render :xml => @metro_area.errors.to_xml }        
      end
    end
  end
  
  def destroy
    @metro_area = MetroArea.find(params[:id])
    @metro_area.destroy
    
    respond_to do |format|
      format.html { redirect_to metro_areas_url   }
      format.xml  { render :nothing => true }
    end
  end

  private

  def metro_area_params
    params[:metro_area].permit(:name, :state, :country_id, :state_id)
  end
end
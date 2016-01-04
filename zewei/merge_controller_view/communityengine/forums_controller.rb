class ForumsController < BaseController
  before_action :admin_required, :except => [:index, :show]

  uses_tiny_mce do    
    {:options => configatron.default_mce_options}
  end
  
  def index
    @forums = Forum.order("position")
    respond_to do |format|
      format.html
      format.xml { render :xml => @forums }
    end
  end

  def show
    @forum = Forum.find(params[:id])
    respond_to do |format|
      format.html do
        # keep track of when we last viewed this forum for activity indicators
        (session[:forums] ||= {})[@forum.id] = Time.now.utc if logged_in?

        @topics = @forum.topics.includes(:replied_by_user).order('sticky DESC, replied_at DESC').page(params[:page]).per(20)
      end
      
      format.xml do
        render :xml => @forum
      end
    end
  end

  def new
    @forum = Forum.new
 @page_title = :new_forum.l 
 link_to :back.l, forums_path, :class => 'btn btn-default' 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 bootstrap_form_for @forum, :layout => :horizontal do |f| 
 f.text_field :name 
 f.number_field :position 
 f.text_field :tag_list, :autocomplete => "off", :help => :optional_keywords_describing_this_forum_separated_by_commas.l 
 content_for :end_javascript do 
 tag_auto_complete_field 'forum_tag_list', {:url => { :controller => "tags", :action => 'auto_complete_for_tag_name'}, :tokens => [','] } 
 end 
 f.text_area :description, :rows => 7, :class => "rich_text_editor" 
 f.form_group :submit_group do 
 f.primary :save.l 
 end 
 end 


end

 

  end
  
  def create
    @forum = Forum.new(forum_params)
    @forum.tag_list = params[:tag_list] || ''
    @forum.save!
    respond_to do |format|
      format.html { redirect_to forums_path }
      format.xml  { head :created, :location => forum_url(:id => @forum, :format => :xml) }
    end
  end

  def edit
    @forum = Forum.find(params[:id])
 @page_title = :edit_forum.l 
 link_to :back.l, forums_path, :class => 'btn btn-default' 
 link_to :show.l, forum_path(@forum), :class => 'btn btn-primary' 
 link_to :delete.l, forum_path(@forum), :method => 'delete', data: { confirm: :are_you_sure.l }, :class => 'btn btn-danger' 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 

 bootstrap_form_for @forum, :layout => :horizontal do |f| 
 f.text_field :name 
 f.number_field :position 
 f.text_field :tag_list, :autocomplete => "off", :help => :optional_keywords_describing_this_forum_separated_by_commas.l 
 content_for :end_javascript do 
 tag_auto_complete_field 'forum_tag_list', {:url => { :controller => "tags", :action => 'auto_complete_for_tag_name'}, :tokens => [','] } 
 end 
 f.text_area :description, :rows => 7, :class => "rich_text_editor" 
 f.form_group :submit_group do 
 f.primary :save.l 
 end 
 end 


end

 

  end

  def update
    @forum = Forum.find(params[:id])
    @forum.tag_list = params[:tag_list] || ''
    @forum.update_attributes!(forum_params)
    respond_to do |format|
      format.html { redirect_to forums_path }
      format.xml  { head 200 }
    end
  end
  
  def destroy
    @forum = Forum.find(params[:id])
    @forum.destroy
    respond_to do |format|
      format.html { redirect_to forums_path }
      format.xml  { head 200 }
    end
  end
  
  private

  def forum_params
    params[:forum].permit(:name, :position, :description)
  end
    
end

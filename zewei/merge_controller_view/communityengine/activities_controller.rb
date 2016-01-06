class ActivitiesController < BaseController
  before_action :login_required,  :except => :index
  before_action :find_user,       :only => :network

  before_action :require_current_user,            :except => [:index, :destroy]
  before_action :require_ownership_or_moderator,  :only   => :destroy


  def network
    @activities = @user.network_activity(:per_page => 15, :page => params[:page])
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 



end

 
 unless @activities.empty? 
 :activity_from_your_network.l 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 



end

 
 if @activities.total_count > 1 
 paginate @activities, :theme => 'bootstrap' 
 end 
 else 
 :you_have_no_network_activity_yet.l  
 link_to :add_some_friends_to_get_started.l, users_path 
 end 

  end

  def index
    @activities = User.recent_activity(:per_page => 30, :page => params[:page], :limit => 1000)
    @popular_tags = popular_tags(30).to_a
 @section = 'activities' 
 @page_title = 'Recent Activities' 
 :whats_fresh.l 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 



end

 
 paginate @activities, :theme => 'bootstrap' 
 widget do 
 :tags.l 
 tag_cloud @popular_tags, %w(nube1 nube2 nube3 nube4 nube5) do |tag, css_class| 
 link_to tag.name, tag_path(tag.to_param), :class => css_class 
 end 
 link_to fa_icon('plus-circle', :text => :all_tags.l.downcase.capitalize), tags_path 
 end 

  end

  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy

    respond_to do |format|
      format.html {redirect_to :back and return}
      format.js
    end
  end

  private
    def require_ownership_or_moderator
      @activity = Activity.find(params[:id])

      unless @activity && @activity.can_be_deleted_by?(current_user)
        redirect_to :controller => 'sessions', :action => 'new' and return false
      end
      return @user
    end

end

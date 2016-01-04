class StatisticsController < BaseController
  before_action :login_required
  before_action :admin_required

  def index
    @total_users = User.where('activated_at IS NOT NULL').count
    @unactivated_users = User.where('activated_at IS NULL').count

    @yesterday_new_users = find_new_users(1.day.ago.midnight, Date.today.midnight)
    @today_new_users = find_new_users(Date.today.midnight, Date.today.tomorrow.midnight)  

    # Query returns a hash of user_id to number of activities for that user.
    @active_users_count = Activity.group("user_id").having("count(created_at > ?) > 0", 1.month.ago).count.keys.size

    @active_users = User.find_by_activity({:since => 1.month.ago})
    
    @percent_reporting_zip = (User.where("zip IS NOT NULL").count / @total_users.to_f)*100
    
    users_reporting_gender = User.where("gender IS NOT NULL").count
    @percent_male = (User.where('gender = ?', User::MALE).count / users_reporting_gender.to_f) * 100
    @percent_female = (User.where('gender = ?', User::FEMALE).count / users_reporting_gender.to_f) * 100
    
    @featured_writers = User.find_featured

    @posts = Post.includes(:user).where('? <= posts.published_at AND posts.published_at <= ? AND users.featured_writer = ?', Time.now.beginning_of_month, (Time.now.end_of_month + 1.day), true).includes(:users)
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

 
 @page_title = :statistics.l 
 :total_users.l 
 @total_users 
 :unactivated_users.l 
 @unactivated_users 
 :new_today.l 
 @today_new_users.size 
 @today_new_users.each do |user| 
 link_to user.login, user_path(user) 
 end 
 :new_yesterday.l 
 @yesterday_new_users.size 
 @yesterday_new_users.each do |user| 
 link_to user.login, user_path(user) 
 end 
 :active.l 
 pluralize @active_users_count, :user.l 
 number_to_percentage((@active_users_count/@total_users.to_f)*100, :precision => 1) 
 ", 1 "+:month.l+")" 
 :most_active_1_month.l 
 'Users' 
 @active_users.each do |user| 
 link_to user.login, user_path(user.id) 
 user.activities_count 
 end 
 'Reporting ZIP' 
 number_to_percentage @percent_reporting_zip, :precision => 1 
 :male.l 
 number_to_percentage @percent_male 
 :female.l 
 number_to_percentage @percent_female 
 :featured_writer.l 
 @featured_writers.each do |w| 
 link_to w.login, statistics_user_path(w) 
 end 

  end  

      
  protected
    def find_new_users(from, to, limit= nil)
      User.active.where(:created_at => from..to)
    end
  

end

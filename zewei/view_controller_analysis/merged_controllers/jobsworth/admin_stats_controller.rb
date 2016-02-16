# encoding: UTF-8
# Controller handling admin activities

class AdminStatsController < ApplicationController
  before_filter :authorize_user_is_admin

  def index
    @users_from_this_year = User.from_this_year
    @users_total          = User.count

    @projects_from_this_year = Project.from_this_year
    @projects_total          = Project.count

    @tasks_from_this_year = TaskRecord.from_this_year
    @tasks_total          = TaskRecord.count

    @last_50_users = User.recent_users
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t("admin_stats.admin_stats") 
 link_to t("admin_stats.admin"), :action => "index" 
 link_to t("admin_stats.news"), :action => "news" 
 t("admin_stats.active_users") 
 t("shared.today") 
 total_count_for(@users_from_this_year,"today","last_sign_in_at") 
 t("shared.this_week") 
 total_count_for(@users_from_this_year,"this_week","last_sign_in_at") 
 t("shared.this_month") 
 total_count_for(@users_from_this_year,"this_month","last_sign_in_at") 
 t("shared.this_year") 
 total_count_for(@users_from_this_year,"this_year","last_sign_in_at") 
 t("admin_stats.user_registrations") 
 t("shared.today") 
 total_count_for(@users_from_this_year,"today") 
 t("shared.yesterday") 
 total_count_for(@users_from_this_year,"yesterday") 
 t("shared.this_week") 
total_count_for(@users_from_this_year,"this_week") 
 t("shared.last_week") 
 total_count_for(@users_from_this_year, "last_week") 
 t("shared.this_month") 
 total_count_for(@users_from_this_year,"this_month") 
 t("shared.last_month") 
 total_count_for(@users_from_this_year,"last_month") 
 t("shared.this_year") 
 total_count_for(@users_from_this_year,"this_year") 
 t("shared.total") 
 @users_total 
 t("admin_stats.projects") 
 t("shared.today") 
 total_count_for(@projects_from_this_year,"today") 
 t("shared.yesterday") 
 total_count_for(@projects_from_this_year,"yesterday") 
 t("shared.this_week") 
total_count_for(@projects_from_this_year,"this_week") 
 t("shared.last_week") 
 total_count_for(@projects_from_this_year, "last_week") 
 t("shared.this_month") 
 total_count_for(@projects_from_this_year,"this_month") 
 t("shared.last_month") 
 total_count_for(@projects_from_this_year,"last_month") 
 t("shared.this_year") 
 total_count_for(@projects_from_this_year,"this_year") 
 t("shared.total") 
 @projects_total 
 t("shared.today") 
 total_count_for(@tasks_from_this_year,"today") 
 t("shared.yesterday") 
 total_count_for(@tasks_from_this_year,"yesterday") 
 t("shared.this_week") 
total_count_for(@tasks_from_this_year,"this_week") 
 t("shared.last_week") 
 total_count_for(@tasks_from_this_year, "last_week") 
 t("shared.this_month") 
 total_count_for(@tasks_from_this_year,"this_month") 
 t("shared.last_month") 
 total_count_for(@tasks_from_this_year,"last_month") 
 t("shared.this_year") 
 total_count_for(@tasks_from_this_year,"this_year") 
 t("shared.total") 
 @tasks_total 
 t("admin_stats.last_registered_users") 
 t("admin_stats.name") 
 t("admin_stats.company") 
 t("admin_stats.email") 
 t("admin_stats.created") 
 t("admin_stats.timezone") 
 for u in @last_50_users 
 u.name 
 u.company.name 
 u.email 
 tz.utc_to_local(u.created_at).strftime("%d/%m %Y %H:%M") 
 u.time_zone 
 end 

end

  end
end

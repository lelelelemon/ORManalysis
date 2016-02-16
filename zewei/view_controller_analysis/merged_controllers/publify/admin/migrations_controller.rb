class Admin::MigrationsController < Admin::BaseController
  cache_sweeper :blog_sweeper
  skip_before_action :look_for_needed_db_updates

  def show
    @current_version = migrator.current_schema_version
    @needed_migrations = migrator.pending_migrations
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :page_heading do 
 t(".database_migration") 
 end 
 t(".information") 
 t(".current_database_version") 
 @current_version 
 unless @needed_migrations.blank? 
 t(".migrations")
 t(".migration_pending", count: @needed_migrations.count) 
 t(".needed_migrations")
 for migration in @needed_migrations 
 migration.name 
 end 
 end 
 form_tag admin_migrations_path do 
 if @needed_migrations.blank? 
 t(".you_are_up_to_date")
 else 
 submit_tag(t(".update_database_now"), class: 'btn btn-success') 
 t(".may_take_a_moment")
 end 
 end 

end

  end

  def update
    migrator.migrate
    redirect_to admin_migrations_url
  end

  private

  def migrator
    @migrator ||= Migrator.new
  end
end

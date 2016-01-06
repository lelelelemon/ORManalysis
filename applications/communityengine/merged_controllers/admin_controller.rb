class AdminController < BaseController
  before_action :admin_required

  def clear_cache
    case Rails.cache
      when ActiveSupport::Cache::FileStore
        dir = Rails.cache.cache_path
        unless dir == Rails.public_path
          FileUtils.rm_r(Dir.glob(dir+"/*")) rescue Errno::ENOENT
          Rails.logger.info("Cache directory fully swept.")
        end
        flash[:notice] = :cache_cleared.l
      else
        Rails.logger.warn("Cache not swept: you must override AdminController#clear_cache to support #{Rails.cache}")
    end
    redirect_to admin_dashboard_path and return
  end

  def events
    @events = Event.order('start_time DESC').page(params[:page])

  end

  def messages
    @user = current_user
    @messages = Message.order('created_at DESC').page(params[:page]).per(50)
 @page_title = :sent_messages.l 
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

 @page_title = :sent_messages.l 
 if @messages.empty? 
 :no_messages.l 
 else 
 @messages.each do |message| 
 check_box_tag "delete[]", message.id 
 :to.l 
 link_to h(message.recipient.login), user_path(message.recipient) 
 link_to image_tag( message.recipient.avatar_photo_url(:thumb), :alt => message.recipient.login , :class => 'thumbnail'), user_path(message.recipient), :title => :users_profile.l(:user => message.recipient.login) 
 link_to h(message.subject), user_message_path(message.sender, message) 
 time_ago_in_words_or_date(message.created_at) 
 end 
 submit_tag :delete_selected.l, :class => 'btn btn-danger' 
 paginate @messages, :theme => 'bootstrap' 
 end 


end

 

  end

  def users
    @users = User.recent
    user = User.arel_table

    if params['login']
      @users = @users.where(user[:login].matches("%#{params['login']}%"))
    end
    if params['email']
      @users = @users.where(user[:email].matches("%#{params['email']}%"))
    end

    @users = @users.page(params[:page]).per(100)

    respond_to do |format|
      format.html
      format.xml {
        render :xml => @users.to_xml(:except => [ :password, :crypted_password, :single_access_token, :perishable_token, :password_salt, :persistence_token ])
      }
    end
  end

  def comments
    @search = Comment.search(params[:q])
    @comments = @search.result.distinct
    @comments = @comments.order("created_at DESC").page(params[:page]).per(100)
 @page_title = 'Comments' 
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

 
 bootstrap_form_for @search, :url => admin_comments_path, :layout => :horizontal do |f| 
 :search.l 
 f.text_field :author_email_or_user_email_cont, :label => :email.l 
 f.form_group :submit_group  do 
 f.primary :search.l 
 end 
 end 
 bootstrap_form_tag :url => delete_selected_comments_path, :method => :delete, :id => 'comments' do 
 :delete.l 
 :author.l 
 :body_text.l 
 :on_commentable.l 
 :actions.l 
 @comments.each do |comment| 
 comment.id 
 check_box_tag "delete[]", comment.id 
 if comment.user 
 link_to h(comment.user.login), user_path(comment.user) 
 comment.user.email 
 else 
 link_to_unless(comment.author_url.blank?, h(comment.username), h(comment.author_url)){ h(comment.username) } 
 comment.author_email 
 "(#{comment.author_url})" 
 end 
 comment.comment.html_safe 
 if comment.commentable_name.blank? 
 link_to comment.commentable_type, commentable_url(comment) 
 else 
 link_to comment.commentable_name, commentable_url(comment) 
 end 
 link_to :delete.l, commentable_comment_path(comment.commentable_type, comment.commentable_id, comment), :method => :delete, :remote => true, :data => { :confirm => :are_you_sure_you_want_to_permanently_delete_this_comment.l }, :class => 'btn btn-danger' 
 end 
 if @comments.any? 
 submit_tag :delete_selected.l, :class => 'btn btn-danger' 
 end 
 end 
 paginate @comments, :theme => 'bootstrap' 

  end

  def activate_user
    user = User.find(params[:id])
    user.activate
    flash[:notice] = :the_user_was_activated.l
    redirect_to :action => :users
  end

  def deactivate_user
    user = User.find(params[:id])
    user.deactivate
    flash[:notice] = :the_user_was_deactivated.l
    redirect_to :action => :users
  end

  def subscribers
    @users = User.where("notify_community_news = ? AND users.activated_at IS NOT NULL", (params[:unsubs] ? false : true))

    respond_to do |format|
      format.xml {
        render :xml => @users.to_xml(:only => [:login, :email])
      }
    end

  end

end
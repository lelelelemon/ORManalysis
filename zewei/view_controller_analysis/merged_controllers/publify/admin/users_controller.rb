class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:edit, :update, :destroy]
  cache_sweeper :blog_sweeper

  def index
    @users = User.order('login asc').page(params[:page]).per(this_blog.admin_display_elements)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :page_heading do 
 t(".users") 
 link_to(t(".new_user"), new_admin_user_path, id: 'dialog-link', class: 'btn btn-info pull-right') 
 end 
 t(".login") 
 t(".name") 
 t(".email") 
 t(".profile") 
 t(".articles") 
 t(".comments") 
 t(".state") 
 for user in @users 
 link_to user.login, author_path(id: user.login) 
 link_to(content_tag(:span, '', class: 'glyphicon glyphicon-pencil'), edit_admin_user_path(user), class: 'btn btn-primary btn-xs btn-action' ) 
 link_to(content_tag(:span, '', class: 'glyphicon glyphicon-link'), author_path(id:user.login), class: 'btn btn-success btn-xs btn-action' ) 
 user.nickname 
 mail_to user.email, user.email 
 t("profile.#{user.profile.label}") 
 Article.where("user_id = #{user.id}").count 
 Comment.where("user_id = #{user.id}").count 
 t("user.status.#{user.state}") 
 end 
 display_pagination(@users, 7) 

end

  end

  def new
    @user = User.new
    @user.text_filter = TextFilter.find_by_name(this_blog.text_filter)
    setup_profiles
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :page_heading do 
 t(".add_user") 
 end 
  form_for([:admin, @user]) do |f| 
 if @user.errors.any? 
 pluralize(@user.errors.count, "error") 
 @user.errors.full_messages.each do |message| 
 message 
 end 
 end 
 t('.account_settings')
 t('.login')
 f.text_field :login, class: 'form-control' 
 t('.password')
 f.password_field :password, class: 'form-control' 
 t('.password_confirmation')
 f.password_field :password_confirmation, :class => 'form-control' 
 t('.email')
 f.text_field :email, class: 'form-control' 
 if controller.controller_name == 'users' 
 t('.profile')
 f.collection_select :profile_id, Profile.order('id').all, :id, :label, { include_blank: false }, class: 'form-control' 
 t('.user_status')
 User::STATUS.each do |state| 
 state 
 'selected' if @user.state == state 
 t("user.status.#{state}") 
 end 
 end 
 t('.profile_settings')
 t('.firstname') 
 f.text_field :firstname, class: 'form-control' 
 t('.lastname') 
 f.text_field :lastname, class: 'form-control' 
 t('.nickname') 
 f.text_field :nickname, class: 'form-control' 
 unless @user.login.nil? 
 t('.display_name') 
 options_for_select(@user.display_names, @user.name) 
 end 
 t('.article_filter') 
 options_for_select text_filter_options_with_id, @user.text_filter.id 
 unless controller.controller_name == 'users'
 t('.avatar') 
 display_user_avatar(current_user, 'thumb') 
 t('.avatar_current') 
 t('.upload') 
 f.file_field :filename, class: 'input-file' 
 t('.upload_file') 
 end 
 t('.notification_settings') 
 t('.notifications') 
 f.check_box :notify_via_email 
 t('.notification_email') 
 f.check_box :notify_on_new_articles 
 t('.notification_article') 
 f.check_box :notify_on_comments 
 t('.notification_comment') 
 unless controller.controller_name == 'users' 
 t('.twitter') 
 unless twitter_available?(this_blog, current_user) 
 t(".how_to_setup_twitter", twitter_settings_link: link_to(t(".fill_the_twitter_credentials"), controller: 'admin/settings', action: 'write'), twitter_registration_link: link_to(t(".registered_your_application"), "https://dev.twitter.com/apps/new")) 
 end 
 t('.twitter_account')
 f.text_field :twitter_account, {class: 'form-control', disabled: twitter_available?(this_blog, current_user)} 
 t('.twitter_oauth')
 f.text_field :twitter_oauth_token, {class: 'form-control', disabled: twitter_available?(this_blog, current_user)} 
 t('.twitter_oauth_secret')
 f.text_field :twitter_oauth_token_secret, {class: 'form-control', disabled: twitter_available?(this_blog, current_user)} 
 t('.contact_settings')
 t('.contact_explain', link: link_to(t('.author_page'), author_path(id: current_user.login))) 
 t('.about')
 f.text_area :description, {class: 'form-control', rows: 5} 
 t('.website')
 f.text_field :url, class: 'form-control' 
 t('.msn')
 f.text_field :msn, class: 'form-control' 
 t('.yahoo')
 f.text_field :yahoo, class: 'form-control' 
 t('.jabber')
 f.text_field :jabber, class: 'form-control' 
 t('.aim')
 f.text_field :aim, class: 'form-control' 
 t('.twitter')
 f.text_field :twitter, class: 'form-control' 
 end 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 submit_tag(t(".save"), class: 'btn btn-success') 
 end 
 

end

  end

  def edit
    @user = params[:id] ? User.find_by_id(params[:id]) : current_user
    setup_profiles
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :page_heading do 
 t(".edit_user") 
 end 
 form_tag :action=>"update", :id => @user.id do 
  form_for([:admin, @user]) do |f| 
 if @user.errors.any? 
 pluralize(@user.errors.count, "error") 
 @user.errors.full_messages.each do |message| 
 message 
 end 
 end 
 t('.account_settings')
 t('.login')
 f.text_field :login, class: 'form-control' 
 t('.password')
 f.password_field :password, class: 'form-control' 
 t('.password_confirmation')
 f.password_field :password_confirmation, :class => 'form-control' 
 t('.email')
 f.text_field :email, class: 'form-control' 
 if controller.controller_name == 'users' 
 t('.profile')
 f.collection_select :profile_id, Profile.order('id').all, :id, :label, { include_blank: false }, class: 'form-control' 
 t('.user_status')
 User::STATUS.each do |state| 
 state 
 'selected' if @user.state == state 
 t("user.status.#{state}") 
 end 
 end 
 t('.profile_settings')
 t('.firstname') 
 f.text_field :firstname, class: 'form-control' 
 t('.lastname') 
 f.text_field :lastname, class: 'form-control' 
 t('.nickname') 
 f.text_field :nickname, class: 'form-control' 
 unless @user.login.nil? 
 t('.display_name') 
 options_for_select(@user.display_names, @user.name) 
 end 
 t('.article_filter') 
 options_for_select text_filter_options_with_id, @user.text_filter.id 
 unless controller.controller_name == 'users'
 t('.avatar') 
 display_user_avatar(current_user, 'thumb') 
 t('.avatar_current') 
 t('.upload') 
 f.file_field :filename, class: 'input-file' 
 t('.upload_file') 
 end 
 t('.notification_settings') 
 t('.notifications') 
 f.check_box :notify_via_email 
 t('.notification_email') 
 f.check_box :notify_on_new_articles 
 t('.notification_article') 
 f.check_box :notify_on_comments 
 t('.notification_comment') 
 unless controller.controller_name == 'users' 
 t('.twitter') 
 unless twitter_available?(this_blog, current_user) 
 t(".how_to_setup_twitter", twitter_settings_link: link_to(t(".fill_the_twitter_credentials"), controller: 'admin/settings', action: 'write'), twitter_registration_link: link_to(t(".registered_your_application"), "https://dev.twitter.com/apps/new")) 
 end 
 t('.twitter_account')
 f.text_field :twitter_account, {class: 'form-control', disabled: twitter_available?(this_blog, current_user)} 
 t('.twitter_oauth')
 f.text_field :twitter_oauth_token, {class: 'form-control', disabled: twitter_available?(this_blog, current_user)} 
 t('.twitter_oauth_secret')
 f.text_field :twitter_oauth_token_secret, {class: 'form-control', disabled: twitter_available?(this_blog, current_user)} 
 t('.contact_settings')
 t('.contact_explain', link: link_to(t('.author_page'), author_path(id: current_user.login))) 
 t('.about')
 f.text_area :description, {class: 'form-control', rows: 5} 
 t('.website')
 f.text_field :url, class: 'form-control' 
 t('.msn')
 f.text_field :msn, class: 'form-control' 
 t('.yahoo')
 f.text_field :yahoo, class: 'form-control' 
 t('.jabber')
 f.text_field :jabber, class: 'form-control' 
 t('.aim')
 f.text_field :aim, class: 'form-control' 
 t('.twitter')
 f.text_field :twitter, class: 'form-control' 
 end 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 submit_tag(t(".save"), class: 'btn btn-success') 
 end 
 
 end 

end

  end

  def create
    @user = User.new(user_params)
    @user.name = @user.login
    if @user.save
      redirect_to admin_users_url, notice: I18n.t('admin.users.new.success')
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :page_heading do 
 t(".add_user") 
 end 
  form_for([:admin, @user]) do |f| 
 if @user.errors.any? 
 pluralize(@user.errors.count, "error") 
 @user.errors.full_messages.each do |message| 
 message 
 end 
 end 
 t('.account_settings')
 t('.login')
 f.text_field :login, class: 'form-control' 
 t('.password')
 f.password_field :password, class: 'form-control' 
 t('.password_confirmation')
 f.password_field :password_confirmation, :class => 'form-control' 
 t('.email')
 f.text_field :email, class: 'form-control' 
 if controller.controller_name == 'users' 
 t('.profile')
 f.collection_select :profile_id, Profile.order('id').all, :id, :label, { include_blank: false }, class: 'form-control' 
 t('.user_status')
 User::STATUS.each do |state| 
 state 
 'selected' if @user.state == state 
 t("user.status.#{state}") 
 end 
 end 
 t('.profile_settings')
 t('.firstname') 
 f.text_field :firstname, class: 'form-control' 
 t('.lastname') 
 f.text_field :lastname, class: 'form-control' 
 t('.nickname') 
 f.text_field :nickname, class: 'form-control' 
 unless @user.login.nil? 
 t('.display_name') 
 options_for_select(@user.display_names, @user.name) 
 end 
 t('.article_filter') 
 options_for_select text_filter_options_with_id, @user.text_filter.id 
 unless controller.controller_name == 'users'
 t('.avatar') 
 display_user_avatar(current_user, 'thumb') 
 t('.avatar_current') 
 t('.upload') 
 f.file_field :filename, class: 'input-file' 
 t('.upload_file') 
 end 
 t('.notification_settings') 
 t('.notifications') 
 f.check_box :notify_via_email 
 t('.notification_email') 
 f.check_box :notify_on_new_articles 
 t('.notification_article') 
 f.check_box :notify_on_comments 
 t('.notification_comment') 
 unless controller.controller_name == 'users' 
 t('.twitter') 
 unless twitter_available?(this_blog, current_user) 
 t(".how_to_setup_twitter", twitter_settings_link: link_to(t(".fill_the_twitter_credentials"), controller: 'admin/settings', action: 'write'), twitter_registration_link: link_to(t(".registered_your_application"), "https://dev.twitter.com/apps/new")) 
 end 
 t('.twitter_account')
 f.text_field :twitter_account, {class: 'form-control', disabled: twitter_available?(this_blog, current_user)} 
 t('.twitter_oauth')
 f.text_field :twitter_oauth_token, {class: 'form-control', disabled: twitter_available?(this_blog, current_user)} 
 t('.twitter_oauth_secret')
 f.text_field :twitter_oauth_token_secret, {class: 'form-control', disabled: twitter_available?(this_blog, current_user)} 
 t('.contact_settings')
 t('.contact_explain', link: link_to(t('.author_page'), author_path(id: current_user.login))) 
 t('.about')
 f.text_area :description, {class: 'form-control', rows: 5} 
 t('.website')
 f.text_field :url, class: 'form-control' 
 t('.msn')
 f.text_field :msn, class: 'form-control' 
 t('.yahoo')
 f.text_field :yahoo, class: 'form-control' 
 t('.jabber')
 f.text_field :jabber, class: 'form-control' 
 t('.aim')
 f.text_field :aim, class: 'form-control' 
 t('.twitter')
 f.text_field :twitter, class: 'form-control' 
 end 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 submit_tag(t(".save"), class: 'btn btn-success') 
 end 
 

end

    end
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_url, notice: 'User was successfully updated.'
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :page_heading do 
 t(".edit_user") 
 end 
 form_tag :action=>"update", :id => @user.id do 
  form_for([:admin, @user]) do |f| 
 if @user.errors.any? 
 pluralize(@user.errors.count, "error") 
 @user.errors.full_messages.each do |message| 
 message 
 end 
 end 
 t('.account_settings')
 t('.login')
 f.text_field :login, class: 'form-control' 
 t('.password')
 f.password_field :password, class: 'form-control' 
 t('.password_confirmation')
 f.password_field :password_confirmation, :class => 'form-control' 
 t('.email')
 f.text_field :email, class: 'form-control' 
 if controller.controller_name == 'users' 
 t('.profile')
 f.collection_select :profile_id, Profile.order('id').all, :id, :label, { include_blank: false }, class: 'form-control' 
 t('.user_status')
 User::STATUS.each do |state| 
 state 
 'selected' if @user.state == state 
 t("user.status.#{state}") 
 end 
 end 
 t('.profile_settings')
 t('.firstname') 
 f.text_field :firstname, class: 'form-control' 
 t('.lastname') 
 f.text_field :lastname, class: 'form-control' 
 t('.nickname') 
 f.text_field :nickname, class: 'form-control' 
 unless @user.login.nil? 
 t('.display_name') 
 options_for_select(@user.display_names, @user.name) 
 end 
 t('.article_filter') 
 options_for_select text_filter_options_with_id, @user.text_filter.id 
 unless controller.controller_name == 'users'
 t('.avatar') 
 display_user_avatar(current_user, 'thumb') 
 t('.avatar_current') 
 t('.upload') 
 f.file_field :filename, class: 'input-file' 
 t('.upload_file') 
 end 
 t('.notification_settings') 
 t('.notifications') 
 f.check_box :notify_via_email 
 t('.notification_email') 
 f.check_box :notify_on_new_articles 
 t('.notification_article') 
 f.check_box :notify_on_comments 
 t('.notification_comment') 
 unless controller.controller_name == 'users' 
 t('.twitter') 
 unless twitter_available?(this_blog, current_user) 
 t(".how_to_setup_twitter", twitter_settings_link: link_to(t(".fill_the_twitter_credentials"), controller: 'admin/settings', action: 'write'), twitter_registration_link: link_to(t(".registered_your_application"), "https://dev.twitter.com/apps/new")) 
 end 
 t('.twitter_account')
 f.text_field :twitter_account, {class: 'form-control', disabled: twitter_available?(this_blog, current_user)} 
 t('.twitter_oauth')
 f.text_field :twitter_oauth_token, {class: 'form-control', disabled: twitter_available?(this_blog, current_user)} 
 t('.twitter_oauth_secret')
 f.text_field :twitter_oauth_token_secret, {class: 'form-control', disabled: twitter_available?(this_blog, current_user)} 
 t('.contact_settings')
 t('.contact_explain', link: link_to(t('.author_page'), author_path(id: current_user.login))) 
 t('.about')
 f.text_area :description, {class: 'form-control', rows: 5} 
 t('.website')
 f.text_field :url, class: 'form-control' 
 t('.msn')
 f.text_field :msn, class: 'form-control' 
 t('.yahoo')
 f.text_field :yahoo, class: 'form-control' 
 t('.jabber')
 f.text_field :jabber, class: 'form-control' 
 t('.aim')
 f.text_field :aim, class: 'form-control' 
 t('.twitter')
 f.text_field :twitter, class: 'form-control' 
 end 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 submit_tag(t(".save"), class: 'btn btn-success') 
 end 
 
 end 

end

    end
  end

  def destroy
    @user.destroy if User.where('profile_id = ? and id != ?', Profile.find_by_label('admin'), @user.id).count > 1
    redirect_to admin_users_url
  end

  private

  def setup_profiles
    @profiles = Profile.order('id')
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:login, :password, :password_confirmation, :email, :firstname, :lastname, :nickname, :display_name, :notify_via_email, :notify_on_new_articles, :notify_on_comments, :profile_id, :text_filter_id, :state, :twitter_account, :twitter_oauth_token, :twitter_oauth_token_secret, :description, :url, :msn, :yahoo, :jabber, :aim, :twitter)
  end
end

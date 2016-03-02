  class UsersController < ResourceController
    include AdminTab

    check_permissions :administrate, :except => [:change_password, :update_password]
    before_filter :only_self_or_administrator, :only => [:change_password, :update_password]
    after_filter :update_flash, :only => [:update]


    def index
      @have_external_users = ExternalUser.count > 0

      query, conditions = [], []

      unless params[:show_expired]
        query << "expires_at IS NULL OR expires_at >= ?"
        conditions << Time.now.utc
      end

      unless params[:key_word].blank?
        query << %w(login email first_name last_name).collect { |f| "lower(#{f}) LIKE lower(?)" }.join(" OR ")
        4.times { conditions << "%#{params[:key_word]}%" }
      end

      unless params[:group_id].to_i == 0
        query << "#{UserGroupMembership.table_name}.group_id = ?"
        conditions << params[:group_id]
      end

      query.collect! { |q| "(#{q})" }
      conditions = conditions.unshift(query.join(" AND "))
      per_page = params[:per_page] || 10

      page_num = params[:page] ? params[:page].to_i : 1
      @users = PersistentUser.where(conditions).paginate(page: page_num, per_page: per_page).includes(:user_group_memberships).references(:user_group_memberships).order("first_name, last_name, email")
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Users" 
 render layout: 'page_title', locals: {span: 'span3'} do 
 link_to "Add User", new_user_path, :id => "add_user_button", :class => "btn btn-small btn-primary right" 
 end 
 form_tag(users_path, :method => :get, class: 'form-search right') do 
 group_filter 
 text_field_tag "key_word", params[:key_word], placeholder: "Search Users...", class: 'search-query' 
 check_box_tag "show_expired", "yes", params[:show_expired] 
 submit_tag "Search", id: 'user_search_submit', class: 'hide' 
 end 
 render layout: 'main_content' do 
 if @have_external_users 
 end 
 @users.each do |user| 
 link_to "#{user.full_name_or_login}", edit_user_path(user) 
 link_to user.email, "mailto:#{user.email}" 
 user.groups.order("#{Group.table_name}.name").each do |g| 
 g.name 
 end 
 user.expires_at ? format_date(user.expires_at) : "Never" 
 link_to("Change Password", [:change_password, user.becomes(User)], :id => "change_password_button", :class => "btn btn-primary btn-mini") if user.password_changeable? 
 if user.expired? 
 link_to("Enable", [:enable, user.becomes(User)], :class => "http_put btn btn-mini btn-success") 
 else 
 link_to("Disable", [:disable, user.becomes(User)], :class => "http_put btn btn-mini btn-danger") if @users.size > 1 
 end 
 if @have_external_users 
 user.source 
 end 
 end 
 if @users.size == 0 && params[:key_word] 
 params[:key_word] 
 elsif @users.total_pages > 1 
 render_pagination @users, User 
 end 
 end 

end

    end

    def new
      @user = User.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "New User" 
  simple_form_for(@user.becomes(User), html: {autocomplete: 'off'}) do |f| 
  page_title_with_buttons(f, 'save_buttons') 
 render layout: 'main_with_sidebar' do 
 render :partial => 'user_fields', :locals => {:f => f} unless @change_password 
 render :partial => 'password', :locals => {:f => f} if @user.new_record? 
 f.association :groups, as: :check_boxes 
 end 
 bottom_buttons(f, 'save_buttons') 
 end 
 

end

    end

    def create
      @user = User.new(cms_user_params)
      if @user.save
        flash[:notice] = "User '#{@user.login}' was created"
        redirect_to users_path
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "New User" 
  simple_form_for(@user.becomes(User), html: {autocomplete: 'off'}) do |f| 
  page_title_with_buttons(f, 'save_buttons') 
 render layout: 'main_with_sidebar' do 
 render :partial => 'user_fields', :locals => {:f => f} unless @change_password 
 render :partial => 'password', :locals => {:f => f} if @user.new_record? 
 f.association :groups, as: :check_boxes 
 end 
 bottom_buttons(f, 'save_buttons') 
 end 
 

end

      end
    end

    def change_password
      user
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Set New Password" 
 content_for :buttons, 'save_buttons' 
 simple_form_for([:update_password, @user], html: {autocomplete: 'off'}) do |f| 
 render layout: 'form_with_buttons', locals: {f: f} do 
 render 'password', f: f 
 content_for :sidebar do 
 @user.login 
 end 
 end 
 end 

end

    end

    def update_password
      if user.update(cms_user_params)
        flash[:notice] = "Password for '#{user.login}' was changed"
        redirect_to(current_user.able_to?(:administrate) ? users_path : "/")
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Set New Password" 
 content_for :buttons, 'save_buttons' 
 simple_form_for([:update_password, @user], html: {autocomplete: 'off'}) do |f| 
 render layout: 'form_with_buttons', locals: {f: f} do 
 render 'password', f: f 
 content_for :sidebar do 
 @user.login 
 end 
 end 
 end 

end

      end
    end

    def disable
      begin
        user.disable!
        flash[:notice] = "User #{user.login} disabled"
      rescue Exception => e
        flash[:error] = e.message
      end
      redirect_to users_path
    end

    def enable
      user.enable!
      redirect_to users_path
    end

    protected

    def cms_user_params
      params.require("user").permit(User.permitted_params)
    end

    def after_create_url
      users_path
    end

    def after_update_url
      users_path
    end

    def update_flash
      if params[:on_fail_action] == "change_password"
        flash[:notice] = "Password for '#{@object.login}' changed"
      elsif params[:action] == "create"
        flash[:notice] = "User '#{@object.login}' was created"
      else
        flash[:notice] = "User '#{@object.login}' was updated"
      end
    end

    def resource_name
      'PersistentUser'
    end

    def variable_name
      'user'
    end

    private
    def user
      @user ||= PersistentUser.find(params[:id])
    end

    def set_menu_section
      @menu_section = 'users'
    end

    def only_self_or_administrator
      raise Errors::AccessDenied if !current_user.able_to?(:administrate) && params[:id].to_i != current_user.id
    end
  end
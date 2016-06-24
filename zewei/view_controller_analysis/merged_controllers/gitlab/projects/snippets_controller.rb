class Projects::SnippetsController < Projects::ApplicationController
  before_action :module_enabled
  before_action :snippet, only: [:show, :edit, :destroy, :update, :raw]

  # Allow read any snippet
  before_action :authorize_read_project_snippet!, except: [:new, :create, :index]

  # Allow write(create) snippet
  before_action :authorize_create_project_snippet!, only: [:new, :create]

  # Allow modify snippet
  before_action :authorize_update_project_snippet!, only: [:edit, :update]

  # Allow destroy snippet
  before_action :authorize_admin_project_snippet!, only: [:destroy]

  respond_to :html

  def index
    @snippets = SnippetsFinder.new.execute(current_user, {
      filter: :by_project,
      project: @project
    })
    @snippets = @snippets.page(params[:page])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 page_title       @project.name_with_namespace 
 page_description @project.description    unless page_description 
 header_title     project_title(@project) unless header_title 
 nav              "project" 
 content_for :scripts_body_top do 
 project = @target_project || @project 
 if @project_wiki 
 markdown_preview_path = namespace_project_wikis_markdown_preview_path(project.namespace, project) 
 else 
 markdown_preview_path = markdown_preview_namespace_project_path(project.namespace, project) 
 end 
 if current_user 
 end 
 end 
 content_for :scripts_body do 
  project = @target_project || @project 
 if @noteable 
 end 
 
 end 
 content_for :header_content do 
 dropdown_title("Go to a project") 
 dropdown_filter("Search your projects") 
 dropdown_content 
 dropdown_loading 
 end 
   page_description brand_title unless page_description 
 site_name = "GitLab" 
 # Open Graph - http://ogp.me/ 
 site_name 
 page_title 
 page_description 
 page_image 
 request.base_url 
 # Twitter Card - https://dev.twitter.com/cards/types/summary 
 page_title 
 page_description 
 page_image 
 page_card_meta_tags 
 page_title(site_name) 
 page_description 
 favicon_link_tag 'favicon.ico' 
 stylesheet_link_tag "application", media: "all" 
 stylesheet_link_tag "print",       media: "print" 
 javascript_include_tag "application" 
 if page_specific_javascripts 
 javascript_include_tag page_specific_javascripts, {"data-turbolinks-track" => true} 
 end 
 csrf_meta_tags 
 unless browser.safari? 
 end 
 # Apple Safari/iOS home screen icons 
 favicon_link_tag 'touch-icon-iphone.png',        rel: 'apple-touch-icon' 
 favicon_link_tag 'touch-icon-ipad.png',          rel: 'apple-touch-icon', sizes: '76x76' 
 favicon_link_tag 'touch-icon-iphone-retina.png', rel: 'apple-touch-icon', sizes: '120x120' 
 favicon_link_tag 'touch-icon-ipad-retina.png',   rel: 'apple-touch-icon', sizes: '152x152' 
 image_path('logo.svg') 
 # Windows 8 pinned site tile 
 image_path('msapplication-tile.png') 
 yield :meta_tags 
  
  
  
  
 
 Gon::Base.render_data 
 # Ideally this would be inside the head, but turbolinks only evaluates page-specific JS in the body. 
 yield :scripts_body_top 
  nav_header_class 
 icon('bars') 
 icon('angle-left') 
  page_title    "Search" 
 header_title  "Search", search_path 
 render template: "layouts/application" 
 
 link_to search_path, title: 'Search', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('search') 
 end 
 if current_user 
 if session[:impersonator_id] 
 link_to admin_impersonation_path, method: :delete, title: 'Stop Impersonation', data: { toggle: 'tooltip', placement: 'bottom', container: 'body' } do 
 icon('user-secret fw') 
 end 
 end 
 if current_user.is_admin? 
 link_to admin_root_path, title: 'Admin Area', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('wrench fw') 
 end 
 end 
 link_to dashboard_todos_path, title: 'Todos', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('bell fw') 
 unless todos_pending_count == 0 
 todos_pending_count 
 end 
 end 
 if current_user.can_create_project? 
 link_to new_project_path, title: 'New project', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('plus fw') 
 end 
 end 
 if Gitlab::Sherlock.enabled? 
 link_to sherlock_transactions_path, title: 'Sherlock Transactions',                  data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('tachometer fw') 
 end 
 end 
 link_to destroy_user_session_path, class: 'logout', method: :delete, title: 'Sign out', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('sign-out') 
 end 
 else 
 link_to "Sign in", new_session_path(:user, redirect_to_referer: 'yes'), class: 'btn btn-sign-in btn-success' 
 end 
 title 
 yield :header_content 
  if outdated_browser? 
 link = "https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/install/requirements.md#supported-web-browsers" 
 link_to 'supported web browser', link 
 end 
 
 if @project && !@project.empty_repo? 
 if ref = @ref || @project.repository.root_ref 
 end 
 end 
 
  nav_sidebar_class 
 brand_header_logo 
 link_to root_path, class: 'gitlab-text-container-link', title: 'Dashboard', id: 'js-shortcuts-home' do 
 end 
 if defined?(sidebar) && sidebar 
 render "layouts/nav/" 
 elsif current_user 
  nav_link(path: ['root#index', 'projects#trending', 'projects#starred', 'dashboard/projects#index'], html_options: {}) do 
 link_to dashboard_projects_path, title: 'Projects', class: 'dashboard-shortcuts-projects' do 
 icon('bookmark fw') 
 end 
 end 
 nav_link(controller: :todos) do 
 link_to dashboard_todos_path, title: 'Todos' do 
 icon('bell fw') 
 number_with_delimiter(todos_pending_count) 
 end 
 end 
 nav_link(path: 'dashboard#activity') do 
 link_to activity_dashboard_path, class: 'dashboard-shortcuts-activity', title: 'Activity' do 
 icon('dashboard fw') 
 end 
 end 
 nav_link(controller: [:groups, 'groups/milestones', 'groups/group_members']) do 
 link_to dashboard_groups_path, title: 'Groups' do 
 icon('group fw') 
 end 
 end 
 nav_link(controller: 'dashboard/milestones') do 
 link_to dashboard_milestones_path, title: 'Milestones' do 
 icon('clock-o fw') 
 end 
 end 
 nav_link(path: 'dashboard#issues') do 
 link_to assigned_issues_dashboard_path, title: 'Issues', class: 'dashboard-shortcuts-issues' do 
 icon('exclamation-circle fw') 
 number_with_delimiter(current_user.assigned_open_issues_count) 
 end 
 end 
 nav_link(path: 'dashboard#merge_requests') do 
 link_to assigned_mrs_dashboard_path, title: 'Merge Requests', class: 'dashboard-shortcuts-merge_requests' do 
 icon('tasks fw') 
 number_with_delimiter(current_user.assigned_open_merge_request_count) 
 end 
 end 
 nav_link(controller: :snippets) do 
 link_to dashboard_snippets_path, title: 'Snippets' do 
 icon('clipboard fw') 
 end 
 end 
 nav_link(controller: :help) do 
 link_to help_path, title: 'Help' do 
 icon('question-circle fw') 
 end 
 end 
 nav_link(html_options: {class: profile_tab_class}) do 
 link_to profile_path, title: 'Profile Settings', data: {placement: 'bottom'} do 
 icon('user fw') 
 end 
 end 
 
 else 
  nav_link(path: ['dashboard#show', 'root#show', 'projects#trending', 'projects#starred', 'projects#index'], html_options: {class: 'home'}) do 
 link_to explore_root_path, title: 'Projects' do 
 icon('bookmark fw') 
 end 
 end 
 nav_link(controller: [:groups, 'groups/milestones', 'groups/group_members']) do 
 link_to explore_groups_path, title: 'Groups' do 
 icon('group fw') 
 end 
 end 
 nav_link(controller: :snippets) do 
 link_to explore_snippets_path, title: 'Snippets' do 
 icon('clipboard fw') 
 end 
 end 
 nav_link(controller: :help) do 
 link_to help_path, title: 'Help' do 
 icon('question-circle fw') 
 end 
 end 
 
 end 
  if nav_menu_collapsed? 
 link_to icon('angle-right'), '#', class: 'toggle-nav-collapse', title: "Open/Close" 
 else 
 link_to icon('angle-left'), '#', class: 'toggle-nav-collapse', title: "Open/Close" 
 end 
 
 if current_user 
 link_to current_user, class: 'sidebar-user', title: "Profile" do 
 image_tag avatar_icon(current_user, 60), alt: 'Profile', class: 'avatar avatar s36' 
 current_user.username 
 end 
 end 
 if defined?(nav) && nav 
 render "layouts/nav/" 
 end 
  broadcast_message 
 
  if alert 
 alert 
 elsif notice 
 notice 
 end 
 
 yield :flash_message 
 (container_class unless @no_container) 
 page_title "Snippets" 
 link_to new_namespace_project_snippet_path(@project.namespace, @project), class: "btn btn-new", title: "New Snippet" do 
 icon('plus') 
 end 
   image_tag avatar_icon(snippet.author_email), class: "avatar s40 hidden-xs", alt: '' 
 link_to reliable_snippet_path(snippet) do 
 truncate(snippet.title, length: 60) 
 if snippet.private? 
 icon('lock') 
 end 
 end 
 snippet.file_name 
 if snippet.project_id? 
 link_to snippet.project.name_with_namespace, namespace_project_path(snippet.project.namespace, snippet.project) 
 end 
 link_to user_snippets_path(snippet.author) do 
 snippet.author_name 
 end 
 
 if @snippets.empty? 
 end 
 paginate @snippets, theme: 'gitlab' 
 
 
 yield :scripts_body 
 

end

  end

  def new
    @snippet = @noteable = @project.snippets.build
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 page_title       @project.name_with_namespace 
 page_description @project.description    unless page_description 
 header_title     project_title(@project) unless header_title 
 nav              "project" 
 content_for :scripts_body_top do 
 project = @target_project || @project 
 if @project_wiki 
 markdown_preview_path = namespace_project_wikis_markdown_preview_path(project.namespace, project) 
 else 
 markdown_preview_path = markdown_preview_namespace_project_path(project.namespace, project) 
 end 
 if current_user 
 end 
 end 
 content_for :scripts_body do 
  project = @target_project || @project 
 if @noteable 
 end 
 
 end 
 content_for :header_content do 
 dropdown_title("Go to a project") 
 dropdown_filter("Search your projects") 
 dropdown_content 
 dropdown_loading 
 end 
   page_description brand_title unless page_description 
 site_name = "GitLab" 
 # Open Graph - http://ogp.me/ 
 site_name 
 page_title 
 page_description 
 page_image 
 request.base_url 
 # Twitter Card - https://dev.twitter.com/cards/types/summary 
 page_title 
 page_description 
 page_image 
 page_card_meta_tags 
 page_title(site_name) 
 page_description 
 favicon_link_tag 'favicon.ico' 
 stylesheet_link_tag "application", media: "all" 
 stylesheet_link_tag "print",       media: "print" 
 javascript_include_tag "application" 
 if page_specific_javascripts 
 javascript_include_tag page_specific_javascripts, {"data-turbolinks-track" => true} 
 end 
 csrf_meta_tags 
 unless browser.safari? 
 end 
 # Apple Safari/iOS home screen icons 
 favicon_link_tag 'touch-icon-iphone.png',        rel: 'apple-touch-icon' 
 favicon_link_tag 'touch-icon-ipad.png',          rel: 'apple-touch-icon', sizes: '76x76' 
 favicon_link_tag 'touch-icon-iphone-retina.png', rel: 'apple-touch-icon', sizes: '120x120' 
 favicon_link_tag 'touch-icon-ipad-retina.png',   rel: 'apple-touch-icon', sizes: '152x152' 
 image_path('logo.svg') 
 # Windows 8 pinned site tile 
 image_path('msapplication-tile.png') 
 yield :meta_tags 
  
  
  
  
 
 Gon::Base.render_data 
 # Ideally this would be inside the head, but turbolinks only evaluates page-specific JS in the body. 
 yield :scripts_body_top 
  nav_header_class 
 icon('bars') 
 icon('angle-left') 
  page_title    "Search" 
 header_title  "Search", search_path 
 render template: "layouts/application" 
 
 link_to search_path, title: 'Search', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('search') 
 end 
 if current_user 
 if session[:impersonator_id] 
 link_to admin_impersonation_path, method: :delete, title: 'Stop Impersonation', data: { toggle: 'tooltip', placement: 'bottom', container: 'body' } do 
 icon('user-secret fw') 
 end 
 end 
 if current_user.is_admin? 
 link_to admin_root_path, title: 'Admin Area', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('wrench fw') 
 end 
 end 
 link_to dashboard_todos_path, title: 'Todos', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('bell fw') 
 unless todos_pending_count == 0 
 todos_pending_count 
 end 
 end 
 if current_user.can_create_project? 
 link_to new_project_path, title: 'New project', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('plus fw') 
 end 
 end 
 if Gitlab::Sherlock.enabled? 
 link_to sherlock_transactions_path, title: 'Sherlock Transactions',                  data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('tachometer fw') 
 end 
 end 
 link_to destroy_user_session_path, class: 'logout', method: :delete, title: 'Sign out', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('sign-out') 
 end 
 else 
 link_to "Sign in", new_session_path(:user, redirect_to_referer: 'yes'), class: 'btn btn-sign-in btn-success' 
 end 
 title 
 yield :header_content 
  if outdated_browser? 
 link = "https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/install/requirements.md#supported-web-browsers" 
 link_to 'supported web browser', link 
 end 
 
 if @project && !@project.empty_repo? 
 if ref = @ref || @project.repository.root_ref 
 end 
 end 
 
  nav_sidebar_class 
 brand_header_logo 
 link_to root_path, class: 'gitlab-text-container-link', title: 'Dashboard', id: 'js-shortcuts-home' do 
 end 
 if defined?(sidebar) && sidebar 
 render "layouts/nav/" 
 elsif current_user 
  nav_link(path: ['root#index', 'projects#trending', 'projects#starred', 'dashboard/projects#index'], html_options: {}) do 
 link_to dashboard_projects_path, title: 'Projects', class: 'dashboard-shortcuts-projects' do 
 icon('bookmark fw') 
 end 
 end 
 nav_link(controller: :todos) do 
 link_to dashboard_todos_path, title: 'Todos' do 
 icon('bell fw') 
 number_with_delimiter(todos_pending_count) 
 end 
 end 
 nav_link(path: 'dashboard#activity') do 
 link_to activity_dashboard_path, class: 'dashboard-shortcuts-activity', title: 'Activity' do 
 icon('dashboard fw') 
 end 
 end 
 nav_link(controller: [:groups, 'groups/milestones', 'groups/group_members']) do 
 link_to dashboard_groups_path, title: 'Groups' do 
 icon('group fw') 
 end 
 end 
 nav_link(controller: 'dashboard/milestones') do 
 link_to dashboard_milestones_path, title: 'Milestones' do 
 icon('clock-o fw') 
 end 
 end 
 nav_link(path: 'dashboard#issues') do 
 link_to assigned_issues_dashboard_path, title: 'Issues', class: 'dashboard-shortcuts-issues' do 
 icon('exclamation-circle fw') 
 number_with_delimiter(current_user.assigned_open_issues_count) 
 end 
 end 
 nav_link(path: 'dashboard#merge_requests') do 
 link_to assigned_mrs_dashboard_path, title: 'Merge Requests', class: 'dashboard-shortcuts-merge_requests' do 
 icon('tasks fw') 
 number_with_delimiter(current_user.assigned_open_merge_request_count) 
 end 
 end 
 nav_link(controller: :snippets) do 
 link_to dashboard_snippets_path, title: 'Snippets' do 
 icon('clipboard fw') 
 end 
 end 
 nav_link(controller: :help) do 
 link_to help_path, title: 'Help' do 
 icon('question-circle fw') 
 end 
 end 
 nav_link(html_options: {class: profile_tab_class}) do 
 link_to profile_path, title: 'Profile Settings', data: {placement: 'bottom'} do 
 icon('user fw') 
 end 
 end 
 
 else 
  nav_link(path: ['dashboard#show', 'root#show', 'projects#trending', 'projects#starred', 'projects#index'], html_options: {class: 'home'}) do 
 link_to explore_root_path, title: 'Projects' do 
 icon('bookmark fw') 
 end 
 end 
 nav_link(controller: [:groups, 'groups/milestones', 'groups/group_members']) do 
 link_to explore_groups_path, title: 'Groups' do 
 icon('group fw') 
 end 
 end 
 nav_link(controller: :snippets) do 
 link_to explore_snippets_path, title: 'Snippets' do 
 icon('clipboard fw') 
 end 
 end 
 nav_link(controller: :help) do 
 link_to help_path, title: 'Help' do 
 icon('question-circle fw') 
 end 
 end 
 
 end 
  if nav_menu_collapsed? 
 link_to icon('angle-right'), '#', class: 'toggle-nav-collapse', title: "Open/Close" 
 else 
 link_to icon('angle-left'), '#', class: 'toggle-nav-collapse', title: "Open/Close" 
 end 
 
 if current_user 
 link_to current_user, class: 'sidebar-user', title: "Profile" do 
 image_tag avatar_icon(current_user, 60), alt: 'Profile', class: 'avatar avatar s36' 
 current_user.username 
 end 
 end 
 if defined?(nav) && nav 
 render "layouts/nav/" 
 end 
  broadcast_message 
 
  if alert 
 alert 
 elsif notice 
 notice 
 end 
 
 yield :flash_message 
 (container_class unless @no_container) 
 page_title "New Snippets" 
  form_for @snippet, url: url, html: { class: "form-horizontal snippet-form js-requires-input" } do |f| 
 form_errors(@snippet) 
 f.label :title, class: 'control-label' 
 f.text_field :title, class: 'form-control', required: true, autofocus: true 
  f.label :visibility_level, class: 'control-label' do 
 link_to "(?)", help_page_path("public_access", "public_access") 
 end 
 if can_change_visibility_level 
  Gitlab::VisibilityLevel.values.each do |level| 
 next if skip_level?(form_model, level) 
 restricted = restricted_visibility_levels.include?(level) 
 form.label "_" do 
 form.radio_button model_method, level, checked: (selected_level == level), disabled: restricted 
 visibility_level_icon(level) 
 visibility_level_label(level) 
 visibility_level_description(level, form_model) 
 end 
 end 
 unless restricted_visibility_levels.empty? 
 end 
 
 else 
 visibility_level_icon(visibility_level) 
 visibility_level_label(visibility_level) 
 visibility_level_description(visibility_level, form_model) 
 end 
 
 f.label :file_name, "File", class: 'control-label' 
 f.text_field :file_name, placeholder: "Optionally name this file to add code highlighting, e.g. example.rb for Ruby.", class: 'form-control snippet-file-name' 
 @snippet.content 
 f.hidden_field :content, class: 'snippet-file-content' 
 if @snippet.new_record? 
 f.submit 'Create snippet', class: "btn-create btn" 
 else 
 f.submit 'Save changes', class: "btn-save btn" 
 end 
 if @snippet.project_id 
 link_to "Cancel", namespace_project_snippets_path(@project.namespace, @project), class: "btn btn-cancel" 
 else 
 link_to "Cancel", snippets_path(@project), class: "btn btn-cancel" 
 end 
 end 
 
 
 yield :scripts_body 
 

end

  end

  def create
    @snippet = CreateSnippetService.new(@project, current_user,
                                        snippet_params).execute

    if @snippet.valid?
      respond_with(@snippet,
                   location: namespace_project_snippet_path(@project.namespace,
                                                            @project, @snippet))
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 page_title       @project.name_with_namespace 
 page_description @project.description    unless page_description 
 header_title     project_title(@project) unless header_title 
 nav              "project" 
 content_for :scripts_body_top do 
 project = @target_project || @project 
 if @project_wiki 
 markdown_preview_path = namespace_project_wikis_markdown_preview_path(project.namespace, project) 
 else 
 markdown_preview_path = markdown_preview_namespace_project_path(project.namespace, project) 
 end 
 if current_user 
 end 
 end 
 content_for :scripts_body do 
  project = @target_project || @project 
 if @noteable 
 end 
 
 end 
 content_for :header_content do 
 dropdown_title("Go to a project") 
 dropdown_filter("Search your projects") 
 dropdown_content 
 dropdown_loading 
 end 
   page_description brand_title unless page_description 
 site_name = "GitLab" 
 # Open Graph - http://ogp.me/ 
 site_name 
 page_title 
 page_description 
 page_image 
 request.base_url 
 # Twitter Card - https://dev.twitter.com/cards/types/summary 
 page_title 
 page_description 
 page_image 
 page_card_meta_tags 
 page_title(site_name) 
 page_description 
 favicon_link_tag 'favicon.ico' 
 stylesheet_link_tag "application", media: "all" 
 stylesheet_link_tag "print",       media: "print" 
 javascript_include_tag "application" 
 if page_specific_javascripts 
 javascript_include_tag page_specific_javascripts, {"data-turbolinks-track" => true} 
 end 
 csrf_meta_tags 
 unless browser.safari? 
 end 
 # Apple Safari/iOS home screen icons 
 favicon_link_tag 'touch-icon-iphone.png',        rel: 'apple-touch-icon' 
 favicon_link_tag 'touch-icon-ipad.png',          rel: 'apple-touch-icon', sizes: '76x76' 
 favicon_link_tag 'touch-icon-iphone-retina.png', rel: 'apple-touch-icon', sizes: '120x120' 
 favicon_link_tag 'touch-icon-ipad-retina.png',   rel: 'apple-touch-icon', sizes: '152x152' 
 image_path('logo.svg') 
 # Windows 8 pinned site tile 
 image_path('msapplication-tile.png') 
 yield :meta_tags 
  
  
  
  
 
 Gon::Base.render_data 
 # Ideally this would be inside the head, but turbolinks only evaluates page-specific JS in the body. 
 yield :scripts_body_top 
  nav_header_class 
 icon('bars') 
 icon('angle-left') 
  page_title    "Search" 
 header_title  "Search", search_path 
 render template: "layouts/application" 
 
 link_to search_path, title: 'Search', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('search') 
 end 
 if current_user 
 if session[:impersonator_id] 
 link_to admin_impersonation_path, method: :delete, title: 'Stop Impersonation', data: { toggle: 'tooltip', placement: 'bottom', container: 'body' } do 
 icon('user-secret fw') 
 end 
 end 
 if current_user.is_admin? 
 link_to admin_root_path, title: 'Admin Area', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('wrench fw') 
 end 
 end 
 link_to dashboard_todos_path, title: 'Todos', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('bell fw') 
 unless todos_pending_count == 0 
 todos_pending_count 
 end 
 end 
 if current_user.can_create_project? 
 link_to new_project_path, title: 'New project', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('plus fw') 
 end 
 end 
 if Gitlab::Sherlock.enabled? 
 link_to sherlock_transactions_path, title: 'Sherlock Transactions',                  data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('tachometer fw') 
 end 
 end 
 link_to destroy_user_session_path, class: 'logout', method: :delete, title: 'Sign out', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('sign-out') 
 end 
 else 
 link_to "Sign in", new_session_path(:user, redirect_to_referer: 'yes'), class: 'btn btn-sign-in btn-success' 
 end 
 title 
 yield :header_content 
  if outdated_browser? 
 link = "https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/install/requirements.md#supported-web-browsers" 
 link_to 'supported web browser', link 
 end 
 
 if @project && !@project.empty_repo? 
 if ref = @ref || @project.repository.root_ref 
 end 
 end 
 
  nav_sidebar_class 
 brand_header_logo 
 link_to root_path, class: 'gitlab-text-container-link', title: 'Dashboard', id: 'js-shortcuts-home' do 
 end 
 if defined?(sidebar) && sidebar 
 render "layouts/nav/" 
 elsif current_user 
  nav_link(path: ['root#index', 'projects#trending', 'projects#starred', 'dashboard/projects#index'], html_options: {}) do 
 link_to dashboard_projects_path, title: 'Projects', class: 'dashboard-shortcuts-projects' do 
 icon('bookmark fw') 
 end 
 end 
 nav_link(controller: :todos) do 
 link_to dashboard_todos_path, title: 'Todos' do 
 icon('bell fw') 
 number_with_delimiter(todos_pending_count) 
 end 
 end 
 nav_link(path: 'dashboard#activity') do 
 link_to activity_dashboard_path, class: 'dashboard-shortcuts-activity', title: 'Activity' do 
 icon('dashboard fw') 
 end 
 end 
 nav_link(controller: [:groups, 'groups/milestones', 'groups/group_members']) do 
 link_to dashboard_groups_path, title: 'Groups' do 
 icon('group fw') 
 end 
 end 
 nav_link(controller: 'dashboard/milestones') do 
 link_to dashboard_milestones_path, title: 'Milestones' do 
 icon('clock-o fw') 
 end 
 end 
 nav_link(path: 'dashboard#issues') do 
 link_to assigned_issues_dashboard_path, title: 'Issues', class: 'dashboard-shortcuts-issues' do 
 icon('exclamation-circle fw') 
 number_with_delimiter(current_user.assigned_open_issues_count) 
 end 
 end 
 nav_link(path: 'dashboard#merge_requests') do 
 link_to assigned_mrs_dashboard_path, title: 'Merge Requests', class: 'dashboard-shortcuts-merge_requests' do 
 icon('tasks fw') 
 number_with_delimiter(current_user.assigned_open_merge_request_count) 
 end 
 end 
 nav_link(controller: :snippets) do 
 link_to dashboard_snippets_path, title: 'Snippets' do 
 icon('clipboard fw') 
 end 
 end 
 nav_link(controller: :help) do 
 link_to help_path, title: 'Help' do 
 icon('question-circle fw') 
 end 
 end 
 nav_link(html_options: {class: profile_tab_class}) do 
 link_to profile_path, title: 'Profile Settings', data: {placement: 'bottom'} do 
 icon('user fw') 
 end 
 end 
 
 else 
  nav_link(path: ['dashboard#show', 'root#show', 'projects#trending', 'projects#starred', 'projects#index'], html_options: {class: 'home'}) do 
 link_to explore_root_path, title: 'Projects' do 
 icon('bookmark fw') 
 end 
 end 
 nav_link(controller: [:groups, 'groups/milestones', 'groups/group_members']) do 
 link_to explore_groups_path, title: 'Groups' do 
 icon('group fw') 
 end 
 end 
 nav_link(controller: :snippets) do 
 link_to explore_snippets_path, title: 'Snippets' do 
 icon('clipboard fw') 
 end 
 end 
 nav_link(controller: :help) do 
 link_to help_path, title: 'Help' do 
 icon('question-circle fw') 
 end 
 end 
 
 end 
  if nav_menu_collapsed? 
 link_to icon('angle-right'), '#', class: 'toggle-nav-collapse', title: "Open/Close" 
 else 
 link_to icon('angle-left'), '#', class: 'toggle-nav-collapse', title: "Open/Close" 
 end 
 
 if current_user 
 link_to current_user, class: 'sidebar-user', title: "Profile" do 
 image_tag avatar_icon(current_user, 60), alt: 'Profile', class: 'avatar avatar s36' 
 current_user.username 
 end 
 end 
 if defined?(nav) && nav 
 render "layouts/nav/" 
 end 
  broadcast_message 
 
  if alert 
 alert 
 elsif notice 
 notice 
 end 
 
 yield :flash_message 
 (container_class unless @no_container) 
 page_title "New Snippets" 
  form_for @snippet, url: url, html: { class: "form-horizontal snippet-form js-requires-input" } do |f| 
 form_errors(@snippet) 
 f.label :title, class: 'control-label' 
 f.text_field :title, class: 'form-control', required: true, autofocus: true 
  f.label :visibility_level, class: 'control-label' do 
 link_to "(?)", help_page_path("public_access", "public_access") 
 end 
 if can_change_visibility_level 
  Gitlab::VisibilityLevel.values.each do |level| 
 next if skip_level?(form_model, level) 
 restricted = restricted_visibility_levels.include?(level) 
 form.label "_" do 
 form.radio_button model_method, level, checked: (selected_level == level), disabled: restricted 
 visibility_level_icon(level) 
 visibility_level_label(level) 
 visibility_level_description(level, form_model) 
 end 
 end 
 unless restricted_visibility_levels.empty? 
 end 
 
 else 
 visibility_level_icon(visibility_level) 
 visibility_level_label(visibility_level) 
 visibility_level_description(visibility_level, form_model) 
 end 
 
 f.label :file_name, "File", class: 'control-label' 
 f.text_field :file_name, placeholder: "Optionally name this file to add code highlighting, e.g. example.rb for Ruby.", class: 'form-control snippet-file-name' 
 @snippet.content 
 f.hidden_field :content, class: 'snippet-file-content' 
 if @snippet.new_record? 
 f.submit 'Create snippet', class: "btn-create btn" 
 else 
 f.submit 'Save changes', class: "btn-save btn" 
 end 
 if @snippet.project_id 
 link_to "Cancel", namespace_project_snippets_path(@project.namespace, @project), class: "btn btn-cancel" 
 else 
 link_to "Cancel", snippets_path(@project), class: "btn btn-cancel" 
 end 
 end 
 
 
 yield :scripts_body 
 

end

    end
  end

  def edit
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 page_title       @project.name_with_namespace 
 page_description @project.description    unless page_description 
 header_title     project_title(@project) unless header_title 
 nav              "project" 
 content_for :scripts_body_top do 
 project = @target_project || @project 
 if @project_wiki 
 markdown_preview_path = namespace_project_wikis_markdown_preview_path(project.namespace, project) 
 else 
 markdown_preview_path = markdown_preview_namespace_project_path(project.namespace, project) 
 end 
 if current_user 
 end 
 end 
 content_for :scripts_body do 
  project = @target_project || @project 
 if @noteable 
 end 
 
 end 
 content_for :header_content do 
 dropdown_title("Go to a project") 
 dropdown_filter("Search your projects") 
 dropdown_content 
 dropdown_loading 
 end 
   page_description brand_title unless page_description 
 site_name = "GitLab" 
 # Open Graph - http://ogp.me/ 
 site_name 
 page_title 
 page_description 
 page_image 
 request.base_url 
 # Twitter Card - https://dev.twitter.com/cards/types/summary 
 page_title 
 page_description 
 page_image 
 page_card_meta_tags 
 page_title(site_name) 
 page_description 
 favicon_link_tag 'favicon.ico' 
 stylesheet_link_tag "application", media: "all" 
 stylesheet_link_tag "print",       media: "print" 
 javascript_include_tag "application" 
 if page_specific_javascripts 
 javascript_include_tag page_specific_javascripts, {"data-turbolinks-track" => true} 
 end 
 csrf_meta_tags 
 unless browser.safari? 
 end 
 # Apple Safari/iOS home screen icons 
 favicon_link_tag 'touch-icon-iphone.png',        rel: 'apple-touch-icon' 
 favicon_link_tag 'touch-icon-ipad.png',          rel: 'apple-touch-icon', sizes: '76x76' 
 favicon_link_tag 'touch-icon-iphone-retina.png', rel: 'apple-touch-icon', sizes: '120x120' 
 favicon_link_tag 'touch-icon-ipad-retina.png',   rel: 'apple-touch-icon', sizes: '152x152' 
 image_path('logo.svg') 
 # Windows 8 pinned site tile 
 image_path('msapplication-tile.png') 
 yield :meta_tags 
  
  
  
  
 
 Gon::Base.render_data 
 # Ideally this would be inside the head, but turbolinks only evaluates page-specific JS in the body. 
 yield :scripts_body_top 
  nav_header_class 
 icon('bars') 
 icon('angle-left') 
  page_title    "Search" 
 header_title  "Search", search_path 
 render template: "layouts/application" 
 
 link_to search_path, title: 'Search', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('search') 
 end 
 if current_user 
 if session[:impersonator_id] 
 link_to admin_impersonation_path, method: :delete, title: 'Stop Impersonation', data: { toggle: 'tooltip', placement: 'bottom', container: 'body' } do 
 icon('user-secret fw') 
 end 
 end 
 if current_user.is_admin? 
 link_to admin_root_path, title: 'Admin Area', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('wrench fw') 
 end 
 end 
 link_to dashboard_todos_path, title: 'Todos', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('bell fw') 
 unless todos_pending_count == 0 
 todos_pending_count 
 end 
 end 
 if current_user.can_create_project? 
 link_to new_project_path, title: 'New project', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('plus fw') 
 end 
 end 
 if Gitlab::Sherlock.enabled? 
 link_to sherlock_transactions_path, title: 'Sherlock Transactions',                  data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('tachometer fw') 
 end 
 end 
 link_to destroy_user_session_path, class: 'logout', method: :delete, title: 'Sign out', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('sign-out') 
 end 
 else 
 link_to "Sign in", new_session_path(:user, redirect_to_referer: 'yes'), class: 'btn btn-sign-in btn-success' 
 end 
 title 
 yield :header_content 
  if outdated_browser? 
 link = "https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/install/requirements.md#supported-web-browsers" 
 link_to 'supported web browser', link 
 end 
 
 if @project && !@project.empty_repo? 
 if ref = @ref || @project.repository.root_ref 
 end 
 end 
 
  nav_sidebar_class 
 brand_header_logo 
 link_to root_path, class: 'gitlab-text-container-link', title: 'Dashboard', id: 'js-shortcuts-home' do 
 end 
 if defined?(sidebar) && sidebar 
 render "layouts/nav/" 
 elsif current_user 
  nav_link(path: ['root#index', 'projects#trending', 'projects#starred', 'dashboard/projects#index'], html_options: {}) do 
 link_to dashboard_projects_path, title: 'Projects', class: 'dashboard-shortcuts-projects' do 
 icon('bookmark fw') 
 end 
 end 
 nav_link(controller: :todos) do 
 link_to dashboard_todos_path, title: 'Todos' do 
 icon('bell fw') 
 number_with_delimiter(todos_pending_count) 
 end 
 end 
 nav_link(path: 'dashboard#activity') do 
 link_to activity_dashboard_path, class: 'dashboard-shortcuts-activity', title: 'Activity' do 
 icon('dashboard fw') 
 end 
 end 
 nav_link(controller: [:groups, 'groups/milestones', 'groups/group_members']) do 
 link_to dashboard_groups_path, title: 'Groups' do 
 icon('group fw') 
 end 
 end 
 nav_link(controller: 'dashboard/milestones') do 
 link_to dashboard_milestones_path, title: 'Milestones' do 
 icon('clock-o fw') 
 end 
 end 
 nav_link(path: 'dashboard#issues') do 
 link_to assigned_issues_dashboard_path, title: 'Issues', class: 'dashboard-shortcuts-issues' do 
 icon('exclamation-circle fw') 
 number_with_delimiter(current_user.assigned_open_issues_count) 
 end 
 end 
 nav_link(path: 'dashboard#merge_requests') do 
 link_to assigned_mrs_dashboard_path, title: 'Merge Requests', class: 'dashboard-shortcuts-merge_requests' do 
 icon('tasks fw') 
 number_with_delimiter(current_user.assigned_open_merge_request_count) 
 end 
 end 
 nav_link(controller: :snippets) do 
 link_to dashboard_snippets_path, title: 'Snippets' do 
 icon('clipboard fw') 
 end 
 end 
 nav_link(controller: :help) do 
 link_to help_path, title: 'Help' do 
 icon('question-circle fw') 
 end 
 end 
 nav_link(html_options: {class: profile_tab_class}) do 
 link_to profile_path, title: 'Profile Settings', data: {placement: 'bottom'} do 
 icon('user fw') 
 end 
 end 
 
 else 
  nav_link(path: ['dashboard#show', 'root#show', 'projects#trending', 'projects#starred', 'projects#index'], html_options: {class: 'home'}) do 
 link_to explore_root_path, title: 'Projects' do 
 icon('bookmark fw') 
 end 
 end 
 nav_link(controller: [:groups, 'groups/milestones', 'groups/group_members']) do 
 link_to explore_groups_path, title: 'Groups' do 
 icon('group fw') 
 end 
 end 
 nav_link(controller: :snippets) do 
 link_to explore_snippets_path, title: 'Snippets' do 
 icon('clipboard fw') 
 end 
 end 
 nav_link(controller: :help) do 
 link_to help_path, title: 'Help' do 
 icon('question-circle fw') 
 end 
 end 
 
 end 
  if nav_menu_collapsed? 
 link_to icon('angle-right'), '#', class: 'toggle-nav-collapse', title: "Open/Close" 
 else 
 link_to icon('angle-left'), '#', class: 'toggle-nav-collapse', title: "Open/Close" 
 end 
 
 if current_user 
 link_to current_user, class: 'sidebar-user', title: "Profile" do 
 image_tag avatar_icon(current_user, 60), alt: 'Profile', class: 'avatar avatar s36' 
 current_user.username 
 end 
 end 
 if defined?(nav) && nav 
 render "layouts/nav/" 
 end 
  broadcast_message 
 
  if alert 
 alert 
 elsif notice 
 notice 
 end 
 
 yield :flash_message 
 (container_class unless @no_container) 
 page_title "Edit", @snippet.title, "Snippets" 
  form_for @snippet, url: url, html: { class: "form-horizontal snippet-form js-requires-input" } do |f| 
 form_errors(@snippet) 
 f.label :title, class: 'control-label' 
 f.text_field :title, class: 'form-control', required: true, autofocus: true 
  f.label :visibility_level, class: 'control-label' do 
 link_to "(?)", help_page_path("public_access", "public_access") 
 end 
 if can_change_visibility_level 
  Gitlab::VisibilityLevel.values.each do |level| 
 next if skip_level?(form_model, level) 
 restricted = restricted_visibility_levels.include?(level) 
 form.label "_" do 
 form.radio_button model_method, level, checked: (selected_level == level), disabled: restricted 
 visibility_level_icon(level) 
 visibility_level_label(level) 
 visibility_level_description(level, form_model) 
 end 
 end 
 unless restricted_visibility_levels.empty? 
 end 
 
 else 
 visibility_level_icon(visibility_level) 
 visibility_level_label(visibility_level) 
 visibility_level_description(visibility_level, form_model) 
 end 
 
 f.label :file_name, "File", class: 'control-label' 
 f.text_field :file_name, placeholder: "Optionally name this file to add code highlighting, e.g. example.rb for Ruby.", class: 'form-control snippet-file-name' 
 @snippet.content 
 f.hidden_field :content, class: 'snippet-file-content' 
 if @snippet.new_record? 
 f.submit 'Create snippet', class: "btn-create btn" 
 else 
 f.submit 'Save changes', class: "btn-save btn" 
 end 
 if @snippet.project_id 
 link_to "Cancel", namespace_project_snippets_path(@project.namespace, @project), class: "btn btn-cancel" 
 else 
 link_to "Cancel", snippets_path(@project), class: "btn btn-cancel" 
 end 
 end 
 
 
 yield :scripts_body 
 

end

  end

  def update
    UpdateSnippetService.new(project, current_user, @snippet,
                             snippet_params).execute
    respond_with(@snippet,
                 location: namespace_project_snippet_path(@project.namespace,
                                                          @project, @snippet))
  end

  def show
    @note = @project.notes.new(noteable: @snippet)
    @notes = @snippet.notes.fresh
    @noteable = @snippet
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 page_title       @project.name_with_namespace 
 page_description @project.description    unless page_description 
 header_title     project_title(@project) unless header_title 
 nav              "project" 
 content_for :scripts_body_top do 
 project = @target_project || @project 
 if @project_wiki 
 markdown_preview_path = namespace_project_wikis_markdown_preview_path(project.namespace, project) 
 else 
 markdown_preview_path = markdown_preview_namespace_project_path(project.namespace, project) 
 end 
 if current_user 
 end 
 end 
 content_for :scripts_body do 
  project = @target_project || @project 
 if @noteable 
 end 
 
 end 
 content_for :header_content do 
 dropdown_title("Go to a project") 
 dropdown_filter("Search your projects") 
 dropdown_content 
 dropdown_loading 
 end 
   page_description brand_title unless page_description 
 site_name = "GitLab" 
 # Open Graph - http://ogp.me/ 
 site_name 
 page_title 
 page_description 
 page_image 
 request.base_url 
 # Twitter Card - https://dev.twitter.com/cards/types/summary 
 page_title 
 page_description 
 page_image 
 page_card_meta_tags 
 page_title(site_name) 
 page_description 
 favicon_link_tag 'favicon.ico' 
 stylesheet_link_tag "application", media: "all" 
 stylesheet_link_tag "print",       media: "print" 
 javascript_include_tag "application" 
 if page_specific_javascripts 
 javascript_include_tag page_specific_javascripts, {"data-turbolinks-track" => true} 
 end 
 csrf_meta_tags 
 unless browser.safari? 
 end 
 # Apple Safari/iOS home screen icons 
 favicon_link_tag 'touch-icon-iphone.png',        rel: 'apple-touch-icon' 
 favicon_link_tag 'touch-icon-ipad.png',          rel: 'apple-touch-icon', sizes: '76x76' 
 favicon_link_tag 'touch-icon-iphone-retina.png', rel: 'apple-touch-icon', sizes: '120x120' 
 favicon_link_tag 'touch-icon-ipad-retina.png',   rel: 'apple-touch-icon', sizes: '152x152' 
 image_path('logo.svg') 
 # Windows 8 pinned site tile 
 image_path('msapplication-tile.png') 
 yield :meta_tags 
  
  
  
  
 
 Gon::Base.render_data 
 # Ideally this would be inside the head, but turbolinks only evaluates page-specific JS in the body. 
 yield :scripts_body_top 
  nav_header_class 
 icon('bars') 
 icon('angle-left') 
  page_title    "Search" 
 header_title  "Search", search_path 
 render template: "layouts/application" 
 
 link_to search_path, title: 'Search', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('search') 
 end 
 if current_user 
 if session[:impersonator_id] 
 link_to admin_impersonation_path, method: :delete, title: 'Stop Impersonation', data: { toggle: 'tooltip', placement: 'bottom', container: 'body' } do 
 icon('user-secret fw') 
 end 
 end 
 if current_user.is_admin? 
 link_to admin_root_path, title: 'Admin Area', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('wrench fw') 
 end 
 end 
 link_to dashboard_todos_path, title: 'Todos', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('bell fw') 
 unless todos_pending_count == 0 
 todos_pending_count 
 end 
 end 
 if current_user.can_create_project? 
 link_to new_project_path, title: 'New project', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('plus fw') 
 end 
 end 
 if Gitlab::Sherlock.enabled? 
 link_to sherlock_transactions_path, title: 'Sherlock Transactions',                  data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('tachometer fw') 
 end 
 end 
 link_to destroy_user_session_path, class: 'logout', method: :delete, title: 'Sign out', data: {toggle: 'tooltip', placement: 'bottom', container: 'body'} do 
 icon('sign-out') 
 end 
 else 
 link_to "Sign in", new_session_path(:user, redirect_to_referer: 'yes'), class: 'btn btn-sign-in btn-success' 
 end 
 title 
 yield :header_content 
  if outdated_browser? 
 link = "https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/install/requirements.md#supported-web-browsers" 
 link_to 'supported web browser', link 
 end 
 
 if @project && !@project.empty_repo? 
 if ref = @ref || @project.repository.root_ref 
 end 
 end 
 
  nav_sidebar_class 
 brand_header_logo 
 link_to root_path, class: 'gitlab-text-container-link', title: 'Dashboard', id: 'js-shortcuts-home' do 
 end 
 if defined?(sidebar) && sidebar 
 render "layouts/nav/" 
 elsif current_user 
  nav_link(path: ['root#index', 'projects#trending', 'projects#starred', 'dashboard/projects#index'], html_options: {}) do 
 link_to dashboard_projects_path, title: 'Projects', class: 'dashboard-shortcuts-projects' do 
 icon('bookmark fw') 
 end 
 end 
 nav_link(controller: :todos) do 
 link_to dashboard_todos_path, title: 'Todos' do 
 icon('bell fw') 
 number_with_delimiter(todos_pending_count) 
 end 
 end 
 nav_link(path: 'dashboard#activity') do 
 link_to activity_dashboard_path, class: 'dashboard-shortcuts-activity', title: 'Activity' do 
 icon('dashboard fw') 
 end 
 end 
 nav_link(controller: [:groups, 'groups/milestones', 'groups/group_members']) do 
 link_to dashboard_groups_path, title: 'Groups' do 
 icon('group fw') 
 end 
 end 
 nav_link(controller: 'dashboard/milestones') do 
 link_to dashboard_milestones_path, title: 'Milestones' do 
 icon('clock-o fw') 
 end 
 end 
 nav_link(path: 'dashboard#issues') do 
 link_to assigned_issues_dashboard_path, title: 'Issues', class: 'dashboard-shortcuts-issues' do 
 icon('exclamation-circle fw') 
 number_with_delimiter(current_user.assigned_open_issues_count) 
 end 
 end 
 nav_link(path: 'dashboard#merge_requests') do 
 link_to assigned_mrs_dashboard_path, title: 'Merge Requests', class: 'dashboard-shortcuts-merge_requests' do 
 icon('tasks fw') 
 number_with_delimiter(current_user.assigned_open_merge_request_count) 
 end 
 end 
 nav_link(controller: :snippets) do 
 link_to dashboard_snippets_path, title: 'Snippets' do 
 icon('clipboard fw') 
 end 
 end 
 nav_link(controller: :help) do 
 link_to help_path, title: 'Help' do 
 icon('question-circle fw') 
 end 
 end 
 nav_link(html_options: {class: profile_tab_class}) do 
 link_to profile_path, title: 'Profile Settings', data: {placement: 'bottom'} do 
 icon('user fw') 
 end 
 end 
 
 else 
  nav_link(path: ['dashboard#show', 'root#show', 'projects#trending', 'projects#starred', 'projects#index'], html_options: {class: 'home'}) do 
 link_to explore_root_path, title: 'Projects' do 
 icon('bookmark fw') 
 end 
 end 
 nav_link(controller: [:groups, 'groups/milestones', 'groups/group_members']) do 
 link_to explore_groups_path, title: 'Groups' do 
 icon('group fw') 
 end 
 end 
 nav_link(controller: :snippets) do 
 link_to explore_snippets_path, title: 'Snippets' do 
 icon('clipboard fw') 
 end 
 end 
 nav_link(controller: :help) do 
 link_to help_path, title: 'Help' do 
 icon('question-circle fw') 
 end 
 end 
 
 end 
  if nav_menu_collapsed? 
 link_to icon('angle-right'), '#', class: 'toggle-nav-collapse', title: "Open/Close" 
 else 
 link_to icon('angle-left'), '#', class: 'toggle-nav-collapse', title: "Open/Close" 
 end 
 
 if current_user 
 link_to current_user, class: 'sidebar-user', title: "Profile" do 
 image_tag avatar_icon(current_user, 60), alt: 'Profile', class: 'avatar avatar s36' 
 current_user.username 
 end 
 end 
 if defined?(nav) && nav 
 render "layouts/nav/" 
 end 
  broadcast_message 
 
  if alert 
 alert 
 elsif notice 
 notice 
 end 
 
 yield :flash_message 
 (container_class unless @no_container) 
 page_title @snippet.title, "Snippets" 
  visibility_level_label(@snippet.visibility_level) 
 visibility_level_icon(@snippet.visibility_level, fw: false) 
 time_ago_with_tooltip(@snippet.created_at, placement: 'bottom', html_class: 'snippet_updated_ago') 
 if @snippet.updated_at != @snippet.created_at 
 icon('edit', title: 'edited') 
 time_ago_with_tooltip(@snippet.updated_at, placement: 'bottom', html_class: 'snippet_edited_ago') 
 end 
 if @snippet.project_id? 
  link_to new_namespace_project_snippet_path(@project.namespace, @project), class: 'btn btn-grouped btn-create new-snippet-link', title: "New Snippet" do 
 icon('plus') 
 end 
 if can?(current_user, :update_project_snippet, @snippet) 
 link_to edit_namespace_project_snippet_path(@project.namespace, @project, @snippet), class: "btn btn-grouped snippable-edit" do 
 end 
 end 
 if can?(current_user, :update_project_snippet, @snippet) 
 link_to namespace_project_snippet_path(@project.namespace, @project, @snippet), method: :delete, data: { confirm: "Are you sure?" }, class: "btn btn-grouped btn-warning", title: 'Delete Snippet' do 
 end 
 end 
 link_to new_namespace_project_snippet_path(@project.namespace, @project), title: "New Snippet" do 
 end 
 if can?(current_user, :update_project_snippet, @snippet) 
 link_to edit_namespace_project_snippet_path(@project.namespace, @project, @snippet) do 
 end 
 end 
 if can?(current_user, :update_project_snippet, @snippet) 
 link_to namespace_project_snippet_path(@project.namespace, @project, @snippet), method: :delete, data: { confirm: "Are you sure?" }, title: 'Delete Snippet' do 
 end 
 end 
 
 else 
  link_to new_snippet_path, class: "btn btn-grouped btn-create new-snippet-link", title: "New Snippet" do 
 icon('plus') 
 end 
 if can?(current_user, :update_personal_snippet, @snippet) 
 link_to edit_snippet_path(@snippet), class: "btn btn-grouped snippable-edit" do 
 end 
 end 
 if can?(current_user, :admin_personal_snippet, @snippet) 
 link_to snippet_path(@snippet), method: :delete, data: { confirm: "Are you sure?" }, class: "btn btn-grouped btn-warning", title: 'Delete Snippet' do 
 end 
 end 
 link_to new_snippet_path, title: "New Snippet" do 
 end 
 if can?(current_user, :update_personal_snippet, @snippet) 
 link_to edit_snippet_path(@snippet) do 
 end 
 end 
 if can?(current_user, :admin_personal_snippet, @snippet) 
 link_to snippet_path(@snippet), method: :delete, data: { confirm: "Are you sure?" }, title: 'Delete Snippet' do 
 end 
 end 
 
 end 
 markdown escape_once(@snippet.title), pipeline: :single_line, author: @snippet.author 
 
 blob_icon 0, @snippet.file_name 
 @snippet.file_name 
 clipboard_button(clipboard_target: ".blob-content[data-blob-id='']") 
 link_to 'Raw', raw_namespace_project_snippet_path(@project.namespace, @project, @snippet), class: "btn btn-sm", target: "_blank" 
  unless @snippet.content.empty? 
 if markup?(@snippet.file_name) 
 @snippet.data 
 render_markup(@snippet.file_name, @snippet.data) 
 else 
  if blob.data.present? 
 link_icon = icon('link') 
 blob.data.each_line.each_with_index do |_, index| 
 offset = defined?(first_line_number) ? first_line_number : 1 
 i = index + offset 
 # We're not using `link_to` because it is too slow once we get to thousands of lines. 
 link_icon 
 i 
 end 
 end 
 highlight(blob.name, blob.data, plain: blob.no_highlighting?) 
 
 end 
 else 
 end 
 
   if @discussions.present? 
 @discussions.each do |discussion_notes| 
 note = discussion_notes.first 
 if note_for_main_target?(note) 
  return unless note.author 
 return if note.cross_reference_not_visible_for?(current_user) 
 note_editable = note_editable?(note) 
 user_path(note.author) 
 image_tag avatar_icon(note.author), alt: '', class: 'avatar s40' 
 link_to_member(note.project, note.author, avatar: false) 
 note.author.to_reference 
 unless note.system 
 end 
 time_ago_with_tooltip(note.created_at, placement: 'bottom', html_class: 'note-created-ago') 
 access = note.project.team.human_max_access(note.author.id) 
 if access 
 access 
 end 
 if note_editable 
 link_to '#', title: 'Award Emoji', class: 'note-action-button note-emoji-button js-add-award js-note-emoji', data: { position: 'right' } do 
 icon('spinner spin') 
 icon('smile-o') 
 end 
 link_to '#', title: 'Edit comment', class: 'note-action-button js-note-edit' do 
 icon('pencil') 
 end 
 link_to namespace_project_note_path(note.project.namespace, note.project, note), title: 'Remove comment', method: :delete, data: { confirm: 'Are you sure you want to remove this comment?' }, remote: true, class: 'note-action-button hidden-xs js-note-delete danger' do 
 icon('trash-o') 
 end 
 end 
 preserve do 
 markdown(note.note, pipeline: :note, cache_key: [note, "note"], author: note.author) 
 end 
 edited_time_ago_with_tooltip(note, placement: 'bottom', html_class: 'note_edited_ago', include_author: true) 
 if note_editable 
  form_for note, url: namespace_project_note_path(@project.namespace, @project, note), method: :put, remote: true, authenticity_token: true, html: { class: 'edit-note common-note-form js-quick-submit' } do |f| 
 note_target_fields(note) 
 render layout: 'projects/md_preview', locals: { preview_class: 'md-preview' } do 
 render 'projects/zen', f: f, attr: :note, classes: 'note-textarea js-note-text js-task-list-field', placeholder: "Write a comment or drag your files here..." 
 render 'projects/notes/hints' 
 end 
 f.submit 'Save Comment', class: 'btn btn-nr btn-save btn-grouped js-comment-button' 
 end 
 
 end 
  grouped_emojis = awardable.grouped_awards(with_thumbs: inline) 
 awards_sort(grouped_emojis).each do |emoji, awards| 
 emoji_icon(emoji, sprite: false) 
 awards.count 
 end 
 if current_user 
 icon('smile-o', class: "award-control-icon award-control-icon-normal") 
 icon('spinner spin', class: "award-control-icon award-control-icon-loading") 
 end 
 
 if note.attachment.url 
 if note.attachment.image? 
 link_to note.attachment.url, target: '_blank' do 
 image_tag note.attachment.url, class: 'note-image-attach' 
 end 
 end 
 link_to note.attachment.url, target: '_blank' do 
 icon('paperclip') 
 note.attachment_identifier 
 link_to delete_attachment_namespace_project_note_path(note.project.namespace, note.project, note),                title: 'Delete this attachment', method: :delete, remote: true, data: { confirm: 'Are you sure you want to remove the attachment?' }, class: 'danger js-note-attachment-delete' do 
 icon('trash-o', class: 'cred') 
 end 
 end 
 end 
 
 else 
  note = discussion_notes.first 
 expanded = !note.diff_note? || note.active? 
 link_to user_path(note.author) do 
 image_tag avatar_icon(note.author), class: "avatar s40" 
 end 
 note.discussion_id 
 link_to_member(@project, note.author, avatar: false) 
 note.author.to_reference 
 if note.for_commit? 
 commit = note.noteable 
 if commit 
 link_to commit.short_id, namespace_project_commit_path(note.project.namespace, note.project, note.noteable, anchor: note.line_code), class: 'monospace' 
 else 
 end 
 else 
 if note.active? 
 link_to diffs_namespace_project_merge_request_path(note.project.namespace, note.project, note.noteable, anchor: note.line_code) do 
 end 
 else 
 end 
 end 
 time_ago_with_tooltip(note.created_at, placement: "bottom", html_class: "note-created-ago") 
 link_to "#", class: "note-action-button discussion-toggle-button js-toggle-button" do 
 if expanded 
 icon("chevron-up") 
 else 
 icon("chevron-down") 
 end 
 end 
 ("hide" unless expanded) 
 if note.diff_note? 
  note = discussion_notes.first 
 diff = note.diff 
 return unless diff 
 if diff.deleted_file 
 diff.old_path 
 else 
 diff.new_path 
 if diff.a_mode && diff.b_mode && diff.a_mode != diff.b_mode 
 "  " 
 end 
 end 
 note.truncated_diff_lines.each do |line| 
 type = line.type 
 line_code = generate_line_code(note.diff_file_path, line) 
 if type == "match" 
 "..." 
 "..." 
 line.text 
 else 
 ['noteable_line', type, line_code] 
 line_code 
 diff_line_content(line.text, type) 
 if line_code == note.line_code 
  note = notes.first 
  return unless note.author 
 return if note.cross_reference_not_visible_for?(current_user) 
 note_editable = note_editable?(note) 
 user_path(note.author) 
 image_tag avatar_icon(note.author), alt: '', class: 'avatar s40' 
 link_to_member(note.project, note.author, avatar: false) 
 note.author.to_reference 
 unless note.system 
 end 
 time_ago_with_tooltip(note.created_at, placement: 'bottom', html_class: 'note-created-ago') 
 access = note.project.team.human_max_access(note.author.id) 
 if access 
 access 
 end 
 if note_editable 
 link_to '#', title: 'Award Emoji', class: 'note-action-button note-emoji-button js-add-award js-note-emoji', data: { position: 'right' } do 
 icon('spinner spin') 
 icon('smile-o') 
 end 
 link_to '#', title: 'Edit comment', class: 'note-action-button js-note-edit' do 
 icon('pencil') 
 end 
 link_to namespace_project_note_path(note.project.namespace, note.project, note), title: 'Remove comment', method: :delete, data: { confirm: 'Are you sure you want to remove this comment?' }, remote: true, class: 'note-action-button hidden-xs js-note-delete danger' do 
 icon('trash-o') 
 end 
 end 
 preserve do 
 markdown(note.note, pipeline: :note, cache_key: [note, "note"], author: note.author) 
 end 
 edited_time_ago_with_tooltip(note, placement: 'bottom', html_class: 'note_edited_ago', include_author: true) 
 if note_editable 
 render 'projects/notes/edit_form', note: note 
 end 
 render 'award_emoji/awards_block', awardable: note, inline: false 
 if note.attachment.url 
 if note.attachment.image? 
 link_to note.attachment.url, target: '_blank' do 
 image_tag note.attachment.url, class: 'note-image-attach' 
 end 
 end 
 link_to note.attachment.url, target: '_blank' do 
 icon('paperclip') 
 note.attachment_identifier 
 link_to delete_attachment_namespace_project_note_path(note.project.namespace, note.project, note),                title: 'Delete this attachment', method: :delete, remote: true, data: { confirm: 'Are you sure you want to remove the attachment?' }, class: 'danger js-note-attachment-delete' do 
 icon('trash-o', class: 'cred') 
 end 
 end 
 end 
 
 link_to_reply_discussion(note) 
 
 end 
 end 
 end 
 
 else 
  note = discussion_notes.first 
  return unless note.author 
 return if note.cross_reference_not_visible_for?(current_user) 
 note_editable = note_editable?(note) 
 user_path(note.author) 
 image_tag avatar_icon(note.author), alt: '', class: 'avatar s40' 
 link_to_member(note.project, note.author, avatar: false) 
 note.author.to_reference 
 unless note.system 
 end 
 time_ago_with_tooltip(note.created_at, placement: 'bottom', html_class: 'note-created-ago') 
 access = note.project.team.human_max_access(note.author.id) 
 if access 
 access 
 end 
 if note_editable 
 link_to '#', title: 'Award Emoji', class: 'note-action-button note-emoji-button js-add-award js-note-emoji', data: { position: 'right' } do 
 icon('spinner spin') 
 icon('smile-o') 
 end 
 link_to '#', title: 'Edit comment', class: 'note-action-button js-note-edit' do 
 icon('pencil') 
 end 
 link_to namespace_project_note_path(note.project.namespace, note.project, note), title: 'Remove comment', method: :delete, data: { confirm: 'Are you sure you want to remove this comment?' }, remote: true, class: 'note-action-button hidden-xs js-note-delete danger' do 
 icon('trash-o') 
 end 
 end 
 preserve do 
 markdown(note.note, pipeline: :note, cache_key: [note, "note"], author: note.author) 
 end 
 edited_time_ago_with_tooltip(note, placement: 'bottom', html_class: 'note_edited_ago', include_author: true) 
 if note_editable 
 render 'projects/notes/edit_form', note: note 
 end 
 render 'award_emoji/awards_block', awardable: note, inline: false 
 if note.attachment.url 
 if note.attachment.image? 
 link_to note.attachment.url, target: '_blank' do 
 image_tag note.attachment.url, class: 'note-image-attach' 
 end 
 end 
 link_to note.attachment.url, target: '_blank' do 
 icon('paperclip') 
 note.attachment_identifier 
 link_to delete_attachment_namespace_project_note_path(note.project.namespace, note.project, note),                title: 'Delete this attachment', method: :delete, remote: true, data: { confirm: 'Are you sure you want to remove the attachment?' }, class: 'danger js-note-attachment-delete' do 
 icon('trash-o', class: 'cred') 
 end 
 end 
 end 
 
 link_to_reply_discussion(note) 
 
 end 
 
 end 
 end 
 else 
 @notes.each do |note| 
  return unless note.author 
 return if note.cross_reference_not_visible_for?(current_user) 
 note_editable = note_editable?(note) 
 user_path(note.author) 
 image_tag avatar_icon(note.author), alt: '', class: 'avatar s40' 
 link_to_member(note.project, note.author, avatar: false) 
 note.author.to_reference 
 unless note.system 
 end 
 time_ago_with_tooltip(note.created_at, placement: 'bottom', html_class: 'note-created-ago') 
 access = note.project.team.human_max_access(note.author.id) 
 if access 
 access 
 end 
 if note_editable 
 link_to '#', title: 'Award Emoji', class: 'note-action-button note-emoji-button js-add-award js-note-emoji', data: { position: 'right' } do 
 icon('spinner spin') 
 icon('smile-o') 
 end 
 link_to '#', title: 'Edit comment', class: 'note-action-button js-note-edit' do 
 icon('pencil') 
 end 
 link_to namespace_project_note_path(note.project.namespace, note.project, note), title: 'Remove comment', method: :delete, data: { confirm: 'Are you sure you want to remove this comment?' }, remote: true, class: 'note-action-button hidden-xs js-note-delete danger' do 
 icon('trash-o') 
 end 
 end 
 preserve do 
 markdown(note.note, pipeline: :note, cache_key: [note, "note"], author: note.author) 
 end 
 edited_time_ago_with_tooltip(note, placement: 'bottom', html_class: 'note_edited_ago', include_author: true) 
 if note_editable 
  form_for note, url: namespace_project_note_path(@project.namespace, @project, note), method: :put, remote: true, authenticity_token: true, html: { class: 'edit-note common-note-form js-quick-submit' } do |f| 
 note_target_fields(note) 
 render layout: 'projects/md_preview', locals: { preview_class: 'md-preview' } do 
 render 'projects/zen', f: f, attr: :note, classes: 'note-textarea js-note-text js-task-list-field', placeholder: "Write a comment or drag your files here..." 
 render 'projects/notes/hints' 
 end 
 f.submit 'Save Comment', class: 'btn btn-nr btn-save btn-grouped js-comment-button' 
 end 
 
 end 
  grouped_emojis = awardable.grouped_awards(with_thumbs: inline) 
 awards_sort(grouped_emojis).each do |emoji, awards| 
 emoji_icon(emoji, sprite: false) 
 awards.count 
 end 
 if current_user 
 icon('smile-o', class: "award-control-icon award-control-icon-normal") 
 icon('spinner spin', class: "award-control-icon award-control-icon-loading") 
 end 
 
 if note.attachment.url 
 if note.attachment.image? 
 link_to note.attachment.url, target: '_blank' do 
 image_tag note.attachment.url, class: 'note-image-attach' 
 end 
 end 
 link_to note.attachment.url, target: '_blank' do 
 icon('paperclip') 
 note.attachment_identifier 
 link_to delete_attachment_namespace_project_note_path(note.project.namespace, note.project, note),                title: 'Delete this attachment', method: :delete, remote: true, data: { confirm: 'Are you sure you want to remove the attachment?' }, class: 'danger js-note-attachment-delete' do 
 icon('trash-o', class: 'cred') 
 end 
 end 
 end 
 
 end 
 end 
 
 if can? current_user, :create_note, @project 
 user_path(current_user) 
 image_tag avatar_icon(current_user), alt: current_user.to_reference, class: 'avatar s40' 
  form_for [@project.namespace.becomes(Namespace), @project, @note], remote: true, html: { :'data-type' => 'json', multipart: true, id: nil, class: "new-note js-new-note-form js-quick-submit common-note-form" }, authenticity_token: true do |f| 
 hidden_field_tag :view, diff_view 
 hidden_field_tag :line_type 
 note_target_fields(@note) 
 f.hidden_field :commit_id 
 f.hidden_field :line_code 
 f.hidden_field :noteable_id 
 f.hidden_field :noteable_type 
 f.hidden_field :type 
 render layout: 'projects/md_preview', locals: { preview_class: "md-preview", referenced_users: true } do 
 render 'projects/zen', f: f, attr: :note, classes: 'note-textarea js-note-text', placeholder: "Write a comment or drag your files here..." 
 render 'projects/notes/hints' 
 end 
 f.submit 'Comment', class: "btn btn-nr btn-create comment-btn btn-grouped js-comment-button" 
 yield(:note_actions) 
 end 
 
 else 
 link_to "register",new_user_session_path 
 link_to "login",new_user_session_path 
 end 
 
 
 yield :scripts_body 
 

end

  end

  def destroy
    return access_denied! unless can?(current_user, :admin_project_snippet, @snippet)

    @snippet.destroy

    redirect_to namespace_project_snippets_path(@project.namespace, @project)
  end

  def raw
    send_data(
      @snippet.content,
      type: 'text/plain; charset=utf-8',
      disposition: 'inline',
      filename: @snippet.sanitized_file_name
    )
  end

  protected

  def snippet
    @snippet ||= @project.snippets.find(params[:id])
  end

  def authorize_read_project_snippet!
    return render_404 unless can?(current_user, :read_project_snippet, @snippet)
  end

  def authorize_update_project_snippet!
    return render_404 unless can?(current_user, :update_project_snippet, @snippet)
  end

  def authorize_admin_project_snippet!
    return render_404 unless can?(current_user, :admin_project_snippet, @snippet)
  end

  def module_enabled
    return render_404 unless @project.snippets_enabled
  end

  def snippet_params
    params.require(:project_snippet).permit(:title, :content, :file_name, :private, :visibility_level)
  end
end

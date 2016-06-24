# Controller for a specific Commit
#
# Not to be confused with CommitsController, plural.
class Projects::CommitController < Projects::ApplicationController
  include CreatesCommit
  include DiffHelper

  # Authorize
  before_action :require_non_empty_project
  before_action :authorize_download_code!, except: [:cancel_builds, :retry_builds]
  before_action :authorize_update_build!, only: [:cancel_builds, :retry_builds]
  before_action :authorize_read_commit_status!, only: [:builds]
  before_action :commit
  before_action :define_show_vars, only: [:show, :builds]
  before_action :authorize_edit_tree!, only: [:revert, :cherry_pick]

  def show
    apply_diff_view_cookie!

    @grouped_diff_notes = commit.notes.grouped_diff_notes

    @note = @project.build_commit_note(commit)
    @notes = commit.notes.non_diff_notes.fresh
    @noteable = @commit
    @comments_target = {
      noteable_type: 'Commit',
      commit_id: @commit.id
    }

    respond_to do |format|
      format.html
      format.diff  { render text: @commit.to_diff }
      format.patch { render text: @commit.to_patch }
    end
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
 page_title        " ()", "Commits" 
 page_description  @commit.description 
  commit_author_link(@commit, avatar: true, size: 24) 
 if defined?(@notes_count) && @notes_count > 0 
 icon('comment') 
 @notes_count 
 end 
 link_to namespace_project_tree_path(@project.namespace, @project, @commit), class: "btn btn-grouped hidden-xs hidden-sm" do 
 end 
 link_to namespace_project_tree_path(@project.namespace, @project, @commit) do 
 end 
 unless @commit.has_been_reverted?(current_user) 
 revert_commit_link(@commit, namespace_project_commit_path(@project.namespace, @project, @commit.id), has_tooltip: false) 
 end 
 cherry_pick_commit_link(@commit, namespace_project_commit_path(@project.namespace, @project, @commit.id), has_tooltip: false) 
 unless @commit.parents.length > 1 
 link_to "Email Patches", namespace_project_commit_path(@project.namespace, @project, @commit, format: :patch) 
 end 
 link_to "Plain Diff",    namespace_project_commit_path(@project.namespace, @project, @commit, format: :diff) 
 if @commit.different_committer? 
 commit_committer_link(@commit, avatar: true, size: 24) 
 end 
 link_to @commit.id, namespace_project_commit_path(@project.namespace, @project, @commit), class: "monospace hidden-xs hidden-sm" 
 link_to @commit.short_id, namespace_project_commit_path(@project.namespace, @project, @commit), class: "monospace visible-xs-inline visible-sm-inline" 
 clipboard_button(clipboard_text: @commit.id) 
 pluralize(@commit.parents.count, "parent") 
 @commit.parents.each do |parent| 
 link_to parent.short_id, namespace_project_commit_path(@project.namespace, @project, parent), class: "monospace" 
 end 
 if @commit.status 
 pluralize(@commit.ci_commits.count, 'pipeline') 
 link_to builds_namespace_project_commit_path(@project.namespace, @project, @commit.id), class: "ci-status-link ci-status-icon-" do 
 ci_icon_for_status(@commit.status) 
 ci_label_for_status(@commit.status) 
 end 
 if @commit.ci_commits.duration 
 time_interval_in_words @commit.ci_commits.duration 
 end 
 end 
 markdown escape_once(@commit.title), pipeline: :single_line, author: @commit.author 
 if @commit.description.present? 
 preserve(markdown(escape_once(@commit.description), pipeline: :single_line, author: @commit.author)) 
 end 
 
 if @commit.status 
  nav_link(path: 'commit#show') do 
 link_to namespace_project_commit_path(@project.namespace, @project, @commit.id) do 
 @diffs.count 
 end 
 end 
 nav_link(path: 'commit#builds') do 
 link_to builds_namespace_project_commit_path(@project.namespace, @project, @commit.id) do 
 @statuses.count 
 end 
 end 
 
 else 
 end 
  show_whitespace_toggle = local_assigns.fetch(:show_whitespace_toggle, true) 
 if diff_view == 'parallel' 
 fluid_layout true 
 end 
 diff_files = safe_diff_files(diffs, diff_refs) 
 if show_whitespace_toggle 
 if current_controller?(:commit) 
 commit_diff_whitespace_link(@project, @commit, class: 'hidden-xs') 
 elsif current_controller?(:merge_requests) 
 diff_merge_request_whitespace_link(@project, @merge_request, class: 'hidden-xs') 
 end 
 end 
 inline_diff_btn 
 parallel_diff_btn 
  link_to '#', class: 'js-toggle-button' do 
 end 
 diff_files.each_with_index do |diff_file, i| 
 if diff_file.deleted_file 
 diff_file.old_path 
 elsif diff_file.renamed_file 
 diff_file.old_path 
 diff_file.new_path 
 elsif diff_file.new_file 
 diff_file.new_path 
 else 
 diff_file.new_path 
 end 
 end 
 
 if diff_files.overflow? 
  unless diff_hard_limit_enabled? 
 link_to "Reload with full diff", url_for(params.merge(force_show_diff: true, format: nil)), class: "btn btn-sm" 
 end 
 if current_controller?(:commit) or current_controller?(:merge_requests) 
 if current_controller?(:commit) 
 link_to "Plain diff", namespace_project_commit_path(@project.namespace, @project, @commit, format: :diff), class: "btn btn-sm" 
 link_to "Email patch", namespace_project_commit_path(@project.namespace, @project, @commit, format: :patch), class: "btn btn-sm" 
 elsif @merge_request && @merge_request.persisted? 
 link_to "Plain diff", merge_request_path(@merge_request, format: :diff), class: "btn btn-sm" 
 link_to "Email patch", merge_request_path(@merge_request, format: :patch), class: "btn btn-sm" 
 end 
 end 
 
 end 
 diff_files.each_with_index do |diff_file, index| 
 diff_commit = commit_for_diff(diff_file) 
 blob = project.repository.blob_for_diff(diff_commit, diff_file) 
 next unless blob 
  if diff_file.diff.submodule? 
 icon('archive fw') 
 submodule_link(blob, @commit.id, project.repository) 
 else 
 blob_icon blob.mode, blob.name 
 link_to "#diff-" do 
 if diff_file.renamed_file 
 old_path, new_path = mark_inline_diffs(diff_file.old_path, diff_file.new_path) 
 old_path 
 new_path 
 else 
 diff_file.new_path 
 if diff_file.deleted_file 
 end 
 end 
 end 
 if diff_file.mode_changed? 
 "  " 
 end 
 if blob_text_viewable?(blob) 
 link_to '#', class: 'js-toggle-diff-comments btn active has-tooltip btn-file-option', title: "Toggle comments for this file" do 
 icon('comment') 
 end 
 end 
 if editable_diff?(diff_file) 
 edit_blob_link(@merge_request.source_project,              @merge_request.source_branch, diff_file.new_path,              from_merge_request_id: @merge_request.id) 
 end 
 view_file_btn(diff_commit.id, diff_file, project) 
 end 
 # Skip all non non-supported blobs 
 return unless blob.respond_to?(:text?) 
 if diff_file.too_large? 
 elsif blob_text_viewable?(blob) && !project.repository.diffable?(blob) 
 elsif blob_text_viewable?(blob) 
 if diff_view == 'parallel' 
  diff_file.parallel_diff_lines.each do |line| 
 left = line[:left] 
 right = line[:right] 
 if left[:type] == 'match' 
  line 
 line 
 
 elsif left[:type] == 'nonewline' 
 left[:text] 
 left[:text] 
 else 
 link_to raw(left[:number]), "#", id: left[:line_code] 
 if !@diff_notes_disabled && can?(current_user, :create_note, @project) 
 link_to_new_diff_note(left[:line_code], 'old') 
 end 
 diff_line_content(left[:text]) 
 if right[:type] == 'new' 
 new_line_class = 'new' 
 new_line_code = right[:line_code] 
 else 
 new_line_class = nil 
 new_line_code = left[:line_code] 
 end 
 link_to raw(right[:number]), "#", id: new_line_code 
 if !@diff_notes_disabled && can?(current_user, :create_note, @project) 
 link_to_new_diff_note(new_line_code, 'new') 
 end 
 diff_line_content(right[:text]) 
 end 
 unless @diff_notes_disabled 
 notes_left, notes_right = organize_comments(left, right) 
 if notes_left.present? || notes_right.present? 
  note_left = notes_left.present? ? notes_left.first : nil 
 note_right = notes_right.present? ? notes_right.first : nil 
 if note_left 
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
 
 else 
 "" 
 "" 
 end 
 if note_right 
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
 
 else 
 "" 
 "" 
 end 
 
 end 
 end 
 end 
 if diff_file.diff.diff.blank? && diff_file.mode_changed? 
 end 
 
 else 
  
 end 
 elsif blob.image? 
 old_file = project.repository.prev_blob_for_diff(diff_commit, diff_file) 
  
 else 
 end 
 
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
 
 if can_collaborate_with_project? 
 %w(revert cherry-pick).each do |type| 
  case type.to_s 
 when 'revert' 
 label = 'Revert' 
 target_label = 'Revert in branch' 
 when 'cherry-pick' 
 label = 'Cherry-pick' 
 target_label = 'Pick into branch' 
 end 
 form_tag send("_namespace_project_commit_path", @project.namespace, @project, commit.id), method: :post, remote: false, class: 'form-horizontal js--form js-requires-input' do 
 label_tag 'target_branch', target_label, class: 'control-label' 
 select_tag "target_branch", grouped_options_refs, class: "select2 select2-sm js-target-branch" 
 if can?(current_user, :push_code, @project) 
 nonce = SecureRandom.hex 
 label_tag "create_merge_request-" do 
 check_box_tag 'create_merge_request', 1, true, class: 'js-create-merge-request', id: "create_merge_request-" 
 end 
 else 
 hidden_field_tag 'create_merge_request', 1 
 end 
 submit_tag label, class: 'btn btn-create' 
 link_to "Cancel", '#', class: "btn btn-cancel", "data-dismiss" => "modal" 
 unless can?(current_user, :push_code, @project) 
 commit_in_fork_help 
 end 
 end 
 
 end 
 end 
 
 yield :scripts_body 
 

end

  end

  def builds
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
 page_title "Builds", " ()", "Commits" 
 render "commit_box" 
 render "ci_menu" 
  page_title "Builds", " ()", "Commits" 
  commit_author_link(@commit, avatar: true, size: 24) 
 if defined?(@notes_count) && @notes_count > 0 
 icon('comment') 
 @notes_count 
 end 
 link_to namespace_project_tree_path(@project.namespace, @project, @commit), class: "btn btn-grouped hidden-xs hidden-sm" do 
 end 
 link_to namespace_project_tree_path(@project.namespace, @project, @commit) do 
 end 
 unless @commit.has_been_reverted?(current_user) 
 revert_commit_link(@commit, namespace_project_commit_path(@project.namespace, @project, @commit.id), has_tooltip: false) 
 end 
 cherry_pick_commit_link(@commit, namespace_project_commit_path(@project.namespace, @project, @commit.id), has_tooltip: false) 
 unless @commit.parents.length > 1 
 link_to "Email Patches", namespace_project_commit_path(@project.namespace, @project, @commit, format: :patch) 
 end 
 link_to "Plain Diff",    namespace_project_commit_path(@project.namespace, @project, @commit, format: :diff) 
 if @commit.different_committer? 
 commit_committer_link(@commit, avatar: true, size: 24) 
 end 
 link_to @commit.id, namespace_project_commit_path(@project.namespace, @project, @commit), class: "monospace hidden-xs hidden-sm" 
 link_to @commit.short_id, namespace_project_commit_path(@project.namespace, @project, @commit), class: "monospace visible-xs-inline visible-sm-inline" 
 clipboard_button(clipboard_text: @commit.id) 
 pluralize(@commit.parents.count, "parent") 
 @commit.parents.each do |parent| 
 link_to parent.short_id, namespace_project_commit_path(@project.namespace, @project, parent), class: "monospace" 
 end 
 if @commit.status 
 pluralize(@commit.ci_commits.count, 'pipeline') 
 link_to builds_namespace_project_commit_path(@project.namespace, @project, @commit.id), class: "ci-status-link ci-status-icon-" do 
 ci_icon_for_status(@commit.status) 
 ci_label_for_status(@commit.status) 
 end 
 if @commit.ci_commits.duration 
 time_interval_in_words @commit.ci_commits.duration 
 end 
 end 
 markdown escape_once(@commit.title), pipeline: :single_line, author: @commit.author 
 if @commit.description.present? 
 preserve(markdown(escape_once(@commit.description), pipeline: :single_line, author: @commit.author)) 
 end 
 
  nav_link(path: 'commit#show') do 
 link_to namespace_project_commit_path(@project.namespace, @project, @commit.id) do 
 @diffs.count 
 end 
 end 
 nav_link(path: 'commit#builds') do 
 link_to builds_namespace_project_commit_path(@project.namespace, @project, @commit.id) do 
 @statuses.count 
 end 
 end 
 
 render "builds" 
 
 
 yield :scripts_body 
 

end

  end

  def cancel_builds
    ci_builds.running_or_pending.each(&:cancel)

    redirect_back_or_default default: builds_namespace_project_commit_path(project.namespace, project, commit.sha)
  end

  def retry_builds
    ci_builds.latest.failed.each do |build|
      if build.retryable?
        Ci::Build.retry(build)
      end
    end

    redirect_back_or_default default: builds_namespace_project_commit_path(project.namespace, project, commit.sha)
  end

  def branches
    @branches = @project.repository.branch_names_contains(commit.id)
    @tags = @project.repository.tag_names_contains(commit.id)
    render layout: false
  end

  def revert
    assign_change_commit_vars(@commit.revert_branch_name)

    return render_404 if @target_branch.blank?

    create_commit(Commits::RevertService, success_notice: "The #{@commit.change_type_title} has been successfully reverted.",
                                          success_path: successful_change_path, failure_path: failed_change_path)
  end

  def cherry_pick
    assign_change_commit_vars(@commit.cherry_pick_branch_name)

    return render_404 if @target_branch.blank?

    create_commit(Commits::CherryPickService, success_notice: "The #{@commit.change_type_title} has been successfully cherry-picked.",
                                              success_path: successful_change_path, failure_path: failed_change_path)
  end

  private

  def successful_change_path
    return referenced_merge_request_url if @commit.merged_merge_request

    namespace_project_commits_url(@project.namespace, @project, @target_branch)
  end

  def failed_change_path
    return referenced_merge_request_url if @commit.merged_merge_request

    namespace_project_commit_url(@project.namespace, @project, params[:id])
  end

  def referenced_merge_request_url
    namespace_project_merge_request_url(@project.namespace, @project, @commit.merged_merge_request)
  end

  def commit
    @commit ||= @project.commit(params[:id])
  end

  def ci_commits
    @ci_commits ||= project.ci_commits.where(sha: commit.sha)
  end

  def ci_builds
    @ci_builds ||= Ci::Build.where(commit: ci_commits)
  end

  def define_show_vars
    return git_not_found! unless commit

    opts = diff_options
    opts[:ignore_whitespace_change] = true if params[:format] == 'diff'

    @diffs = commit.diffs(opts)
    @diff_refs = [commit.parent || commit, commit]
    @notes_count = commit.notes.count

    @statuses = CommitStatus.where(commit: ci_commits)
    @builds = Ci::Build.where(commit: ci_commits)
  end

  def assign_change_commit_vars(mr_source_branch)
    @commit = project.commit(params[:id])
    @target_branch = params[:target_branch]
    @mr_source_branch = mr_source_branch
    @mr_target_branch = @target_branch
    @commit_params = {
      commit: @commit,
      create_merge_request: params[:create_merge_request].present? || different_project?
    }
  end
end

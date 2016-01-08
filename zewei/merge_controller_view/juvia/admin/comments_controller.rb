class Admin::CommentsController < ApplicationController
  layout 'admin'

  skip_authorization_check :only => [:preview, :new_import, :import]
  before_filter :set_navigation_ids
  before_filter :save_return_to_url, :only => [:new, :edit, :approve, :destroy]
  before_filter :require_admin!, :only => [:new_import, :import]

  def index
    authorize! :read, Comment
    @all_comments = Comment.
      accessible_by(current_ability).
      order('created_at DESC').
      includes(:topic)
    @comments = @all_comments.page(params[:page])
 @title = "Comments" 
 if @all_comments.empty? 
 else 
 render :partial => 'admin/comments/comment',
      :collection => @comments,
      :locals => { :show_topic => true } 
 will_paginate @comments 
 end 

  end

  def edit
    @comment = Comment.find(params[:id])
    authorize! :update, @comment
 @comment.author_name || 'Anonymous' 
 form_for([:admin, @comment], :html => { :class => 'comment' }) do |f| 
 if @comment.errors.any? 
 pluralize(@comment.errors.count, "error") 
 @comment.errors.full_messages.each do |msg| 
 msg 
 end 
 end 
 f.label :author_name 
 f.text_field :author_name 
 f.label :author_email 
 f.text_field :author_email 
 f.label :content 
 f.text_area :content 
 f.submit :class => 'primary button' 
 button_link_to 'Cancel', session[:return_to] || admin_comments_path 
 render_markdown(@comment.content) 
 end 

  end

  def update
    @comment = Comment.find(params[:id])
    authorize! :update, @comment
    if @comment.update_attributes(params[:comment], :as => current_user.role)
      redirect_back(admin_comments_path)
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 @comment.author_name || 'Anonymous' 
 form_for([:admin, @comment], :html => { :class => 'comment' }) do |f| 
 if @comment.errors.any? 
 pluralize(@comment.errors.count, "error") 
 @comment.errors.full_messages.each do |msg| 
 msg 
 end 
 end 
 f.label :author_name 
 f.text_field :author_name 
 f.label :author_email 
 f.text_field :author_email 
 f.label :content 
 f.text_area :content 
 f.submit :class => 'primary button' 
 button_link_to 'Cancel', session[:return_to] || admin_comments_path 
 render_markdown(@comment.content) 
 end 

end

    end
  end

  def preview
    render :text => ApplicationHelper.render_markdown(params[:content])
  end

  def approve
    @comment = Comment.find(params[:id])
    authorize! :update, @comment
    @comment.transaction do
      @comment.moderation_status = :ok
      if @comment.site.moderation_method == :akismet
        @comment.report_ham
      end
      @comment.save!
    end
    redirect_back(admin_comments_path)
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize! :destroy, @comment
    @comment.transaction do
      if params[:spam] && @comment.site.moderation_method == :akismet
        @comment.report_spam
      end
      @comment.destroy
    end
    redirect_back(admin_comments_path)
  end

  def new_import
    @sites = Site.all
    @migrators = Juvia::Migrators::PLATFORMS.map{ |p| p.titleize }
 @title = "Import Comments" 
 form_tag(:import_admin_comments) do |f| 
 label_tag :site_id 
 select_tag :site_id, options_from_collection_for_select(@sites, 'id', 'name', params[:site_id].to_i) 
 label_tag :import_type 
 select_tag :import_type, options_for_select(@migrators) 
 label_tag :database_host 
 text_field_tag :database_host, 'localhost' 
 label_tag :database_name 
 text_field_tag :database_name 
 label_tag :database_user 
 text_field_tag :database_user 
 label_tag :database_password 
 text_field_tag :database_password 
 label_tag :table_prefix 
 text_field_tag :table_prefix, 'wp_' 
 label_tag :wp_multisite_id 
 text_field_tag :wp_multisite_id 
 primary_button_submit_tag('Import') 
 button_link_to 'Cancel', admin_comments_path 
 end 

  end

  def import
    options = {:table_prefix => params[:table_prefix],
      :wp_multisite_id => params[:wp_multisite_id]}
    if Juvia::Migrators.process(
      params[:site_id],
      params[:import_type],
      params[:database_name],
      params[:database_user],
      params[:database_password],
      params[:database_host],
      options
    )
      flash[:notice] = "Imported!"
      redirect_to(admin_comments_path)
    end
  end

private
  def set_navigation_ids
    @navigation_ids = [:dashboard, :comments]
  end
end

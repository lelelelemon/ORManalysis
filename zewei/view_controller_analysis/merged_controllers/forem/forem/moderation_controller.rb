module Forem
  class ModerationController < Forem::ApplicationController
    before_filter :ensure_moderator_or_admin

    helper 'forem/posts'

    def index
      @posts = forum.posts.pending_review
      @topics = forum.topics.pending_review
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag    "application", media: "all", "data-turbolinks-track" => true 
 javascript_include_tag "application", "data-turbolinks-track" => true 
 csrf_meta_tags 
 if current_user 
 current_user 
 link_to "Sign out", main_app.destroy_user_session_path, :method => :delete 
 else 
 link_to "Sign in", main_app.new_user_session_path 
 link_to "Register", main_app.new_user_registration_path 
 end 
 t('.title', :forum => forum) 
 t('posts_count', :count => @posts.count, :scope => 'forem.general') 
 form_tag forem.forum_moderate_posts_url(forum), :method => :put do 
 @posts.limit(25).group_by(&:topic).each do |topic, posts| 
 forem_emojify(topic.forum.title) 
 forem_emojify(topic.subject) 
  post.id 
 post_counter + 1 
 cycle('odd', 'even') 
 if post.pending_review? 
 t(".pending_review") 
 if forem_admin_or_moderator?(post.topic.forum) 
 if local_assigns[:mass_moderation] 
  fields_for "posts[#{post.id}]" do |f| 
  f.radio_button "moderation_option", "approve" 
 f.label "moderation_option_approve", t('approve', :scope => 'forem.posts.moderation'), :class => "label label-success" 
 f.radio_button "moderation_option", "spam" 
 f.label "moderation_option_spam", t('spam', :scope => 'forem.posts.moderation'), :class => "label label-danger" 
 f.submit t('moderate', :scope => 'forem.posts.moderation'), :class => "btn btn-primary" 
 
 end 
 
 else 
 form_tag forem.forum_moderate_posts_path(post.topic.forum), :method => :put do 
  fields_for "posts[#{post.id}]" do |f| 
  f.radio_button "moderation_option", "approve" 
 f.label "moderation_option_approve", t('approve', :scope => 'forem.posts.moderation'), :class => "label label-success" 
 f.radio_button "moderation_option", "spam" 
 f.label "moderation_option_spam", t('spam', :scope => 'forem.posts.moderation'), :class => "label label-danger" 
 f.submit t('moderate', :scope => 'forem.posts.moderation'), :class => "btn btn-primary" 
 
 end 
 
 end 
 end 
 end 
 end 
 if post.user.is_a?(Forem::NilUser) 
 t(:deleted) 
 else 
 link_to_if Forem.user_profile_links, post.user.forem_name, [main_app, post.user] 
 end 
 forem_avatar(post.user, :size => 60) 
 post.id 
 post_time_tag(post) 
 forem_format(post.text) 
 if post.reply_to 
 link_to "#{t("forem.post.in_reply_to")} #{post.reply_to.user.forem_name}", "#post-#{post.reply_to.id}" 
 end 
 if forem_user 
 if can?(:reply, post.topic) 
 if post.topic.can_be_replied_to? 
 link_to t('reply', :scope => 'forem.topic'), forem.new_forum_topic_post_path(post.forum, post.topic, :reply_to_id => post.id), :class => "btn btn-primary" 
 link_to t('quote', :scope => 'forem.topic'), forem.new_forum_topic_post_path(post.forum, post.topic, :reply_to_id => post.id, :quote => true), :class => "btn btn-success" 
 end 
 end 
 if post.owner_or_admin?(forem_user) 
 if can?(:edit_post, post.topic.forum) 
 link_to t('edit', :scope => 'forem.post'), forem.edit_forum_topic_post_path(post.forum, post.topic, post), :class => "btn btn-info" 
 end 
 if can?(:destroy_post, post.topic.forum) 
 link_to t('delete', :scope => 'forem.topic'), forem.forum_topic_post_path(post.forum, post.topic, post), :method => :delete, data: { :confirm => t("are_you_sure") }, :class => "btn btn-danger" 
 end 
 end 
 end 
 
 end 
 end 
 t('topics_count', :count => @topics.count, :scope => 'forem.forum') 
 @topics.limit(25).each_with_index do |topic, topic_counter| 
 topic_counter + 1 
 cycle('odd', 'even', name: 'topics') 
 link_to forem_emojify(topic.subject),
                    forem.forum_topic_path(forum, topic) 
 end 

end

    end

    def posts
      Forem::Post.moderate!(params[:posts] || [])
      flash[:notice] = t('forem.posts.moderation.success')
      redirect_to :back
    end

    def topic
      if params[:topic]
        topic = forum.topics.friendly.find(params[:topic_id])
        topic.moderate!(params[:topic][:moderation_option])
        flash[:notice] = t("forem.topic.moderation.success")
      else
        flash[:error] = t("forem.topic.moderation.no_option_selected")
      end
      redirect_to :back
    end

    private

    def forum
      @forum = Forem::Forum.friendly.find(params[:forum_id])
    end

    helper_method :forum

    def ensure_moderator_or_admin
      unless forem_admin? || forum.moderator?(forem_user)
        raise CanCan::AccessDenied
      end
    end

  end
end

class StoriesController < ApplicationController
  before_filter :require_logged_in_user_or_400,
    :only => [ :upvote, :downvote, :unvote, :hide, :unhide, :preview ]

  before_filter :require_logged_in_user, :only => [ :destroy, :create, :edit,
    :fetch_url_title, :new ]

  before_filter :find_user_story, :only => [ :destroy, :edit, :undelete,
    :update ]

  def create
    @title = "Submit Story"
    @cur_url = "/stories/new"

    @story = Story.new(story_params)
    @story.user_id = @user.id

    if @story.valid? && !(@story.already_posted_story && !@story.seen_previous)
      if @story.save
        Countinual.count!("#{Rails.application.shortname}.stories.submitted",
          "+1")

        return redirect_to @story.comments_path
      end
    end

    ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 form_for @story do |f| 
 render :partial => "stories/form", :locals => { :story => @story,
        :f => f } 
 submit_tag "Submit" 
 render :partial => "global/markdownhelp",
            :locals => { :allow_images => true } 
 end 
 if @story.previewing && @story.valid? 
 render :template => "stories/show" 
 end 
 if @story.previewing 
 else 
 end 

end
  end

  def destroy
    if !@story.is_editable_by_user?(@user)
      flash[:error] = "You cannot edit that story."
      return redirect_to "/"
    end

    @story.is_expired = true
    @story.editor = @user

    if params[:reason].present? && @story.user_id != @user.id
      @story.moderation_reason = params[:reason]
    end

    @story.save(:validate => false)

    redirect_to @story.comments_path
  end

  def edit
    if !@story.is_editable_by_user?(@user)
      flash[:error] = "You cannot edit that story."
      return redirect_to "/"
    end

    @title = "Edit Story"

    if @story.merged_into_story
      @story.merge_story_short_id = @story.merged_into_story.short_id
    end
  end

  def fetch_url_attributes
    s = Story.new
    s.fetching_ip = request.remote_ip
    s.url = params[:fetch_url]

    oattrs = { :url => params[:fetch_url], :title => nil }

    if (title = s.fetched_title).present?
      oattrs[:title] = title
    end

    if (cu = s.fetched_canonical_url).present?
      oattrs[:url] = cu
    end

    return render :json => oattrs
  end

  def new
    @title = "Submit Story"
    @cur_url = "/stories/new"

    @story = Story.new
    @story.fetching_ip = request.remote_ip

    if params[:url].present?
      @story.url = params[:url]

      if (cu = @story.fetched_canonical_url).present? && @story.url != cu
        flash.now[:notice] = "Note: URL has been changed to fetched " <<
          "canonicalized version"
        @story.url = cu
      end

      if s = Story.find_similar_by_url(@story.url)
        if s.is_recent?
          # user won't be able to submit this story as new, so just redirect
          # them to the previous story
          flash[:success] = "This URL has already been submitted recently."
          return redirect_to s.comments_path
        else
          # user will see a warning like with preview screen
          @story.already_posted_story = s
        end
      end

      # ignore what the user brought unless we need it as a fallback
      @story.title = @story.fetched_title
      if !@story.title.present? && params[:title].present?
        @story.title = params[:title]
      end
    end
  end

  def preview
    @story = Story.new(story_params)
    @story.user_id = @user.id
    @story.previewing = true

    @story.vote = Vote.new(:vote => 1)
    @story.upvotes = 1

    @story.valid?

    @story.seen_previous = true

    ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 form_for @story do |f| 
 render :partial => "stories/form", :locals => { :story => @story,
        :f => f } 
 submit_tag "Submit" 
 render :partial => "global/markdownhelp",
            :locals => { :allow_images => true } 
 end 
 if @story.previewing && @story.valid? 
 render :template => "stories/show" 
 end 
 if @story.previewing 
 else 
 end 

end
  end

  def show
    @story = Story.where(:short_id => params[:id]).first!

    if @story.merged_into_story
      flash[:success] = "\"#{@story.title}\" has been merged into this story."
      return redirect_to @story.merged_into_story.comments_path
    end

    if @story.can_be_seen_by_user?(@user)
      @title = @story.title
    else
      @title = "[Story removed]"
    end

    @short_url = @story.short_id_url

    @comments = @story.merged_comments.includes(:user, :story,
      :hat).arrange_for_user(@user)

    if params[:comment_short_id]
      @comments.each do |c,x|
        if c.short_id == params[:comment_short_id]
          c.highlighted = true
          break
        end
      end
    end

    respond_to do |format|
      format.html {
        @comment = @story.comments.build

        load_user_votes

        ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 render :partial => "stories/listdetail",
    :locals => { :story => @story, :single_story => true } 
 if @story.markeddown_description.present? 
 raw @story.markeddown_description 
 end 
 if @story.is_unavailable && @story.story_cache.present? 

    time_ago_in_words_label(@story.unavailable_at) 
 simple_format(@story.story_cache) 
 end 
 if !@story.previewing 
 if !@story.is_gone? && !@story.previewing 
 render "comments/commentbox", :comment => @comment 
 end 
 comments_by_parent = @comments.group_by(&:parent_comment_id) 
 subtree = comments_by_parent[nil] 
 ancestors = [] 
 while subtree 
 if (comment = subtree.shift) 
 render "comments/comment", :comment => comment,
          :show_story => (comment.story_id != @story.id),
          :was_merged => (comment.story_id != @story.id) 
 if (children = comments_by_parent[comment.id]) 
 ancestors << subtree 
 subtree = children 
 else 
 end 
 elsif (subtree = ancestors.pop) 
 end 
 end 
 end 

end
      }
      format.json {
        render :json => @story.as_json(:with_comments => @comments)
      }
    end
  end

  def undelete
    if !(@story.is_editable_by_user?(@user) &&
    @story.is_undeletable_by_user?(@user))
      flash[:error] = "You cannot edit that story."
      return redirect_to "/"
    end

    @story.is_expired = false
    @story.editor = @user
    @story.save(:validate => false)

    redirect_to @story.comments_path
  end

  def update
    if !@story.is_editable_by_user?(@user)
      flash[:error] = "You cannot edit that story."
      return redirect_to "/"
    end

    @story.is_expired = false
    @story.editor = @user

    if @story.url_is_editable_by_user?(@user)
      @story.attributes = story_params
    else
      @story.attributes = story_params.except(:url)
    end

    if @story.save
      return redirect_to @story.comments_path
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 form_for @story, :url => story_path(@story.short_id),
  :method => :put, :html => { :id => "edit_story" } do |f| 
 render :partial => "stories/form", :locals => { :story => @story,
      :f => f } 
 if @user.is_moderator? 
 f.label :merge_story_short_id, "Merge Into:",
            :class => "required" 
 f.text_field :merge_story_short_id, :autocomplete => "off",
            :placeholder => "Short id of story into which this story " <<
            "be merged" 
 f.label :unavailable_at, "Unavailable:",
            :class => "required" 
 f.check_box :is_unavailable 
 f.label :unavailable_at, "Source URL is unavailable, " <<
            "enable display of cached text", :class => "normal" 
 if @story.user_id != @user.id 
 f.label :moderation_reason, "Mod Reason:",
              :class => "required" 
 f.text_field :moderation_reason, :autocomplete => "off" 
 end 
 end 
 submit_tag "Save" 
 story_path(@story.short_id) 
 render :partial => "global/markdownhelp",
          :locals => { :allow_images => true } 
 end 

end
    end
  end

  def unvote
    if !(story = find_story)
      return render :text => "can't find story", :status => 400
    end

    Vote.vote_thusly_on_story_or_comment_for_user_because(0, story.id,
      nil, @user.id, nil)

    render :text => "ok"
  end

  def upvote
    if !(story = find_story)
      return render :text => "can't find story", :status => 400
    end

    Vote.vote_thusly_on_story_or_comment_for_user_because(1, story.id,
      nil, @user.id, nil)

    render :text => "ok"
  end

  def downvote
    if !(story = find_story)
      return render :text => "can't find story", :status => 400
    end

    if !Vote::STORY_REASONS[params[:reason]]
      return render :text => "invalid reason", :status => 400
    end

    if !@user.can_downvote?(story)
      return render :text => "not permitted to downvote", :status => 400
    end

    Vote.vote_thusly_on_story_or_comment_for_user_because(-1, story.id,
      nil, @user.id, params[:reason])

    render :text => "ok"
  end

  def hide
    if !(story = find_story)
      return render :text => "can't find story", :status => 400
    end

    HiddenStory.hide_story_for_user(story.id, @user.id)

    render :text => "ok"
  end

  def unhide
    if !(story = find_story)
      return render :text => "can't find story", :status => 400
    end

    HiddenStory.where(:user_id => @user.id, :story_id => story.id).delete_all

    render :text => "ok"
  end

private

  def story_params
    p = params.require(:story).permit(
      :title, :url, :description, :moderation_reason, :seen_previous,
      :merge_story_short_id, :is_unavailable, :user_is_author, :tags_a => [],
    )

    if @user.is_moderator?
      p
    else
      p.except(:moderation_reason, :merge_story_short_id, :is_unavailable)
    end
  end

  def find_story
    story = Story.where(:short_id => params[:story_id]).first
    if @user && story
      story.vote = Vote.where(:user_id => @user.id,
        :story_id => story.id, :comment_id => nil).first.try(:vote)
    end

    story
  end

  def find_user_story
    if @user.is_moderator?
      @story = Story.where(:short_id => params[:story_id] || params[:id]).first
    else
      @story = Story.where(:user_id => @user.id, :short_id =>
        (params[:story_id] || params[:id])).first
    end

    if !@story
      flash[:error] = "Could not find story or you are not authorized " <<
        "to manage it."
      redirect_to "/"
      return false
    end
  end

  def load_user_votes
    if @user
      if v = Vote.where(:user_id => @user.id, :story_id => @story.id,
      :comment_id => nil).first
        @story.vote = { :vote => v.vote, :reason => v.reason }
      end

      @story.is_hidden_by_cur_user = @story.is_hidden_by_user?(@user)

      @votes = Vote.comment_votes_by_user_for_story_hash(@user.id, @story.id)
      @comments.each do |c|
        if @votes[c.id]
          c.current_vote = @votes[c.id]
        end
      end
    end
  end
end

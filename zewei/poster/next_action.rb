class CommentsController < ApplicationController
  def index
    @comments = Comment.where(
      :is_deleted => false, :is_moderated => false
    ).includes(
      :user, :story
    )
  end
  def threads
    comments = Comment.where(
      :thread_id => thread_ids
    ).includes(
      :user, :story
    )
  end
end



class HomeController < ApplicationController
  def tagged
    user = User.where(:session_token => session[:u].to_s).first
    @tag = Tag.where(:tag => params[:tag]).first!
    @stories = Story.where(
      :tag => @tag
    )
    @stories.each do |story|
      story.vote
    end
  end
end
class StoriesController < ApplicationController
  def show
    user = User.where(:session_token => session[:u].to_s).first
    @story = Story.where(:short_id => params[:id]).first!
    @story.vote
  end
end


class HomeController < ApplicationController
  def newest_by_user
    story.merged_stories.each do |ms|
      ms.url_or_comments_path
      ms.sorted_taggings.each do |tagging|
        tagging.tag.css_class
        tagging.tag.description
        tagging.tag.tag
      end
    end
  end
end
class StoriesController < ApplicationController
  def edit
    if @story.merged_into_story
      @story.merge_story_short_id = 
        @story.merged_into_story.short_id
      story_path(@story.short_id)
    end
  end
end

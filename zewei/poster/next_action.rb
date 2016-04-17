class HomeController < ApplicationController
  def hidden
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

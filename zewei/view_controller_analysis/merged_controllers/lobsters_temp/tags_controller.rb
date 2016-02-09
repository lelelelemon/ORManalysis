class TagsController < ApplicationController
  def index
    @cur_url = "/tags"
    @title = "Tags"

    @tags = Tag.all_with_story_counts_for(nil)

    respond_to do |format|
      format.html {  max_size = @tags.map{|t| t.stories_count }.max 
 @tags.each do |tag| 
 mod = (max_size.to_f / tag.stories_count.to_f) 
 link_to tag.tag, tag_path(tag), :class => tag.css_class,
      :style => "text-decoration: none; vertical-align: middle; " <<
      "font-size: #{((52 / (mod + 1)) + 8).ceil}pt; line-height: 1.5em;" 
 end 
 }
      format.json { render :json => @tags }
    end
 max_size = @tags.map{|t| t.stories_count }.max 
 @tags.each do |tag| 
 mod = (max_size.to_f / tag.stories_count.to_f) 
 link_to tag.tag, tag_path(tag), :class => tag.css_class,
      :style => "text-decoration: none; vertical-align: middle; " <<
      "font-size: #{((52 / (mod + 1)) + 8).ceil}pt; line-height: 1.5em;" 
 end 

  end
end

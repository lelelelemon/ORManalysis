class TagsController < ApplicationController

  def show
    @tag = params[:id] =~ /^\d+$/ ? Tag.find(params[:id]) : Tag.find_by!(name: params[:id])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :header do 
 breadcrumbs 
 t('tags.tag') 
 @tag.name 
 end 
 if @tag.verses.any? 
 t('verses.heading') 
 @tag.verses.with_people_count.each do |verse| 
  link_to verse.reference, verse, class: 'verse-reference' 
 if not @person and verse.people_count > 0 
 t('verses.saved_by_count', count: verse.people_count) 
 end 
 verse.text 
 unless @person 
  if (count = object.comments.count) > 0 
 names = object.comments.map { |c| link_to(c.person.try(:name) ) }.uniq 
 link_to icon('fa fa-comment-o'), object 
 if names.length > 3 
 t('verses.comment_count.many', count: count, by: names[0..2].join(', '), extra_count: names[3..-1].size, url: url_for(object)).html_safe 
 elsif names.length > 1 
 t('verses.comment_count.few', count: count, by: names.to_sentence, url: url_for(object)).html_safe 
 elsif names.length == 1 
 t('verses.comment_count.one', by: names.first, url: url_for(object)).html_safe 
 end 
 end 
 
 end 
 
 end 
 end 

end

  end

end

class VersesController < ApplicationController

  def index
    if params[:person_id]
      @person = Person.find(params[:person_id])
      if @logged_in.can_read?(@person)
        @verses = @person.verses.paginate(order: 'created_at desc', page: params[:page])
      else
        render text: t('not_authorized'), layout: true, status: 401
      end
      @tags = Verse.tag_counts(conditions: ['verses.id in (?)', @verses.map(&:id) || [0]], order: 'name')
    else
      @verses = Verse.order(:book, :chapter, :verse).with_people_count.page(params[:page])
      @tags = Verse.tag_counts(order: 'name')
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('verses.heading') 
 t('verses.intro', community: Setting.get(:name, :community)) 
  form_tag(search_verses_path, {method: "get", id: 'search_verse_form'}) do |form| 
 label_tag :q, t('verses.add_your_favorite_verse') 
 text_field_tag :q, nil, placeholder: t('verses.example_verse'), class: 'form-control' 
 button_tag value: "submit", class: 'btn btn-info' do 
 icon 'fa fa-search' 
 t('verses.search_verse') 
 end 
 end 
 t('verses.search.error') 
 
 t('tags.tags') 
 t('verses.about_tags') 
 tag_cloud @tags, %w(size1 size2 size3 size4) do |tag, css_class| 
 link_to tag.name, tag, class: css_class 
 end 
 if @tags.empty? 
 t('tags.no_tags_yet') 
 end 
 if @verses.any? 
 render partial: @verses 
 else 
 t('verses.no_verses_yet') 
 end 
 pagination @verses 

end

  end

  def show
    get_verse
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = @verse.reference 
 content_for :sub_title, "(#{@verse.translation})" 
 small_verse?(@verse) ? 'big' : '' 
 @verse.text 
 if @verse.translation == 'WEB' 
 t('verses.disclaimer') 
 end 
 t('Comments') 
  if object.comments.any? 
 object.comments.each do |comment| 
 link_to comment.person do 
 avatar_tag comment.person 
 end 
 link_to comment.person.name, comment.person 
 comment.created_at.to_s(:full) 
 if @logged_in.can_update?(comment) 
 link_to comment_path(comment), class: 'btn btn-xs bg-gray text-red', method: 'delete', data: { confirm: t('are_you_sure') } do 
 icon 'fa fa-trash-o' 
 end 
 end 
 preserve_breaks comment.text 
 end 
 else 
 t('comments.none_yet') 
 end 
 t('comments.add_a_comment') 
 form_for Comment.new, html: {style: 'border:none;'} do |form| 
 hidden_field_tag 'comment[commentable_type]', object.class 
 hidden_field_tag 'comment[commentable_id]', object.id 
 hidden_field_tag :return_to, request.fullpath 
 text_area_tag 'comment[text]', '', rows: 3, cols: 40, id: 'new_comment_textarea', class: 'form-control' 
 form.submit t('comments.save'), class: 'btn btn-success' 
 end 
 
 if @verse.people.any? 
 t('verses.people_who_like_this_verse') 
 end 
 if @verse.people.any? 
 @verse.people.each do |person| 
 link_to avatar_tag(person), person 
 link_to person.name, person 
 end 
 end 
 if @logged_in.verses.include? @verse 
 link_to @verse, method: 'delete', data: { confirm: t('are_you_sure') }, class: 'btn bg-gray text-red' do 
 icon 'fa fa-minus-circle' 
 t('verses.remove_this_verse') 
 end 
 else 
 link_to verses_path(id: @verse), method: 'post', class: 'btn btn-success' do 
 icon 'fa fa-plus-circle' 
 t('verses.add_this_verse_to_my_list') 
 end 
 end 
 t('tags.tags') 
 t('verses.about_tags') 
  controller ||= object.class.name.pluralize.downcase 
 object.id 
 if object.tags.any? 
 object.tags.each do |tag| 
 link_to tag.name, tag 
 if params[:controller] == controller 
 if controller == 'verses' 
 url = verse_path(id: object, remove_tag: tag.name) 
 end 
 link_to url, title: t('delete'), class: 'delete', method: 'put', data: { remote: true, confirm: t('tags.confirm_delete') } do 
 icon 'fa fa-times' 
 end 
 end 
 end 
 else 
 t('tags.no_tags_yet') 
 end 
 
 form_tag(@verse, method: 'put', data: { remote: true }) do 
 t('tags.add_tags') 
 text_field_tag :add_tags, nil, class: 'form-control' 
 end 

end

  end

  def search
    @verse = Verse.find(params[:q])
    if @verse.invalid?
      render text: t('verses.not_found'), layout: true, status: 400
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @verse.reference 
 @verse.text 
 form_for Verse.new do |form| 
 hidden_field_tag :id, @verse.id 
 button_tag value: "submit", class: 'btn btn-success' do 
 icon 'fa fa-plus' 
 t('verses.add_verse') 
 end 
 end 

end

    end
  rescue ActiveRecord::RecordNotFound
    render text: t('verses.not_found'), layout: true, status: 404
  end

  def create
    if get_verse
      unless @verse.people.include?(@logged_in)
        @verse.people << @logged_in
        @verse.create_as_stream_item(@logged_in)
      end
      redirect_to @verse
    end
  end

  def update
    @verse = Verse.find(params[:id])
    @verse.tag_list.remove(params[:remove_tag]) if params[:remove_tag]
    if params[:add_tags]
      add = params[:add_tags].split(/\s*,\s*|\s+/).map(&:downcase) - @verse.tag_list.map(&:downcase)
      @verse.tag_list.add(*add)
    end
    @verse.save
    respond_to do |format|
      format.html { redirect_to @verse }
      format.js
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @verse.id 
 escape_javascript  controller ||= object.class.name.pluralize.downcase 
 object.id 
 if object.tags.any? 
 object.tags.each do |tag| 
 link_to tag.name, tag 
 if params[:controller] == controller 
 if controller == 'verses' 
 url = verse_path(id: object, remove_tag: tag.name) 
 end 
 link_to url, title: t('delete'), class: 'delete', method: 'put', data: { remote: true, confirm: t('tags.confirm_delete') } do 
 icon 'fa fa-times' 
 end 
 end 
 end 
 else 
 t('tags.no_tags_yet') 
 end 
 

end

  end

  def destroy
    @verse = Verse.find(params[:id])
    @verse.people.delete @logged_in
    @verse.delete_stream_items(@logged_in)
    expire_fragment(%r{views/people/#{@logged_in.id}_})
    unless @verse.people.count == 0
      redirect_to @verse
    else
      @verse.destroy
      redirect_to verses_path
    end
  end

  private

  def get_verse
    @verse = Verse.find(params[:id])
    if @verse.try(:valid?)
      if params[:id] !~ /^\d+$/ and @verse.reference != params[:id]
        redirect_to verse_path(@verse.reference)
        return false
      end
      true
    elsif @verse and @verse.errors.any?
      add_errors_to_flash(@verse)
      redirect_to verses_path
      false
    else
      raise 'verse not found'
    end
  rescue
      render text: t('verses.not_found'), layout: true, status: 404
      false
  end

end

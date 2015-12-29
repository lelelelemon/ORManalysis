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
  end

  def show
    get_verse
 @title = @verse.reference 
 content_for :sub_title, "(#{@verse.translation})" 
 small_verse?(@verse) ? 'big' : '' 
 @verse.text 
 if @verse.translation == 'WEB' 
 t('verses.disclaimer') 
 end 
 t('Comments') 
 render partial: 'comments/comments', locals: {object: @verse, intro: t('verses.about_this_verse')} 
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
 render partial: 'tags/tags_with_delete', locals: {object: @verse} 
 form_tag(@verse, method: 'put', data: { remote: true }) do 
 t('tags.add_tags') 
 text_field_tag :add_tags, nil, class: 'form-control' 
 end 

  end

  def search
    @verse = Verse.find(params[:q])
    if @verse.invalid?
      render text: t('verses.not_found'), layout: true, status: 400
    else
      render partial: 'search_result'
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

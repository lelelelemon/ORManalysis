class StreamsController < ApplicationController
  skip_before_filter :authenticate_user, only: %w(show)
  before_filter :authenticate_user_with_code_or_session, only: %w(show)

  include TimelineHelper

  def show
    unless @logged_in.active?
      redirect_to(@logged_in)
      return
    end
    if params[:stream_item_group_id]
      @stream_group = StreamItem.where(streamable_type: 'StreamItemGroup').find(params[:stream_item_group_id])
      @stream_items = @stream_group.items
    elsif params[:group_id]
      @group = Group.find(params[:group_id])
      @stream_items = @logged_in.can_read?(@group) ? @group.stream_items : @group.stream_items.none
    else
      @stream_items = StreamItem.shared_with(@logged_in)
      @stream_items.where!(person_id: params[:person_id]) if params[:person_id]
    end
    @count = @stream_items.count
    @stream_items = @stream_items.paginate(page: params[:timeline_page], per_page: params[:per_page] || 5)
    record_last_seen_stream_item
    respond_to do |format|
      format.html
      format.xml { render layout: false }
      format.json do
        render json: {
          html: html_for_json,
          items: @stream_items,
          count: @count,
          next: timeline_has_more?(@stream_items) ? next_timeline_url(@stream_items.current_page + 1) : nil
        }
      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :meta do 
 stream_url(format: :xml, code: @logged_in.feed_code) 
 t('stream.feed') 
 end 
 @title = t('stream.title') 
 content_for :sub_title, t('stream.sub_title') 
 timeline(@stream_items) 
 if @logged_in.pending_friendship_requests.any? 
 icon 'fa fa-star' 
 t('friends.you_have_pending_requests') 
 link_to t('friends.friends_list_button'), person_friends_path(@logged_in), class: 'btn' 
 end 
 if setting(:features, [:pictures, :verses]) 
 t('stream.share.heading.friends') 
 if setting(:features, :friends) and setting(:features, :groups) 
 t('stream.share.intro.friends_and_group_members') 
 elsif setting(:features, :friends) 
 t('stream.share.intro.friends_only') 
 elsif setting(:features, :groups) 
 t('stream.share.intro.group_members_only') 
 end 
 if setting(:features, :pictures) 
 link_to new_picture_path, class: 'btn bg-orange' do 
 t('stream.share.button.picture') 
 end 
 end 
 if setting(:features, :verses) 
 link_to new_verse_path, class: 'btn bg-green' do 
 t('stream.share.button.verse') 
 end 
 end 
 if setting(:features, :groups) 
 link_to groups_path, class: 'btn bg-teal' do 
 t('stream.share.button.message') 
 end 
 if @logged_in.groups.active.any? 
 @logged_in.groups.active.order('name').each do |group| 
 next unless group.can_post?(@logged_in) 
 link_to group.name, new_group_message_path(group) 
 end 
 end 
 end 
 t('stream.share.sharing_with_html', count: @logged_in.sharing_with_people.count, url: stream_people_path) 
 end 
 if can_post_news? 
 t('stream.share.heading.everyone') 
 t('stream.share.intro.everyone') 
 link_to new_news_item_path, class: 'btn bg-red' do 
 t('stream.share.button.news') 
 end 
 t('stream.share.sharing_with_html', count: Person.can_sign_in.adults_or_have_consent.count, url: new_search_path) 
 end 

end

  end

  private

  def html_for_json
    if @stream_group
      @stream_items.map { |si| si.decorate.to_html }.join
    else
      view_context.timeline(@stream_items)
    end
  end

  def record_last_seen_stream_item
    was = @logged_in.last_seen_stream_item
    @logged_in.record_last_seen_stream_item(@stream_items.first)
    @logged_in.last_seen_stream_item = was # so the "new" labels show in the view
  end
end

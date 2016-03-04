class FriendsController < ApplicationController

  before_filter :person_must_be_user, except: %w(index)

  def index
    @person = Person.find(params[:person_id])
    if @logged_in.can_read?(@person)
      @pending = me? ? @person.pending_friendship_requests : []
      @friendships = @person.friendships.to_a.select { |f| f.friend and @logged_in.can_read?(f.friend) }
    else
      render text: t('people.not_found'), layout: true, status: 404
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('friends.personal_friends', name: @person.name) 
 if @pending.any? 
 icon 'fa fa-clock-o' 
 t('friends.pending_requests') 
 t('friends.people_requested') 
 @pending.each do |friendship_request| 
 link_to friendship_request.from do 
 avatar_tag(friendship_request.from) 
 friendship_request.from.name 
 end 
 link_to person_friend_path(@logged_in, friendship_request, accept: true), method: 'put', class: 'btn btn-success' do 
 icon 'fa fa-plus-circle' 
 t('friends.accept') 
 end 
 link_to person_friend_path(@logged_in, friendship_request, reject: true), method: 'put', data: { confirm: t('are_you_sure') }, class: 'btn bg-gray text-red' do 
 icon 'fa fa-minus-circle' 
 t('friends.decline') 
 end 
 end 
 end 
 t('friends.friends') 
 if @friendships.any? 
 @friendships.each do |friendship| 
 friendship.id 
 link_to friendship.friend do 
 avatar_tag friendship.friend 
 end 
 link_to friendship.friend.name, friendship.friend 
 if me? 
 link_to person_friend_path(@person, friendship.friend), class: 'btn bg-gray text-red pull-right', method: 'delete', data: { confirm: t('are_you_sure') } do 
 icon 'fa fa-minus-circle' 
 t('friends.remove_from_friends') 
 end 
 end 
 end 
 javascript_include_tag 'dragdrop.js' 
 else 
 t('.nobody_yet') 
 end 
 if me? 
 link_to search_path, class: 'btn btn-info' do 
 icon 'fa fa-search' 
 t('friends.search_in_the_directory') 
 end 
 end 

end

  end

  # friend_id = Person (other person)
  def create
    @person = Person.find(params[:person_id])
    @other_person = Person.find(params[:friend_id])
    @message = @person.request_friendship_with(@other_person)
    respond_to do |wants|
      wants.html
      wants.js
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @other_person.id 
 escape_javascript @message 

end

  end

  # id = FriendshipRequest
  def update
    @person = Person.find(params[:person_id])
    @friendship_request = @person.friendship_requests.find(params[:id])
    if params[:accept]
      @friendship_request.accept
      flash[:notice] = t('people.friendship_accepted')
      redirect_to person_friends_path(@person)
    elsif params[:reject]
      @friendship_request.reject
      flash[:notice] = t('people.friendship_rejected')
      redirect_to person_friends_path(@person)
    else
      render text: t('people.friendship_must_specify'), layout: true, status: 500
    end
  end

  # id = Person (friend)
  def destroy
    @person = Person.find(params[:person_id])
    if @friendship = @person.friendships.where(friend_id: params[:id]).first
      @friendship.destroy
      redirect_to person_friends_path(@person)
    else
      render text: t('people.friend_not_found'), layout: true, status: 404
    end
  end

  def reorder
    @person = Person.find(params[:person_id])
    params[:friends].each_with_index do |id, index|
      if f = @person.friendships.where(id: id).first
        f.update_attribute :ordering, index
      end
    end
    render nothing: true
  end

  private

    def person_must_be_user
      unless @logged_in.id == params[:person_id].to_i
        render text: t('people.friendship_manage'), layout: true, status: 401
        return false
      end
    end

end

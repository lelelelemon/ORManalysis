class FollowersController < ApplicationController

  before_filter do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_view_this_content")
  end

  def create
    @person = Person.find(params[:person_id] || params[:id])
    PersonViewUtils.ensure_person_belongs_to_community!(@person, @current_community)

    @person.followers << @current_user
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @current_user.follows?(person) 
 link_to person_follower_path(person, @current_user), :method => "delete", :remote => true, :class => "follow-button unfollow button-hoverable" do 
 t(".unfollow") 
 t(".following") 
 end 
 else 
 link_to [ person, :followers ], :method => "post", :remote => true, :class => "follow-button" do 
 t(".follow") 
 end 
 end 

end
 }
    end
  end

  def destroy
    @person = Person.find(params[:person_id] || params[:id])
    PersonViewUtils.ensure_person_belongs_to_community!(@person, @current_community)

    @person.followers.delete(@current_user)
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @current_user.follows?(person) 
 link_to person_follower_path(person, @current_user), :method => "delete", :remote => true, :class => "follow-button unfollow button-hoverable" do 
 t(".unfollow") 
 t(".following") 
 end 
 else 
 link_to [ person, :followers ], :method => "post", :remote => true, :class => "follow-button" do 
 t(".follow") 
 end 
 end 

end
 }
    end
  end

end


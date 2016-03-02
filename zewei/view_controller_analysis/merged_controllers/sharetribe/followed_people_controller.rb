class FollowedPeopleController < ApplicationController

  def index
    @person = Person.find(params[:person_id] || params[:id])
    PersonViewUtils.ensure_person_belongs_to_community!(@person, @current_community)

    @followed_people = @person.followed_people
    respond_to do |format|
      format.js { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 link_to person, :class => "fluid-thumbnail-grid-image-item-link" do 
 large_avatar_thumb(person, :class => "fluid-thumbnail-grid-image-image") 
 person.name(@current_community) 
 end 
 if @current_user 
 if current_user?(person) 
  person_settings_path(@current_user) 
 t("people.show.edit_profile_info") 
 
 else 
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
 end 

end
 }
    end
  end

  # Add or remove followed people from FollowersController

end


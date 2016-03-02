class StreamPeopleController < ApplicationController

  def index
    @people = @logged_in \
      .sharing_with_people \
      .minimal.select(:family_id) \
      .order(:first_name, :last_name) \
      .page(params[:page])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('stream.people.heading') 
 if @people.any? 
 t('stream.people.intro') 
 t('stream.people.column.name') 
 t('stream.people.column.family_name') 
 t('stream.people.column.reason') 
 @people.each do |person| 
 avatar_tag(person) 
 link_to person.name, person 
 link_to person.family.name, person.family 
 (reason, detail) = @logged_in.reason_sharing_with(person).first 
 if reason == :family 
 t('stream.people.reason.family_html', url: family_path(@logged_in.family_id)) 
 elsif reason == :friend 
 t('stream.people.reason.friend_html', url: person_friends_path(@logged_in)) 
 elsif reason == :groups 
 t('stream.people.reason.groups_html', count: detail.length, groups: detail.map { |g| link_to(g.name, g) }.join(', ').html_safe) 
 end 
 end 
 pagination @people 
 else 
 t('stream.people.intro_none') 
 end 

end

  end

end

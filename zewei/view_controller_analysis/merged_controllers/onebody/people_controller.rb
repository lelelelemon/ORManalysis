class PeopleController < ApplicationController
  def index
    respond_to do |format|
      format.html { redirect_to person_path(@logged_in) }
      if can_export?
        format.xml do
          job = ExportJob.perform_later(Site.current, 'people', 'xml', @logged_in.id)
          redirect_to generated_file_path(job.job_id)
        end
        format.csv do
          job = ExportJob.perform_later(Site.current, 'people', 'csv', @logged_in.id)
          redirect_to generated_file_path(job.job_id)
        end
      end
    end
  end

  def show
    if params[:id].to_i == session[:logged_in_id]
      @person = @logged_in
    elsif params[:legacy_id]
      @person = Person.where(legacy_id: params[:id]).includes(:family).first
    else
      @person = Person.where(id: params[:id]).includes(:family).first
    end
    if params[:limited] || !@logged_in.active?
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = @person.name 
 t('people.limited_access') 
 if @person.home_phone.present? 
 ":" 
 format_phone @person.home_phone 
 end 
 if not me? and @person.messages_enabled? 
 link_to new_message_path(to_person_id: @person), class: 'btn btn-info' do 
 icon 'fa fa-envelope' 
 t('messages.send_message') 
 end 
 end 
 t('people.groups.heading') 
  

end

    elsif @person and @logged_in.can_read?(@person)
      @family = @person.family
      if @person == @logged_in
        # TODO eager load family here
        @family_people = (@person.family.try(:people) || []).reject(&:deleted)
      else
        @family_people = @person.family.try(:visible_people) || []
      end
      @albums = @person.albums.order(created_at: :desc)
      @friends = @person.friends.minimal
      @verses = @person.verses.order(:book, :chapter, :verse)
      @groups = @person.groups.is_public.approved.limit(3).order("(select created_at from stream_items where group_id=groups.id order by created_at desc limit 1) desc")
      @stream_items = StreamItem.shared_with(@logged_in).where(person_id: @person.id).paginate(page: params[:timeline_page], per_page: 5)
      if params[:business] and @person.business_name.present?
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = @person.business_name.presence || @person.name 
 avatar_tag @person, size: :large 
 t('people.business.services_provided_by', person: link_to(@person.name, @person)).html_safe 
 format_text @person.business_description 
 if @person.business_phone.present? 
 t('people.business.phone') 
 format_phone @person.business_phone 
 end 
 if @person.business_email.present? 
 t('people.business.email') 
 mail_to @person.business_email 
 end 
 if @person.business_website.present? 
 t('people.business.website') 
 link_to simple_url(@person.business_website), safe_url(@person.business_website) 
 end 
 if @person.business_address.present? 
 t('people.business.address') 
 preserve_breaks @person.business_address 
 end 

end

      else
        respond_to do |format|
          format.html
          format.xml { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = person_title(@person) 
 if has_type?(@person) 
 content_for :sub_title do 
 link_to_person_role(@person, only_one: true) 
 end 
 end 
 if flash[:show_verification_link] 
 t('people.verification_email.heading') 
 t('people.verification_email.intro') 
  link_to account_path(verification: {email: @person.email}, via_admin: true), method: 'post', data: { confirm: t('are_you_sure') }, class: 'btn btn-warning' do 
 icon 'fa fa-envelope' 
 t('people.verification_email.button') 
 end 
 
 end 
 unless @person.visible? 
 icon 'fa fa-lock' 
 t('people.this_profile_is_hidden') 
 end 
 if !@family and @logged_in.admin?(:edit_profiles) 
 icon 'fa fa-user' 
 t('people.no_family_for_this_person') 
 end 
 if @person.updates.pending.any? and @logged_in.can_update?(@person) 
 icon 'fa fa-clock-o' 
 t('people.updates.pending_callout') 
 end 
 avatar_tag @person, size: 'large', class: 'img-full' 
 if @stream_items.any? 
  link_to avatar_tag(@family), @family 
 link_to t('people.show.details.family', family: @family.try(:name)), @family 
 show_attribute(:website) do 
 t('people.show.details.website') 
 link_to simple_url(@person.website), safe_url(@person.website) 
 end 
 show_attribute(:email) do 
 t('people.show.details.email') 
 showing_attribute_because_admin_icon(:email) 
 mail_to @person.email 
 end 
 show_attribute(:mobile_phone) do 
 t('people.show.details.mobile_phone') 
 showing_attribute_because_admin_icon(:mobile_phone) 
 link_to_phone @person.mobile_phone, mobile: true 
 end 
 show_attribute(:home_phone) do 
 t('people.show.details.home_phone') 
 showing_attribute_because_admin_icon(:home_phone) 
 link_to_phone @person.home_phone 
 end 
 show_attribute(:work_phone) do 
 t('people.show.details.work_phone') 
 showing_attribute_because_admin_icon(:work_phone) 
 link_to_phone @person.work_phone 
 end 
 show_attribute(:address) do 
 t('people.show.details.address') 
 showing_attribute_because_admin_icon(:address) 
 preserve_breaks @person.address 
 end 
 show_attribute(:birthday) do 
 t('people.show.details.birthday') 
 showing_attribute_because_admin_icon(:birthday) 
 @person.birthday.to_s(:date_without_year) 
 end 
 unless @person.child? 
 show_attribute(:anniversary) do 
 t('people.show.details.anniversary') 
 showing_attribute_because_admin_icon(:anniversary) 
 @person.anniversary.to_s(:date_without_year) 
 end 
 end 
 if has_social_networks?(@person) 
 t('people.show.details.social') 
 if @person.twitter.present? 
 link_to(twitter_url(@person), target: '_blank') do 
 icon 'fa fa-twitter' 
 @person.twitter 
 end 
 end 
 if @person.facebook_url.present? 
 link_to(@person.facebook_url, target: '_blank') do 
 icon 'fa fa-facebook' 
 simple_url(@person.facebook_url, www: false) 
 end 
 end 
 end 
 
 end 
 if (contact_controls =  unless me? 
 if setting(:features, :friends) 
  if setting(:features, :friends) 
 if @logged_in.can_request_friendship_with?(@person) 
 link_to person_friends_path(@logged_in, friend_id: @person), remote: true, method: :post, data: { confirm: t('friends.add_friend_are_you_sure'), 'pending-label' => t('friends.add_to_friends_pending') }, id: "add_friend_", class: 'btn btn-info add-friend' do 
 icon 'fa fa-smile-o' 
 t('friends.add_to_friends') 
 end 
 elsif @logged_in.friendship_waiting_on? @person 
 link_to person_friends_path(@logged_in, friend_id: @person), remote: true, method: :post, data: { confirm: t('friends.add_friend_are_you_sure') }, id: "add_friend_", class: 'btn btn-info add-friend disabled' do 
 icon 'fa fa-smile-o' 
 t('friends.add_to_friends_pending') 
 end 
 end 
 end 
 
 end 
 if @person.messages_enabled? 
 link_to new_message_path(to_person_id: @person), class: 'btn btn-info' do 
 icon 'fa fa-envelope' 
 t('messages.send_message') 
 end 
 end 
 end 
).present? 
 contact_controls 
 end 
 if @stream_items.any? 
 timeline(@stream_items) || timeline_none 
 else 
  link_to avatar_tag(@family), @family 
 link_to t('people.show.details.family', family: @family.try(:name)), @family 
 show_attribute(:website) do 
 t('people.show.details.website') 
 link_to simple_url(@person.website), safe_url(@person.website) 
 end 
 show_attribute(:email) do 
 t('people.show.details.email') 
 showing_attribute_because_admin_icon(:email) 
 mail_to @person.email 
 end 
 show_attribute(:mobile_phone) do 
 t('people.show.details.mobile_phone') 
 showing_attribute_because_admin_icon(:mobile_phone) 
 link_to_phone @person.mobile_phone, mobile: true 
 end 
 show_attribute(:home_phone) do 
 t('people.show.details.home_phone') 
 showing_attribute_because_admin_icon(:home_phone) 
 link_to_phone @person.home_phone 
 end 
 show_attribute(:work_phone) do 
 t('people.show.details.work_phone') 
 showing_attribute_because_admin_icon(:work_phone) 
 link_to_phone @person.work_phone 
 end 
 show_attribute(:address) do 
 t('people.show.details.address') 
 showing_attribute_because_admin_icon(:address) 
 preserve_breaks @person.address 
 end 
 show_attribute(:birthday) do 
 t('people.show.details.birthday') 
 showing_attribute_because_admin_icon(:birthday) 
 @person.birthday.to_s(:date_without_year) 
 end 
 unless @person.child? 
 show_attribute(:anniversary) do 
 t('people.show.details.anniversary') 
 showing_attribute_because_admin_icon(:anniversary) 
 @person.anniversary.to_s(:date_without_year) 
 end 
 end 
 if has_social_networks?(@person) 
 t('people.show.details.social') 
 if @person.twitter.present? 
 link_to(twitter_url(@person), target: '_blank') do 
 icon 'fa fa-twitter' 
 @person.twitter 
 end 
 end 
 if @person.facebook_url.present? 
 link_to(@person.facebook_url, target: '_blank') do 
 icon 'fa fa-facebook' 
 simple_url(@person.facebook_url, www: false) 
 end 
 end 
 end 
 
 end 
 if @person.testimony.present? 
 link_to testimony_person_path(@person) do 
 icon 'fa fa-comment-o' 
 t('people.testimony.box_heading') 
 end 
 icon 'fa fa-quote-left' 
 preserve_breaks(truncate_words(@person.testimony, length: 250)) 
 if @person.testimony.size > 250 
 link_to t('people.testimony.view_full'), testimony_person_path(@person), class: 'btn bg-gray btn-xs' 
 end 
 icon 'fa fa-quote-right' 
 link_to t('people.testimony.find_more'), search_path(testimony: true), class: 'btn bg-gray btn-xs' 
 end 
 if @person.albums.any? 
 @person.albums.order(id: :desc).limit(3).reverse.each do |album| 
 link_to album do 
 if album.cover 
 link_to image_tag(album.cover.photo.url(:tn), alt: t('pictures.click_to_enlarge'), class: 'picture thumbnail'),                album, title: t('pictures.click_to_enlarge') 
 else 
 image_tag 'picture.tn.jpg', class: 'picture thumbnail' 
 end 
 end 
 end 
 link_to person_albums_path(@person) do 
 icon 'fa fa-camera-retro' 
 end 
 end 
 if setting(:features, :groups) 
 @groups.each do |group| 
 group_box_class(group) 
 link_to group.name, group 
 t('people.groups.members') 
 group.memberships.count 
 t('people.groups.messages') 
 group.messages.count 
 end 
 if @groups.any? 
 link_to t('people.groups.see_all'), person_groups_path(@person) 
 end 
 if @groups.empty? and me? 
 link_to groups_path, class: 'btn btn-info' do 
 icon 'fa fa-search' 
 t('people.groups.join.button') 
 end 
 end 
 end 

end
 } if can_export?
        end
      end
    elsif @person and @person.deleted? and @logged_in.admin?(:edit_profiles)
      @deleted_people_url = administration_deleted_people_path('search[id]' => @person.id)
      render text: t('people.deleted_html', url: @deleted_people_url), status: 404, layout: true
    else
      render text: t('people.not_found'), status: 404, layout: true
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = person_title(@person) 
 if has_type?(@person) 
 content_for :sub_title do 
 link_to_person_role(@person, only_one: true) 
 end 
 end 
 if flash[:show_verification_link] 
 t('people.verification_email.heading') 
 t('people.verification_email.intro') 
  link_to account_path(verification: {email: @person.email}, via_admin: true), method: 'post', data: { confirm: t('are_you_sure') }, class: 'btn btn-warning' do 
 icon 'fa fa-envelope' 
 t('people.verification_email.button') 
 end 
 
 end 
 unless @person.visible? 
 icon 'fa fa-lock' 
 t('people.this_profile_is_hidden') 
 end 
 if !@family and @logged_in.admin?(:edit_profiles) 
 icon 'fa fa-user' 
 t('people.no_family_for_this_person') 
 end 
 if @person.updates.pending.any? and @logged_in.can_update?(@person) 
 icon 'fa fa-clock-o' 
 t('people.updates.pending_callout') 
 end 
 avatar_tag @person, size: 'large', class: 'img-full' 
 if @stream_items.any? 
  link_to avatar_tag(@family), @family 
 link_to t('people.show.details.family', family: @family.try(:name)), @family 
 show_attribute(:website) do 
 t('people.show.details.website') 
 link_to simple_url(@person.website), safe_url(@person.website) 
 end 
 show_attribute(:email) do 
 t('people.show.details.email') 
 showing_attribute_because_admin_icon(:email) 
 mail_to @person.email 
 end 
 show_attribute(:mobile_phone) do 
 t('people.show.details.mobile_phone') 
 showing_attribute_because_admin_icon(:mobile_phone) 
 link_to_phone @person.mobile_phone, mobile: true 
 end 
 show_attribute(:home_phone) do 
 t('people.show.details.home_phone') 
 showing_attribute_because_admin_icon(:home_phone) 
 link_to_phone @person.home_phone 
 end 
 show_attribute(:work_phone) do 
 t('people.show.details.work_phone') 
 showing_attribute_because_admin_icon(:work_phone) 
 link_to_phone @person.work_phone 
 end 
 show_attribute(:address) do 
 t('people.show.details.address') 
 showing_attribute_because_admin_icon(:address) 
 preserve_breaks @person.address 
 end 
 show_attribute(:birthday) do 
 t('people.show.details.birthday') 
 showing_attribute_because_admin_icon(:birthday) 
 @person.birthday.to_s(:date_without_year) 
 end 
 unless @person.child? 
 show_attribute(:anniversary) do 
 t('people.show.details.anniversary') 
 showing_attribute_because_admin_icon(:anniversary) 
 @person.anniversary.to_s(:date_without_year) 
 end 
 end 
 if has_social_networks?(@person) 
 t('people.show.details.social') 
 if @person.twitter.present? 
 link_to(twitter_url(@person), target: '_blank') do 
 icon 'fa fa-twitter' 
 @person.twitter 
 end 
 end 
 if @person.facebook_url.present? 
 link_to(@person.facebook_url, target: '_blank') do 
 icon 'fa fa-facebook' 
 simple_url(@person.facebook_url, www: false) 
 end 
 end 
 end 
 
 end 
 if (contact_controls =  unless me? 
 if setting(:features, :friends) 
  if setting(:features, :friends) 
 if @logged_in.can_request_friendship_with?(@person) 
 link_to person_friends_path(@logged_in, friend_id: @person), remote: true, method: :post, data: { confirm: t('friends.add_friend_are_you_sure'), 'pending-label' => t('friends.add_to_friends_pending') }, id: "add_friend_", class: 'btn btn-info add-friend' do 
 icon 'fa fa-smile-o' 
 t('friends.add_to_friends') 
 end 
 elsif @logged_in.friendship_waiting_on? @person 
 link_to person_friends_path(@logged_in, friend_id: @person), remote: true, method: :post, data: { confirm: t('friends.add_friend_are_you_sure') }, id: "add_friend_", class: 'btn btn-info add-friend disabled' do 
 icon 'fa fa-smile-o' 
 t('friends.add_to_friends_pending') 
 end 
 end 
 end 
 
 end 
 if @person.messages_enabled? 
 link_to new_message_path(to_person_id: @person), class: 'btn btn-info' do 
 icon 'fa fa-envelope' 
 t('messages.send_message') 
 end 
 end 
 end 
).present? 
 contact_controls 
 end 
 if @stream_items.any? 
 timeline(@stream_items) || timeline_none 
 else 
  link_to avatar_tag(@family), @family 
 link_to t('people.show.details.family', family: @family.try(:name)), @family 
 show_attribute(:website) do 
 t('people.show.details.website') 
 link_to simple_url(@person.website), safe_url(@person.website) 
 end 
 show_attribute(:email) do 
 t('people.show.details.email') 
 showing_attribute_because_admin_icon(:email) 
 mail_to @person.email 
 end 
 show_attribute(:mobile_phone) do 
 t('people.show.details.mobile_phone') 
 showing_attribute_because_admin_icon(:mobile_phone) 
 link_to_phone @person.mobile_phone, mobile: true 
 end 
 show_attribute(:home_phone) do 
 t('people.show.details.home_phone') 
 showing_attribute_because_admin_icon(:home_phone) 
 link_to_phone @person.home_phone 
 end 
 show_attribute(:work_phone) do 
 t('people.show.details.work_phone') 
 showing_attribute_because_admin_icon(:work_phone) 
 link_to_phone @person.work_phone 
 end 
 show_attribute(:address) do 
 t('people.show.details.address') 
 showing_attribute_because_admin_icon(:address) 
 preserve_breaks @person.address 
 end 
 show_attribute(:birthday) do 
 t('people.show.details.birthday') 
 showing_attribute_because_admin_icon(:birthday) 
 @person.birthday.to_s(:date_without_year) 
 end 
 unless @person.child? 
 show_attribute(:anniversary) do 
 t('people.show.details.anniversary') 
 showing_attribute_because_admin_icon(:anniversary) 
 @person.anniversary.to_s(:date_without_year) 
 end 
 end 
 if has_social_networks?(@person) 
 t('people.show.details.social') 
 if @person.twitter.present? 
 link_to(twitter_url(@person), target: '_blank') do 
 icon 'fa fa-twitter' 
 @person.twitter 
 end 
 end 
 if @person.facebook_url.present? 
 link_to(@person.facebook_url, target: '_blank') do 
 icon 'fa fa-facebook' 
 simple_url(@person.facebook_url, www: false) 
 end 
 end 
 end 
 
 end 
 if @person.testimony.present? 
 link_to testimony_person_path(@person) do 
 icon 'fa fa-comment-o' 
 t('people.testimony.box_heading') 
 end 
 icon 'fa fa-quote-left' 
 preserve_breaks(truncate_words(@person.testimony, length: 250)) 
 if @person.testimony.size > 250 
 link_to t('people.testimony.view_full'), testimony_person_path(@person), class: 'btn bg-gray btn-xs' 
 end 
 icon 'fa fa-quote-right' 
 link_to t('people.testimony.find_more'), search_path(testimony: true), class: 'btn bg-gray btn-xs' 
 end 
 if @person.albums.any? 
 @person.albums.order(id: :desc).limit(3).reverse.each do |album| 
 link_to album do 
 if album.cover 
 link_to image_tag(album.cover.photo.url(:tn), alt: t('pictures.click_to_enlarge'), class: 'picture thumbnail'),                album, title: t('pictures.click_to_enlarge') 
 else 
 image_tag 'picture.tn.jpg', class: 'picture thumbnail' 
 end 
 end 
 end 
 link_to person_albums_path(@person) do 
 icon 'fa fa-camera-retro' 
 end 
 end 
 if setting(:features, :groups) 
 @groups.each do |group| 
 group_box_class(group) 
 link_to group.name, group 
 t('people.groups.members') 
 group.memberships.count 
 t('people.groups.messages') 
 group.messages.count 
 end 
 if @groups.any? 
 link_to t('people.groups.see_all'), person_groups_path(@person) 
 end 
 if @groups.empty? and me? 
 link_to groups_path, class: 'btn btn-info' do 
 icon 'fa fa-search' 
 t('people.groups.join.button') 
 end 
 end 
 end 

end

  end

  def new
    if @logged_in.admin?(:edit_profiles)
      if params[:family_id]
        @family = Family.find(params[:family_id])
        @person = @family.people.new
      else
        @family = Family.new
        @person = Person.new(family: @family)
      end
      @person.status = :active
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @family.persisted? 
 @title = t('people.new.heading', family: link_to(@family.try(:name), @family)).html_safe 
 else 
 @title = t('people.new.heading_without_family') 
 end 
 error_messages_for(@person) 
  form_for @person, html: { multipart: true } do |form| 
 unless @family.persisted? 
 icon 'fa fa-warning' 
 t('people.new.no_family_warning_html') 
 end 
 t('privacies.please_read_our_privacy_policy_html', url: help_path('privacy_policy')) 
 link_to t('people.edit.basics'), '#basics', data: { toggle: 'tab' } 
 link_to t('people.edit.about'), '#about', data: { toggle: 'tab' } 
 if setting(:features, :business_directory) 
 link_to t('people.edit.business'), '#business', data: { toggle: 'tab' } 
 end 
 if @logged_in.admin?(:edit_profiles) 
 link_to t('people.edit.person_type'), '#roles', data: { toggle: 'tab' } 
 link_to t('people.edit.status'), '#status', data: { toggle: 'tab' } 
 end 
   if @logged_in.can_update?(@person) and @person.updates.pending.count > 0 
 t('people.update_to_profile_is') 
 if @logged_in.admin?(:edit_profiles) 
 link_to t('people.pending_approval'), administration_updates_path 
 else 
 t('people.pending_approval') 
 end 
 end 
 
 if Setting.get(:features, :updates_must_be_approved) and not @logged_in.admin?(:edit_profiles) 
 icon 'fa fa-check-square' 
 t('people.changes_must_be_reviewed_html') 
 end 
 form.label :first_name 
 form.text_field :first_name, size: 15, class: 'form-control' 
 t('people.edit.required_field') 
 icon 'fa fa-star text-red' 
 form.label :last_name 
 form.text_field :last_name, size: 15, class: 'form-control' 
 t('people.edit.required_field') 
 icon 'fa fa-star text-red' 
 form.label :suffix 
 form.select :suffix, [nil]+Setting.get(:system, :suffixes), {}, class: 'form-control' 
 form.label :description, t('accounts.description') 
 form.text_field :description, class: 'form-control', maxlength: 25 
 t('people.edit.description_hint') 
 form.label :gender, t('accounts.gender') 
 form.select :gender, [['', nil], [t('search.male'), 'Male'], [t('search.female'), 'Female']], {}, class: 'form-control' 
 form.label :email, t('people.email') 
 t('people.edit.email_hint') 
 form.text_field :email, class: 'form-control' 
 form.label :mobile_phone 
 form.phone_field :mobile_phone, class: 'form-control' 
 unless @person.new_record? 
 t('people.if_you_wish_to_remove_something_html', url: edit_person_privacy_path(@person)) 
 end 
 form.label :work_phone 
 form.phone_field :work_phone, class: 'form-control' 
 form.label :fax 
 form.phone_field :fax, class: 'form-control' 
 if @logged_in.admin?(:edit_profiles) and @person.family.try(:persisted?) 
 form.hidden_field :family_id 
 end 
 form.label :birthday 
 icon 'fa fa-calendar' 
 form.date_field :birthday, class: 'form-control' 
 if @logged_in.admin?(:edit_profiles) 
 form.label :child, t('people.child') 
 t('people.edit.child_hint') 
 select_tag "person[child]", options_for_select(['', [t('people.edit.child.enabled'), true], [t('people.edit.child.disabled'), false]], @person.child), id: "person_child", class: 'form-control' 
 end 
 unless @person.child? 
 form.label :anniversary 
 icon 'fa fa-calendar' 
 form.date_field :anniversary, class: 'form-control' 
 end 
 unless @person.new_record? 
 fields_for @family do |family| 
  form.label :name 
 form.text_field :name, onkeyup: 'set_last_name()', class: 'form-control' 
 if @family.new_record? 
 t('families.edit.name_example_html') 
 elsif @family.suggested_name and @family.suggested_name != @family.name 
 t('families.edit.name_suggestion_html', name: @family.suggested_name) 
 link_to '#', class: 'btn btn-xs btn-warning family-name-suggestion-button', data: { name: @family.suggested_name } do 
 icon 'fa fa-bolt' 
 t('families.edit.name_suggestion_button') 
 end 
 end 
 form.label :last_name 
 form.text_field :last_name, class: 'form-control' 
  form.label :home_phone 
 form.phone_field :home_phone, class: 'form-control' 
 form.label :address1 
 form.text_field :address1, class: 'form-control' 
 form.label :address2 
 form.text_field :address2, class: 'form-control' 
 form.label :city, t('families.edit.city_st_zip') 
 form.text_field :city, class: 'form-control inline full-width' 
 form.text_field :state, class: 'form-control inline full-width' 
 form.text_field :zip, class: 'form-control inline full-width' 
 form.label :country 
 form.country_select :country, { include_blank: true }, class: 'form-control' 
 
 
 end 
 end 
 
 submit_or_save_button 
  form.label :facebook_url 
 form.text_field :facebook_url, class: 'form-control', placeholder: t('people.edit.facebook_url.placeholder') 
 form.label :twitter 
 form.text_field :twitter, class: 'form-control', placeholder: t('people.edit.twitter.placeholder') 
 form.label :website 
 form.text_field :website, class: 'form-control' 
 form.label :testimony 
 t('people.share_your_personal_testimony') 
 form.text_area :testimony, rows: 15, class: 'form-control' 
 form.label :about 
 t('people.tell_us_about_yourself') 
 form.text_area :about, rows: 10, class: 'form-control' 
 
 submit_or_save_button 
 if setting(:features, :business_directory) 
  t('people.if_you_wish_to_be_listed_business_dir_html', url: search_path(business: true)) 
 form.label :business_category 
 form.select :business_category, business_categories, { include_blank: true }, class: 'form-control can-create', data: { 'custom-select-prompt' => t('people.edit.business_category.create_prompt') } 
 form.label :business_name 
 form.text_field :business_name, class: 'form-control' 
 form.label :business_description 
 form.text_area :business_description, rows: 3, class: 'form-control' 
 form.label :business_phone 
 form.text_field :business_phone, class: 'form-control' 
 form.label :business_email 
 form.text_field :business_email, class: 'form-control' 
 form.label :business_website 
 form.text_field :business_website, class: 'form-control' 
 form.label :business_address 
 form.text_area :business_address, rows: 2, class: 'form-control' 
 
 end 
 if @logged_in.admin?(:edit_profiles) 
  t('people.edit.person_type_hint') 
 form.check_box :member 
 form.label :member, t('search.member'), class: 'inline' 
 form.check_box :staff 
 form.label :staff,  t('search.staff'),  class: 'inline' 
 form.check_box :elder 
 form.label :elder,  t('search.elder'),  class: 'inline' 
 form.check_box :deacon 
 form.label :deacon, t('search.deacon'), class: 'inline' 
 if setting(:features, :custom_person_type) 
 form.label :custom_type 
 form.select :custom_type, custom_types, { include_blank: true }, class: 'form-control can-create', data: { 'custom-select-prompt' => t('people.edit.custom_type.create_prompt') } 
 end 
 
 end 
 t('people.edit.photo') 
 photo_upload_for @person do 
 avatar_tag @person, size: :large 
 end 
 t('people.edit.family_photo') 
 photo_upload_for @family do 
 family_avatar_tag @family, size: :large 
 end 
 end 
 content_for(:js) do 
 end 
 

end

  end

  def create
    if @logged_in.admin?(:edit_profiles)
      @person = Person.new_with_default_sharing(person_params)
      if (family_id = params[:person][:family_id]).present?
        @family = Family.find(family_id)
      else
        @family = Family.new(family_params.merge(
          name: @person.name,
          last_name: @person.last_name
        ))
      end
      @person.family = @family
      respond_to do |format|
        if @family.save and @person.save
          format.html { redirect_to @person.family }
          format.xml  { render xml: @person, status: :created, location: @person }
        else
          @person.valid? # trigger any error messages
          format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @family.persisted? 
 @title = t('people.new.heading', family: link_to(@family.try(:name), @family)).html_safe 
 else 
 @title = t('people.new.heading_without_family') 
 end 
 error_messages_for(@person) 
  form_for @person, html: { multipart: true } do |form| 
 unless @family.persisted? 
 icon 'fa fa-warning' 
 t('people.new.no_family_warning_html') 
 end 
 t('privacies.please_read_our_privacy_policy_html', url: help_path('privacy_policy')) 
 link_to t('people.edit.basics'), '#basics', data: { toggle: 'tab' } 
 link_to t('people.edit.about'), '#about', data: { toggle: 'tab' } 
 if setting(:features, :business_directory) 
 link_to t('people.edit.business'), '#business', data: { toggle: 'tab' } 
 end 
 if @logged_in.admin?(:edit_profiles) 
 link_to t('people.edit.person_type'), '#roles', data: { toggle: 'tab' } 
 link_to t('people.edit.status'), '#status', data: { toggle: 'tab' } 
 end 
   if @logged_in.can_update?(@person) and @person.updates.pending.count > 0 
 t('people.update_to_profile_is') 
 if @logged_in.admin?(:edit_profiles) 
 link_to t('people.pending_approval'), administration_updates_path 
 else 
 t('people.pending_approval') 
 end 
 end 
 
 if Setting.get(:features, :updates_must_be_approved) and not @logged_in.admin?(:edit_profiles) 
 icon 'fa fa-check-square' 
 t('people.changes_must_be_reviewed_html') 
 end 
 form.label :first_name 
 form.text_field :first_name, size: 15, class: 'form-control' 
 t('people.edit.required_field') 
 icon 'fa fa-star text-red' 
 form.label :last_name 
 form.text_field :last_name, size: 15, class: 'form-control' 
 t('people.edit.required_field') 
 icon 'fa fa-star text-red' 
 form.label :suffix 
 form.select :suffix, [nil]+Setting.get(:system, :suffixes), {}, class: 'form-control' 
 form.label :description, t('accounts.description') 
 form.text_field :description, class: 'form-control', maxlength: 25 
 t('people.edit.description_hint') 
 form.label :gender, t('accounts.gender') 
 form.select :gender, [['', nil], [t('search.male'), 'Male'], [t('search.female'), 'Female']], {}, class: 'form-control' 
 form.label :email, t('people.email') 
 t('people.edit.email_hint') 
 form.text_field :email, class: 'form-control' 
 form.label :mobile_phone 
 form.phone_field :mobile_phone, class: 'form-control' 
 unless @person.new_record? 
 t('people.if_you_wish_to_remove_something_html', url: edit_person_privacy_path(@person)) 
 end 
 form.label :work_phone 
 form.phone_field :work_phone, class: 'form-control' 
 form.label :fax 
 form.phone_field :fax, class: 'form-control' 
 if @logged_in.admin?(:edit_profiles) and @person.family.try(:persisted?) 
 form.hidden_field :family_id 
 end 
 form.label :birthday 
 icon 'fa fa-calendar' 
 form.date_field :birthday, class: 'form-control' 
 if @logged_in.admin?(:edit_profiles) 
 form.label :child, t('people.child') 
 t('people.edit.child_hint') 
 select_tag "person[child]", options_for_select(['', [t('people.edit.child.enabled'), true], [t('people.edit.child.disabled'), false]], @person.child), id: "person_child", class: 'form-control' 
 end 
 unless @person.child? 
 form.label :anniversary 
 icon 'fa fa-calendar' 
 form.date_field :anniversary, class: 'form-control' 
 end 
 unless @person.new_record? 
 fields_for @family do |family| 
  form.label :name 
 form.text_field :name, onkeyup: 'set_last_name()', class: 'form-control' 
 if @family.new_record? 
 t('families.edit.name_example_html') 
 elsif @family.suggested_name and @family.suggested_name != @family.name 
 t('families.edit.name_suggestion_html', name: @family.suggested_name) 
 link_to '#', class: 'btn btn-xs btn-warning family-name-suggestion-button', data: { name: @family.suggested_name } do 
 icon 'fa fa-bolt' 
 t('families.edit.name_suggestion_button') 
 end 
 end 
 form.label :last_name 
 form.text_field :last_name, class: 'form-control' 
  form.label :home_phone 
 form.phone_field :home_phone, class: 'form-control' 
 form.label :address1 
 form.text_field :address1, class: 'form-control' 
 form.label :address2 
 form.text_field :address2, class: 'form-control' 
 form.label :city, t('families.edit.city_st_zip') 
 form.text_field :city, class: 'form-control inline full-width' 
 form.text_field :state, class: 'form-control inline full-width' 
 form.text_field :zip, class: 'form-control inline full-width' 
 form.label :country 
 form.country_select :country, { include_blank: true }, class: 'form-control' 
 
 
 end 
 end 
 
 submit_or_save_button 
  form.label :facebook_url 
 form.text_field :facebook_url, class: 'form-control', placeholder: t('people.edit.facebook_url.placeholder') 
 form.label :twitter 
 form.text_field :twitter, class: 'form-control', placeholder: t('people.edit.twitter.placeholder') 
 form.label :website 
 form.text_field :website, class: 'form-control' 
 form.label :testimony 
 t('people.share_your_personal_testimony') 
 form.text_area :testimony, rows: 15, class: 'form-control' 
 form.label :about 
 t('people.tell_us_about_yourself') 
 form.text_area :about, rows: 10, class: 'form-control' 
 
 submit_or_save_button 
 if setting(:features, :business_directory) 
  t('people.if_you_wish_to_be_listed_business_dir_html', url: search_path(business: true)) 
 form.label :business_category 
 form.select :business_category, business_categories, { include_blank: true }, class: 'form-control can-create', data: { 'custom-select-prompt' => t('people.edit.business_category.create_prompt') } 
 form.label :business_name 
 form.text_field :business_name, class: 'form-control' 
 form.label :business_description 
 form.text_area :business_description, rows: 3, class: 'form-control' 
 form.label :business_phone 
 form.text_field :business_phone, class: 'form-control' 
 form.label :business_email 
 form.text_field :business_email, class: 'form-control' 
 form.label :business_website 
 form.text_field :business_website, class: 'form-control' 
 form.label :business_address 
 form.text_area :business_address, rows: 2, class: 'form-control' 
 
 end 
 if @logged_in.admin?(:edit_profiles) 
  t('people.edit.person_type_hint') 
 form.check_box :member 
 form.label :member, t('search.member'), class: 'inline' 
 form.check_box :staff 
 form.label :staff,  t('search.staff'),  class: 'inline' 
 form.check_box :elder 
 form.label :elder,  t('search.elder'),  class: 'inline' 
 form.check_box :deacon 
 form.label :deacon, t('search.deacon'), class: 'inline' 
 if setting(:features, :custom_person_type) 
 form.label :custom_type 
 form.select :custom_type, custom_types, { include_blank: true }, class: 'form-control can-create', data: { 'custom-select-prompt' => t('people.edit.custom_type.create_prompt') } 
 end 
 
 end 
 t('people.edit.photo') 
 photo_upload_for @person do 
 avatar_tag @person, size: :large 
 end 
 t('people.edit.family_photo') 
 photo_upload_for @family do 
 family_avatar_tag @family, size: :large 
 end 
 end 
 content_for(:js) do 
 end 
 

end
 }
          format.xml  { render xml: @person.errors, status: :unprocessable_entity }
        end
      end
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
  end

  def edit
    @person ||= Person.find(params[:id])
    render(text: t('people.edit.no_family_error'), layout: true) && return unless @person.family
    if @logged_in.can_update?(@person)
      @family = @person.family
      @business_categories = Person.business_categories
      @custom_types = Person.custom_types
      if params[:email]
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('people.email.heading') 
 form_for @person do |form| 
 error_messages_for(form) 
 t('people.email.primary.heading') 
 t('people.email.primary.description_html') 
 form.label :email 
 form.text_field :email, class: 'input-huge form-control' 
 if (shared_email_people = @person.others_with_same_email).any? 
 t('people.edit.primary_emailer.intro_html', person: shared_email_people.first.try(:name)) 
 form.check_box :primary_emailer 
 form.label :primary_emailer, class: 'inline' 
 end 
 submit_tag t('save_changes'), class: 'btn btn-success' 
 t('people.email.alternate.heading') 
 t('people.email.alternate.description_html') 
 form.label :alternate_email 
 form.text_field :alternate_email, class: 'form-control' 
 submit_tag t('save_changes'), class: 'btn btn-success' 
 end 
 form_for @person do |form| 
 hidden_field_tag :email, true 
 t('people.email.groups.heading') 
  
 end 

end

      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('people.edit.header') 
 if @person.account_frozen? 
 t('people.account_frozen.callout') 
 end 
 if @person.updates.pending.any? and @logged_in.can_update?(@person) 
 icon 'fa fa-clock-o' 
 t('people.updates.pending_callout') 
 end 
 error_messages_for @person 
  form_for @person, html: { multipart: true } do |form| 
 unless @family.persisted? 
 icon 'fa fa-warning' 
 t('people.new.no_family_warning_html') 
 end 
 t('privacies.please_read_our_privacy_policy_html', url: help_path('privacy_policy')) 
 link_to t('people.edit.basics'), '#basics', data: { toggle: 'tab' } 
 link_to t('people.edit.about'), '#about', data: { toggle: 'tab' } 
 if setting(:features, :business_directory) 
 link_to t('people.edit.business'), '#business', data: { toggle: 'tab' } 
 end 
 if @logged_in.admin?(:edit_profiles) 
 link_to t('people.edit.person_type'), '#roles', data: { toggle: 'tab' } 
 link_to t('people.edit.status'), '#status', data: { toggle: 'tab' } 
 end 
   if @logged_in.can_update?(@person) and @person.updates.pending.count > 0 
 t('people.update_to_profile_is') 
 if @logged_in.admin?(:edit_profiles) 
 link_to t('people.pending_approval'), administration_updates_path 
 else 
 t('people.pending_approval') 
 end 
 end 
 
 if Setting.get(:features, :updates_must_be_approved) and not @logged_in.admin?(:edit_profiles) 
 icon 'fa fa-check-square' 
 t('people.changes_must_be_reviewed_html') 
 end 
 form.label :first_name 
 form.text_field :first_name, size: 15, class: 'form-control' 
 t('people.edit.required_field') 
 icon 'fa fa-star text-red' 
 form.label :last_name 
 form.text_field :last_name, size: 15, class: 'form-control' 
 t('people.edit.required_field') 
 icon 'fa fa-star text-red' 
 form.label :suffix 
 form.select :suffix, [nil]+Setting.get(:system, :suffixes), {}, class: 'form-control' 
 form.label :description, t('accounts.description') 
 form.text_field :description, class: 'form-control', maxlength: 25 
 t('people.edit.description_hint') 
 form.label :gender, t('accounts.gender') 
 form.select :gender, [['', nil], [t('search.male'), 'Male'], [t('search.female'), 'Female']], {}, class: 'form-control' 
 form.label :email, t('people.email') 
 t('people.edit.email_hint') 
 form.text_field :email, class: 'form-control' 
 form.label :mobile_phone 
 form.phone_field :mobile_phone, class: 'form-control' 
 unless @person.new_record? 
 t('people.if_you_wish_to_remove_something_html', url: edit_person_privacy_path(@person)) 
 end 
 form.label :work_phone 
 form.phone_field :work_phone, class: 'form-control' 
 form.label :fax 
 form.phone_field :fax, class: 'form-control' 
 if @logged_in.admin?(:edit_profiles) and @person.family.try(:persisted?) 
 form.hidden_field :family_id 
 end 
 form.label :birthday 
 icon 'fa fa-calendar' 
 form.date_field :birthday, class: 'form-control' 
 if @logged_in.admin?(:edit_profiles) 
 form.label :child, t('people.child') 
 t('people.edit.child_hint') 
 select_tag "person[child]", options_for_select(['', [t('people.edit.child.enabled'), true], [t('people.edit.child.disabled'), false]], @person.child), id: "person_child", class: 'form-control' 
 end 
 unless @person.child? 
 form.label :anniversary 
 icon 'fa fa-calendar' 
 form.date_field :anniversary, class: 'form-control' 
 end 
 unless @person.new_record? 
 fields_for @family do |family| 
  form.label :name 
 form.text_field :name, onkeyup: 'set_last_name()', class: 'form-control' 
 if @family.new_record? 
 t('families.edit.name_example_html') 
 elsif @family.suggested_name and @family.suggested_name != @family.name 
 t('families.edit.name_suggestion_html', name: @family.suggested_name) 
 link_to '#', class: 'btn btn-xs btn-warning family-name-suggestion-button', data: { name: @family.suggested_name } do 
 icon 'fa fa-bolt' 
 t('families.edit.name_suggestion_button') 
 end 
 end 
 form.label :last_name 
 form.text_field :last_name, class: 'form-control' 
  form.label :home_phone 
 form.phone_field :home_phone, class: 'form-control' 
 form.label :address1 
 form.text_field :address1, class: 'form-control' 
 form.label :address2 
 form.text_field :address2, class: 'form-control' 
 form.label :city, t('families.edit.city_st_zip') 
 form.text_field :city, class: 'form-control inline full-width' 
 form.text_field :state, class: 'form-control inline full-width' 
 form.text_field :zip, class: 'form-control inline full-width' 
 form.label :country 
 form.country_select :country, { include_blank: true }, class: 'form-control' 
 
 
 end 
 end 
 
 submit_or_save_button 
  form.label :facebook_url 
 form.text_field :facebook_url, class: 'form-control', placeholder: t('people.edit.facebook_url.placeholder') 
 form.label :twitter 
 form.text_field :twitter, class: 'form-control', placeholder: t('people.edit.twitter.placeholder') 
 form.label :website 
 form.text_field :website, class: 'form-control' 
 form.label :testimony 
 t('people.share_your_personal_testimony') 
 form.text_area :testimony, rows: 15, class: 'form-control' 
 form.label :about 
 t('people.tell_us_about_yourself') 
 form.text_area :about, rows: 10, class: 'form-control' 
 
 submit_or_save_button 
 if setting(:features, :business_directory) 
  t('people.if_you_wish_to_be_listed_business_dir_html', url: search_path(business: true)) 
 form.label :business_category 
 form.select :business_category, business_categories, { include_blank: true }, class: 'form-control can-create', data: { 'custom-select-prompt' => t('people.edit.business_category.create_prompt') } 
 form.label :business_name 
 form.text_field :business_name, class: 'form-control' 
 form.label :business_description 
 form.text_area :business_description, rows: 3, class: 'form-control' 
 form.label :business_phone 
 form.text_field :business_phone, class: 'form-control' 
 form.label :business_email 
 form.text_field :business_email, class: 'form-control' 
 form.label :business_website 
 form.text_field :business_website, class: 'form-control' 
 form.label :business_address 
 form.text_area :business_address, rows: 2, class: 'form-control' 
 
 end 
 if @logged_in.admin?(:edit_profiles) 
  t('people.edit.person_type_hint') 
 form.check_box :member 
 form.label :member, t('search.member'), class: 'inline' 
 form.check_box :staff 
 form.label :staff,  t('search.staff'),  class: 'inline' 
 form.check_box :elder 
 form.label :elder,  t('search.elder'),  class: 'inline' 
 form.check_box :deacon 
 form.label :deacon, t('search.deacon'), class: 'inline' 
 if setting(:features, :custom_person_type) 
 form.label :custom_type 
 form.select :custom_type, custom_types, { include_blank: true }, class: 'form-control can-create', data: { 'custom-select-prompt' => t('people.edit.custom_type.create_prompt') } 
 end 
 
 end 
 t('people.edit.photo') 
 photo_upload_for @person do 
 avatar_tag @person, size: :large 
 end 
 t('people.edit.family_photo') 
 photo_upload_for @family do 
 family_avatar_tag @family, size: :large 
 end 
 end 
 content_for(:js) do 
 end 
 

end

      end
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('people.edit.header') 
 if @person.account_frozen? 
 t('people.account_frozen.callout') 
 end 
 if @person.updates.pending.any? and @logged_in.can_update?(@person) 
 icon 'fa fa-clock-o' 
 t('people.updates.pending_callout') 
 end 
 error_messages_for @person 
  form_for @person, html: { multipart: true } do |form| 
 unless @family.persisted? 
 icon 'fa fa-warning' 
 t('people.new.no_family_warning_html') 
 end 
 t('privacies.please_read_our_privacy_policy_html', url: help_path('privacy_policy')) 
 link_to t('people.edit.basics'), '#basics', data: { toggle: 'tab' } 
 link_to t('people.edit.about'), '#about', data: { toggle: 'tab' } 
 if setting(:features, :business_directory) 
 link_to t('people.edit.business'), '#business', data: { toggle: 'tab' } 
 end 
 if @logged_in.admin?(:edit_profiles) 
 link_to t('people.edit.person_type'), '#roles', data: { toggle: 'tab' } 
 link_to t('people.edit.status'), '#status', data: { toggle: 'tab' } 
 end 
   if @logged_in.can_update?(@person) and @person.updates.pending.count > 0 
 t('people.update_to_profile_is') 
 if @logged_in.admin?(:edit_profiles) 
 link_to t('people.pending_approval'), administration_updates_path 
 else 
 t('people.pending_approval') 
 end 
 end 
 
 if Setting.get(:features, :updates_must_be_approved) and not @logged_in.admin?(:edit_profiles) 
 icon 'fa fa-check-square' 
 t('people.changes_must_be_reviewed_html') 
 end 
 form.label :first_name 
 form.text_field :first_name, size: 15, class: 'form-control' 
 t('people.edit.required_field') 
 icon 'fa fa-star text-red' 
 form.label :last_name 
 form.text_field :last_name, size: 15, class: 'form-control' 
 t('people.edit.required_field') 
 icon 'fa fa-star text-red' 
 form.label :suffix 
 form.select :suffix, [nil]+Setting.get(:system, :suffixes), {}, class: 'form-control' 
 form.label :description, t('accounts.description') 
 form.text_field :description, class: 'form-control', maxlength: 25 
 t('people.edit.description_hint') 
 form.label :gender, t('accounts.gender') 
 form.select :gender, [['', nil], [t('search.male'), 'Male'], [t('search.female'), 'Female']], {}, class: 'form-control' 
 form.label :email, t('people.email') 
 t('people.edit.email_hint') 
 form.text_field :email, class: 'form-control' 
 form.label :mobile_phone 
 form.phone_field :mobile_phone, class: 'form-control' 
 unless @person.new_record? 
 t('people.if_you_wish_to_remove_something_html', url: edit_person_privacy_path(@person)) 
 end 
 form.label :work_phone 
 form.phone_field :work_phone, class: 'form-control' 
 form.label :fax 
 form.phone_field :fax, class: 'form-control' 
 if @logged_in.admin?(:edit_profiles) and @person.family.try(:persisted?) 
 form.hidden_field :family_id 
 end 
 form.label :birthday 
 icon 'fa fa-calendar' 
 form.date_field :birthday, class: 'form-control' 
 if @logged_in.admin?(:edit_profiles) 
 form.label :child, t('people.child') 
 t('people.edit.child_hint') 
 select_tag "person[child]", options_for_select(['', [t('people.edit.child.enabled'), true], [t('people.edit.child.disabled'), false]], @person.child), id: "person_child", class: 'form-control' 
 end 
 unless @person.child? 
 form.label :anniversary 
 icon 'fa fa-calendar' 
 form.date_field :anniversary, class: 'form-control' 
 end 
 unless @person.new_record? 
 fields_for @family do |family| 
  form.label :name 
 form.text_field :name, onkeyup: 'set_last_name()', class: 'form-control' 
 if @family.new_record? 
 t('families.edit.name_example_html') 
 elsif @family.suggested_name and @family.suggested_name != @family.name 
 t('families.edit.name_suggestion_html', name: @family.suggested_name) 
 link_to '#', class: 'btn btn-xs btn-warning family-name-suggestion-button', data: { name: @family.suggested_name } do 
 icon 'fa fa-bolt' 
 t('families.edit.name_suggestion_button') 
 end 
 end 
 form.label :last_name 
 form.text_field :last_name, class: 'form-control' 
  form.label :home_phone 
 form.phone_field :home_phone, class: 'form-control' 
 form.label :address1 
 form.text_field :address1, class: 'form-control' 
 form.label :address2 
 form.text_field :address2, class: 'form-control' 
 form.label :city, t('families.edit.city_st_zip') 
 form.text_field :city, class: 'form-control inline full-width' 
 form.text_field :state, class: 'form-control inline full-width' 
 form.text_field :zip, class: 'form-control inline full-width' 
 form.label :country 
 form.country_select :country, { include_blank: true }, class: 'form-control' 
 
 
 end 
 end 
 
 submit_or_save_button 
  form.label :facebook_url 
 form.text_field :facebook_url, class: 'form-control', placeholder: t('people.edit.facebook_url.placeholder') 
 form.label :twitter 
 form.text_field :twitter, class: 'form-control', placeholder: t('people.edit.twitter.placeholder') 
 form.label :website 
 form.text_field :website, class: 'form-control' 
 form.label :testimony 
 t('people.share_your_personal_testimony') 
 form.text_area :testimony, rows: 15, class: 'form-control' 
 form.label :about 
 t('people.tell_us_about_yourself') 
 form.text_area :about, rows: 10, class: 'form-control' 
 
 submit_or_save_button 
 if setting(:features, :business_directory) 
  t('people.if_you_wish_to_be_listed_business_dir_html', url: search_path(business: true)) 
 form.label :business_category 
 form.select :business_category, business_categories, { include_blank: true }, class: 'form-control can-create', data: { 'custom-select-prompt' => t('people.edit.business_category.create_prompt') } 
 form.label :business_name 
 form.text_field :business_name, class: 'form-control' 
 form.label :business_description 
 form.text_area :business_description, rows: 3, class: 'form-control' 
 form.label :business_phone 
 form.text_field :business_phone, class: 'form-control' 
 form.label :business_email 
 form.text_field :business_email, class: 'form-control' 
 form.label :business_website 
 form.text_field :business_website, class: 'form-control' 
 form.label :business_address 
 form.text_area :business_address, rows: 2, class: 'form-control' 
 
 end 
 if @logged_in.admin?(:edit_profiles) 
  t('people.edit.person_type_hint') 
 form.check_box :member 
 form.label :member, t('search.member'), class: 'inline' 
 form.check_box :staff 
 form.label :staff,  t('search.staff'),  class: 'inline' 
 form.check_box :elder 
 form.label :elder,  t('search.elder'),  class: 'inline' 
 form.check_box :deacon 
 form.label :deacon, t('search.deacon'), class: 'inline' 
 if setting(:features, :custom_person_type) 
 form.label :custom_type 
 form.select :custom_type, custom_types, { include_blank: true }, class: 'form-control can-create', data: { 'custom-select-prompt' => t('people.edit.custom_type.create_prompt') } 
 end 
 
 end 
 t('people.edit.photo') 
 photo_upload_for @person do 
 avatar_tag @person, size: :large 
 end 
 t('people.edit.family_photo') 
 photo_upload_for @family do 
 family_avatar_tag @family, size: :large 
 end 
 end 
 content_for(:js) do 
 end 
 

end

  end

  def update
    @person = Person.find(params[:id])
    if params[:move_person] and params[:family_id] and @logged_in.admin?(:edit_profiles)
      @family = Family.find(params[:family_id])
      @family.people << @person
      flash[:info] = t('people.move.success_message', person: @person.name, family: @family.name)
      redirect_to @family
    elsif @logged_in.can_update?(@person)
      @updater = Updater.new(params)
      if @updater.save!
        respond_to do |format|
          format.html do
            flash[:notice] = t('people.changes_submitted')
            flash[:show_verification_link] = @updater.show_verification_link?
            redirect_to @person
          end
          format.xml { render xml: @person.to_xml } if can_export?
        end
      else
        @person = @updater.person
        edit
      end
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
  end

  def destroy
    if @logged_in.admin?(:edit_profiles)
      @person = Person.find(params[:id])
      if me?
        render text: t('people.cant_delete_yourself'), layout: true, status: 401
      elsif @person.super_admin?
        render text: t('people.cant_delete'), layout: true, status: 401
      else
        @person.destroy
        redirect_to @person.family
      end
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
  end

  def batch
    # post from families/show page
    if params[:family_id] and @logged_in.admin?(:edit_profiles)
      params[:ids].each { |id| Person.find(id).update_attribute(:family_id, params[:family_id]) }
      respond_to do |format|
        format.html { redirect_to family_path(params[:family_id]) }
        format.js   { render js: "location.replace('#{family_path(params[:family_id])}')" }
      end
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
  end

  def testimony
    @person = Person.find(params[:id])
    unless @logged_in.can_read?(@person)
      render text: t('people.not_found'), status: 404, layout: true
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('people.testimony.heading', person: link_to(@person.name, @person)).html_safe 
 avatar_tag @person, size: :large 
 link_to @person, class: 'btn btn-info', style: 'width: 100%' do 
 icon 'fa fa-user' 
 t('people.testimony.view_profile') 
 end 
 preserve_breaks(@person.testimony) 

end

  end

  def login
    if @logged_in.super_admin?
      session[:logged_in_id] = Person.find(params[:id])
      redirect_to root_path
    end
  end

  def update_position
    @family = Family.find(params[:family_id])
    @person = @family.people.find(params[:id])
    @person.insert_at(params[:position].to_i) if @family.reorderable_by?(@logged_in)
    render nothing: true
  end

  private

  def person_params
    Updater.new(params).params[:person]
  end

  def family_params
    Updater.new(params).params[:family] || {}
  end
end

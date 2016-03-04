class Checkin::FamiliesController < ApplicationController

  def show
    @family = Family.undeleted.find(params[:id])
    @family_people = @family.people.undeleted.order(:position)
    @attendance_records = AttendanceRecord.find_for_people_and_date(@family_people.map(&:id), Date.today)
                                          .group_by(&:person_id)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 escape_javascript  link_to @family.name, @family 
 preserve_breaks @family.pretty_address 
 format_phone @family.home_phone 
  if @family_people.length > 1 
 @family_people.each do |person| 
 avatar_tag(person) 
 link_to person.name, person 
 if person.mobile_phone.present? 
 format_phone(person.mobile_phone, :mobile) 
 end 
 link_to person_relationships_path(person), class: 'btn bg-gray btn-xs' do 
 icon 'fa fa-link' 
 end 
 if person.can_pick_up.present? 
 h person.can_pick_up 
 end 
 if person.cannot_pick_up.present? 
 h person.cannot_pick_up 
 end 
 if person.medical_notes.present? 
 h person.medical_notes 
 end 
 if (checkin_people = Relationship.where('person_id = ? and other_name like ?', person.id, '%Check-in Person%').to_a.map(&:related).uniq).any? 
 raw checkin_people.map { |p| link_to(h(p.name), p) }.join(', ') 
 end 
 if @attendance_records 
 @attendance_records[person.id].to_a.each do |attendance_record| 
 h attendance_record.attended_at.to_s(:time) 
 h attendance_record.group.name rescue '?' 
 end 
 end 
 end 
 end 
 
 if @family.photo.exists? 
 image_tag @family.photo.url(:medium), :style => 'float:right' 
 end 
 
 escape_javascript  form_for @family, url: checkin_family_path(@family), remote: true do |form| 
 form.label :barcode_id, 'Scan Card:', class: 'inline' 
 form.text_field :barcode_id, size: 15, autocomplete: 'off', class: 'form-control' 
 if @family.barcode_assigned_at 
 @family.barcode_assigned_at.to_s 
 time_ago_in_words @family.barcode_assigned_at 
 end 
 link_to_function raw('alternate card &raquo;'), "$('#alternate-card').show();$(this).hide();$('#family_alternate_barcode_id')[0].focus();" 
 form.label :alternate_barcode_id, 'Alternate (Temporary) Card:', class: 'inline' 
 form.text_field :alternate_barcode_id, size: 15, autocomplete: 'off', class: 'form-control' 
 form.button 'Save', class: 'btn btn-success' 
 end 
 

end

  end

  def new
    family_form = FamilyFormPresenter.new
    @family = family_form.family
    @people = family_form.build_people
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('checkin.family.new.heading') 
  form_for @family, url: checkin_families_path, html: { onsubmit: "return validateNames()" } do |form| 
 if params[:compact] 
 hidden_field_tag :compact, true 
 end 
 if params[:people] 
 hidden_field_tag :people,  true 
 end 
 if params[:barcode] 
 hidden_field_tag :barcode, true 
 end 
 error_messages_for(form) 
 t('checkin.family.new.first_name') 
 t('checkin.family.new.last_name') 
 t('checkin.family.new.birthday') 
 t('checkin.family.new.medical_notes') 
 @people.each_with_index do |person, index| 
 if index == 0 
 t('checkin.family.new.parents') 
 elsif index == 2 
 link_to_function 'Add Person', "if(!addPersonRow()) $('#add_row_link').hide()", class: 'add-icon', style: 'background-position:0px -3px' 
 t('checkin.family.new.children') 
 end 
 text_field_tag "family[people_attributes][#{index}][first_name]", @people[index].first_name, size: 25, id: "family_people_attributes_#{index}_first_name", class: 'name form-control' 
 text_field_tag "family[people_attributes][#{index}][last_name]", @people[index].last_name, size: 25, id: "family_people_attributes_#{index}_last_name", class: 'name family-last-name form-control', onkeyup: index == 0 ? 'setLastName(this.value)' : nil, onblur: index == 0 ? 'setLastName(this.value)' : nil 
 date_field_tag "family[people_attributes][#{index}][birthday]", @people[index].birthday ? @people[index].birthday.to_s(:date) : '', size: 12, id: "family_people_attributes_#{index}_birthday", class: 'date-field form-control' 
 text_field_tag "family[people_attributes][#{index}][medical_notes]", @people[index].medical_notes, size: 25, id: "family_people_attributes_#{index}_medical_notes", class: 'form-control' 
 end 
 form.label :barcode_id, t('checkin.family.new.barcode') 
 form.text_field :barcode_id, autocomplete: 'off', class: 'form-control', style: 'max-width: 732px' 
 t('checkin.family.new.ignore_spelling_errors') 
 button_tag t('checkin.family.new.save'), class: 'btn btn-success' 
 link_to t('checkin.family.new.cancel'), administration_checkin_dashboard_path 
 end 
 content_for :js do 
 end 
 

end

  end

  def create
    family_form = FamilyFormPresenter.new(params)
    family_form.create
    @family = family_form.family
    @people = family_form.people
    render action: 'new' if @family.errors.any?
  end

  def update
    @family = Family.undeleted.find(params[:id])
    @family.barcode_id = params[:family][:barcode_id]
    @family.alternate_barcode_id = params[:family][:alternate_barcode_id]
    @success = @family.save
    respond_to do |format|
      format.js
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @success 
 t('checkin.family.saved') 
 else 
 t('checkin.family.errors') 
 escape_javascript @family.errors.values.join('; ') 
 end 

end

  end

  private

  def build_family_people
    @people = @family.people.to_a
    adults = []
    adults << @people.shift until adults.length >= 2 or @people.first.nil? or @people.first.child?
    adults << @family.people.adults.build until adults.length >= 2
    @people.unshift(*adults)
    @people << @family.people.children.build until @people.length >= 25
  end
end

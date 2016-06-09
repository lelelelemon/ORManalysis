class RelationshipsController < ApplicationController
  before_filter :only_admins

  def index
    if params[:person_id]
      person_index
    elsif params[:family_id]
      family_index
    else
      render text: t('relationships.no_person_selected'), layout: true
    end
  end

  def person_index
    @person = Person.undeleted.find(params[:person_id])
    @relationships = @person.relationships.includes(:related).order('people.last_name', 'people.first_name')
    @inward_relationships = @person.inward_relationships.includes(:person).order('people.last_name', 'people.first_name')
    @other_names = Relationship.other_names
    @relationship = Relationship.new(person: @person)
    respond_to do |format|
      format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('relationships.heading', person: link_to(@person.name, @person)).html_safe 
 if @relationships.any? 
 form_tag batch_person_relationships_path(@person) do 
 t('name') 
 t('relationships.relationship') 
 @relationships.each do |relationship| 
 check_box_tag 'ids[]', relationship.id, false, class: 'outward_relationship_checkbox' 
 link_to relationship.related.name, person_relationships_path(relationship.related) 
 relationship.name_or_other 
 end 
 button_tag name: 'delete', data: { confirm: t('are_you_sure') }, class: 'btn btn-delete' do 
 icon 'fa fa-trash-o' 
 t('Delete') 
 end 
 button_tag name: 'reciprocate', class: 'btn btn-success' do 
 icon 'fa fa-exchange' 
 t('relationships.reciprocate.button') 
 end 
 end 
 else 
 t('none') 
 end 
 form_tag search_path, remote: true do 
 hidden_field_tag :select_person, true 
 t('relationships.add_relationship.intro') 
 t('search.search_by_name') 
 text_field_tag 'name', '', class: 'form-control' 
 button_tag t('relationships.add_relationship.button'), class: 'btn btn-info' 
 end 
 form_tag person_relationships_path(@person) do 
 t('relationships.relationship_type') 
 select_tag :name, relationships_for_select,            id: 'relationship_name',            class: 'form-control',            include_blank: true,            data: { toggle: '#other_name', 'toggle-value' => 'other' } 
 text_field_tag :other_name, nil,          style: 'display:none;',          class: 'form-control',          placeholder: t('relationships.other_name.placeholder') 
 button_tag t('search.add_selected'), class: 'btn btn-success' 
 end 
 link_to family_relationships_path(@person.family), class: 'btn btn-info' do 
 icon 'fa fa-group' 
 t('relationships.family.button') 
 end 
 t('relationships.inward.heading') 
 if @inward_relationships.any? 
 form_tag batch_person_relationships_path(@person) do 
 t('From') 
 t('relationships.relationship') 
 @inward_relationships.each do |relationship| 
 check_box_tag 'ids[]', relationship.id, false, class: 'inward_relationship_checkbox' 
 link_to relationship.person.name, person_relationships_path(relationship.person) 
 relationship.name_or_other 
 end 
 button_tag name: 'delete', data: { confirm: t('are_you_sure') }, class: 'btn btn-delete' do 
 icon 'fa fa-trash-o' 
 t('Delete') 
 end 
 button_tag name: 'reciprocate', class: 'btn btn-success' do 
 icon 'fa fa-exchange' 
 t('relationships.reciprocate.button') 
 end 
 end 
 else 
 t('none') 
 end 

end
 }
      format.xml  { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('relationships.heading', person: link_to(@person.name, @person)).html_safe 
 if @relationships.any? 
 form_tag batch_person_relationships_path(@person) do 
 t('name') 
 t('relationships.relationship') 
 @relationships.each do |relationship| 
 check_box_tag 'ids[]', relationship.id, false, class: 'outward_relationship_checkbox' 
 link_to relationship.related.name, person_relationships_path(relationship.related) 
 relationship.name_or_other 
 end 
 button_tag name: 'delete', data: { confirm: t('are_you_sure') }, class: 'btn btn-delete' do 
 icon 'fa fa-trash-o' 
 t('Delete') 
 end 
 button_tag name: 'reciprocate', class: 'btn btn-success' do 
 icon 'fa fa-exchange' 
 t('relationships.reciprocate.button') 
 end 
 end 
 else 
 t('none') 
 end 
 form_tag search_path, remote: true do 
 hidden_field_tag :select_person, true 
 t('relationships.add_relationship.intro') 
 t('search.search_by_name') 
 text_field_tag 'name', '', class: 'form-control' 
 button_tag t('relationships.add_relationship.button'), class: 'btn btn-info' 
 end 
 form_tag person_relationships_path(@person) do 
 t('relationships.relationship_type') 
 select_tag :name, relationships_for_select,            id: 'relationship_name',            class: 'form-control',            include_blank: true,            data: { toggle: '#other_name', 'toggle-value' => 'other' } 
 text_field_tag :other_name, nil,          style: 'display:none;',          class: 'form-control',          placeholder: t('relationships.other_name.placeholder') 
 button_tag t('search.add_selected'), class: 'btn btn-success' 
 end 
 link_to family_relationships_path(@person.family), class: 'btn btn-info' do 
 icon 'fa fa-group' 
 t('relationships.family.button') 
 end 
 t('relationships.inward.heading') 
 if @inward_relationships.any? 
 form_tag batch_person_relationships_path(@person) do 
 t('From') 
 t('relationships.relationship') 
 @inward_relationships.each do |relationship| 
 check_box_tag 'ids[]', relationship.id, false, class: 'inward_relationship_checkbox' 
 link_to relationship.person.name, person_relationships_path(relationship.person) 
 relationship.name_or_other 
 end 
 button_tag name: 'delete', data: { confirm: t('are_you_sure') }, class: 'btn btn-delete' do 
 icon 'fa fa-trash-o' 
 t('Delete') 
 end 
 button_tag name: 'reciprocate', class: 'btn btn-success' do 
 icon 'fa fa-exchange' 
 t('relationships.reciprocate.button') 
 end 
 end 
 else 
 t('none') 
 end 

end
 }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('relationships.heading', person: link_to(@person.name, @person)).html_safe 
 if @relationships.any? 
 form_tag batch_person_relationships_path(@person) do 
 t('name') 
 t('relationships.relationship') 
 @relationships.each do |relationship| 
 check_box_tag 'ids[]', relationship.id, false, class: 'outward_relationship_checkbox' 
 link_to relationship.related.name, person_relationships_path(relationship.related) 
 relationship.name_or_other 
 end 
 button_tag name: 'delete', data: { confirm: t('are_you_sure') }, class: 'btn btn-delete' do 
 icon 'fa fa-trash-o' 
 t('Delete') 
 end 
 button_tag name: 'reciprocate', class: 'btn btn-success' do 
 icon 'fa fa-exchange' 
 t('relationships.reciprocate.button') 
 end 
 end 
 else 
 t('none') 
 end 
 form_tag search_path, remote: true do 
 hidden_field_tag :select_person, true 
 t('relationships.add_relationship.intro') 
 t('search.search_by_name') 
 text_field_tag 'name', '', class: 'form-control' 
 button_tag t('relationships.add_relationship.button'), class: 'btn btn-info' 
 end 
 form_tag person_relationships_path(@person) do 
 t('relationships.relationship_type') 
 select_tag :name, relationships_for_select,            id: 'relationship_name',            class: 'form-control',            include_blank: true,            data: { toggle: '#other_name', 'toggle-value' => 'other' } 
 text_field_tag :other_name, nil,          style: 'display:none;',          class: 'form-control',          placeholder: t('relationships.other_name.placeholder') 
 button_tag t('search.add_selected'), class: 'btn btn-success' 
 end 
 link_to family_relationships_path(@person.family), class: 'btn btn-info' do 
 icon 'fa fa-group' 
 t('relationships.family.button') 
 end 
 t('relationships.inward.heading') 
 if @inward_relationships.any? 
 form_tag batch_person_relationships_path(@person) do 
 t('From') 
 t('relationships.relationship') 
 @inward_relationships.each do |relationship| 
 check_box_tag 'ids[]', relationship.id, false, class: 'inward_relationship_checkbox' 
 link_to relationship.person.name, person_relationships_path(relationship.person) 
 relationship.name_or_other 
 end 
 button_tag name: 'delete', data: { confirm: t('are_you_sure') }, class: 'btn btn-delete' do 
 icon 'fa fa-trash-o' 
 t('Delete') 
 end 
 button_tag name: 'reciprocate', class: 'btn btn-success' do 
 icon 'fa fa-exchange' 
 t('relationships.reciprocate.button') 
 end 
 end 
 else 
 t('none') 
 end 

end

  end

  def family_index
    @family = Family.undeleted.find(params[:family_id])
    people_ids = @family.people.map { |p| p.id }
    @relationships = Relationship.where("person_id in (?) and related_id in (?)", people_ids, people_ids)
    @unique_relationships = {}
    @relationships.each do |relationship|
      @unique_relationships[relationship.related] ||= []
      @unique_relationships[relationship.related] << relationship.name_or_other
      @unique_relationships[relationship.related].uniq!
    end
    @suggested_relationships = @family.suggested_relationships
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('relationships.family.heading', family: link_to(@family.name, @family)).html_safe 
 if @relationships.any? 
 t('name') 
 t('relationships.relationship') 
 @unique_relationships.each do |person, relationship_names| 
 link_to person.name, person_relationships_path(person) 
 relationship_names.join(', ') 
 end 
 t('From') 
 t('relationships.relationship') 
 @relationships.each do |relationship| 
 link_to relationship.person.name, person_relationships_path(relationship.person) 
 link_to relationship.related.name, person_relationships_path(relationship.related) 
 relationship.name_or_other 
 end 
 end 
 if @relationships.any? or @family.people.any? 
 if @relationships.any? 
 link_to_function t('relationships.toggle_individual'), "$('#unique_relationships, #individual_relationships').toggle();", class: 'btn bg-gray' 
 end 
 if @family.people.any? 
 link_to_function t('relationships.family.create.button'), "$('#auto_generate').show()", class: 'btn bg-gray' 
 end 
 else 
 t('none') 
 end 
 if @family.people.count > 0 
 form_tag family_relationships_path(@family) do 
 t('relationships.family.create.intro') 
 t('From') 
 t('To') 
 t('relationships.relationship') 
 @suggested_relationships.each do |person, relationships| 
 relationships.each do |related, relationship| 
 link_to person.name, person 
 link_to related.name, related 
 select_tag "people[][]", options_for_select([["()", '']]+relationship_labels, relationship.to_sym) 
 end 
 end 
 button_tag t('relationships.family.create.button'), class: 'btn btn-success' 
 end 
 end 

end

  end

  def create
    if params[:person_id]
      create_for_person
    elsif params[:family_id]
      create_for_family
    else
      render text: t('relationships.no_person_selected'), layout: true
    end
  end

  def create_for_person
    @person = Person.undeleted.find(params[:person_id])
    @related = Person.undeleted.find(Array(params[:ids]).first)
    @relationship = Relationship.new(person: @person, related: @related, name: params[:name], other_name: params[:other_name])
    respond_to do |format|
      if @relationship.save
        format.html { redirect_to person_relationships_path(@person) }
        format.xml  { render xml: @relationship, status: :created, location: person_relationship_path(@person, @relationship) }
      else
        format.html { add_errors_to_flash(@relationship); redirect_to person_relationships_path(@person) }
        format.xml  { render xml: @relationship.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_for_family
    @family = Family.undeleted.find(params[:family_id])
    params[:people].to_a.each do |person_id, relationships|
      relationships.each do |related_id, relationship|
        Relationship.create(
          person:  @family.people.find(person_id),
          related: @family.people.find(related_id),
          name:    relationship
        )
      end
    end
    redirect_to family_relationships_path(@family)
  end

  def destroy
    @person = Person.undeleted.find(params[:person_id])
    @person.relationship.find(params[:id]).destroy
    respond_to do |format|
      format.xml { head :ok }
    end
  end

  def batch
    @person = Person.undeleted.find(params[:person_id])
    params[:ids].to_a.each do |id|
      if relationship = Relationship.where("id = ? and (person_id = ? or related_id = ?)", id, @person.id, @person.id).first
        if params[:delete]
          relationship.destroy
        elsif params[:reciprocate]
          r = relationship.reciprocate
          if r.nil?
            flash[:warning] ||= ''
            flash[:warning] << t('relationships.reciprocate.failure', name: relationship.related.name) + "\n"
          elsif !r.valid?
            add_errors_to_flash(r)
          end
        end
      end
    end
    redirect_to person_relationships_path(@person)
  end

  private

    def only_admins
      unless @logged_in.admin?(:edit_profiles)
        render text: t('only_admins'), layout: true, status: 401
        return false
      end
    end

end

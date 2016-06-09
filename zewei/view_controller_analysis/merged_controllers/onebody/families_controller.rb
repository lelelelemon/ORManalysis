class FamiliesController < ApplicationController

  load_and_authorize_resource except: [:show, :batch, :select]

  def index
    respond_to do |format|
      format.html { redirect_to @logged_in }
      if can_export?
        @families = Family.order('last_name, name').paginate(page: params[:page], per_page: params[:per_page] || MAX_EXPORT_AT_A_TIME)
        format.xml do
          if @families.any?
            render xml: @families.to_xml(include: [:people], except: %w(site_id))
          else
            flash[:warning] = t('No_more_records')
            redirect_to people_path
          end
        end
      end
    end
  end

  def show
    if params[:legacy_id]
      @family = Family.where(legacy_id: params[:id]).first
    elsif params[:barcode_id]
      @family = Family.where(barcode_id: params[:id], deleted: false).first ||
        Family.where(alternate_barcode_id: params[:id], deleted: false).first
    else
      @family = Family.where(id: params[:id], deleted: false).first
    end
    raise ActiveRecord::RecordNotFound unless @family
    @people = @family.people.undeleted.to_a.select { |p| @logged_in.can_read?(p) }
    if @logged_in.can_read?(@family)
      respond_to do |format|
        format.html
        format.xml  { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('families.show.heading', family: @family.name) 
 map_header(@family) 
 if show_family_name_suggestion 
 icon 'fa fa-info-circle' 
 t('families.show.suggested_name_html', count: @family.people.undeleted.adults.count, first: @family.people.undeleted.adults.first.try(:name), second: @family.people.undeleted.adults.second.try(:name), url: edit_family_path(@family), name: @family.suggested_name) 
 end 
 if @family.updates.pending.any? and @logged_in.can_update?(@family) 
 icon 'fa fa-clock-o' 
 t('families.updates.pending_callout') 
 end 
 avatar_tag @family, size: :large, class: 'fit-width' 
 if @family.show_attribute_to?(:home_phone, @logged_in) 
 t('.table.home_phone') 
 link_to_phone @family.home_phone 
 end 
 if @family.show_attribute_to?(:address, @logged_in) 
 t('.table.address') 
 preserve_breaks @family.address 
 end 
 if anniversary = @family.anniversary_sharable_with(@logged_in) 
 t('.table.anniversary') 
 anniversary.to_s(:date_without_year) 
 end 
 @people.each_with_index do |person, person_index| 
 if @logged_in.can_reorder?(@family) 
 icon 'fa fa-reorder', style: 'color: #999' 
 end 
 link_to avatar_tag(person), person 
 link_to person.name, person 
 unless person.visible? 
 end 
 if @logged_in.can_update?(person) 
 link_to edit_person_path(person), class: 'btn bg-gray btn-xs text-yellow' do 
 icon 'fa fa-pencil' 
 end 
 end 
 if @logged_in.can_delete?(person) 
 link_to person, data: { method: 'delete', confirm: t('are_you_sure') },  class: 'btn bg-gray btn-xs text-red' do 
 icon 'fa fa-minus-circle' 
 end 
 end 
 end 
 if @logged_in.can_update?(@family) 
 link_to edit_family_path(@family), class: 'btn btn-info' do 
 icon 'fa fa-pencil' 
 t('families.show.edit_link') 
 end 
 if @logged_in.admin?(:edit_profiles) 
 link_to new_family_person_path(@family), class: 'btn btn-success' do 
 icon 'fa fa-plus-circle' 
 t('families.add.new') 
 end 
 link_to family_search_path(@family), class: 'btn btn-warning' do 
 icon 'fa fa-arrow-circle-left' 
 t('families.add.existing') 
 end 
 link_to @family, data: { method: 'delete', confirm: t('are_you_sure') }, class: 'btn btn-danger' do 
 icon 'fa fa-trash-o' 
 t('families.delete.button') 
 end 
 end 
 end 

end
 } if can_export?
        format.json { render text: @family.to_json(except: %w(site_id)) } if can_export?
        format.js do
          if params[:barcode_entry]
            ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if not @group_time 
 t('There_was_an_error') 
 elsif @group_time.errors.any? 
 escape_javascript @group_time.errors.values.join('; ') 
 else 
 dom_id(@group_time) 
 end 

end

          end
        end
      end
    else
      render text: t('families.not_found'), status: 404
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('families.show.heading', family: @family.name) 
 map_header(@family) 
 if show_family_name_suggestion 
 icon 'fa fa-info-circle' 
 t('families.show.suggested_name_html', count: @family.people.undeleted.adults.count, first: @family.people.undeleted.adults.first.try(:name), second: @family.people.undeleted.adults.second.try(:name), url: edit_family_path(@family), name: @family.suggested_name) 
 end 
 if @family.updates.pending.any? and @logged_in.can_update?(@family) 
 icon 'fa fa-clock-o' 
 t('families.updates.pending_callout') 
 end 
 avatar_tag @family, size: :large, class: 'fit-width' 
 if @family.show_attribute_to?(:home_phone, @logged_in) 
 t('.table.home_phone') 
 link_to_phone @family.home_phone 
 end 
 if @family.show_attribute_to?(:address, @logged_in) 
 t('.table.address') 
 preserve_breaks @family.address 
 end 
 if anniversary = @family.anniversary_sharable_with(@logged_in) 
 t('.table.anniversary') 
 anniversary.to_s(:date_without_year) 
 end 
 @people.each_with_index do |person, person_index| 
 if @logged_in.can_reorder?(@family) 
 icon 'fa fa-reorder', style: 'color: #999' 
 end 
 link_to avatar_tag(person), person 
 link_to person.name, person 
 unless person.visible? 
 end 
 if @logged_in.can_update?(person) 
 link_to edit_person_path(person), class: 'btn bg-gray btn-xs text-yellow' do 
 icon 'fa fa-pencil' 
 end 
 end 
 if @logged_in.can_delete?(person) 
 link_to person, data: { method: 'delete', confirm: t('are_you_sure') },  class: 'btn bg-gray btn-xs text-red' do 
 icon 'fa fa-minus-circle' 
 end 
 end 
 end 
 if @logged_in.can_update?(@family) 
 link_to edit_family_path(@family), class: 'btn btn-info' do 
 icon 'fa fa-pencil' 
 t('families.show.edit_link') 
 end 
 if @logged_in.admin?(:edit_profiles) 
 link_to new_family_person_path(@family), class: 'btn btn-success' do 
 icon 'fa fa-plus-circle' 
 t('families.add.new') 
 end 
 link_to family_search_path(@family), class: 'btn btn-warning' do 
 icon 'fa fa-arrow-circle-left' 
 t('families.add.existing') 
 end 
 link_to @family, data: { method: 'delete', confirm: t('are_you_sure') }, class: 'btn btn-danger' do 
 icon 'fa fa-trash-o' 
 t('families.delete.button') 
 end 
 end 
 end 

end

  end

  def new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('families.new.heading') 
  form_for @family, html: { multipart: true } do |form| 
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
 
 
 submit_or_save_button 
 t('families.edit.photo') 
 photo_upload_for @family do 
 family_avatar_tag @family, size: :large 
 end 
 end 
 

end

  end

  def create
    respond_to do |format|
      if @family.save
        format.html { redirect_to @family, notice: t('families.new.created.notice') }
        format.xml  { render xml: @family, status: :created, location: @family }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('families.new.heading') 
  form_for @family, html: { multipart: true } do |form| 
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
 
 
 submit_or_save_button 
 t('families.edit.photo') 
 photo_upload_for @family do 
 family_avatar_tag @family, size: :large 
 end 
 end 
 

end
 }
        format.xml  { render xml: @family.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('families.edit.heading') 
 if Setting.get(:features, :updates_must_be_approved) and not @logged_in.admin?(:edit_profiles) 
 icon 'fa fa-check-square' 
 t('people.changes_must_be_reviewed_html') 
 end 
 if @family.updates.pending.any? and @logged_in.can_update?(@family) 
 icon 'fa fa-clock-o' 
 t('people.updates.pending_callout') 
 end 
  form_for @family, html: { multipart: true } do |form| 
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
 
 
 submit_or_save_button 
 t('families.edit.photo') 
 photo_upload_for @family do 
 family_avatar_tag @family, size: :large 
 end 
 end 
 

end

  end

  def update
    @updater = FamilyUpdater.new(params)
    @family = @updater.family
    if @updater.save!
      respond_to do |format|
        format.html { flash[:notice] = t('families.edit.saved'); redirect_to params[:redirect_to] || @family }
        format.xml  { render xml: @family.to_xml } if can_export?
      end
    else
      respond_to do |format|
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('families.edit.heading') 
 if Setting.get(:features, :updates_must_be_approved) and not @logged_in.admin?(:edit_profiles) 
 icon 'fa fa-check-square' 
 t('people.changes_must_be_reviewed_html') 
 end 
 if @family.updates.pending.any? and @logged_in.can_update?(@family) 
 icon 'fa fa-clock-o' 
 t('people.updates.pending_callout') 
 end 
  form_for @family, html: { multipart: true } do |form| 
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
 
 
 submit_or_save_button 
 t('families.edit.photo') 
 photo_upload_for @family do 
 family_avatar_tag @family, size: :large 
 end 
 end 
 

end
 }
        format.xml  { render xml: @family.errors, status: :unprocessable_entity } if can_export?
        format.js do # only used by barcode entry right now
          ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if not @group_time 
 t('There_was_an_error') 
 elsif @group_time.errors.any? 
 escape_javascript @group_time.errors.values.join('; ') 
 else 
 dom_id(@group_time) 
 end 

end

        end
      end
    end
  end

  def destroy
    if @family == @logged_in.family
      flash[:warning] = t('families.delete.cannot_delete_your_own')
      redirect_to @family
    else
      @family.destroy
      redirect_to people_path
    end
  end

  def batch
    # delete family (used by Administration::DeletedPeopleController)
    if @logged_in.admin?(:edit_profiles) and params[:delete]
      params[:ids].to_a.each do |id|
        Family.find(id).destroy
      end
      redirect_back
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
  end

  def select
    @family = Family.find(params[:id]) unless params[:id].blank?
    respond_to do |format|
      format.html { redirect_to new_person_path(family_id: @family) }
      format.js
    end
  end

  private

  def family_params
    params.require(:family).permit(:legacy_id, :barcode_id, :alternate_barcode_id, :name, :last_name, :address1, :address2, :city, :state, :zip, :home_phone, :email, :share_address, :share_mobile_phone, :share_work_phone, :share_fax, :share_email, :share_birthday, :share_anniversary, :visible, :share_activity, :share_home_phone, :photo)
  end
end

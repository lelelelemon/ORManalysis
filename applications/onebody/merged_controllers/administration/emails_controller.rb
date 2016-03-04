class Administration::EmailsController < ApplicationController
  before_filter :only_admins

  def index
    @people = Person.where(email_changed: true, deleted: false).order('last_name, first_name')
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('admin.emails.changed_addresses') 
 t('admin.emails.intro_html') 
 if @people.any? 
 form_tag batch_administration_emails_path, method: :put do 
 t('admin.emails.table.id') 
 t('admin.emails.table.legacy_id') 
 t('admin.emails.table.last_name') 
 t('admin.emails.table.first_name') 
 t('admin.emails.table.email') 
 @people.each do |person| 
 check_box_tag 'ids[]', person.id, false, class: 'person_checkbox simple' 
 link_to person.id, person 
 person.legacy_id 
 person.last_name 
 person.first_name 
 person.email 
 end 
 button_tag t('admin.emails.clear_flags'), class: 'btn btn-success' 
 end 
 else 
 t('admin.emails.no_records') 
 end 

end

  end

  def batch
    params[:ids].to_a.each do |id|
      Person.find(id).update_attribute(:email_changed, false)
    end
    flash[:notice] = t('messages.flag_cleared')
    redirect_to administration_emails_path
  end

  private

    def only_admins
      unless @logged_in.admin?(:manage_updates)
        render text: t('only_admins'), layout: true, status: 401
        return false
      end
    end

end

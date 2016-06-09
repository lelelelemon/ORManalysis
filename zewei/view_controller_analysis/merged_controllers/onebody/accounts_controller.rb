class AccountsController < ApplicationController
  skip_before_filter :authenticate_user, except: %w(edit update)

  load_and_authorize_parent :person, permit: :edit, only: %w(edit update)

  def show
    if params[:person_id]
      redirect_to person_account_path(params[:person_id])
    else
      redirect_to new_account_path
    end
  end

  def new
    @verification ||= Verification.new
    if params[:forgot]
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('accounts.forgot.heading') 
  t('accounts.verify_who_you_are') 
 link_to "<i class='fa fa-envelope'></i> ".html_safe, new_account_path(email: true), class: 'btn btn-success' 
 t('accounts.verify_by_email_message') 
 link_to "<i class='fa fa-mobile'></i> ".html_safe, new_account_path(phone: true), class: 'btn btn-warning' 
 t('accounts.verify_by_phone_message') 
 link_to_phone(Setting.get(:contact, :community_office_phone), label: "<i class='fa fa-phone'></i> ".html_safe, class: 'btn btn-info') 
 t('accounts.call_office_message').html_safe 
 

end

    elsif params[:email]
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('accounts.verify_by_email') 
 t('accounts.enter_your_email') 
 form_tag account_path, method: 'post' do 
 hidden_field_tag :email, true 
 error_messages_for(@verification) 
 t('accounts.type_your_email') 
 text_field_tag 'verification[email]', params[:email] == 'true' ? '' : params[:email], class: 'form-control' 
 submit_tag t('accounts.verify_email'), class: 'btn btn-success' 
 end 

end

    elsif params[:phone]
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t('accounts.verify_by_phone') 
 t('accounts.verify_by_phone_description_html') 
 form_tag account_path, method: 'post' do 
 hidden_field_tag :phone, true 
 error_messages_for(@verification) 
 t('accounts.type_your_mobile') 
 text_field_tag 'verification[mobile_phone]', params[:phone] == 'true' ? '' : params[:phone], class: 'form-control' 
 t('accounts.select_your_carrier') 
 options_for_select MOBILE_GATEWAYS.keys, params[:carrier] 
 submit_tag t('accounts.verify_mobile'), class: 'btn btn-success' 
 end 

end

    elsif Setting.get(:features, :sign_up)
      @signup = Signup.new
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 error_messages_for(@verification) if @verification 
 if Setting.get(:features, :sign_up) 
 t('accounts.create.heading') 
 form_for @signup, as: :signup, url: account_path, method: 'post' do |form| 
 error_messages_for(form) 
 form.label :email 
 form.text_field :email, class: 'form-control' 
 form.label :first_name 
 form.text_field :first_name, class: 'form-control' 
 form.label :last_name 
 form.text_field :last_name, class: 'form-control' 
 form.label :gender 
 form.select :gender, [[t('search.male'), 'Male'], [t('search.female'), 'Female']], {include_blank: true}, class: 'form-control' 
 form.label :birthday 
 icon 'fa fa-calendar' 
 form.date_field :birthday, class: 'form-control' 
 form.label :mobile_phone 
 form.phone_field :mobile_phone, class: 'form-control' 
 form.text_field :a_phone_number, id: 'dummy_phone' 
 form.button t('accounts.create.button'), class: 'btn btn-success' 
 end 
 else 
 t('accounts.this_site_doesnt_allow_signup', office_phone: Setting.get(:contact, :community_office_phone)) 
 t('accounts.verify') 
  t('accounts.verify_who_you_are') 
 link_to "<i class='fa fa-envelope'></i> ".html_safe, new_account_path(email: true), class: 'btn btn-success' 
 t('accounts.verify_by_email_message') 
 link_to "<i class='fa fa-mobile'></i> ".html_safe, new_account_path(phone: true), class: 'btn btn-warning' 
 t('accounts.verify_by_phone_message') 
 link_to_phone(Setting.get(:contact, :community_office_phone), label: "<i class='fa fa-phone'></i> ".html_safe, class: 'btn btn-info') 
 t('accounts.call_office_message').html_safe 
 
 end 

end

    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 error_messages_for(@verification) if @verification 
 if Setting.get(:features, :sign_up) 
 t('accounts.create.heading') 
 form_for @signup, as: :signup, url: account_path, method: 'post' do |form| 
 error_messages_for(form) 
 form.label :email 
 form.text_field :email, class: 'form-control' 
 form.label :first_name 
 form.text_field :first_name, class: 'form-control' 
 form.label :last_name 
 form.text_field :last_name, class: 'form-control' 
 form.label :gender 
 form.select :gender, [[t('search.male'), 'Male'], [t('search.female'), 'Female']], {include_blank: true}, class: 'form-control' 
 form.label :birthday 
 icon 'fa fa-calendar' 
 form.date_field :birthday, class: 'form-control' 
 form.label :mobile_phone 
 form.phone_field :mobile_phone, class: 'form-control' 
 form.text_field :a_phone_number, id: 'dummy_phone' 
 form.button t('accounts.create.button'), class: 'btn btn-success' 
 end 
 else 
 t('accounts.this_site_doesnt_allow_signup', office_phone: Setting.get(:contact, :community_office_phone)) 
 t('accounts.verify') 
  t('accounts.verify_who_you_are') 
 link_to "<i class='fa fa-envelope'></i> ".html_safe, new_account_path(email: true), class: 'btn btn-success' 
 t('accounts.verify_by_email_message') 
 link_to "<i class='fa fa-mobile'></i> ".html_safe, new_account_path(phone: true), class: 'btn btn-warning' 
 t('accounts.verify_by_phone_message') 
 link_to_phone(Setting.get(:contact, :community_office_phone), label: "<i class='fa fa-phone'></i> ".html_safe, class: 'btn btn-info') 
 t('accounts.call_office_message').html_safe 
 
 end 

end

    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 error_messages_for(@verification) if @verification 
 if Setting.get(:features, :sign_up) 
 t('accounts.create.heading') 
 form_for @signup, as: :signup, url: account_path, method: 'post' do |form| 
 error_messages_for(form) 
 form.label :email 
 form.text_field :email, class: 'form-control' 
 form.label :first_name 
 form.text_field :first_name, class: 'form-control' 
 form.label :last_name 
 form.text_field :last_name, class: 'form-control' 
 form.label :gender 
 form.select :gender, [[t('search.male'), 'Male'], [t('search.female'), 'Female']], {include_blank: true}, class: 'form-control' 
 form.label :birthday 
 icon 'fa fa-calendar' 
 form.date_field :birthday, class: 'form-control' 
 form.label :mobile_phone 
 form.phone_field :mobile_phone, class: 'form-control' 
 form.text_field :a_phone_number, id: 'dummy_phone' 
 form.button t('accounts.create.button'), class: 'btn btn-success' 
 end 
 else 
 t('accounts.this_site_doesnt_allow_signup', office_phone: Setting.get(:contact, :community_office_phone)) 
 t('accounts.verify') 
  t('accounts.verify_who_you_are') 
 link_to "<i class='fa fa-envelope'></i> ".html_safe, new_account_path(email: true), class: 'btn btn-success' 
 t('accounts.verify_by_email_message') 
 link_to "<i class='fa fa-mobile'></i> ".html_safe, new_account_path(phone: true), class: 'btn btn-warning' 
 t('accounts.verify_by_phone_message') 
 link_to_phone(Setting.get(:contact, :community_office_phone), label: "<i class='fa fa-phone'></i> ".html_safe, class: 'btn btn-info') 
 t('accounts.call_office_message').html_safe 
 
 end 

end

  end

  def create
    if params[:signup]
      @signup = Signup.new(params[:signup])
      if @signup.save
        if @signup.approval_sent?
          render text: t('accounts.pending_approval'), layout: true
        elsif @signup.verification_sent?
          if @signup.found_existing?
            flash.now[:notice] = t('accounts.create.existing_account.by_email')
          end
          render text: t('accounts.verification_email_sent'), layout: true
        elsif @signup.can_verify_mobile?
          flash[:notice] = t('accounts.create.existing_account.by_mobile')
          redirect_to new_account_path(phone: @signup.mobile_phone)
        end
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 error_messages_for(@verification) if @verification 
 if Setting.get(:features, :sign_up) 
 t('accounts.create.heading') 
 form_for @signup, as: :signup, url: account_path, method: 'post' do |form| 
 error_messages_for(form) 
 form.label :email 
 form.text_field :email, class: 'form-control' 
 form.label :first_name 
 form.text_field :first_name, class: 'form-control' 
 form.label :last_name 
 form.text_field :last_name, class: 'form-control' 
 form.label :gender 
 form.select :gender, [[t('search.male'), 'Male'], [t('search.female'), 'Female']], {include_blank: true}, class: 'form-control' 
 form.label :birthday 
 icon 'fa fa-calendar' 
 form.date_field :birthday, class: 'form-control' 
 form.label :mobile_phone 
 form.phone_field :mobile_phone, class: 'form-control' 
 form.text_field :a_phone_number, id: 'dummy_phone' 
 form.button t('accounts.create.button'), class: 'btn btn-success' 
 end 
 else 
 t('accounts.this_site_doesnt_allow_signup', office_phone: Setting.get(:contact, :community_office_phone)) 
 t('accounts.verify') 
  t('accounts.verify_who_you_are') 
 link_to "<i class='fa fa-envelope'></i> ".html_safe, new_account_path(email: true), class: 'btn btn-success' 
 t('accounts.verify_by_email_message') 
 link_to "<i class='fa fa-mobile'></i> ".html_safe, new_account_path(phone: true), class: 'btn btn-warning' 
 t('accounts.verify_by_phone_message') 
 link_to_phone(Setting.get(:contact, :community_office_phone), label: "<i class='fa fa-phone'></i> ".html_safe, class: 'btn btn-info') 
 t('accounts.call_office_message').html_safe 
 
 end 

end

      end
    elsif params[:verification]
      @verification = Verification.new(verification_params)
      if @verification.save
        if params[:phone]
          flash[:notice] = t('accounts.verification_message_sent')
          ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t('accounts.verify_code_intro') 
 form_tag verify_code_account_path, id: 'verify-form' do 
 hidden_field_tag :id, @verification.id 
 t('accounts.enter_code') 
 text_field_tag :code, params[:code], class: 'form-control' 
 submit_tag t('accounts.check_code'), class: 'btn btn-success' 
 end 
 if params[:code].present? 
 end 

end

        elsif params[:via_admin]
          flash[:warning] = t('accounts.verification.email.via_admin')
          redirect_to @verification.people.first
        else
          render text: t('accounts.verification_email_sent'), layout: true
        end
      else
        new
      end
    else
      @signup = Signup.new
      flash[:warning] = t('accounts.fill_required_fields')
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 error_messages_for(@verification) if @verification 
 if Setting.get(:features, :sign_up) 
 t('accounts.create.heading') 
 form_for @signup, as: :signup, url: account_path, method: 'post' do |form| 
 error_messages_for(form) 
 form.label :email 
 form.text_field :email, class: 'form-control' 
 form.label :first_name 
 form.text_field :first_name, class: 'form-control' 
 form.label :last_name 
 form.text_field :last_name, class: 'form-control' 
 form.label :gender 
 form.select :gender, [[t('search.male'), 'Male'], [t('search.female'), 'Female']], {include_blank: true}, class: 'form-control' 
 form.label :birthday 
 icon 'fa fa-calendar' 
 form.date_field :birthday, class: 'form-control' 
 form.label :mobile_phone 
 form.phone_field :mobile_phone, class: 'form-control' 
 form.text_field :a_phone_number, id: 'dummy_phone' 
 form.button t('accounts.create.button'), class: 'btn btn-success' 
 end 
 else 
 t('accounts.this_site_doesnt_allow_signup', office_phone: Setting.get(:contact, :community_office_phone)) 
 t('accounts.verify') 
  t('accounts.verify_who_you_are') 
 link_to "<i class='fa fa-envelope'></i> ".html_safe, new_account_path(email: true), class: 'btn btn-success' 
 t('accounts.verify_by_email_message') 
 link_to "<i class='fa fa-mobile'></i> ".html_safe, new_account_path(phone: true), class: 'btn btn-warning' 
 t('accounts.verify_by_phone_message') 
 link_to_phone(Setting.get(:contact, :community_office_phone), label: "<i class='fa fa-phone'></i> ".html_safe, class: 'btn btn-info') 
 t('accounts.call_office_message').html_safe 
 
 end 

end

    end
  end

  def verify_code
    @verification = Verification.find(params[:id])
    if not @verification.pending?
      render text: t('accounts.verification.not_pending', url: new_account_path(forgot: true)), layout: true
    elsif request.post?
      if @verification.check!(params[:code])
        redirect_for_verification
      else
        render text: t('accounts.wrong_code_html'), layout: true, status: :bad_request
      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t('accounts.verify_code_intro') 
 form_tag verify_code_account_path, id: 'verify-form' do 
 hidden_field_tag :id, @verification.id 
 t('accounts.enter_code') 
 text_field_tag :code, params[:code], class: 'form-control' 
 submit_tag t('accounts.check_code'), class: 'btn btn-success' 
 end 
 if params[:code].present? 
 end 

end

  end

  def edit
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = @person.name 
 form_for @person, url: person_account_path(@person) do |form| 
 error_messages_for(form) 
 form.label :person_email, t('accounts.email_address') 
 form.text_field :email, class: 'form-control' 
 form.label :person_password, t('accounts.password') 
 form.password_field :password, class: 'form-control' 
 if @person.encrypted_password 
 t('accounts.leave_blank') 
 end 
 form.label :password_confirmation, t('accounts.password_confirm') 
 form.password_field :password_confirmation, class: 'form-control' 
 submit_tag t('save_changes'), class: 'btn btn-success' 
 end 

end

  end

  def update
    if @person.update_attributes(person_params)
      flash[:notice] = t('Changes_saved')
      redirect_to @person
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = @person.name 
 form_for @person, url: person_account_path(@person) do |form| 
 error_messages_for(form) 
 form.label :person_email, t('accounts.email_address') 
 form.text_field :email, class: 'form-control' 
 form.label :person_password, t('accounts.password') 
 form.password_field :password, class: 'form-control' 
 if @person.encrypted_password 
 t('accounts.leave_blank') 
 end 
 form.label :password_confirmation, t('accounts.password_confirm') 
 form.password_field :password_confirmation, class: 'form-control' 
 submit_tag t('save_changes'), class: 'btn btn-success' 
 end 

end

    end
  end

  def select
    if session[:select_from_people]
      @people = session[:select_from_people]
      if request.post? and @person = @people.detect { |p| p.id == params[:id].to_i }
        session[:logged_in_id] = @person.id
        session[:select_from_people] = nil
        flash[:warning] = t('accounts.must_set_email_pass')
        redirect_to edit_person_account_path(@person)
      end
    else
      render text: t('Page_no_longer_valid'), layout: true, status: :gone
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t('accounts.please_select_your_name') 
 form_tag do 
 @people.each do |person| 
 radio_button_tag :id, person.id, false, class: "checkbox", id: "person_" 
 person.name 
 end 
 submit_tag t('accounts.I_am_this_person'), class: 'btn btn-success' 
 end 

end

  end

  private

  def redirect_for_verification
    if @verification.people.count > 1
      session[:select_from_people] = @verification.people.to_a
      redirect_to select_account_path
    else
      person = @verification.people.first
      session[:logged_in_id] = person.id
      flash[:warning] = if @verification.mobile_phone?
        t('accounts.set_your_email')
      else
        t('accounts.set_your_email_may_be_different')
      end
      redirect_to edit_person_account_path(person)
    end
  end

  def verification_params
    params.require(:verification).permit(:email, :mobile_phone, :carrier)
  end

  def person_params
    params.require(:person).permit(:email, :password, :password_confirmation)
  end

  def check_ssl
    unless request.ssl? or !Rails.env.production? or !Setting.get(:features, :ssl)
      redirect_to protocol: 'https://', from: params[:from]
      return
    end
  end
end

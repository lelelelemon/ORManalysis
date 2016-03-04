class CheckoutAccountsController < ApplicationController
  before_filter do |controller|
    controller.ensure_logged_in "You need to be logged in in order to change payment details."
  end

  CheckoutAccountForm = FormUtils.define_form("CheckoutAccountForm", :company_id_or_personal_id, :organization_address, :phone_number, :organization_website)
    .with_validations do
      validates_presence_of :organization_address, :phone_number
      validates_format_of :company_id_or_personal_id, with: /^(\d{7}\-\d)$|^(\d{6}\D\d{3}\w)$/, allow_nil: false
    end

  def new
    redirect_to action: :show and return if @current_user.checkout_account

    @selected_left_navi_link = "payments"
    render(locals: { checkout_account: CheckoutAccountForm.new({ phone_number: @current_user.phone_number }),
                     form_action: person_checkout_account_path(@current_user) })
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  
 content_for :javascript do 
 end 
 t("organizations.form.merhcant_registration_detailed_instructions", locale: :fi).html_safe 
 form_for checkout_account, url: form_action, :html => { :id => "payment_settings_form"} do |form| 
 hidden_field_tag :payment_settings, true 
 form.label :company_id_or_personal_id, t("organizations.form.company_id_or_personal_id", locale: :fi), :class => "input" 
 form.text_field :company_id_or_personal_id, :class => :text_field, :maxlenght => "11" 
 form.label :organization_address, t("organizations.form.organization_address", locale: :fi), :class => "input" 
 form.text_field :organization_address, :class => :text_field 
 form.label :phone_number, t("organizations.form.phone_number", locale: :fi) 
 form.text_field :phone_number, :class => "text_field", :maxlength => "25" 
 form.label :organization_website, t("organizations.form.organization_website", locale: :fi), :class => "input" 
 form.text_field :organization_website, :class => :text_field 
 form.button t("settings.save_information", locale: :fi), :class => "send_button" 
 end 

end

  end

  def show
    redirect_to action: :new and return unless @current_user.checkout_account

    @selected_left_navi_link = "payments"
    render(locals: {person: @current_user})
  end

  def create
    checkout_account_form = CheckoutAccountForm.new(params[:checkout_account_form])

    if checkout_account_form.valid?
      payment_gateway = @current_community.payment_gateway
      # If updating payout details, check that they are valid
      registering_successful = payment_gateway.register_payout_details(@current_user, checkout_account_form)
      redirect_to action: :show
    else
      flash[:error] = checkout_account_form.errors.full_messages
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  
 content_for :javascript do 
 end 
 t("organizations.form.merhcant_registration_detailed_instructions", locale: :fi).html_safe 
 form_for checkout_account, url: form_action, :html => { :id => "payment_settings_form"} do |form| 
 hidden_field_tag :payment_settings, true 
 form.label :company_id_or_personal_id, t("organizations.form.company_id_or_personal_id", locale: :fi), :class => "input" 
 form.text_field :company_id_or_personal_id, :class => :text_field, :maxlenght => "11" 
 form.label :organization_address, t("organizations.form.organization_address", locale: :fi), :class => "input" 
 form.text_field :organization_address, :class => :text_field 
 form.label :phone_number, t("organizations.form.phone_number", locale: :fi) 
 form.text_field :phone_number, :class => "text_field", :maxlength => "25" 
 form.label :organization_website, t("organizations.form.organization_website", locale: :fi), :class => "input" 
 form.text_field :organization_website, :class => :text_field 
 form.button t("settings.save_information", locale: :fi), :class => "send_button" 
 end 

end

    end
  end
end
class SetupsController < ApplicationController

  skip_before_filter :authenticate_user
  before_filter :check_setup_requirements

  layout 'signed_out'

  def show
    redirect_to new_setup_path
  end

  def new
    @person = Person.new
    @host = URI.parse(request.url).host
    @host = nil if @host =~ /\A(localhost|\d+\.\d+\.\d+\.\d+)\z/
 t('setup.heading') 
 form_for @person, url: setup_path, method: 'POST', html: { role: 'form' } do |form| 
 t('setup.congratulations') 
 t('setup.do_right_away') 
 error_messages_for(form) 
 t('setup.domain_name') 
 text_field_tag 'domain_name', @host, class: 'form-control' 
 t('setup.domain_name_note') 
 t('setup.admin_account') 
 t('setup.more_accounts_later') 
 t('setup.first_name') 
 form.text_field :first_name, class: 'form-control' 
 t('setup.last_name') 
 form.text_field :last_name, class: 'form-control' 
 t('setup.email') 
 form.text_field :email, class: 'form-control' 
 t('setup.password') 
 form.password_field :password, class: 'form-control' 
 t('setup.password_confirmation') 
 form.password_field :password_confirmation, class: 'form-control' 
 button_tag t('setup.submit_button_html'), class: 'btn btn-success' 
 end 

  end

  def create
    @setup = Setup.new(params.permit!)
    if @setup.execute!
      flash[:notice] = t('setup.complete_html', url: admin_path).html_safe
      session[:logged_in_id] = @setup.person.id
      redirect_to root_path
    else
      @person = @setup.person
      render action: 'new'
    end
  end

  private

    def check_setup_requirements
      if Person.count > 0
        render text: t('not_authorized'), layout: true
        return false
      end
    end

end

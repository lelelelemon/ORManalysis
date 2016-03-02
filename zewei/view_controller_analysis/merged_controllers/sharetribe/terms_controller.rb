class TermsController < ApplicationController

  layout :choose_layout

  def show
    redirect_to root_path and return unless session[:temp_cookie]
    @current_community = Community.find(session[:temp_community_id])
    @current_user = nil
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :javascript do 
 end 
 if session[:consent_changed] 
 t('.terms_have_changed') 
 t('.you_need_to_accept_new_terms') 
 t('.you_can_view_the_new_terms') 
 link_to(t(".here"), "#", :id => "terms_link") + "." 
 form_tag accept_terms_path do 
 button_tag t('.i_accept_new_terms') 
 end 
 else 
 t('.accept_terms') 
 t('.you_need_to_accept') 
 link_to(t(".terms"), "#", :id => "terms_link") + "." 
 form_tag accept_terms_path do 
 submit_tag(t('.i_accept_terms'), :class => "send_button_terms") 
 end 
 end 
  render :layout => "layouts/lightbox", locals: {id: field, field: field} do 
 unless field.eql?("terms") 
 t("people.help_texts.#{field}_title") 
 end 
 render :partial => "people/help_texts/#{field}" 
 end 
 

end

  end

  def accept
    if session[:consent_changed]
      @current_user = Person.find_by_id(session[:temp_person_id])
      @current_community = Community.find(session[:temp_community_id])
      @current_community_membership = CommunityMembership.find_by_person_id_and_community_id(@current_user.id, @current_community.id)
      @current_community_membership.update_attribute(:consent, @current_community.consent)
      @grid_class = params[:private_community] ? "grid_6 prefix_3 suffix_3" : "grid_10 prefix_7 suffix_7"
    else
      # This situation can occur when the users clicks the back button
      # of the browser after accepting new terms, returns to the acceptance
      # form and clicks the accept button again. In that case an error page is shown.
      unless session[:temp_person_id]
        ApplicationHelper.send_error_notification("User tried to accept the new terms again. Showing an error page.", "Duplicate-acceptance-of-terms error", params)
        render :file => "public/404.html", :layout => false and return
      end
      @current_user = Person.add_to_kassi_db(session[:temp_person_id])
      @current_user.set_default_preferences
      @current_user.update_attribute(:locale, (params[:locale] || APP_CONFIG.default_locale))
      @current_user.communities << @current_community
    end

    sign_in @current_user
    session[:person_id] = session[:temp_person_id]
    session[:temp_cookie] = session[:temp_person_id] = nil
    session[:temp_community_id] = nil
    session[:consent_changed] = nil
    flash[:notice] = t("layouts.notifications.login_successful", :person_name => view_context.link_to(@current_user.given_name_or_username, person_path(@current_user))).html_safe
    redirect_to (session[:return_to] || root)
  end

  private

  def choose_layout
    if @current_community.private
      'private'
    else
      'application'
    end
  end

end

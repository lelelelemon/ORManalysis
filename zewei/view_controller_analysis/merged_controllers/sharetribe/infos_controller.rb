class InfosController < ApplicationController

  skip_filter :check_email_confirmation

  def about
    @selected_tribe_navi_tab = "about"
    @selected_left_navi_link = "about"
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  
 content_for :title, t('layouts.infos.about') 
 content_for :title_header do 
 t("layouts.infos.info_about_kassi") 
 end 
 render :layout => "layouts/mercury_editable_page", :locals => { :content_type => "about_page_content" } do 
 if @community_customization && @community_customization.about_page_content 
 content = @community_customization.about_page_content.html_safe 
 else 
 content = render :partial => "default_about_page" 
 end 
 content_for :meta_description, StringUtils.first_words(strip_tags(content.html_safe)) 
 content_for :keywords, StringUtils.keywords(strip_tags(content.html_safe)) 
 content 
 end 

end

  end

  def how_to_use
    @selected_tribe_navi_tab = "about"
    @selected_left_navi_link = "how_to_use"
    if @community_customization && !@community_customization.how_to_use_page_content.nil?
      content = @community_customization.how_to_use_page_content.html_safe
    else
      content = MarketplaceService::API::Marketplaces::Helper.how_to_use_page_default_content(I18n.locale, @current_community.name(I18n.locale))
    end
    render locals: { how_to_use_content: content }
  end

  def terms
    @selected_tribe_navi_tab = "about"
    @selected_left_navi_link = "terms"
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  
 content_for :title do 
 t('layouts.infos.terms') 
 end 
 content_for :title_header do 
 t("layouts.infos.info_about_kassi") 
 end 
  content = "" 
 if @current_community.payment_gateway && @current_community.payment_gateway.has_additional_terms_of_use 
 content +=  content_for :javascript do 
 end 
 t("payments.#{gateway_name}.terms.#{gateway_name}_terms_also_included", :terms_link_text => link_to(t("payments.#{gateway_name}.terms.terms_link_text"), "#", :tabindex => "-1", :id => "#{gateway_name}_terms_link")).html_safe 
  render :layout => "layouts/lightbox", locals: {id: "#{gateway_name}_terms", gateway_name: gateway_name} do 
 text_with_line_breaks do 
 render :partial => "payments/#{gateway_name}/terms" 
 end 
 end 
 
 
 end 
 content += render :layout => "layouts/mercury_editable_page", :locals => { :content_type => "terms_page_content" } do 
 if @community_customization && @community_customization.terms_page_content 
 @community_customization.terms_page_content.html_safe 
 elsif File.exists?("app/views/infos/localized_terms/terms.#{I18n.locale}.haml") 
 render :file => "infos/localized_terms/terms.#{I18n.locale}" 
 else 
 render :file => "infos/localized_terms/terms.en" 
 end 
 end 
 content_for :meta_description, StringUtils.first_words(strip_tags(content.html_safe)) 
 content_for :keywords, StringUtils.keywords(strip_tags(content.html_safe)) 
 content.html_safe 
 

end

  end

  def privacy
    @selected_tribe_navi_tab = "about"
    @selected_left_navi_link = "privacy"
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  
 content_for :title, t('layouts.infos.register_details') 
 content_for :title_header do 
 t("layouts.infos.info_about_kassi") 
 end 
 render :layout => "layouts/mercury_editable_page", :locals => { :content_type => "privacy_page_content" } do 
 if @community_customization && @community_customization.privacy_page_content 
 content = @community_customization.privacy_page_content.html_safe 
 elsif File.exists?("app/views/infos/localized_privacy_policy/privacy_policy.#{I18n.locale}.haml") 
 content = render :file => "infos/localized_privacy_policy/privacy_policy.#{I18n.locale}" 
 else 
 content = render :file => "infos/localized_privacy_policy/privacy_policy.en" 
 end 
 content_for :meta_description, StringUtils.first_words(strip_tags(content.html_safe)) 
 content_for :keywords, StringUtils.keywords(strip_tags(content.html_safe)) 
 content 
 end 

end

  end

  private

  def how_to_use_content?
    Maybe(@community_customization).map { |customization| !customization.how_to_use_page_content.nil? }
  end
end

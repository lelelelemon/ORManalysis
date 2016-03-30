class Admin::ConfigurationsController < AdminController
  before_action :find_configuration

  def show
    redirect_to edit_admin_configuration_url
  end

  def edit
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 [@page_title,Sugar.config.forum_name].compact.join(' - ') 
 stylesheet_link_tag "application" 
 if current_user? && current_user.mobile_stylesheet_url? 
 stylesheet_link_tag current_user.mobile_stylesheet_url 
 else 
 stylesheet_link_tag @theme.mobile_stylesheet_path 
 end 
 icon_tags 
 csrf_meta_tag 
 link_to "", "#", class: (current_user? && current_user.unread_conversations? ? 'new toggle-navigation' : 'toggle-navigation') 
 if @page_title 
 link_to "#{Sugar.config.forum_short_name}:", discussions_path 
 @page_title 
 else 
 link_to "#{Sugar.config.forum_short_name}", discussions_path 
 end 
 if current_user? || Sugar.public_browsing? 
 link_to "Discussions", discussions_path 
 if current_user? 
 link_to "Popular", popular_discussions_path 
 link_to "Following", following_discussions_path 
 link_to "Favorites", favorites_discussions_path 
 if current_user.unread_conversations? 
 link_to "Conversations", conversations_path 
 else 
 link_to "Conversations", conversations_path 
 end 
 end 
 link_to "Users", users_path 
 if current_user? 
 link_to "New discussion", new_discussion_path 
 if @exchange && !@exchange.new_record? && @exchange.editable_by?(current_user) 
 link_to "Edit discussion", edit_discussion_path(@exchange) 
 end 
 link_to "Log out", logout_users_path, confirm: "Are you sure you want to log out?" 
 end 
 form_tag((@search_path || search_path), method: 'get') do 
 text_field_tag 'q', @search_query, class: :query 
 select_tag 'search_mode', options_for_select(
            search_mode_options,
            @search_path || search_path
          ) 
 submit_tag "Go", name: nil 
 end 
 end 
 if flash[:notice] 
 raw flash[:notice] 
 end 
 
  add_body_class "admin configuration"
  @page_title = t('configuration.configuration')

 link_to t('admin'), admin_path 
 link_to t('configuration.configuration'), admin_configuration_path 
 t('configuration.general_settings') 
 t('configuration.themes') 
 t('configuration.services_and_integration') 
 t('configuration.customization') 
 form_for Sugar.config, url: admin_configuration_path, method: :patch, builder: Sugar::FormBuilder do |f| 
 t('configuration.forum_name') 
 f.labelled_text_field :forum_name, size: 48 
 f.labelled_text_field :forum_title, size: 48, description: t('configuration.forum_title_description') 
 f.labelled_text_field :forum_short_name, size: 10, description: t('configuration.forum_short_name_description') 
 t('configuration.domain_and_email') 
 f.labelled_text_field :domain_names, size: 48, description: t('configuration.domain_names_description') 
 f.labelled_text_field :mail_sender, size: 48, description: t('configuration.mail_sender_description') 
 t('configuration.login_and_signup') 
 t('configuration.access_control') 
 f.radio_button :public_browsing, true 
 t('configuration.anyone_can_browse') 
 f.radio_button :public_browsing, false 
 t('configuration.browsing_requires_login') 
 t('configuration.signing_up') 
 f.radio_button :signups_allowed, true 
 t('configuration.users_can_sign_up') 
 f.radio_button :signups_allowed, false 
 t('configuration.users_must_be_invited') 
 t('configuration.themes') 
 f.labelled_select :default_theme, Theme.all.map{|t| [t.full_name, t.id]} 
 f.labelled_select :default_mobile_theme, Theme.mobile.map{|t| [t.full_name, t.id]} 
 t('configuration.google_analytics') 
 f.labelled_text_field :google_analytics, description: t('configuration.google_analytics_description') 
 t('configuration.facebook') 
 t('configuration.facebook_description', link: link_to(t('configuration.facebook_apps_link'), 'http://www.facebook.com/developers')).html_safe 
 f.labelled_text_field :facebook_app_id, size: 48 
 f.labelled_text_field :facebook_api_secret, size: 48 
 t('configuration.amazon_aws') 
 t('configuration.amazon_aws_description', link: link_to(t('configuration.amazon_signup_link'), 'http://aws.amazon.com/s3/')).html_safe 
 f.labelled_text_field :amazon_aws_key, size: 48 
 f.labelled_text_field :amazon_aws_secret, size: 48 
 f.labelled_text_field :amazon_s3_bucket, size: 48 
 t('configuration.amazon_associates') 
 f.labelled_text_field :amazon_associates_id, description: t('configuration.amazon_associates_id_description') 
 t('configuration.flickr') 
 f.labelled_text_field :flickr_api, description: t('configuration.flickr_api_description') 
 t('configuration.emoticons') 
 f.labelled_text_field :emoticons, size: 48 
 t('configuration.custom_html') 
 f.labelled_text_area :custom_header, size: '40x15', class: 'code', description: t('configuration.custom_header_description') 
 f.labelled_text_area :custom_footer, size: '40x15', class: 'code', description: t('configuration.custom_footer_description') 
 t('configuration.custom_javascript') 
 t('configuration.custom_javascript_info').html_safe 
 f.labelled_text_area :custom_javascript, size: '40x15', class: 'code' 
 t('save') 
 end 
 link_to "Discussions", discussions_path 
 if current_user? 
 link_to "Following", following_discussions_path 
 link_to "Favorites", favorites_discussions_path 
 end 
 link_to "Regular site", {mobile_format: 'html'}, class: 'regular_site' 
 javascript_include_tag "mobile" 
 frontend_configuration.to_json.html_safe 
 if @posts && @posts.any? 
 end 
 if Sugar.config.google_analytics 
 Sugar.config.google_analytics 
 end 

end

  end

  def update
    if configuration_params
      @configuration.update(configuration_params)
    end
    redirect_to edit_admin_configuration_url
  end

  protected

  def configuration_params
    params[:configuration]
  end

  def find_configuration
    @configuration = Sugar.config
  end
end

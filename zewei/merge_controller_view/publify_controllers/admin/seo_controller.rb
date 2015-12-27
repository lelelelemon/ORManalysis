class Admin::SeoController < Admin::BaseController
  cache_sweeper :blog_sweeper
  before_action :set_setting
  before_action :set_section

  def show
    if @setting.permalink_format != '/%year%/%month%/%day%/%title%' &&
        @setting.permalink_format != '/%year%/%month%/%title%' &&
        @setting.permalink_format != '/%title%'
      @setting.custom_permalink = @setting.permalink_format
      @setting.permalink_format = 'custom'
    end
 content_for :page_heading do 

      case @section
      when 'titles' then t(".title_settings")
      when 'permalinks' then t(".permalinks")
      else t(".global_settings")
      end
    
 end 
 error_messages_for 'blog' 
 form_tag admin_seo_path, method: :put do 

    case @section
    when 'titles' then ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 t(".home") 
 t(".title_template") 
 text_field(:setting, :home_title_template, { :class => 'form-control'})
 t(".description_template") 
 text_area(:setting, :home_desc_template, :rows => 3, :class => 'form-control') 
 t(".articles") 
 t(".title_template") 
 text_field(:setting, :article_title_template, { :class => 'form-control'}) 
 t(".description_template") 
 text_area(:setting, :article_desc_template, :rows => 3, :class => 'form-control') 
 t(".pages") 
 t(".title_template") 
 text_field(:setting, :page_title_template, { :class => 'form-control'}) 
 t(".description_template") 
 text_area(:setting, :page_desc_template, :rows => 3, :class => 'form-control') 
 t(".paginated_archives") 
 t(".title_template") 
 text_field(:setting, :paginated_title_template, { :class => 'form-control'}) 
 t(".description_template") 
 text_area(:setting, :paginated_desc_template, :rows => 3, :class => 'form-control') 
 t(".dated_archives") 
 t(".title_template") 
 text_field(:setting, :archives_title_template, { :class => 'form-control'}) 
 t(".description_template") 
 text_area(:setting, :archives_desc_template, :rows => 3, :class => 'form-control') 
 t(".author_page") 
 t(".title_template") 
 text_field(:setting, :author_title_template, { :class => 'form-control'}) 
 t(".description_template") 
 text_area(:setting, :author_desc_template, :rows => 3, :class => 'form-control') 
 t(".search_results") 
 t(".title_template") 
 text_field(:setting, :search_title_template, { :class => 'form-control'}) 
 t(".description_template") 
 text_area(:setting, :search_desc_template, :rows => 3, :class => 'form-control') 
 t(".short_statuses_lists") 
 t(".title_template") 
 text_field(:setting, :statuses_title_template, { :class => 'form-control'}) 
 t(".description_template") 
 text_area(:setting, :statuses_desc_template, :rows => 3, :class => 'form-control') 
 t(".short_statuses") 
 t(".title_template") 
 text_field(:setting, :status_title_template, { :class => 'form-control'}) 
 t(".description_template") 
 text_area(:setting, :status_desc_template, :rows => 3, :class => 'form-control') 
 t(".help_on_title_settings")
 t(".these_tags_can_be_included") 
 t(".replaced_with_the_title_of_the_article_page") 
 t(".the_blog_s_name") 
 t(".the_blog_s_tagline_description") 
 t(".replaced_with_the_post_page_excerpt") 
 t(".replaced_with_the_article_tags") 
 t(".replaced_with_the_article_categories") 
 t(".replaced_with_the_article_page_title") 
 t(".replaced_with_the_category_tag_name") 
 t(".replaced_with_the_current_search_phrase") 
 t(".replaced_with_the_current_time") 
 t(".replaced_with_the_current_date") 
 t(".replaced_with_the_current_month") 
 t(".replaced_with_the_current_year") 
 t(".replaced_with_the_current_page_number") 
 t(".replaced_by_the_archive_date") 
 t(".replaced_by_the_content_body") 

end

    when 'permalinks' then ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 t(".explain") 
 t(".sample") 
 t(".permalink_format") 
 radio_button(:setting, :permalink_format, '/%year%/%month%/%day%/%title%') 
 t(".date_and_title") 
 "#{this_blog.base_url}/#{Time.now.strftime('%Y/%m/%d')}/sample-article" 
 radio_button(:setting, :permalink_format, '/%year%/%month%/%title%') 
 t(".month_and_title") 
 "#{this_blog.base_url}/#{Time.now.strftime('%Y/%m')}/sample-article" 
 radio_button(:setting, :permalink_format, '/%title%') 
 t(".title_only") 
 "#{this_blog.base_url}/sample-article" 
 radio_button(:setting, :permalink_format, 'custom') 
 t(".custom") 
 text_field(:setting, :custom_permalink, { :class => 'form-control'}) 
 t(".help_on_permalink_settings") 
 t(".you_can_custom_your_url_structure") 
 t(".your_article_slug") 
 t(".your_article_year") 
 t(".your_article_month") 
 t(".your_article_day") 

end

    else ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 t(".general_settings") 
 t(".meta_keywords")
 check_box(:setting, :use_meta_keyword)
 t(".use_meta_keywords")
 text_area(:setting, :meta_keywords, rows: 3, class: 'form-control') 
 t(".meta_description")
 text_area(:setting, :meta_description, rows: 3, class: 'form-control') 
 t(".use_rss_description") 
 check_box(:setting, :rss_description) 
 t(".use_rss_description") 
 t('.this_will_display') 
 show_rss_description 
 t(".rss_description_message") 
 text_area(:setting, :rss_description_text, rows: 10, class: 'form-control') 
 t('.explain_rss_description') 
 t(".indexing") 
 t(".indexing") 
 check_box(:setting, :unindex_tags) 
 t(".do_not_index_tags")
 t(".explain_tag_index") 
 t(".robots_txt") 
 text_area(:setting, :robots, rows: 10, class: 'form-control') 
 t(".dofollow") 
 t(".use_dofollow_in_comments") 
 check_box(:setting, :dofollowify) 
 t(".explain_moderate_feedback") 
 t(".canonical_url") 
 check_box(:setting, :use_canonical_url) 
 t(".use_canonical_url")
 t(".read_more_about", link: link_to("rel='canonical'", "http://support.google.com/webmasters/bin/answer.py?hl=en&answer=139394")) 
 t(".human") 
 t(".humans_txt") 
 text_area(:setting, :humans, rows: 10, class: 'form-control') 
 t(".explain_humans_txt") 
 t(".google") 
 t(".google_analytics") 
 text_field(:setting, :google_analytics, class: 'form-control') 
 t(".google_webmaster_tools_validation_link") 
 text_field(:setting, :google_verification, class: 'form-control') 
 t(".custom_tracking_code") 
 text_area(:setting, :custom_tracking_field, rows: 3, class: 'form-control') 
 t(".explain") 

end

    end
  
 hidden_field_tag 'section', @section 
 link_to(t(".cancel"), admin_seo_path(section: @section)) 
 t(".or") 
 submit_tag(t(".update_settings"), class: 'btn btn-success') 
 end 

  end

  def update
    if settings_params[:permalink_format] == 'custom'
      settings_params[:permalink_format] = settings_params[:custom_permalink]
    end
    if @setting.update_attributes(settings_params)
      flash[:success] = I18n.t('admin.settings.update.success')
      redirect_to admin_seo_path(section: @section)
    else
      flash[:error] = I18n.t('admin.settings.update.error',
                             messages: this_blog.errors.full_messages.join(', '))
      render :show
    end
  end

  private

  def settings_params
    @settings_params ||= params.require(:setting).permit!
  end

  VALID_SECTIONS = %w(general titles permalinks)

  def set_section
    section = params[:section]
    @section = VALID_SECTIONS.include?(section) ? section : 'general'
  end

  def set_setting
    @setting = this_blog
  end
end

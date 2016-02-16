require 'open-uri'
require 'time'
require 'rexml/document'

class Admin::ThemesController < Admin::BaseController
  cache_sweeper :blog_sweeper

  def index
    @themes = Theme.find_all
    @themes.each do |theme|
      # TODO: Move to Theme
      theme.description_html = TextFilter.filter_text(this_blog, theme.description, nil, [:markdown, :smartypants]).html_safe
    end
    @active = this_blog.current_theme
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :page_heading do 
 t(".choose_a_theme") 
 end 
 for theme in @themes 
 preview_url = url_for(action: 'preview', theme: theme.name) 
 switch_url = url_for(action: 'switchto', theme: theme.name) 
 if theme.path == @active.path 
 t(".active_theme", name: theme.name) 
 image_tag(preview_url, class: 'img-responsive img-thumbnail') 
 theme.description_html 
 else 
 link_to(theme.name, switch_url, title: t(".use_this_theme")) 
 link_to(image_tag(preview_url, class: 'img-thumbnail'), switch_url, title: t(".use_this_theme")) 
 theme.description_html 
 link_to(t(".use_this_theme"), switch_url, class: 'btn btn-info') 
 end 
 end 

end

  end

  def preview
    theme = Theme.find(params[:theme])
    send_file File.join(theme.path, 'preview.png'),
              type: 'image/png', disposition: 'inline', stream: false
  end

  def switchto
    this_blog.theme = params[:theme]
    this_blog.save
    zap_theme_caches
    this_blog.current_theme(:reload)
    flash[:success] = I18n.t('admin.themes.switchto.success')
    require "#{this_blog.current_theme.path}/helpers/theme_helper.rb" if File.exist? "#{this_blog.current_theme.path}/helpers/theme_helper.rb"
    redirect_to admin_themes_url
  end

  protected

  def zap_theme_caches
    FileUtils.rm_rf(%w(stylesheets javascript images).map { |v| page_cache_directory + "/#{v}/theme" })
  end
end

#==
# RailsCollab
# Copyright (C) 2009 Sergio Cambra
# Portions Copyright (C) 2011 James S Urquhart
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++

class WikiPagesController < ApplicationController
  layout 'project_website'

  before_filter :process_session
  before_filter :find_sidebar_page, :only => [:index, :show]
  after_filter  :user_track, :only => [:index, :show]

  before_filter :find_wiki_page, :only => [:show, :edit, :update, :destroy]
  before_filter :find_main_wiki_page, :only => :index
  before_filter :find_wiki_pages, :only => :list

  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  
  before_filter :check_create_permissions, :only => [:new, :create]
  before_filter :check_update_permissions, :only => [:edit, :update]
  before_filter :check_delete_permissions, :only => :destroy

  def index
    unless @wiki_page.nil?
      @version = @wiki_page
      @versions = @wiki_page.versions.all.reverse!
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|

  @page_actions = []
  if can? :create_wiki_page, @active_project
    @page_actions << {:title => :add_page, :url => new_wiki_page_path}
  end
  @page_actions << {:title => :all_pages, :url => list_wiki_pages_path}

  h wiki_page.title 
 wiki_text wiki_page.content 
 
 action_list actions_for_wiki_page(@wiki_page) 
 select_tag :versions, options_for_versions_select(@versions), :onchange => 'document.location.href = this.value;' 
 I18n.t('wiki_engine.last_modified_with_time', :time => format_usertime(@version.created_at, :wiki_page_updated_format)) 

end

    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

  @page_actions = []
  if can? :create_wiki_page, @active_project
    @page_actions << {:title => :add_page, :url => new_wiki_page_path}
  end
  @page_actions << {:title => :all_pages, :url => list_wiki_pages_path}


end

  end

  def list
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t 'wiki_engine.title' 
 t 'wiki_engine.last_modified' 
 list.each do |wiki_page| 
 cycle('odd', 'even') 
 link_to h(wiki_page.title), wiki_page_path(:id => wiki_page.slug) 
 wiki_page.updated_at.to_s(:long) 
  action_list actions_for_wiki_page(wiki_page) 
 
 end 

end

  end

  def new
    @wiki_page = wiki_pages.new(:title_from_id => params[:id])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_for(@wiki_page, :url => wiki_pages_path) do |form| 
  content_tag :h2, h(form.object.title) unless form.object.new_record? 
  form.label :title, t('wiki_engine.title') 
 form.text_field :title 
 
  form.label :content, t('wiki_engine.content') 
 form.text_area :content, :rows => 40 
 
  form.check_box :main 
 form.label :main, t('wiki_engine.main_page') 
 
  t 'wiki_engine.help.link_to_format', :link => link_to('Textile', 'http://hobix.com/textile/quick.html') 
 t 'wiki_engine.help.links_to_wiki_pages' 
 t 'wiki_engine.help.format_code' 
 t 'wiki_engine.help.highlight_language' 
 
 
 end 

end

  end

  def show
    @versions = @wiki_page.versions.all.reverse!
    @version = @wiki_page.versions.find_by_version(params[:version]) if params[:version]
    @version ||= @wiki_page
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

  @page_actions = []
  if can? :create_wiki_page, @active_project
    @page_actions << {:title => :add_page, :url => new_wiki_page_path}
  end
  @page_actions << {:title => :all_pages, :url => list_wiki_pages_path}

  h wiki_page.title 
 wiki_text wiki_page.content 
 
 action_list actions_for_wiki_page(@wiki_page) 
 select_tag :versions, options_for_versions_select(@versions), :onchange => 'document.location.href = this.value;' 
 I18n.t('wiki_engine.last_modified_with_time', :time => format_usertime(@version.created_at, :wiki_page_updated_format)) 

end

  end

  def create
    @wiki_page = wiki_pages.new(params[:wiki_page].merge(:created_by => @logged_user))

    if @wiki_page.save
      flash[:message] = I18n.t 'wiki_engine.success_creating_wiki_page'
      redirect_to @wiki_page.main ? wiki_pages_path : wiki_page_path(:id => @wiki_page.slug)
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_for(@wiki_page, :url => wiki_pages_path) do |form| 
  content_tag :h2, h(form.object.title) unless form.object.new_record? 
  form.label :title, t('wiki_engine.title') 
 form.text_field :title 
 
  form.label :content, t('wiki_engine.content') 
 form.text_area :content, :rows => 40 
 
  form.check_box :main 
 form.label :main, t('wiki_engine.main_page') 
 
  t 'wiki_engine.help.link_to_format', :link => link_to('Textile', 'http://hobix.com/textile/quick.html') 
 t 'wiki_engine.help.links_to_wiki_pages' 
 t 'wiki_engine.help.format_code' 
 t 'wiki_engine.help.highlight_language' 
 
 
 end 

end

    end
  end

  def edit
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_for(@wiki_page, :url => wiki_page_path(:id => @wiki_page.slug)) do |form| 
  content_tag :h2, h(form.object.title) unless form.object.new_record? 
  form.label :title, t('wiki_engine.title') 
 form.text_field :title 
 
  form.label :content, t('wiki_engine.content') 
 form.text_area :content, :rows => 40 
 
  form.check_box :main 
 form.label :main, t('wiki_engine.main_page') 
 
  t 'wiki_engine.help.link_to_format', :link => link_to('Textile', 'http://hobix.com/textile/quick.html') 
 t 'wiki_engine.help.links_to_wiki_pages' 
 t 'wiki_engine.help.format_code' 
 t 'wiki_engine.help.highlight_language' 
 
 
 end 
 render @wiki_page 

end

  end

  def update
    if @wiki_page.update_attributes(params[:wiki_page].merge(:created_by => @logged_user))
      flash[:message] = I18n.t 'wiki_engine.success_updating_wiki_page'
      redirect_to @wiki_page.main ? wiki_pages_path : wiki_page_path(:id => @wiki_page)
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_for(@wiki_page, :url => wiki_page_path(:id => @wiki_page.slug)) do |form| 
  content_tag :h2, h(form.object.title) unless form.object.new_record? 
  form.label :title, t('wiki_engine.title') 
 form.text_field :title 
 
  form.label :content, t('wiki_engine.content') 
 form.text_area :content, :rows => 40 
 
  form.check_box :main 
 form.label :main, t('wiki_engine.main_page') 
 
  t 'wiki_engine.help.link_to_format', :link => link_to('Textile', 'http://hobix.com/textile/quick.html') 
 t 'wiki_engine.help.links_to_wiki_pages' 
 t 'wiki_engine.help.format_code' 
 t 'wiki_engine.help.highlight_language' 
 
 
 end 
 render @wiki_page 

end

    end
  end

  def destroy
    @wiki_page.destroy

    flash[:message] = I18n.t 'wiki_engine.success_deleting_wiki_page'
    redirect_to wiki_pages_path
  end

  def preview
    @wiki_page = wiki_pages.new(params[:wiki_page])
    @wiki_page.readonly!

    respond_to do |format|
      format.js { render @wiki_page }
    end
  end

  protected

  def wiki_pages
    WikiPage
  end
  
  def find_wiki_page
    @wiki_page = wiki_pages.find(params[:id])
  end

  # Find main wiki page. This is by default used only for index action.
  def find_main_wiki_page
    @wiki_page = wiki_pages.main(@active_project).first
  end

  # Find all wiki pages. This is by default used only for list action.
  def find_wiki_pages
    @wiki_pages = wiki_pages.all
  end

  # This is called when wiki page is not found. By default it display a page explaining
  # that the wiki page does not exist yet and link to create it.
  def not_found
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t 'wiki_engine.not_found' 
 t 'wiki_engine.non_existing_page' 
 link_to t('wiki_engine.create_it'), new_wiki_page_path(:id => params[:id]) 

end
end
  
  def check_create_permissions
    authorize! :create_wiki_page, @active_project
  end

  def check_update_permissions
    authorize! :edit, @wiki_page
  end

  def check_delete_permissions
    authorize! :delete, @wiki_page
  end

  def wiki_pages
    @active_project.wiki_pages
  end

  def find_main_wiki_page
    @wiki_page = wiki_pages.main(@active_project).first
  end

  def find_wiki_page
    @wiki_page = wiki_pages.where(:project_id => @active_project.id).find_by_slug(params[:id])
  end
  
  def find_sidebar_page
    @wiki_sidebar = wiki_pages.where(:project_id => @active_project.id).find_by_slug("sidebar") rescue nil
    @content_for_sidebar = @wiki_sidebar.nil? ? nil : 'wiki_sidebar' 
  end
end

module Cms
  class CacheController < Cms::BaseController

    include Cms::AdminTab
    check_permissions :administrate

    def show

 use_page_title "Page Cache" 
 render layout: 'page_title' do 
 link_to "Clear", cache_path, class: 'btn btn-primary right http_delete', :rel=>'clear-cache' 
 end 
 render layout: 'main_content' do 
 end 

    end

    def destroy
      Cms::Cache.flush
      flash[:notice] = "Page Cache Flushed"
      redirect_to :action => "show"
    end

    private
    def set_menu_section
      @menu_section = 'caching'
    end

  end
end
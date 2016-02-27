  class CacheController < BaseController

    include AdminTab
    check_permissions :administrate

    def show

ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 use_page_title "Page Cache" 
 render layout: 'page_title' do 
 link_to "Clear", cache_path, class: 'btn btn-primary right http_delete', :rel=>'clear-cache' 
 end 
 render layout: 'main_content' do 
 end 

end

    end

    def destroy
      Cache.flush
      flash[:notice] = "Page Cache Flushed"
      redirect_to :action => "show"
    end

    private
    def set_menu_section
      @menu_section = 'caching'
    end

  end

require 'find'

class Admin::CacheController < Admin::BaseController
  def show
    @cache_size = 0
    @cache_number = 0

    FileUtils.mkdir_p(Publify::Application.config.action_controller.page_cache_directory) unless File.exist?(Publify::Application.config.action_controller.page_cache_directory)

    Find.find(Publify::Application.config.action_controller.page_cache_directory) do |path|
      if FileTest.directory?(path)
        if File.basename(path)[0] == '.'
          Find.prune
        else
          next
        end
      else
        @cache_size += FileTest.size(path)
        @cache_number += 1
      end
    end
 content_for :page_heading do 
 t(".cache") 
 end 
 t(".explaination") 
 t(".stats", files_count: @cache_number.to_i, size: @cache_size.to_i / 1000) 
 form_tag(admin_cache_path, method: :delete) do 
 submit_tag(t(".sweep_cache"), class: 'btn btn-primary') 
 end 

  end

  def destroy
    begin
      PageCache.sweep_all
      flash[:success] = t('admin.cache.destroy.success')
    rescue
      flash[:error] = t('admin.cache.destroy.error')
    end
    redirect_to admin_cache_url
  end
end

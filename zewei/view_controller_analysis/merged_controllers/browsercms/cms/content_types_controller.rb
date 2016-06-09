require_dependency "cms/application_controller"

module Cms
  class ContentTypesController < ApplicationController

    def index
      content_type = ContentType.named(params[:content_type]).first
      @attributes = content_type.orderable_attributes.sort()
      respond_to do |format|
        format.js { render :layout => false }
      end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 id 
 if library 
 nav_link_to "Text", cms.content_library_path 
 divider_tag 
 end 
 modules = Cms::ContentType.available_by_module
     modules.keys.sort.each_with_index do |module_name, i| 
 divider_tag(i) 
 modules[module_name].each do |type| 
 nav_link_to h(type.display_name), engine_aware_path(type) 
 end 
 end 

end

    end
  end
end

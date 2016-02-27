  class PageComponentsController < ApplicationController
    layout false
    respond_to :json

    def new
      @default_type = ContentType.default
      @content_types = ContentType.other_connectables
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  link_to "Add #{@default_type.display_name}", new_engine_aware_path((@default_type),
            "#{@default_type.param_key}[connect_to_page_id]" => params[:connect_to_page_id],
            "#{@default_type.param_key}[connect_to_container]" => params[:connect_to_container]
          ),

                 :class=>"btn btn-small btn-primary" 
 @content_types.each_with_index do |type, i| 
 link_to h(type.display_name), new_engine_aware_path(type,
            "#{type.param_key}[connect_to_page_id]" => params[:connect_to_page_id],
            "#{type.param_key}[connect_to_container]" => params[:connect_to_container]
          ), :target=> "_top" 
 end 
 
 link_to "Never Mind", "#", class: "btn btn-small", data: {dismiss: "modal", }, "aria-hidden" => "true" 
 link_to "Reuse Content Instead?", cms.new_connector_path(:page_id => params[:connect_to_page_id], :container => params[:connect_to_container]) , class: "btn btn-small btn-primary", id: "insert_existing_content" 

end

    end

    def update
      @page_component = PageComponent.new(params[:id], params[:content])
      if @page_component.save
        respond_with(@page_component)
      else
        respond_with(@page_component.errors, :status => :unprocessable_entity)
      end
    end
  end

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
 simple_form_for ListPortlet.new(order: "name") do |f| 
  f.input :order,
            collection: collection,
            label_method: :humanize,
            include_blank: false,
            wrapper_html: {'data-role' => "order-fields", class: 'load'} 
 
 end 

end

    end
  end
end

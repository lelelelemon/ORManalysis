# encoding: UTF-8
# Show recent activities

class ActivitiesController < ApplicationController
  # Show the overview page including whatever widgets the user has added.
  def index
    @columns = []
    current_user.widgets.each do |w|
      @columns[w.column] ||= []
      @columns[w.column] << w
    end
 @page_title = "#{t("activities.dashboard")} - #{Setting.productName}" 
 content_for :head do 
 javascript_include_tag "excanvas" 
 end 
  form_tag({:controller => 'widgets', :action => 'create' }, :id => "add_widget", :remote => true, :class => "form-inline") do  
 t("widgets.widget_title") 
 text_field 'widget', 'name', {:size => 15} 

    gadgets = [
                [t("widgets.tasks"),0],
                [t("widgets.due_tasks"),7],
                [t("widgets.comments"),6],
                [t("widgets.time_chart"),3],
                [t("widgets.burndown"),4],
                [t("widgets.burnup"),5],
                [t("widgets.resolution"),9],
                [t("widgets.active_tasks"),10] ]

   if current_user.widgets.where("widget_type = 8").count == 0
     gadgets << [t("widgets.google_gadget"),8]
   end
  
 t("widgets.type") 
 select( 'widget', 'widget_type', gadgets) 
 submit_tag t("button.create"), :class => "btn" 
 link_to_function(t("button.cancel"), "jQuery('#add-widget').addClass('hide');") 
 end 

 @columns[0] && @columns[0].each do |w| 
 next if w.widget_type == 2 
 @widget = w 
  @widget.id 
 @widget.dom_id 
 image_tag "configure.png" 
 image_tag "delete.png" 
 link_to("&nbsp;".html_safe, "#", { :class => (@widget.collapsed? ? "widget-collapsed toggle-display" : "widget-open toggle-display"), :id => "indicator-#{@widget.dom_id}" }) 
 render(:partial => "widgets/widget_#{@widget.widget_type}_header") 
 @widget.dom_id 
 @widget.collapsed? ? "hide" : "" 
 if @widget.configured? 
 t("shared.loading") 
 else 
 t("widgets.please_configure") 
 end 
 
 end 
 @columns[1] && @columns[1].each do |w| 
 next if w.widget_type == 2 
 @widget = w 
  @widget.id 
 @widget.dom_id 
 image_tag "configure.png" 
 image_tag "delete.png" 
 link_to("&nbsp;".html_safe, "#", { :class => (@widget.collapsed? ? "widget-collapsed toggle-display" : "widget-open toggle-display"), :id => "indicator-#{@widget.dom_id}" }) 
 render(:partial => "widgets/widget_#{@widget.widget_type}_header") 
 @widget.dom_id 
 @widget.collapsed? ? "hide" : "" 
 if @widget.configured? 
 t("shared.loading") 
 else 
 t("widgets.please_configure") 
 end 
 
 end 
 current_user.widgets.each do |widget| 
 unless widget.widget_type == 2  
widget.id
widget.dom_id
widget.widget_type
widget.configured
widget.gadget_url
 end 
 end 

  end
end

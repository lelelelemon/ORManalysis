  class SectionNodesController < BaseController

    check_permissions :publish_content, :except => [:index]

    def index
      @modifiable_sections = current_user.modifiable_sections
      @public_sections = Group.guest.sections.to_a # Load once here so that every section doesn't need to.

      @sitemap = Section.sitemap
      @root_section_node = @sitemap.keys.first
      @section = @root_section_node.node
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  use_page_title "Sitemap" 
 page_title 
 
  sitemap_depth_class(section_node) 
 draggable_class?(@modifiable_sections, section_node, parent) 
 section_node.id 
 section_node.depth + 1 
 row_type_tag(section_node) 
 closable_data(section_node, children) 
 add_page_path_data(section_node, parent) 
 add_link_path_data(section_node, parent) 
 add_section_path_data(section_node, parent) 
 icon_tag(section_node, children) 
 section_node.node.name 
 if current_user_can_modify(@modifiable_sections, section_node, parent) 
  link_to 'View', engine_aware_path(section_node.node), class: 'add-link' unless section_node.root? 
 link_to 'Edit', edit_engine_aware_path(section_node.node), class: 'add-link' 
 if section_node.page? 
 end 
 link_to("Hide", "#", class: 'add-link') unless section_node.root? 
 link_to 'Remove', engine_aware_path(section_node.node),
                  class: 'add-link http_delete confirm_with_title',
                  title: "Are you sure you want to remove #{section_node.node.name}?" if section_node.deletable? 
 
 end 
  draft_icon_tag(content) 
 hidden_icon_tag(content) 
 guest_accessible_icon_tag(parent, content) 
 
  initial_visibility_class(parent) 
 children.keys.each do |section_node| 
  sitemap_depth_class(section_node) 
 draggable_class?(@modifiable_sections, section_node, parent) 
 section_node.id 
 section_node.depth + 1 
 row_type_tag(section_node) 
 closable_data(section_node, children) 
 add_page_path_data(section_node, parent) 
 add_link_path_data(section_node, parent) 
 add_section_path_data(section_node, parent) 
 icon_tag(section_node, children) 
 section_node.node.name 
 if current_user_can_modify(@modifiable_sections, section_node, parent) 
  link_to 'View', engine_aware_path(section_node.node), class: 'add-link' unless section_node.root? 
 link_to 'Edit', edit_engine_aware_path(section_node.node), class: 'add-link' 
 if section_node.page? 
 end 
 link_to("Hide", "#", class: 'add-link') unless section_node.root? 
 link_to 'Remove', engine_aware_path(section_node.node),
                  class: 'add-link http_delete confirm_with_title',
                  title: "Are you sure you want to remove #{section_node.node.name}?" if section_node.deletable? 
 
 end 
  draft_icon_tag(content) 
 hidden_icon_tag(content) 
 guest_accessible_icon_tag(parent, content) 
 
  initial_visibility_class(parent) 
 children.keys.each do |section_node| 
  sitemap_depth_class(section_node) 
 draggable_class?(@modifiable_sections, section_node, parent) 
 section_node.id 
 section_node.depth + 1 
 row_type_tag(section_node) 
 closable_data(section_node, children) 
 add_page_path_data(section_node, parent) 
 add_link_path_data(section_node, parent) 
 add_section_path_data(section_node, parent) 
 icon_tag(section_node, children) 
 section_node.node.name 
 if current_user_can_modify(@modifiable_sections, section_node, parent) 
  link_to 'View', engine_aware_path(section_node.node), class: 'add-link' unless section_node.root? 
 link_to 'Edit', edit_engine_aware_path(section_node.node), class: 'add-link' 
 if section_node.page? 
 end 
 link_to("Hide", "#", class: 'add-link') unless section_node.root? 
 link_to 'Remove', engine_aware_path(section_node.node),
                  class: 'add-link http_delete confirm_with_title',
                  title: "Are you sure you want to remove #{section_node.node.name}?" if section_node.deletable? 
 
 end 
  draft_icon_tag(content) 
 hidden_icon_tag(content) 
 guest_accessible_icon_tag(parent, content) 
 
  initial_visibility_class(parent) 
 children.keys.each do |section_node| 
  sitemap_depth_class(section_node) 
 draggable_class?(@modifiable_sections, section_node, parent) 
 section_node.id 
 section_node.depth + 1 
 row_type_tag(section_node) 
 closable_data(section_node, children) 
 add_page_path_data(section_node, parent) 
 add_link_path_data(section_node, parent) 
 add_section_path_data(section_node, parent) 
 icon_tag(section_node, children) 
 section_node.node.name 
 if current_user_can_modify(@modifiable_sections, section_node, parent) 
  link_to 'View', engine_aware_path(section_node.node), class: 'add-link' unless section_node.root? 
 link_to 'Edit', edit_engine_aware_path(section_node.node), class: 'add-link' 
 if section_node.page? 
 end 
 link_to("Hide", "#", class: 'add-link') unless section_node.root? 
 link_to 'Remove', engine_aware_path(section_node.node),
                  class: 'add-link http_delete confirm_with_title',
                  title: "Are you sure you want to remove #{section_node.node.name}?" if section_node.deletable? 
 
 end 
  draft_icon_tag(content) 
 hidden_icon_tag(content) 
 guest_accessible_icon_tag(parent, content) 
 
  initial_visibility_class(parent) 
 children.keys.each do |section_node| 
  sitemap_depth_class(section_node) 
 draggable_class?(@modifiable_sections, section_node, parent) 
 section_node.id 
 section_node.depth + 1 
 row_type_tag(section_node) 
 closable_data(section_node, children) 
 add_page_path_data(section_node, parent) 
 add_link_path_data(section_node, parent) 
 add_section_path_data(section_node, parent) 
 icon_tag(section_node, children) 
 section_node.node.name 
 if current_user_can_modify(@modifiable_sections, section_node, parent) 
  link_to 'View', engine_aware_path(section_node.node), class: 'add-link' unless section_node.root? 
 link_to 'Edit', edit_engine_aware_path(section_node.node), class: 'add-link' 
 if section_node.page? 
 end 
 link_to("Hide", "#", class: 'add-link') unless section_node.root? 
 link_to 'Remove', engine_aware_path(section_node.node),
                  class: 'add-link http_delete confirm_with_title',
                  title: "Are you sure you want to remove #{section_node.node.name}?" if section_node.deletable? 
 
 end 
  draft_icon_tag(content) 
 hidden_icon_tag(content) 
 guest_accessible_icon_tag(parent, content) 
 
  initial_visibility_class(parent) 
 children.keys.each do |section_node| 
  sitemap_depth_class(section_node) 
 draggable_class?(@modifiable_sections, section_node, parent) 
 section_node.id 
 section_node.depth + 1 
 row_type_tag(section_node) 
 closable_data(section_node, children) 
 add_page_path_data(section_node, parent) 
 add_link_path_data(section_node, parent) 
 add_section_path_data(section_node, parent) 
 icon_tag(section_node, children) 
 section_node.node.name 
 if current_user_can_modify(@modifiable_sections, section_node, parent) 
  link_to 'View', engine_aware_path(section_node.node), class: 'add-link' unless section_node.root? 
 link_to 'Edit', edit_engine_aware_path(section_node.node), class: 'add-link' 
 if section_node.page? 
 end 
 link_to("Hide", "#", class: 'add-link') unless section_node.root? 
 link_to 'Remove', engine_aware_path(section_node.node),
                  class: 'add-link http_delete confirm_with_title',
                  title: "Are you sure you want to remove #{section_node.node.name}?" if section_node.deletable? 
 
 end 
  draft_icon_tag(content) 
 hidden_icon_tag(content) 
 guest_accessible_icon_tag(parent, content) 
 
 render partial: 'children', locals: {parent: section_node, children: children} 
 
 end 
 
 
 end 
 
 
 end 
 
 
 end 
 
 
 end 
 
 

end

    end

    def move_to_position
      @section_node = SectionNode.find(params[:id])
      target_node = SectionNode.find(params[:target_node_id])
      @section_node.move_to(target_node.node, params[:position].to_i)
      render :json => {:success => true, :message => "'#{@section_node.node.name}' was moved to '#{target_node.node.name}'"}
    end

  end

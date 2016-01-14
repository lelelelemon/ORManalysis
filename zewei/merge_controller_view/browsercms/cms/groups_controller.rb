module Cms
  class GroupsController < Cms::ResourceController
    include Cms::AdminTab

    check_permissions :administrate

    def index
      @groups = Group.includes(:group_type).paginate(:page => params[:page]).order(params[:order] || :name)
 use_page_title "Groups" 
 render layout: 'page_title' do 
 link_to("Add Group", new_group_path, :id => "new_group_button", :class => "btn btn-primary btn-small right") 
 end 
 render layout: 'main_content' do 
 link_to "Name", groups_path(:order => determine_order(params[:order], "#{Cms::Group.table_name}.name")) 
 link_to "Type", groups_path(:order => determine_order(params[:order], "#{Cms::GroupType.table_name}.name")) 
 section_count = Cms::Section.count 
 @groups.each do |g| 
 link_to h(g.name), [:edit, g] 
 h(g.group_type.name) 
 g.permissions.uniq.each do |p| 
 p.full_name 
 end 
 g.cms_access? ? "Edit" : "View" 
 g.sections.count >= section_count ? "All Sections" : "#{g.sections.count} of #{section_count} Sections" 
 end 
 end 
 if @groups.total_pages > 1 
 render_pagination @groups, Cms::Group 
 end 

    end

    protected
    def after_create_url
      index_url
    end

    def after_update_url
      index_url
    end

    def set_menu_section
      @menu_section = 'groups'
    end

  end
end
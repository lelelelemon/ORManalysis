#==
# RailsCollab
# Copyright (C) 2007 - 2011 James S Urquhart
# Portions Copyright (C) René Scheibe
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

class TagsController < ApplicationController

  layout 'project_website'

  before_filter :process_session
  after_filter  :user_track
  
  def show
    tags_in_project
    
    respond_to do |format|
      format.html { }
      format.xml { render :xml => [].to_xml(:root => 'tags') }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

  @page_title = t('tags')
  @bread_crumbs = project_crumbs(@tag_name, [{:title => :search, :url => search_project_path(:id => @active_project.id)}])

 if @tagged_objects_count > 0 
 t('objects_tagged_with', {:count => @tagged_objects_count, :tag => h(@tag_name)}).html_safe 
 if not @tagged_objects[:messages].empty? 
 t('messages') 
 @tagged_objects[:messages].each do |message| 
 message.object_url 
 h message.object_name 
 if !message.created_by.nil? 
 format_usertime(message.created_on, :message_created_format) 
 link_to (h message.created_by.display_name), user_path(:id => message.created_by.id) 
 end 
 end 
 end 
 if not @tagged_objects[:milestones].empty? 
 t('milestones') 
 @tagged_objects[:milestones].each do |milestone| 
 milestone.object_url 
 h milestone.object_name 
 if !milestone.assigned_to.nil? 
 t('milestone_assigned_to', {:name => h(milestone.assigned_to.object_name)}) 
 end 
 if milestone.is_completed? 
 render_icon 'ok', "Completed milestone" 
 end 
 end 
 end 
 if not @tagged_objects[:task_lists].empty? 
 t('task_lists') 
 @tagged_objects[:task_lists].each do |task_list| 
 task_list.object_url 
 h task_list.object_name 
 if task_list.is_completed? 
 render_icon 'ok', "Completed task list" 
 end 
 end 
 end 
 if not @tagged_objects[:files].empty? 
 t('files') 
 @tagged_objects[:files].each do |file| 
 file.object_url
 h file.filename 
 format_size file.file_size 
 end 
 end 
 else 
 t('no_objects_tagged_with', {:tag => h(@tag_name)}).html_safe 
 end 

end

  end

private

  def tags_in_project
  	@tag_name = CGI.unescape(params[:id])
  	@active_project = Project.find(params[:project_id]) rescue nil
    return if !verify_project
  	
  	@tag_object_list = Tag.find_objects(@tag_name, @active_project, !@logged_user.member_of_owner?)

  	@tag_names = Tag.list_by_project(@active_project, !@logged_user.member_of_owner?, false)
  	@content_for_sidebar = 'projects/search_sidebar'

  	@tagged_objects_count = @tag_object_list.length
  	@tagged_objects = {
      :messages   => @tag_object_list.select { |obj| obj.class == Message },
      :milestones => @tag_object_list.select { |obj| obj.class == Milestone },
      :task_lists => @tag_object_list.select { |obj| obj.class == TaskList },
      :files      => @tag_object_list.select { |obj| obj.class == ProjectFile },
  	}
  end
end

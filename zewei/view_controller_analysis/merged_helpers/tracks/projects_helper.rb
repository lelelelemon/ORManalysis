module ProjectsHelper

  def show_project_name(project)
    if source_view_is :project
      content_tag(:span, :id => "project_name"){project.name}
    else
      link_to_project( project )
    end
  end

  def show_project_settings(project)
    content_tag(:div, :id => dom_id(project, "container"), :class=>"list") do
       project = project_settings 
 dom_id(project) 
 t('projects.this_project') 
 if project.completed? 
 t('projects.was_marked_complete') 
 elsif project.hidden? 
 t('projects.was_marked_hidden') 
 else 
 t('projects.is_active') 
 end 
 if project.default_context.nil? 
 t('projects.with_no_default_context') 
 else 
 t('projects.with_default_context', :context_name => project.default_context.name) 
 end 
 if project.default_tags.nil? || project.default_tags.blank? 
 t('projects.with_no_default_tags') 
 else 
 t('projects.with_default_tags', :tags => project.default_tags) 
 end 
 link_to_edit_project(project, t('projects.edit_project_settings')) 
 if project.description.present? 
 Tracks::Utils.render_text(project.description) 
 end 
 dom_id(project, 'edit') 

    end
  end

  def project_next_prev
    content_tag(:div, :id=>"project-next-prev") do
      html = ""
      html << link_to_project(@previous_project, "&laquo; #{@previous_project.shortened_name}".html_safe) if @previous_project
      html << " | " if @previous_project && @next_project
      html << link_to_project(@next_project, "#{@next_project.shortened_name} &raquo;".html_safe) if @next_project
      html.html_safe
    end
  end

  def project_next_prev_mobile
    prev_project = ""
    next_project = ""
    prev_project = content_tag(:li, link_to_project_mobile(@previous_project, "5", @previous_project.shortened_name), :class=>"prev") if @previous_project
    next_project = content_tag(:li, link_to_project_mobile(@next_project, "6", @next_project.shortened_name), :class=>"next") if @next_project
    return content_tag(:ul, "#{prev_project}#{next_project}".html_safe, :class=>"next-prev-project")
  end

  def project_summary(project)
    project_description = ''
    project_description += Tracks::Utils.render_text( project.description ) if project.description.present?
    project_description += content_tag(:p,
      "#{count_undone_todos_phrase(p)}. #{t('projects.project_state', :state => project.state)}".html_safe
      )
  end

  def needsreview_class(item)
    raise "item must be a Project " unless item.kind_of? Project
    return item.needs_review?(current_user) ? "needsreview" : "needsnoreview"
  end

  def link_to_delete_project(project, descriptor = sanitize(project.name))
    link_to_delete(:project, project, descriptor)
  end

  def link_to_edit_project (project, descriptor = sanitize(project.name))
    link_to_edit(:project, project, descriptor)
  end

end

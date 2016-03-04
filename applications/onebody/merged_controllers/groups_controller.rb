class GroupsController < ApplicationController

  def index
    if params[:person_id]
      person_index
    elsif params[:category] or params[:name]
      search_index
    else
      overview_index
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 escape_javascript  @groups.each do |group| 
 check_box_tag 'ids[]', group.id, false, style: 'float:left', data: { name: group.name } 
 group.category 
 group.name 
 if group.link_code.present? 
 icon 'fa fa-link' 
 end 
 end 
 

end

  end

  def show
    @group = Group.find(params[:id])
    if not (@group.approved? or @group.admin?(@logged_in))
      render text: t('groups.pending_approval.this_group'), layout: true
    elsif @logged_in.can_read?(@group)
      @member_of = @logged_in.member_of?(@group)
      @stream_items = StreamItem.shared_with(@logged_in).where(group: @group).paginate(page: params[:timeline_page], per_page: 5)
      @pictures = @group.album_pictures.references(:album)
      @pictures.where!('albums.is_public' => true) unless @logged_in.member_of?(@group)
      @tasks = @group.tasks.references(:task)
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = @group.name 
 t('groups.limited.intro') 
  if @group.membership_requests.where(person_id: @logged_in.id).any? 
 icon 'fa fa-plus' 
 t('groups.show.controls.join_pending') 
 else 
 if @member_of 
 link_to group_membership_path(@group, @logged_in), method: 'delete', data: { confirm: t('are_you_sure') }, class: 'btn btn-danger' do 
 icon 'fa fa-times' 
 t('groups.show.controls.leave') 
 end 
 else 
 link_to group_memberships_path(@group, id: @logged_in), method: 'post', data: { confirm: must_request_group_join?(@group) ? t('groups.join.confirm') : t('are_you_sure') }, class: 'btn btn-success' do 
 icon 'fa fa-plus' 
 t('groups.show.controls.join') 
 end 
 end 
 end 
 

end

    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def new
    @group = Group.new(creator_id: @logged_in.id)
    @categories = Group.categories.keys
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('groups.new.heading') 
  form_for @group, html: { multipart: true } do |form| 
 error_messages_for(form) 
 link_to t('groups.edit.tabs.details'), '#details', data: { toggle: 'tab' } 
 link_to t('groups.edit.tabs.meets'), '#meets', data: { toggle: 'tab' } 
 link_to t('groups.edit.tabs.features'), '#features', data: { toggle: 'tab' } 
 link_to t('groups.edit.tabs.security'), '#security', data: { toggle: 'tab' } 
 if @logged_in.admin?(:manage_groups) 
 link_to t('groups.edit.tabs.advanced'), '#advanced', data: { toggle: 'tab' } 
 end 
  form.label :name 
 form.text_field :name, onkeyup: 'update_address(this.value)', class: 'form-control' 
 t('groups.edit.required_field') 
 icon 'fa fa-star text-red' 
 form.label :category 
 form.select :category, group_categories, { include_blank: true }, class: 'can-create form-control' 
 t('groups.edit.required_field') 
 icon 'fa fa-star text-red' 
 t('groups.edit.category.help') 
 form.label :description 
 form.text_area :description, rows: 3, class: 'form-control' 
 t('groups.edit.description.help') 
 form.label :other_notes 
 form.text_area :other_notes, rows: 3, class: 'form-control' 
 form.label :leader_id 
 form.select :leader_id, @group.people.map { |m| [m.name, m.id] }, { include_blank: true }, class: 'form-control' 
 form.label :creator 
 form.text_field :creator, value: (@group.creator ? @group.creator.name : nil), readonly: true, name: 'creator_name', class: 'form-control' 
 form.submit t('save_changes'), class: 'btn btn-success' 
 
  form.label :meets 
 form.text_field :meets, class: 'form-control' 
 t('groups.edit.meets.help') 
 form.label :location 
 form.text_area :location, rows: 3, class: 'form-control' 
 t('groups.edit.location.help') 
 form.label :directions 
 form.text_area :directions, rows: 3, class: 'form-control' 
 t('groups.edit.directions.help') 
 form.submit t('save_changes'), class: 'btn btn-success' 
 
  form.check_box :email, class: 'checkbox', data: { toggle: '#group_address_field' } 
 form.label :email, class: 'inline' 
 form.text_field :address, size: 15, class: 'form-control' 
 t('groups.edit.address.help') 
 form.check_box :prayer, class: 'checkbox' 
 form.label :prayer, class: 'inline' 
 form.check_box :pictures, class: 'checkbox' 
 form.label :pictures, class: 'inline' 
 form.check_box :attendance, class: 'checkbox', disabled: @group.attendance_required? 
 form.label :attendance, class: "inline #{'disabled' if @group.attendance_required?}" 
 if @group.attendance_required? 
 t('groups.edit.attendance_disabled.help') 
 end 
 form.check_box :has_tasks, class: 'checkbox' 
 form.label :has_tasks, class: 'inline' 
 #.form-group 
 #  = check_box_tag :calendar, nil, @group.gcal_private_link.present?, class: 'checkbox', data: { toggle: '#group_calendar_field' } 
 #  = label_tag :calendar, t('groups.edit.enable_calendar'), class: 'inline' 
 #.form-group#group_calendar_field 
 #  = form.label :gcal_private_link 
 #  = form.text_field :gcal_private_link, size: 50, class: 'form-control' 
 #  %span.help-block 
 #    = t('groups.edit.calendar.help') 
 form.submit t('save_changes'), class: 'btn btn-success' 
 
  form.check_box :approval_required_to_join, class: 'checkbox', onclick: "check_mutual_exclusion()" 
 form.label :approval_required_to_join, nil, class: 'inline' 
 t('groups.edit.approval_required_to_join.help') 
 form.check_box :private, class: 'checkbox', onclick: "check_mutual_exclusion()" 
 form.label :private, nil, class: 'inline' 
 t('groups.edit.private_group.help') 
 form.check_box :members_send, class: 'checkbox' 
 form.label :members_send, nil, class: 'inline' 
 t('groups.edit.members_send.help') 
 form.submit t('save_changes'), class: 'btn btn-success' 
 
 if @logged_in.admin?(:manage_groups) 
  t('groups.edit.advanced.description') 
 form.label :membership_mode 
 form.select :membership_mode, group_membership_modes, {}, class: 'form-control' 
 form.label :link_code 
 form.text_field :link_code, class: 'form-control' 
 t('groups.edit.class_link_code.help_html', url: 'https://github.com/churchio/onebody/wiki/How-Group-Membership-Works') 
 form.label :parents_of 
 form.select :parents_of, [['(' + t('none') + ')', '']] + (Group.where(hidden: false).order('name').to_a - [@group]).map { |g| [g.name, g.id] }, {}, class: 'form-control' 
 t('groups.edit.parents_of.help_html') 
 form.submit t('save_changes'), class: 'btn btn-success' 
 t('groups.hide.heading') 
 t('groups.hide.intro') 
 if @group.hidden? 
 link_to group_path(@group, 'group[hidden]' => false), data: { method: 'put', confirm: t('are_you_sure') }, class: 'btn btn-success' do 
 icon 'fa fa-eye' 
 t('groups.hide.unhide_button') 
 end 
 elsif @group.id 
 link_to group_path(@group, 'group[hidden]' => true), data: { method: 'put', confirm: t('are_you_sure') }, class: 'btn btn-warning' do 
 icon 'fa fa-eye-slash' 
 t('groups.hide.button') 
 end 
 end 
 t('groups.delete.heading') 
 t('groups.delete.intro') 
 link_to @group, data: { method: 'delete', confirm: t('are_you_sure') }, class: 'btn btn-danger' do 
 icon 'fa fa-trash' 
 t('groups.delete.button') 
 end 
 
 end 
 photo_upload_for @group do 
 avatar_tag @group, size: :large 
 end 
 end 
 

end

  end

  def create
    @group = Group.new(group_params)
    @group.creator = @logged_in
    if @group.save
      if @logged_in.admin?(:manage_groups)
        @group.update_attribute(:approved, true)
        flash[:notice] = t('groups.created')
      else
        @group.memberships.create(person: @logged_in, admin: true)
        flash[:notice] = t('groups.created_pending_approval')
      end
      redirect_to @group
    else
      @categories = Group.categories.keys
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('groups.new.heading') 
  form_for @group, html: { multipart: true } do |form| 
 error_messages_for(form) 
 link_to t('groups.edit.tabs.details'), '#details', data: { toggle: 'tab' } 
 link_to t('groups.edit.tabs.meets'), '#meets', data: { toggle: 'tab' } 
 link_to t('groups.edit.tabs.features'), '#features', data: { toggle: 'tab' } 
 link_to t('groups.edit.tabs.security'), '#security', data: { toggle: 'tab' } 
 if @logged_in.admin?(:manage_groups) 
 link_to t('groups.edit.tabs.advanced'), '#advanced', data: { toggle: 'tab' } 
 end 
  form.label :name 
 form.text_field :name, onkeyup: 'update_address(this.value)', class: 'form-control' 
 t('groups.edit.required_field') 
 icon 'fa fa-star text-red' 
 form.label :category 
 form.select :category, group_categories, { include_blank: true }, class: 'can-create form-control' 
 t('groups.edit.required_field') 
 icon 'fa fa-star text-red' 
 t('groups.edit.category.help') 
 form.label :description 
 form.text_area :description, rows: 3, class: 'form-control' 
 t('groups.edit.description.help') 
 form.label :other_notes 
 form.text_area :other_notes, rows: 3, class: 'form-control' 
 form.label :leader_id 
 form.select :leader_id, @group.people.map { |m| [m.name, m.id] }, { include_blank: true }, class: 'form-control' 
 form.label :creator 
 form.text_field :creator, value: (@group.creator ? @group.creator.name : nil), readonly: true, name: 'creator_name', class: 'form-control' 
 form.submit t('save_changes'), class: 'btn btn-success' 
 
  form.label :meets 
 form.text_field :meets, class: 'form-control' 
 t('groups.edit.meets.help') 
 form.label :location 
 form.text_area :location, rows: 3, class: 'form-control' 
 t('groups.edit.location.help') 
 form.label :directions 
 form.text_area :directions, rows: 3, class: 'form-control' 
 t('groups.edit.directions.help') 
 form.submit t('save_changes'), class: 'btn btn-success' 
 
  form.check_box :email, class: 'checkbox', data: { toggle: '#group_address_field' } 
 form.label :email, class: 'inline' 
 form.text_field :address, size: 15, class: 'form-control' 
 t('groups.edit.address.help') 
 form.check_box :prayer, class: 'checkbox' 
 form.label :prayer, class: 'inline' 
 form.check_box :pictures, class: 'checkbox' 
 form.label :pictures, class: 'inline' 
 form.check_box :attendance, class: 'checkbox', disabled: @group.attendance_required? 
 form.label :attendance, class: "inline #{'disabled' if @group.attendance_required?}" 
 if @group.attendance_required? 
 t('groups.edit.attendance_disabled.help') 
 end 
 form.check_box :has_tasks, class: 'checkbox' 
 form.label :has_tasks, class: 'inline' 
 #.form-group 
 #  = check_box_tag :calendar, nil, @group.gcal_private_link.present?, class: 'checkbox', data: { toggle: '#group_calendar_field' } 
 #  = label_tag :calendar, t('groups.edit.enable_calendar'), class: 'inline' 
 #.form-group#group_calendar_field 
 #  = form.label :gcal_private_link 
 #  = form.text_field :gcal_private_link, size: 50, class: 'form-control' 
 #  %span.help-block 
 #    = t('groups.edit.calendar.help') 
 form.submit t('save_changes'), class: 'btn btn-success' 
 
  form.check_box :approval_required_to_join, class: 'checkbox', onclick: "check_mutual_exclusion()" 
 form.label :approval_required_to_join, nil, class: 'inline' 
 t('groups.edit.approval_required_to_join.help') 
 form.check_box :private, class: 'checkbox', onclick: "check_mutual_exclusion()" 
 form.label :private, nil, class: 'inline' 
 t('groups.edit.private_group.help') 
 form.check_box :members_send, class: 'checkbox' 
 form.label :members_send, nil, class: 'inline' 
 t('groups.edit.members_send.help') 
 form.submit t('save_changes'), class: 'btn btn-success' 
 
 if @logged_in.admin?(:manage_groups) 
  t('groups.edit.advanced.description') 
 form.label :membership_mode 
 form.select :membership_mode, group_membership_modes, {}, class: 'form-control' 
 form.label :link_code 
 form.text_field :link_code, class: 'form-control' 
 t('groups.edit.class_link_code.help_html', url: 'https://github.com/churchio/onebody/wiki/How-Group-Membership-Works') 
 form.label :parents_of 
 form.select :parents_of, [['(' + t('none') + ')', '']] + (Group.where(hidden: false).order('name').to_a - [@group]).map { |g| [g.name, g.id] }, {}, class: 'form-control' 
 t('groups.edit.parents_of.help_html') 
 form.submit t('save_changes'), class: 'btn btn-success' 
 t('groups.hide.heading') 
 t('groups.hide.intro') 
 if @group.hidden? 
 link_to group_path(@group, 'group[hidden]' => false), data: { method: 'put', confirm: t('are_you_sure') }, class: 'btn btn-success' do 
 icon 'fa fa-eye' 
 t('groups.hide.unhide_button') 
 end 
 elsif @group.id 
 link_to group_path(@group, 'group[hidden]' => true), data: { method: 'put', confirm: t('are_you_sure') }, class: 'btn btn-warning' do 
 icon 'fa fa-eye-slash' 
 t('groups.hide.button') 
 end 
 end 
 t('groups.delete.heading') 
 t('groups.delete.intro') 
 link_to @group, data: { method: 'delete', confirm: t('are_you_sure') }, class: 'btn btn-danger' do 
 icon 'fa fa-trash' 
 t('groups.delete.button') 
 end 
 
 end 
 photo_upload_for @group do 
 avatar_tag @group, size: :large 
 end 
 end 
 

end

    end
  end

  def edit
    @group ||= Group.find(params[:id])
    if @logged_in.can_update?(@group)
      @categories = Group.categories.keys
      @members = @group.people.minimal.order('last_name, first_name')
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('groups.edit.heading') 
 content_for(:sub_title, link_to(@group.name, @group)) 
  form_for @group, html: { multipart: true } do |form| 
 error_messages_for(form) 
 link_to t('groups.edit.tabs.details'), '#details', data: { toggle: 'tab' } 
 link_to t('groups.edit.tabs.meets'), '#meets', data: { toggle: 'tab' } 
 link_to t('groups.edit.tabs.features'), '#features', data: { toggle: 'tab' } 
 link_to t('groups.edit.tabs.security'), '#security', data: { toggle: 'tab' } 
 if @logged_in.admin?(:manage_groups) 
 link_to t('groups.edit.tabs.advanced'), '#advanced', data: { toggle: 'tab' } 
 end 
  form.label :name 
 form.text_field :name, onkeyup: 'update_address(this.value)', class: 'form-control' 
 t('groups.edit.required_field') 
 icon 'fa fa-star text-red' 
 form.label :category 
 form.select :category, group_categories, { include_blank: true }, class: 'can-create form-control' 
 t('groups.edit.required_field') 
 icon 'fa fa-star text-red' 
 t('groups.edit.category.help') 
 form.label :description 
 form.text_area :description, rows: 3, class: 'form-control' 
 t('groups.edit.description.help') 
 form.label :other_notes 
 form.text_area :other_notes, rows: 3, class: 'form-control' 
 form.label :leader_id 
 form.select :leader_id, @group.people.map { |m| [m.name, m.id] }, { include_blank: true }, class: 'form-control' 
 form.label :creator 
 form.text_field :creator, value: (@group.creator ? @group.creator.name : nil), readonly: true, name: 'creator_name', class: 'form-control' 
 form.submit t('save_changes'), class: 'btn btn-success' 
 
  form.label :meets 
 form.text_field :meets, class: 'form-control' 
 t('groups.edit.meets.help') 
 form.label :location 
 form.text_area :location, rows: 3, class: 'form-control' 
 t('groups.edit.location.help') 
 form.label :directions 
 form.text_area :directions, rows: 3, class: 'form-control' 
 t('groups.edit.directions.help') 
 form.submit t('save_changes'), class: 'btn btn-success' 
 
  form.check_box :email, class: 'checkbox', data: { toggle: '#group_address_field' } 
 form.label :email, class: 'inline' 
 form.text_field :address, size: 15, class: 'form-control' 
 t('groups.edit.address.help') 
 form.check_box :prayer, class: 'checkbox' 
 form.label :prayer, class: 'inline' 
 form.check_box :pictures, class: 'checkbox' 
 form.label :pictures, class: 'inline' 
 form.check_box :attendance, class: 'checkbox', disabled: @group.attendance_required? 
 form.label :attendance, class: "inline #{'disabled' if @group.attendance_required?}" 
 if @group.attendance_required? 
 t('groups.edit.attendance_disabled.help') 
 end 
 form.check_box :has_tasks, class: 'checkbox' 
 form.label :has_tasks, class: 'inline' 
 #.form-group 
 #  = check_box_tag :calendar, nil, @group.gcal_private_link.present?, class: 'checkbox', data: { toggle: '#group_calendar_field' } 
 #  = label_tag :calendar, t('groups.edit.enable_calendar'), class: 'inline' 
 #.form-group#group_calendar_field 
 #  = form.label :gcal_private_link 
 #  = form.text_field :gcal_private_link, size: 50, class: 'form-control' 
 #  %span.help-block 
 #    = t('groups.edit.calendar.help') 
 form.submit t('save_changes'), class: 'btn btn-success' 
 
  form.check_box :approval_required_to_join, class: 'checkbox', onclick: "check_mutual_exclusion()" 
 form.label :approval_required_to_join, nil, class: 'inline' 
 t('groups.edit.approval_required_to_join.help') 
 form.check_box :private, class: 'checkbox', onclick: "check_mutual_exclusion()" 
 form.label :private, nil, class: 'inline' 
 t('groups.edit.private_group.help') 
 form.check_box :members_send, class: 'checkbox' 
 form.label :members_send, nil, class: 'inline' 
 t('groups.edit.members_send.help') 
 form.submit t('save_changes'), class: 'btn btn-success' 
 
 if @logged_in.admin?(:manage_groups) 
  t('groups.edit.advanced.description') 
 form.label :membership_mode 
 form.select :membership_mode, group_membership_modes, {}, class: 'form-control' 
 form.label :link_code 
 form.text_field :link_code, class: 'form-control' 
 t('groups.edit.class_link_code.help_html', url: 'https://github.com/churchio/onebody/wiki/How-Group-Membership-Works') 
 form.label :parents_of 
 form.select :parents_of, [['(' + t('none') + ')', '']] + (Group.where(hidden: false).order('name').to_a - [@group]).map { |g| [g.name, g.id] }, {}, class: 'form-control' 
 t('groups.edit.parents_of.help_html') 
 form.submit t('save_changes'), class: 'btn btn-success' 
 t('groups.hide.heading') 
 t('groups.hide.intro') 
 if @group.hidden? 
 link_to group_path(@group, 'group[hidden]' => false), data: { method: 'put', confirm: t('are_you_sure') }, class: 'btn btn-success' do 
 icon 'fa fa-eye' 
 t('groups.hide.unhide_button') 
 end 
 elsif @group.id 
 link_to group_path(@group, 'group[hidden]' => true), data: { method: 'put', confirm: t('are_you_sure') }, class: 'btn btn-warning' do 
 icon 'fa fa-eye-slash' 
 t('groups.hide.button') 
 end 
 end 
 t('groups.delete.heading') 
 t('groups.delete.intro') 
 link_to @group, data: { method: 'delete', confirm: t('are_you_sure') }, class: 'btn btn-danger' do 
 icon 'fa fa-trash' 
 t('groups.delete.button') 
 end 
 
 end 
 photo_upload_for @group do 
 avatar_tag @group, size: :large 
 end 
 end 
 

end

  end

  def update
    @group = Group.find(params[:id])
    if @logged_in.can_update?(@group)
      params[:group][:photo] = nil if params[:group][:photo] == 'remove'
      if @group.update_attributes(group_params)
        flash[:notice] = t('groups.saved')
        redirect_to @group
      else
        edit; ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('groups.edit.heading') 
 content_for(:sub_title, link_to(@group.name, @group)) 
  form_for @group, html: { multipart: true } do |form| 
 error_messages_for(form) 
 link_to t('groups.edit.tabs.details'), '#details', data: { toggle: 'tab' } 
 link_to t('groups.edit.tabs.meets'), '#meets', data: { toggle: 'tab' } 
 link_to t('groups.edit.tabs.features'), '#features', data: { toggle: 'tab' } 
 link_to t('groups.edit.tabs.security'), '#security', data: { toggle: 'tab' } 
 if @logged_in.admin?(:manage_groups) 
 link_to t('groups.edit.tabs.advanced'), '#advanced', data: { toggle: 'tab' } 
 end 
  form.label :name 
 form.text_field :name, onkeyup: 'update_address(this.value)', class: 'form-control' 
 t('groups.edit.required_field') 
 icon 'fa fa-star text-red' 
 form.label :category 
 form.select :category, group_categories, { include_blank: true }, class: 'can-create form-control' 
 t('groups.edit.required_field') 
 icon 'fa fa-star text-red' 
 t('groups.edit.category.help') 
 form.label :description 
 form.text_area :description, rows: 3, class: 'form-control' 
 t('groups.edit.description.help') 
 form.label :other_notes 
 form.text_area :other_notes, rows: 3, class: 'form-control' 
 form.label :leader_id 
 form.select :leader_id, @group.people.map { |m| [m.name, m.id] }, { include_blank: true }, class: 'form-control' 
 form.label :creator 
 form.text_field :creator, value: (@group.creator ? @group.creator.name : nil), readonly: true, name: 'creator_name', class: 'form-control' 
 form.submit t('save_changes'), class: 'btn btn-success' 
 
  form.label :meets 
 form.text_field :meets, class: 'form-control' 
 t('groups.edit.meets.help') 
 form.label :location 
 form.text_area :location, rows: 3, class: 'form-control' 
 t('groups.edit.location.help') 
 form.label :directions 
 form.text_area :directions, rows: 3, class: 'form-control' 
 t('groups.edit.directions.help') 
 form.submit t('save_changes'), class: 'btn btn-success' 
 
  form.check_box :email, class: 'checkbox', data: { toggle: '#group_address_field' } 
 form.label :email, class: 'inline' 
 form.text_field :address, size: 15, class: 'form-control' 
 t('groups.edit.address.help') 
 form.check_box :prayer, class: 'checkbox' 
 form.label :prayer, class: 'inline' 
 form.check_box :pictures, class: 'checkbox' 
 form.label :pictures, class: 'inline' 
 form.check_box :attendance, class: 'checkbox', disabled: @group.attendance_required? 
 form.label :attendance, class: "inline #{'disabled' if @group.attendance_required?}" 
 if @group.attendance_required? 
 t('groups.edit.attendance_disabled.help') 
 end 
 form.check_box :has_tasks, class: 'checkbox' 
 form.label :has_tasks, class: 'inline' 
 #.form-group 
 #  = check_box_tag :calendar, nil, @group.gcal_private_link.present?, class: 'checkbox', data: { toggle: '#group_calendar_field' } 
 #  = label_tag :calendar, t('groups.edit.enable_calendar'), class: 'inline' 
 #.form-group#group_calendar_field 
 #  = form.label :gcal_private_link 
 #  = form.text_field :gcal_private_link, size: 50, class: 'form-control' 
 #  %span.help-block 
 #    = t('groups.edit.calendar.help') 
 form.submit t('save_changes'), class: 'btn btn-success' 
 
  form.check_box :approval_required_to_join, class: 'checkbox', onclick: "check_mutual_exclusion()" 
 form.label :approval_required_to_join, nil, class: 'inline' 
 t('groups.edit.approval_required_to_join.help') 
 form.check_box :private, class: 'checkbox', onclick: "check_mutual_exclusion()" 
 form.label :private, nil, class: 'inline' 
 t('groups.edit.private_group.help') 
 form.check_box :members_send, class: 'checkbox' 
 form.label :members_send, nil, class: 'inline' 
 t('groups.edit.members_send.help') 
 form.submit t('save_changes'), class: 'btn btn-success' 
 
 if @logged_in.admin?(:manage_groups) 
  t('groups.edit.advanced.description') 
 form.label :membership_mode 
 form.select :membership_mode, group_membership_modes, {}, class: 'form-control' 
 form.label :link_code 
 form.text_field :link_code, class: 'form-control' 
 t('groups.edit.class_link_code.help_html', url: 'https://github.com/churchio/onebody/wiki/How-Group-Membership-Works') 
 form.label :parents_of 
 form.select :parents_of, [['(' + t('none') + ')', '']] + (Group.where(hidden: false).order('name').to_a - [@group]).map { |g| [g.name, g.id] }, {}, class: 'form-control' 
 t('groups.edit.parents_of.help_html') 
 form.submit t('save_changes'), class: 'btn btn-success' 
 t('groups.hide.heading') 
 t('groups.hide.intro') 
 if @group.hidden? 
 link_to group_path(@group, 'group[hidden]' => false), data: { method: 'put', confirm: t('are_you_sure') }, class: 'btn btn-success' do 
 icon 'fa fa-eye' 
 t('groups.hide.unhide_button') 
 end 
 elsif @group.id 
 link_to group_path(@group, 'group[hidden]' => true), data: { method: 'put', confirm: t('are_you_sure') }, class: 'btn btn-warning' do 
 icon 'fa fa-eye-slash' 
 t('groups.hide.button') 
 end 
 end 
 t('groups.delete.heading') 
 t('groups.delete.intro') 
 link_to @group, data: { method: 'delete', confirm: t('are_you_sure') }, class: 'btn btn-danger' do 
 icon 'fa fa-trash' 
 t('groups.delete.button') 
 end 
 
 end 
 photo_upload_for @group do 
 avatar_tag @group, size: :large 
 end 
 end 
 

end

      end
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
  end

  def destroy
    @group = Group.find(params[:id])
    if @logged_in.can_delete?(@group)
      @group.destroy
      flash[:notice] = t('groups.deleted')
      redirect_to groups_path
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
  end

  def batch
    if @logged_in.admin?(:manage_groups)
      if request.post?
        @errors = []
        @groups = Group.order('category, name')
        @groups.each do |group|
          if vals = params[:groups][group.id.to_s]
            group.attributes = vals.permit(*group_attributes)
            if group.changed?
              unless group.save
                @errors << [group.id, group.errors.values]
              end
            end
          end
        end
      else
        @groups = Group.order('category, name')
      end
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @errors.any? 
 @errors.each do |id, errors| 
 id 
 id 
 escape_javascript errors.join('; ') 
 end 
 escape_javascript t('groups.batch.errors') 
 else 
 escape_javascript t('changes_saved') 
 end 

end

  end

  private

  def person_index
    @person = Person.find(params[:person_id])
    respond_to do |format|
      format.js   { ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end
 }
      format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t(@person.name =~ /s$/ ? 's' : 'no_s', scope: 'groups.groups_of', name: @person.name) 
  

end
 }
    end
  end

  def search_index
    @categories = Group.category_names
    @groups = Group.all
    @groups.where!(category: params[:category]) if params[:category].present?
    @groups.where!('name like ?', "%#{params[:name]}%") if params[:name].present?
    @groups.order!(:name)
    @hidden_groups = @groups.where(hidden: true)
    @groups.where!(approved: true) unless @logged_in.admin?(:manage_groups)
    @groups.where!(hidden: false) unless @logged_in.admin?(:manage_groups) and params[:include_hidden]
    @groups = @groups.page(params[:page])
    respond_to do |format|
      format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end
 }
      format.js
    end
  end

  def overview_index
    @categories = Group.category_names
    @unapproved_groups = Group.unapproved
    @unapproved_groups.where!(creator_id: @logged_in.id) unless @logged_in.admin?(:manage_groups)
    @person = @logged_in
    record_last_seen_group
    respond_to do |format|
      format.html
      if can_export?
        format.xml do
          job = ExportJob.perform_later(Site.current, 'groups', 'xml', @logged_in.id)
          redirect_to generated_file_path(job.job_id)
        end
        format.csv do
          job = ExportJob.perform_later(Site.current, 'groups', 'csv', @logged_in.id)
          redirect_to generated_file_path(job.job_id)
        end
      end
    end
  end

  def group_attributes
    base = [:name, :description, :photo, :meets, :location, :directions, :other_notes, :address, :members_send, :private, :category, :leader_id, :blog, :email, :prayer, :attendance, :gcal_private_link, :approval_required_to_join, :pictures, :cm_api_list_id, :has_tasks]
    base += [:approved, :membership_mode, :link_code, :parents_of, :hidden] if @logged_in.admin?(:manage_groups)
    base
  end

  def group_params
    params.require(:group).permit(*group_attributes)
  end

  def feature_enabled?
    unless Setting.get(:features, :groups)
      redirect_to people_path
      false
    end
  end

  def record_last_seen_group
    was = @logged_in.last_seen_group
    @logged_in.update_attribute(:last_seen_group_id, Group.maximum(:id))
    @logged_in.last_seen_group = was # so the "new" labels show in the view
  end
end

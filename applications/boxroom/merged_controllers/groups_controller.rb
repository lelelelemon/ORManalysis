class GroupsController < ApplicationController
  before_action :require_admin
  before_action :require_existing_group, :only => [:edit, :update, :destroy]
  before_action :require_group_isnt_admins_group, :only => [:edit, :update, :destroy]

  def index
    @groups = Group.order(:name)
 content_for :title, t(:groups) 
 content_for :title 
 image_tag('group_add.png', :alt => t(:create_a_new_group)) 
 link_to t(:create_a_new_group), new_group_path 
 t :name 
 @groups.each do |group| 
 cycle('even','odd') 
 if group.admins_group? 
 image_tag('group_grey.png') 
 group.name 
 else 
 image_tag('group.png') 
 group.name 
 link_to image_tag('edit.png', :alt => t(:edit)), edit_group_path(group), :title => t(:edit) 
 link_to image_tag('delete.png', :alt => t(:delete_item)), group_path(group), :method => :delete, :data => { :confirm => t(:are_you_sure) }, :title => t(:delete_item) 
 end 
 end 

  end

  def new
    @group = Group.new
 content_for :title, t(:new_group) 
 content_for :title 
  form_for @group do |f| 
 f.error_messages 
 f.label :name 
 f.text_field :name, { :class => 'text_input' } 
 f.submit t(:save) 
 link_to t(:back), groups_url 
 end 
 

  end

  def create
    @group = Group.new(permitted_params.group)

    if @group.save
      redirect_to groups_url
    else
       content_for :title, t(:new_group) 
 content_for :title 
  form_for @group do |f| 
 f.error_messages 
 f.label :name 
 f.text_field :name, { :class => 'text_input' } 
 f.submit t(:save) 
 link_to t(:back), groups_url 
 end 
 

    end
  end

  # Note: @group is set in require_existing_group
  def edit
 content_for :title, t(:rename_group) 
 content_for :title 
  form_for @group do |f| 
 f.error_messages 
 f.label :name 
 f.text_field :name, { :class => 'text_input' } 
 f.submit t(:save) 
 link_to t(:back), groups_url 
 end 
 

  end

  # Note: @group is set in require_existing_group
  def update
    if @group.update_attributes(permitted_params.group)
      redirect_to edit_group_url(@group), :notice => t(:your_changes_were_saved)
    else
       content_for :title, t(:rename_group) 
 content_for :title 
  form_for @group do |f| 
 f.error_messages 
 f.label :name 
 f.text_field :name, { :class => 'text_input' } 
 f.submit t(:save) 
 link_to t(:back), groups_url 
 end 
 

    end
  end

  # Note: @group is set in require_existing_group
  def destroy
    @group.destroy
    redirect_to groups_url
  end

  private

  def require_existing_group
    @group = Group.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to groups_url, :alert => t(:group_already_deleted)
  end

  def require_group_isnt_admins_group
    if @group.admins_group?
      redirect_to groups_url, :alert => t(:admins_group_cannot_be_deleted)
    end
  end
end

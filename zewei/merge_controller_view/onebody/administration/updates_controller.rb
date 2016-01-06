class Administration::UpdatesController < ApplicationController
  before_filter :only_admins

  def index
    @updates = toggle(Update).order('created_at desc').page(params[:page])
    @unapproved_groups = Group.unapproved
 @title = t('admin.updates.profile_updates') 
 content_for :sub_title do 
 link_to t('admin.updates.toggle.pending'), { complete: nil }, class: "#{@complete ? 'toggle-enabled' : 'toggle-disabled'} btn-xs" 
 link_to t('admin.updates.toggle.complete'), { complete: true }, class: "#{@complete ? 'toggle-disabled' : 'toggle-enabled'} btn-xs" 
 end 
 pagination @updates 
 @updates.each do |update| 
 avatar_tag(update.person) 
 if update.person 
 link_to update.person.name, update.person 
 else 
 end 
 t('admin.updates.updated') 
 update.created_at.to_s(:full) 
 form_for update, url: administration_update_path(update) do |form| 
 hidden_field_tag 'update[apply]', true 
 t('admin.updates.diff.property') 
 t('admin.updates.diff.before') 
 t('admin.updates.diff.after') 
 update.diff[:person].each do |key, (before, after)| 
 update_row(update.person, key, before, after) 
 end 
 update.diff[:family].each do |key, (before, after)| 
 update_row(update.family, key, before, after) 
 end 
 if update.require_child_designation? 
 t('admin.updates.child_alert', years: Setting.get(:system, :adult_age)) 
 t('admin.updates.child') 
 select_tag 'update[child]', options_for_select(t('admin.updates.child_select_options')) 
 end 
 if update.complete 
 link_to t('admin.updates.mark_incomplete'), administration_update_path(update, 'update[complete]' => false), method: 'put', class: 'btn btn-warning' 
 else 
 link_to_function t('admin.updates.apply'), "$(this).parents('form')[0].submit()", class: 'btn btn-success' 
 link_to t('admin.updates.mark_complete'), administration_update_path(update, 'update[complete]' => true), method: 'put', class: 'btn btn-warning' 
 end 
 link_to t('Delete'), administration_update_path(update), method: 'delete', data: { confirm: t('are_you_sure') }, class: 'btn btn-danger' 
 end 
 end 
 pagination @updates 
 if @updates.empty? 
 t('none') 
 end 

  end

  def update
    @update = Update.find(params[:id])
    if @update.update_attributes!(update_params)
      redirect_to administration_updates_path
    else
      render action: 'index'
    end
  end

  def destroy
    @update = Update.find(params[:id])
    @update.destroy
    redirect_to administration_updates_path
  end

  private

  def update_params
    params.require(:update).permit(:complete, :apply, :child)
  end

  def toggle(klass)
    if params[:complete] == 'true'
      @complete = true
      klass.complete
    else
      @complete = false
      klass.pending
    end
  end

  def only_admins
    unless @logged_in.admin?(:manage_updates)
      render text: t('only_admins'), layout: true, status: 401
      return false
    end
  end

end

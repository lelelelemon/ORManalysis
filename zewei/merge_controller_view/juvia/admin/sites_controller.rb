class Admin::SitesController < ApplicationController
  layout 'admin'
  
  before_filter :set_navigation_ids
  
  # GET /admin/sites
  # GET /admin/sites.json
  def index
    authorize! :read, Site
    @sites = Site.accessible_by(current_ability, :read).order('name').page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @sites }
    end
  end

  # GET /admin/sites/1
  # GET /admin/sites/1.json
  def show
    @site = Site.find(params[:id])
    authorize! :read, @site

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @site }
    end
  end

  # GET /admin/sites/new
  # GET /admin/sites/new.json
  def new
    authorize! :create, Site
    @site = Site.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @site }
    end
  end

  # GET /admin/sites/1/edit
  def edit
    @site = Site.find(params[:id])
    authorize! :update, @site
 @site.name 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 form_for([:admin, @site]) do |f| 
 if @site.errors.any? 
 pluralize(@site.errors.count, "error") 
 @site.errors.full_messages.each do |msg| 
 msg 
 end 
 end 
 f.label :name 
 f.text_field :name 
 f.label :url, 'URL (optional unless moderating with Akismet)' 
 f.text_field :url 
 f.radio_button :moderation_method, :none 
 f.radio_button :moderation_method, :akismet 
 f.radio_button :moderation_method, :manual 
 f.label :akismet_key 
 f.text_field :akismet_key 
 primary_button_submit_tag(@site.new_record? ? 'Create' : 'Update') 
 button_link_to 'Cancel', [:admin, @site] 
 end 

end
 

  end

  def created
    @site = Site.find(params[:id])
    authorize! :read, @site
 @title = "Your site has been created!" 
 @site.name 
 html_unsafe(
  render(:partial => 'admin/help/code.txt',
      :locals => {
          :site_key  => @site.key
      }
  ))

 positive_button_link_to 'Roger that!', [:admin, @site] 
 comment_button_link_to 'See it in action', test_admin_site_path(@site) 
 button_link_to 'Teach me more about embedding', '/admin/help/embedding' 

  end

  def test
    @site = Site.find(params[:id])
    authorize! :read, @site
 @title = "Test page for site #{@site.name}" 
 link_to @site.name, [:admin, @site] 
 @site.name 
 html_unsafe(
  render(:partial => 'admin/help/code.txt',
      :locals => {
          :container => '#comments',
          :site_key  => @site.key,
          :topic_key => 'test'
      }
  ))

 render(:partial => 'admin/help/code.txt',
      :locals => {
          :container => '#comments',
          :site_key  => @site.key,
          :topic_key => 'test'
      }
) 

  end

  # POST /admin/sites
  # POST /admin/sites.json
  def create
    authorize! :create, Site
    @site = Site.new(params[:site], :as => current_user.role)
    @site.user = current_user

    respond_to do |format|
      if @site.save
        format.html { redirect_to [:admin, @site] }
        format.json { render :json => @site, :status => :created, :location => @site }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 form_for([:admin, @site]) do |f| 
 if @site.errors.any? 
 pluralize(@site.errors.count, "error") 
 @site.errors.full_messages.each do |msg| 
 msg 
 end 
 end 
 f.label :name 
 f.text_field :name 
 f.label :url, 'URL (optional unless moderating with Akismet)' 
 f.text_field :url 
 f.radio_button :moderation_method, :none 
 f.radio_button :moderation_method, :akismet 
 f.radio_button :moderation_method, :manual 
 f.label :akismet_key 
 f.text_field :akismet_key 
 primary_button_submit_tag(@site.new_record? ? 'Create' : 'Update') 
 button_link_to 'Cancel', [:admin, @site] 
 end 

end
 

end
 }
        format.json { render :json => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/sites/1
  # PUT /admin/sites/1.json
  def update
    @site = Site.find(params[:id])
    authorize! :update, @site

    respond_to do |format|
      if @site.update_attributes(params[:site], :as => current_user.role)
        format.html { redirect_to [:admin, @site], :notice => 'Site was successfully updated.' }
        format.json { head :ok }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 @site.name 
 ruby_code_from_view.ruby_code_from_view do |rb_from_view| 
 form_for([:admin, @site]) do |f| 
 if @site.errors.any? 
 pluralize(@site.errors.count, "error") 
 @site.errors.full_messages.each do |msg| 
 msg 
 end 
 end 
 f.label :name 
 f.text_field :name 
 f.label :url, 'URL (optional unless moderating with Akismet)' 
 f.text_field :url 
 f.radio_button :moderation_method, :none 
 f.radio_button :moderation_method, :akismet 
 f.radio_button :moderation_method, :manual 
 f.label :akismet_key 
 f.text_field :akismet_key 
 primary_button_submit_tag(@site.new_record? ? 'Create' : 'Update') 
 button_link_to 'Cancel', [:admin, @site] 
 end 

end
 

end
 }
        format.json { render :json => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/sites/1
  # DELETE /admin/sites/1.json
  def destroy
    @site = Site.find(params[:id])
    authorize! :destroy, @site
    @site.destroy

    respond_to do |format|
      format.html { redirect_to admin_sites_path }
      format.json { head :ok }
    end
  end

private
  def set_navigation_ids
    @navigation_ids = [:dashboard, :sites]
  end
end

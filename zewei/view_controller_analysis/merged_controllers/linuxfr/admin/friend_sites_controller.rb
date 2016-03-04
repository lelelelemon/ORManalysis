# encoding: UTF-8
class Admin::FriendSitesController < AdminController
  before_action :find_friend_site, except: [:index, :new, :create]

  def index
    @friend_sites = FriendSite.all
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Les sites amis" 
 link_to "Ajouter un site ami", new_admin_friend_site_path 
 if @friend_sites.empty? 
 else 
 @friend_sites.each do |site| 
 site.title 
 link_to site.url, site.url 
 button_to "&uarr;".html_safe, higher_admin_friend_site_path(site) 
 button_to "&darr;".html_safe, lower_admin_friend_site_path(site) 
 link_to "Modifier", edit_admin_friend_site_path(site) 
 button_to "Supprimer", [:admin, site], method: :delete, data: { confirm: "Supprimer le site ami ?" }, class: "delete_button" 
 end 
 end 

end

  end

  def new
    @friend_site = FriendSite.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Ajouter un site ami" 
 form_for [:admin, @friend_site] do |form| 
 render form 
 end 

end

  end

  def create
    @friend_site = FriendSite.new
    @friend_site.attributes = params[:friend_site]
    if @friend_site.save
      @friend_site.move_to_bottom
      redirect_to admin_friend_sites_url, notice: "Site ami créé"
    else
      flash.now[:alert] = "Impossible d'enregistrer ce site"
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Ajouter un site ami" 
 form_for [:admin, @friend_site] do |form| 
 render form 
 end 

end

    end
  end

  def edit
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Modifier un site ami" 
 form_for [:admin, @friend_site] do |form| 
 render form 
 end 

end

  end

  def update
    @friend_site.attributes = params[:friend_site]
    if @friend_site.save
      redirect_to admin_friend_sites_url, notice: "Site ami modifié"
    else
      flash.now[:alert] = "Impossible d'enregistrer ce site"
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Modifier un site ami" 
 form_for [:admin, @friend_site] do |form| 
 render form 
 end 

end

    end
  end

  def destroy
    @friend_site.destroy
    redirect_to admin_friend_sites_url, notice: "Site ami supprimé"
  end

  def lower
    @friend_site.move_lower
    redirect_to admin_friend_sites_url
  end

  def higher
    @friend_site.move_higher
    redirect_to admin_friend_sites_url
  end

protected

  def find_friend_site
    @friend_site = FriendSite.find(params[:id])
  end
end

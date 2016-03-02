# encoding: utf-8
class AdminController < ApplicationController
  before_action :admin_required
  before_action :permit_params

  def index
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Administration" 
 link_to "Derniers comptes utilisateurs", admin_accounts_path 
 link_to "Rponses de refus (pour les dpches)", admin_responses_path 
 link_to "Sections (pour les dpches)", admin_sections_path 
 link_to "Forums", admin_forums_path 
 link_to "Catgories (pour le suivi)", admin_categories_path 
 link_to "Bannires", admin_banners_path 
 link_to "Logo", admin_logo_path 
 link_to "Feuilles de style", admin_stylesheet_path 
 link_to "Sites amis", admin_friend_sites_path 
 link_to "Pages statiques", admin_pages_path 
 link_to "Applications de l'API", admin_applications_path 
 link_to "Debug", "/admin/debug" 

end

  end

  def debug
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Administration" 

end

  end

  protected

  def permit_params
    params.permit!
  end
end

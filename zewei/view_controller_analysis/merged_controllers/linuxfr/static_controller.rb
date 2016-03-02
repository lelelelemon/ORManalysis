# encoding: utf-8
class StaticController < ApplicationController
  def show
    @page = Page.find_by!(slug: params[:id])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 @page.title 
 @description = @page.title 
 helperify(@page.body) 

end

  end

  def submit_content
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Proposer un contenu" 
 link_to "Je souhaite proposer une dpche et la soumettre directement  la modration.", "/news/nouveau" 
 link_to "Je souhaite commencer une dpche dans l'espace collaboratif et pouvoir tre aid(e) par d'autres personnes.", "/redaction" 
 link_to "Je souhaite participer  l'criture collaborative d'une dpche.", "/redaction" 
 link_to "Je souhaite remonter un bug ou proposer une volution", "/suivi/nouveau" 
 if account_signed_in? 
 else 
 end 
 link_to "Je souhaite crire un journal", "/journaux/nouveau" 
 link_to "Je souhaite poster dans les forums", "/posts/nouveau" 
 link_to "Je souhaite suggrer un sondage", "/sondages/nouveau" 
 link_to "Je souhaite crire une nouvelle page de wiki", "/wiki/nouveau" 

end

  end

  def changelog
    @page    = params[:page].to_i
    per_page = 15
    skip     = per_page * @page
    @commits = `cd #{Rails.root} && git log -n #{per_page} --skip=#{skip} --no-merges`
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 h1 "Changelog" 
 @commits 
 if @page > 0 
 link_to "Commits plus rcents", { page: @page - 1 }, { rel: 'prev' } 
 end 
 link_to "Commits plus anciens", { page: @page + 1 }, { rel: 'next' } 

end

  end
end

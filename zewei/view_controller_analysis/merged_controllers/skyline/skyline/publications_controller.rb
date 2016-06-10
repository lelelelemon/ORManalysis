class Skyline::PublicationsController < Skyline::ApplicationController
  
  before_filter :find_article
  before_filter :find_publication, :only => [:rollback]
  
  authorize :rollback, :by => "article_variant_create"
  
  def index
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 escape_javascript(t(:dialog_title, :scope => [:publication,:index])) 
  form_tag "", :class => "unsubmittable" do 
 t(:publications, :scope => [:publication,:index]) 
 @article.publications.each do |publication| 
 skyline_article_article_version_url(@article, publication) 
 publication.id 
l(publication.created_at, :format => :short)
publication.data.navigation_title
publication.name
 end 
 t(:preview, :scope => [:publication,:index]) 
 link_to_function t(:cancel, :scope => [:buttons]), "Skyline.Dialog.current.close()", :class => "cancel"  
 if @article.editable_by?(current_user) 
 submit_button :rollback, :disabled => true, :class => "small disabled" 
 end 
 end 
 
 escape_javascript(rollback_skyline_article_publication_path(@article, "000")) 

end

  end
  
  def rollback
  	return handle_unauthorized_user if @article.locked? && !current_user.allow?(:page_lock)
  	
  	new_variant = @publication.rollback({'name' => @publication.name})
  	notifications[:success] = t(:success, :scope => [:publication, :rollback, :flashes])
  	redirect_to edit_skyline_article_path(@article, :variant_id => new_variant.id)
	rescue
		messages[:error] = t(:error, :scope => [:publication, :rollback, :flashes])
		redirect_to edit_skyline_article_path(@article)
	end
  
  protected
  
  def find_article
    @article = Skyline::Article.find_by_id(params[:article_id])
    return redirect_to(skyline_articles_path(:type => params[:article_type])) unless @article
  end    
  
  def find_publication
    @publication = @article.publications.find_by_id(params[:id])
    return redirect_to(edit_skyline_articles_path(@article)) unless @publication
	end
end
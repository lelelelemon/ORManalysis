class Skyline::LocalesController < Skyline::ApplicationController

  def show
    locale = params[:id]
    unless @locale = I18n.t("tinymce", :locale => (locale || I18n.locale))
      render :nothing => true, :status => :not_found
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @options = {
  "locale"  => I18n.locale.to_s.downcase
} 
 @locale.each do |key,value| 
 I18n.locale 
 key 
 value.update(@options).to_json.html_safe 
 end 
 t(:all_uploaded_message, :scope => [:media, :files, :new]).html_safe 
 t(:some_uploaded_message, :scope => [:media, :files, :new]).html_safe 

end

  end
  
  protected
  
  def protect?
    false
  end
end

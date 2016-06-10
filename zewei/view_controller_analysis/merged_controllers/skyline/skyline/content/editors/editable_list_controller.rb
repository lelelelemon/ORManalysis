class Skyline::Content::Editors::EditableListController < Skyline::Skyline2Controller

  helper "skyline/content"
  before_filter :get_classes
  
  def new
    @object = @source_object.send(@assoc.name).build
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 editor = Skyline::Editors::EditableList.new(["element"],@source_object,@source_klass.fields[params[:association].to_sym],@template) 
 editor.js_object_name 
 escape_javascript editor.render_row(@object) 

end

  end
  
  protected
  
  def get_classes
    @source_klass = @implementation.content_class(params[:source_type])
    @source_object = @source_klass.find_by_id(params[:source_id]) || @source_klass.new    
    @assoc = @source_klass.reflect_on_association(params[:association].to_sym)
    @target_klass = @assoc.klass
  end
  
end

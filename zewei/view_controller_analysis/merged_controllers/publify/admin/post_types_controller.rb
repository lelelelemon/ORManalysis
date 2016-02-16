class Admin::PostTypesController < Admin::BaseController
  before_action :set_post_type, only: [:edit, :update, :destroy]
  cache_sweeper :blog_sweeper

  def index
    @post_types = PostType.all
    @post_type = PostType.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  content_for :page_heading do 
 t(".post_types") 
 end 
 form_for([:admin, @post_type]) do |f| 
 if @post_type.errors.any? 
 @post_type.errors.full_messages.each do |message| 
 message 
 end 
 end 
 f.text_field :name, class: 'form-control', placeholder: "Name" 
 f.text_area :description, rows: 5, class: 'form-control', placeholder: "Description" 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 f.submit "Save", class: 'btn btn-success' 
 end 
 t(".name") 
 t(".description") 
 t(".template_name") 
 t(".default") 
 t(".publify_default_post_type") 
 @post_types.each do |post_type| 
 post_type.name 
 link_to content_tag(:span, '', class: 'glyphicon glyphicon-pencil'), edit_admin_post_type_path(post_type), { class: 'btn btn-primary btn-xs btn-action' } 
 link_to content_tag(:span, '', class: 'glyphicon glyphicon-trash'), admin_post_type_path(post_type), method: :delete, data: { confirm: 'Are you sure?' }, class: 'btn btn-danger btn-xs btn-action' 
 post_type.description 
 post_type.permalink 
 end 
 t(".explain") 
 

end

  end

  def edit
    @post_types = PostType.all
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  content_for :page_heading do 
 t(".post_types") 
 end 
 form_for([:admin, @post_type]) do |f| 
 if @post_type.errors.any? 
 @post_type.errors.full_messages.each do |message| 
 message 
 end 
 end 
 f.text_field :name, class: 'form-control', placeholder: "Name" 
 f.text_area :description, rows: 5, class: 'form-control', placeholder: "Description" 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 f.submit "Save", class: 'btn btn-success' 
 end 
 t(".name") 
 t(".description") 
 t(".template_name") 
 t(".default") 
 t(".publify_default_post_type") 
 @post_types.each do |post_type| 
 post_type.name 
 link_to content_tag(:span, '', class: 'glyphicon glyphicon-pencil'), edit_admin_post_type_path(post_type), { class: 'btn btn-primary btn-xs btn-action' } 
 link_to content_tag(:span, '', class: 'glyphicon glyphicon-trash'), admin_post_type_path(post_type), method: :delete, data: { confirm: 'Are you sure?' }, class: 'btn btn-danger btn-xs btn-action' 
 post_type.description 
 post_type.permalink 
 end 
 t(".explain") 
 

end

  end

  def create
    @post_type = PostType.new(post_type_params)

    if @post_type.save
      redirect_to admin_post_types_url, notice: 'Post type was successfully created.'
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  content_for :page_heading do 
 t(".post_types") 
 end 
 form_for([:admin, @post_type]) do |f| 
 if @post_type.errors.any? 
 @post_type.errors.full_messages.each do |message| 
 message 
 end 
 end 
 f.text_field :name, class: 'form-control', placeholder: "Name" 
 f.text_area :description, rows: 5, class: 'form-control', placeholder: "Description" 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 f.submit "Save", class: 'btn btn-success' 
 end 
 t(".name") 
 t(".description") 
 t(".template_name") 
 t(".default") 
 t(".publify_default_post_type") 
 @post_types.each do |post_type| 
 post_type.name 
 link_to content_tag(:span, '', class: 'glyphicon glyphicon-pencil'), edit_admin_post_type_path(post_type), { class: 'btn btn-primary btn-xs btn-action' } 
 link_to content_tag(:span, '', class: 'glyphicon glyphicon-trash'), admin_post_type_path(post_type), method: :delete, data: { confirm: 'Are you sure?' }, class: 'btn btn-danger btn-xs btn-action' 
 post_type.description 
 post_type.permalink 
 end 
 t(".explain") 
 

end

    end
  end

  def update
    if @post_type.update(post_type_params)
      redirect_to admin_post_types_url, notice: 'Post type was successfully updated.'
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  content_for :page_heading do 
 t(".post_types") 
 end 
 form_for([:admin, @post_type]) do |f| 
 if @post_type.errors.any? 
 @post_type.errors.full_messages.each do |message| 
 message 
 end 
 end 
 f.text_field :name, class: 'form-control', placeholder: "Name" 
 f.text_area :description, rows: 5, class: 'form-control', placeholder: "Description" 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 f.submit "Save", class: 'btn btn-success' 
 end 
 t(".name") 
 t(".description") 
 t(".template_name") 
 t(".default") 
 t(".publify_default_post_type") 
 @post_types.each do |post_type| 
 post_type.name 
 link_to content_tag(:span, '', class: 'glyphicon glyphicon-pencil'), edit_admin_post_type_path(post_type), { class: 'btn btn-primary btn-xs btn-action' } 
 link_to content_tag(:span, '', class: 'glyphicon glyphicon-trash'), admin_post_type_path(post_type), method: :delete, data: { confirm: 'Are you sure?' }, class: 'btn btn-danger btn-xs btn-action' 
 post_type.description 
 post_type.permalink 
 end 
 t(".explain") 
 

end

    end
  end

  def destroy
    # Reset all Articles from the PostType we're destroying to the default PostType
    # Wrap it in a transaction for safety
    @post_type.transaction do
      Article.where('post_type = ?', @post_type.permalink).each do |article|
        article.post_type = 'read'
        article.save
      end
      @post_type.destroy
    end
    redirect_to admin_post_types_url, notice: 'Post was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post_type
    @post_type = PostType.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_type_params
    params.require(:post_type).permit(:name, :description)
  end
end

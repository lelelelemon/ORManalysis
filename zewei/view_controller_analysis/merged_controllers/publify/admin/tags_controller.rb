class Admin::TagsController < Admin::BaseController
  before_action :fetch_tags, only: [:index, :edit]
  before_action :set_tag, only: [:edit, :update, :destroy]
  cache_sweeper :blog_sweeper

  def index
    @tag = Tag.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  content_for :page_heading do 
 t('.manage_tags') 
 end 
 form_for([:admin, @tag]) do |f| 
 if @tag.errors.any? 
 @tag.errors.full_messages.each do |message| 
 message 
 end 
 end 
 f.text_field :display_name, class: 'form-control', placeholder: "Name" 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 f.submit "Save", class: 'btn btn-success' 
 end 
 t('.display_name') 
 t('.name')  
 if @tags.empty? 
 t(".no_tags") 
 end 
 for tag in @tags 
 link_to tag.display_name, edit_admin_tag_path(tag), { class: 'edit' } 
 link_to content_tag(:span, '', class: 'glyphicon glyphicon-pencil'), edit_admin_tag_path(tag), { class: 'btn btn-primary btn-xs btn-action' } 
 link_to content_tag(:span, '', class: 'glyphicon glyphicon-trash'), admin_tag_path(tag), method: :delete, data: { confirm: 'Are you sure?' }, class: 'btn btn-danger btn-xs btn-action' 
 link_to_permalink(tag, "#{tag.articles.size} <span class='glyphicon glyphicon-link'></span>".html_safe, nil, 'btn btn-success btn-xs').html_safe 
 tag.name 
 end 
 display_pagination(@tags, 3) 
 

end

  end

  def edit
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  content_for :page_heading do 
 t('.manage_tags') 
 end 
 form_for([:admin, @tag]) do |f| 
 if @tag.errors.any? 
 @tag.errors.full_messages.each do |message| 
 message 
 end 
 end 
 f.text_field :display_name, class: 'form-control', placeholder: "Name" 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 f.submit "Save", class: 'btn btn-success' 
 end 
 t('.display_name') 
 t('.name')  
 if @tags.empty? 
 t(".no_tags") 
 end 
 for tag in @tags 
 link_to tag.display_name, edit_admin_tag_path(tag), { class: 'edit' } 
 link_to content_tag(:span, '', class: 'glyphicon glyphicon-pencil'), edit_admin_tag_path(tag), { class: 'btn btn-primary btn-xs btn-action' } 
 link_to content_tag(:span, '', class: 'glyphicon glyphicon-trash'), admin_tag_path(tag), method: :delete, data: { confirm: 'Are you sure?' }, class: 'btn btn-danger btn-xs btn-action' 
 link_to_permalink(tag, "#{tag.articles.size} <span class='glyphicon glyphicon-link'></span>".html_safe, nil, 'btn btn-success btn-xs').html_safe 
 tag.name 
 end 
 display_pagination(@tags, 3) 
 

end

  end

  def create
    @tag = this_blog.tags.new(tag_params)

    if @tag.save
      redirect_to admin_tags_url, notice: 'Tag was successfully created.'
    else
      fetch_tags
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  content_for :page_heading do 
 t('.manage_tags') 
 end 
 form_for([:admin, @tag]) do |f| 
 if @tag.errors.any? 
 @tag.errors.full_messages.each do |message| 
 message 
 end 
 end 
 f.text_field :display_name, class: 'form-control', placeholder: "Name" 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 f.submit "Save", class: 'btn btn-success' 
 end 
 t('.display_name') 
 t('.name')  
 if @tags.empty? 
 t(".no_tags") 
 end 
 for tag in @tags 
 link_to tag.display_name, edit_admin_tag_path(tag), { class: 'edit' } 
 link_to content_tag(:span, '', class: 'glyphicon glyphicon-pencil'), edit_admin_tag_path(tag), { class: 'btn btn-primary btn-xs btn-action' } 
 link_to content_tag(:span, '', class: 'glyphicon glyphicon-trash'), admin_tag_path(tag), method: :delete, data: { confirm: 'Are you sure?' }, class: 'btn btn-danger btn-xs btn-action' 
 link_to_permalink(tag, "#{tag.articles.size} <span class='glyphicon glyphicon-link'></span>".html_safe, nil, 'btn btn-success btn-xs').html_safe 
 tag.name 
 end 
 display_pagination(@tags, 3) 
 

end

    end
  end

  def update
    old_name = @tag.name
    if @tag.update(tag_params)
      Redirect.create(from_path: "/tag/#{old_name}", to_path: @tag.permalink_url(nil, true))
      redirect_to admin_tags_url, notice: I18n.t('admin.tags.edit.success')
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  content_for :page_heading do 
 t('.manage_tags') 
 end 
 form_for([:admin, @tag]) do |f| 
 if @tag.errors.any? 
 @tag.errors.full_messages.each do |message| 
 message 
 end 
 end 
 f.text_field :display_name, class: 'form-control', placeholder: "Name" 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 f.submit "Save", class: 'btn btn-success' 
 end 
 t('.display_name') 
 t('.name')  
 if @tags.empty? 
 t(".no_tags") 
 end 
 for tag in @tags 
 link_to tag.display_name, edit_admin_tag_path(tag), { class: 'edit' } 
 link_to content_tag(:span, '', class: 'glyphicon glyphicon-pencil'), edit_admin_tag_path(tag), { class: 'btn btn-primary btn-xs btn-action' } 
 link_to content_tag(:span, '', class: 'glyphicon glyphicon-trash'), admin_tag_path(tag), method: :delete, data: { confirm: 'Are you sure?' }, class: 'btn btn-danger btn-xs btn-action' 
 link_to_permalink(tag, "#{tag.articles.size} <span class='glyphicon glyphicon-link'></span>".html_safe, nil, 'btn btn-success btn-xs').html_safe 
 tag.name 
 end 
 display_pagination(@tags, 3) 
 

end

    end
  end

  def destroy
    destroy_a(Tag)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tag
    @tag = Tag.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tag_params
    params.require(:tag).permit(:display_name)
  end

  def fetch_tags
    @tags = Tag.order('display_name').page(params[:page]).per(this_blog.admin_display_elements)
  end
end

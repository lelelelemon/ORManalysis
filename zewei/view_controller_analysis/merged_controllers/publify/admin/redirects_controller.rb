class Admin::RedirectsController < Admin::BaseController
  before_action :set_redirect, only: [:edit, :update, :destroy]

  def index
    @redirects = Redirect.where(content_id: nil).order('id desc').page(params[:page]).per(this_blog.admin_display_elements)
    @redirect = Redirect.new
  content_for :page_heading do 
 t(".redirects") 
 end 
 form_for([:admin, @redirect]) do |f| 
 if @redirect.errors.any? 
 @redirect.errors.full_messages.each do |redirect| 
 message 
 end 
 end 
 f.text_field :from_path, class: 'form-control', placeholder: "From #{this_blog.base_url}/" 
 t(".leave_empty_to_shorten_a_link") 
 f.text_field :to_path, class: 'form-control', placeholder: "To" 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 f.submit "Save", class: 'btn btn-success' 
 end 
 t(".from") 
 t(".to") 
 if @redirects.empty? 
 t(".no_redirects") 
 end 
 for redirect in @redirects 
 link_to("#{redirect.from_url}", "#{redirect.from_url}") 
 button_to_edit redirect 
 button_to_delete redirect 
 link_to(redirect.to_path, redirect.to_path) 
 end 
 display_pagination(@redirects, 2) 
 

  end

  def edit
    @redirects = Redirect.where(content_id: nil).order('id desc').page(params[:page]).per(this_blog.admin_display_elements)
  content_for :page_heading do 
 t(".redirects") 
 end 
 form_for([:admin, @redirect]) do |f| 
 if @redirect.errors.any? 
 @redirect.errors.full_messages.each do |redirect| 
 message 
 end 
 end 
 f.text_field :from_path, class: 'form-control', placeholder: "From #{this_blog.base_url}/" 
 t(".leave_empty_to_shorten_a_link") 
 f.text_field :to_path, class: 'form-control', placeholder: "To" 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 f.submit "Save", class: 'btn btn-success' 
 end 
 t(".from") 
 t(".to") 
 if @redirects.empty? 
 t(".no_redirects") 
 end 
 for redirect in @redirects 
 link_to("#{redirect.from_url}", "#{redirect.from_url}") 
 button_to_edit redirect 
 button_to_delete redirect 
 link_to(redirect.to_path, redirect.to_path) 
 end 
 display_pagination(@redirects, 2) 
 

  end

  def create
    @redirect = this_blog.redirects.build(redirect_params)

    if @redirect.save
      redirect_to admin_redirects_url, notice: 'Redirect was successfully created.'
    else
        content_for :page_heading do 
 t(".redirects") 
 end 
 form_for([:admin, @redirect]) do |f| 
 if @redirect.errors.any? 
 @redirect.errors.full_messages.each do |redirect| 
 message 
 end 
 end 
 f.text_field :from_path, class: 'form-control', placeholder: "From #{this_blog.base_url}/" 
 t(".leave_empty_to_shorten_a_link") 
 f.text_field :to_path, class: 'form-control', placeholder: "To" 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 f.submit "Save", class: 'btn btn-success' 
 end 
 t(".from") 
 t(".to") 
 if @redirects.empty? 
 t(".no_redirects") 
 end 
 for redirect in @redirects 
 link_to("#{redirect.from_url}", "#{redirect.from_url}") 
 button_to_edit redirect 
 button_to_delete redirect 
 link_to(redirect.to_path, redirect.to_path) 
 end 
 display_pagination(@redirects, 2) 
 

    end
  end

  def update
    if @redirect.update(redirect_params)
      redirect_to admin_redirects_url, notice: 'Redirect was successfully updated.'
    else
        content_for :page_heading do 
 t(".redirects") 
 end 
 form_for([:admin, @redirect]) do |f| 
 if @redirect.errors.any? 
 @redirect.errors.full_messages.each do |redirect| 
 message 
 end 
 end 
 f.text_field :from_path, class: 'form-control', placeholder: "From #{this_blog.base_url}/" 
 t(".leave_empty_to_shorten_a_link") 
 f.text_field :to_path, class: 'form-control', placeholder: "To" 
 link_to(t(".cancel"), {action: 'index'}) 
 t(".or") 
 f.submit "Save", class: 'btn btn-success' 
 end 
 t(".from") 
 t(".to") 
 if @redirects.empty? 
 t(".no_redirects") 
 end 
 for redirect in @redirects 
 link_to("#{redirect.from_url}", "#{redirect.from_url}") 
 button_to_edit redirect 
 button_to_delete redirect 
 link_to(redirect.to_path, redirect.to_path) 
 end 
 display_pagination(@redirects, 2) 
 

    end
  end

  def destroy
    @redirect.destroy
    redirect_to admin_redirects_url, notice: I18n.t('admin.redirects.destroy.success')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_redirect
    @redirect = Redirect.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def redirect_params
    params.require(:redirect).permit(:from_path, :to_path)
  end
end

require 'fog'

class Admin::ResourcesController < Admin::BaseController
  cache_sweeper :blog_sweeper

  def upload
    if !params[:upload].blank?
      file = params[:upload][:filename]

      mime = if file.content_type
               file.content_type.chomp
             else
               'text/plain'
             end

      @up = Resource.create(upload: file, mime: mime, created_at: Time.now)
      flash[:success] = I18n.t('admin.resources.upload.success')
    else
      flash[:warning] = I18n.t('admin.resources.upload.warning')
    end

    redirect_to admin_resources_url
  end

  def index
    @r = Resource.new
    @resources = Resource.order('created_at DESC').page(params[:page]).per(this_blog.admin_display_elements)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :page_heading do 
 t(".media_library") 
 end 
 form_tag({action: 'upload'}, {enctype: "multipart/form-data", class: 'form-inline'}) do 
 t('.upload_a_file_to_your_site') 
 file_field('upload', 'filename', {class: 'input-file'}) 
 submit_tag(t('.upload'), {class: 'btn btn-success'}) 
 end 
 t(".filename")
 t('.right_click_for_link') 
 t(".content_type")
 t(".file_size")
 t(".date")
 if @resources.empty? 
 t(".no_resources") 
 end 
 for upload in @resources 
 if upload.mime =~ /image/ 
 upload.upload.medium.url 
 image_tag(upload.upload.thumb.url) 
 else 
 link_to(upload.upload_url, upload.upload_url) 
 end 
 if upload.mime =~ /image/ 
 link_to(t(".thumbnail"), upload.upload.thumb.url) 
 link_to(t(".medium_size"), upload.upload.medium.url) 
 link_to(t(".original_size"), upload.upload.url) 
 end 
 link_to(t(".delete"),
                      { action: 'destroy', id: upload.id, search: params[:search], page: params[:page] },
                      confirm: t(".are_you_sure"), method: :delete) 
 upload.mime 
h upload.size rescue 0 
 l(upload.created_at, format: :short) 
 end 
 display_pagination(@resources, 6)

end

  end

  def destroy
    @record = Resource.find(params[:id])
    @record.destroy
    flash[:notice] = I18n.t('admin.resources.destroy.notice')
    redirect_to admin_resources_url
  end
end

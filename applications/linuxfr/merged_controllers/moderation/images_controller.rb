# encoding: UTF-8
class Moderation::ImagesController < ModerationController

  def index
    @images = Image.latest(20)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @images.each do |image| 
 image.to_html.html_safe 
 button_to "Bloquer", moderation_image_path(image.encoded_link), method: :delete, data: { confirm: "tes-vous sr de vouloir bloquer cette image ?" } 
 end 

end

  end

  def destroy
    Image.destroy params[:id] unless params[:id].blank?
    redirect_to moderation_images_url
  end
end

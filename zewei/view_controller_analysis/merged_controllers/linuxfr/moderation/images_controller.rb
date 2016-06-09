# encoding: UTF-8
class Moderation::ImagesController < ModerationController

  def index
    @images = Image.latest(20)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def destroy
    Image.destroy params[:id] unless params[:id].blank?
    redirect_to moderation_images_url
  end
end

# encoding: UTF-8
class Admin::BannersController < AdminController
  before_action :load_banner, only: [:update, :destroy]

  def index
    @banners = Banner.all
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def new
    @banner = Banner.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def create
    @banner = Banner.new(params[:banner])
    if !preview_mode && @banner.save
      redirect_to admin_banners_url, notice: 'Nouvelle bannière créée.'
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

    end
  end

  def edit
    @banner = Banner.find(params[:id])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def update
    @banner.attributes = params[:banner]
    if !preview_mode && @banner.save
      redirect_to admin_banners_url, notice: 'Bannière mise à jour.'
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

    end
  end

  def destroy
    @banner.destroy
    redirect_to admin_banners_url, notice: 'Bannière supprimée'
  end

protected

  def load_banner
    @banner = Banner.find(params[:id])
  end

end

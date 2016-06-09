# encoding: UTF-8
class Admin::StylesheetsController < AdminController

  def show
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def create
    Stylesheet.temporary(current_account, params[:url]) do
      redirect_to "/" + Stylesheet.capture("http://#{MY_DOMAIN}/", cookies)
    end
  end

end

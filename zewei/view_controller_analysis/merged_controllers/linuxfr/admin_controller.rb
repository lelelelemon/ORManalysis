# encoding: utf-8
class AdminController < ApplicationController
  before_action :admin_required
  before_action :permit_params

  def index
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def debug
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  protected

  def permit_params
    params.permit!
  end
end

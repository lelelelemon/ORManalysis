# encoding: utf-8
class StaticController < ApplicationController
  def show
    @page = Page.find_by!(slug: params[:id])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def submit_content
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def changelog
    @page    = params[:page].to_i
    per_page = 15
    skip     = per_page * @page
    @commits = `cd #{Rails.root} && git log -n #{per_page} --skip=#{skip} --no-merges`
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end
end

# encoding: UTF-8
class StatisticsController < ApplicationController

  def tracker
    @stats = Statistics::Tracker.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def prizes
    @month = params[:month]
    @stats = Statistics::Prizes.new(@month)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def users
    @stats = Statistics::Users.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def top
    @stats = Statistics::Tops.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def moderation
    @stats = Statistics::Moderation.new
    @goals = Statistics::Goals.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def redaction
    @stats = Statistics::Redaction.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def contents
    @stats = Statistics::Contents.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def comments
    @stats = Statistics::Comments.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  def tags
    @stats = Statistics::Tags.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end
end

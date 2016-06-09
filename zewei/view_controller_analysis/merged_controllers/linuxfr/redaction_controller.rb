# encoding: utf-8
class RedactionController < ApplicationController
  before_action :authenticate_account!
  append_view_path NoNamespaceResolver.new

  def index
    @boards = Board.all(Board.writing)
    @board  = @boards.build
    @drafts = News.draft.sorted
    @news   = News.candidate.sorted
    @stats  = Statistics::Redaction.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end
end

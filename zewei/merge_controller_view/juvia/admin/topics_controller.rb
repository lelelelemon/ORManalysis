class Admin::TopicsController < ApplicationController
  layout 'admin'

  load_and_authorize_resource
  before_filter :set_navigation_ids

  def show
    show! do
      @comments = @topic.comments.page(params[:page])
    end
 @title = @topic.title 
 large_identity_tag :topic, "#{link_to @topic.site.name, [:admin, @topic.site]} / #{@topic.title}".html_safe 
 @topic.key 
 if @topic.url 
 link_to @topic.url, @topic.url 
 else 
 end 
 remove_button_link_to 'Delete entire topic', [:admin, @topic],
        :method => :delete,
        :confirm => 'Are you sure? All containing comments will also be removed!' 
 render @comments 
 will_paginate @comments 

  end

  def destroy
    destroy! { admin_site_path(@topic.site) }
  end

  def index
    raise "Not allowed"
  end

  def new
    raise "Not allowed"
  end

  def create
    raise "Not allowed"
  end

  def edit
    raise "Not allowed"
  end

  def update
    raise "Not allowed"
  end

private
  def set_navigation_ids
    @navigation_ids = [:dashboard, :sites]
  end
end

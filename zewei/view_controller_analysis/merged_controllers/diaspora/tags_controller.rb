#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class TagsController < ApplicationController
  skip_before_action :set_grammatical_gender
  before_action :ensure_page, :only => :show

  helper_method :tag_followed?

  layout proc { request.format == :mobile ? "application" : "with_header" }, only: :show

  respond_to :html, :only => [:show]
  respond_to :json, :only => [:index, :show]

  def index
    if params[:q] && params[:q].length > 1
      params[:q].gsub!("#", "")
      params[:limit] = !params[:limit].blank? ? params[:limit].to_i : 10
      @tags = ActsAsTaggableOn::Tag.autocomplete(params[:q]).limit(params[:limit] - 1)
      prep_tags_for_javascript

      respond_to do |format|
        format.json{ render(:json => @tags.to_json, :status => 200) }
      end
    else
      respond_to do |format|
        format.json{ render :nothing => true, :status => 422 }
        format.html{ redirect_to tag_path('partytimeexcellent') }
      end
    end
  end

  def show
    redirect_to(:action => :show, :name => downcased_tag_name) && return if tag_has_capitals?

    if user_signed_in?
      gon.preloads[:tagFollowings] = tags
    end
    @stream = Stream::Tag.new(current_user, params[:name], :max_time => max_time, :page => params[:page])
    respond_with do |format|
      format.json { render :json => @stream.stream_posts.map { |p| LastThreeCommentsDecorator.new(PostPresenter.new(p, current_user)) }}
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 og_prefix 
 page_title yield(:page_title) 
  if @post.present? 
 og_page_post_tags(@post) 
 else 
 og_general_tags 
 end 
 
 chartbeat_head_block 
 include_mixpanel 
 include_color_theme 
 if rtl? 
 stylesheet_link_tag :rtl, media:  'all' 
 end 
 old_browser_js_support 
 javascript_include_tag :ie 
 jquery_include_tag 
 unless @landing_page 
 javascript_include_tag :main, :templates 
 load_javascript_locales 
 end 
 translation_missing_warnings 
 current_user_atom_tag 
 yield(:head) 
 csrf_meta_tag 
 include_gon(camel_case:  true) 
 yield :before_content 
 
 @stream.display_tag_name 
 if user_signed_in? 
 unless tag_followed? 
 t(".follow", tag: @stream.tag_name) 
 else 
 t(".stop_following", tag: @stream.tag_name) 
 end 
 end 
   
 
  if @stream.stream_posts.length == 15 
 next_page_path 
 t("more") 
 elsif params[:max_time].present? || @stream.stream_posts.length > 0 
 t("stream_helper.no_more_posts") 
 else 
 t("stream_helper.no_posts_yet") 
 end 
 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  private

  def tag_followed?
    TagFollowing.user_is_following?(current_user, params[:name])
  end

  def tag_has_capitals?
    mb_tag = params[:name].mb_chars
    mb_tag.downcase != mb_tag
  end

  def downcased_tag_name
    params[:name].mb_chars.downcase.to_s
  end

  def prep_tags_for_javascript
    @tags = @tags.map {|tag|
      { :name  => ("#" + tag.name) }
    }

    @tags << { :name  => ('#' + params[:q]) }
    @tags.uniq!
  end
end

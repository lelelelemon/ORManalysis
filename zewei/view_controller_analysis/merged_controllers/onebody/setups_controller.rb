class SetupsController < ApplicationController

  skip_before_filter :authenticate_user
  before_filter :check_setup_requirements

  layout 'signed_out'

  def show
    redirect_to new_setup_path
  end

  def new
    @person = Person.new
    @host = URI.parse(request.url).host
    @host = nil if @host =~ /\A(localhost|\d+\.\d+\.\d+\.\d+)\z/
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 setting(:name, :site) 
 if @title.present? 
 yield(:meta) 
 stylesheet_link_tag 'application' 
 yield(:css) 
 csrf_meta_tags 
  
 yield(:head) 
 @body_class 
 link_to setting(:name, :site), root_path, class: 'logo' 
 @section_class 
 content = yield 
 if content =~ /^\s*<div class=.row.>/m 
 flash_messages unless content =~ /class=.flash/ 
 if @title 
 @title 
 end 
 content 
 else 
 flash_messages unless content =~ /class=.flash/ 
 if title = yield(:title).presence 
 title 
 elsif @title and not @hide_title 
 @title 
 end 
 content 
 end 
  t('footer.powered_by') 
 link_to t('footer.churchio_onebody'), 'http://church.io/', rel: 'nofollow' 
 link_to t('footer.help'), page_for_public_path('help') 
 link_to t('footer.privacy_policy'), page_for_public_path('help/privacy_policy') 
 
 javascript_include_tag 'application' 
 yield(:js) 
 analytics_js 
 end

end

  end

  def create
    @setup = Setup.new(params.permit!)
    if @setup.execute!
      flash[:notice] = t('setup.complete_html', url: admin_path).html_safe
      session[:logged_in_id] = @setup.person.id
      redirect_to root_path
    else
      @person = @setup.person
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 setting(:name, :site) 
 if @title.present? 
 yield(:meta) 
 stylesheet_link_tag 'application' 
 yield(:css) 
 csrf_meta_tags 
  
 yield(:head) 
 @body_class 
 link_to setting(:name, :site), root_path, class: 'logo' 
 @section_class 
 content = yield 
 if content =~ /^\s*<div class=.row.>/m 
 flash_messages unless content =~ /class=.flash/ 
 if @title 
 @title 
 end 
 content 
 else 
 flash_messages unless content =~ /class=.flash/ 
 if title = yield(:title).presence 
 title 
 elsif @title and not @hide_title 
 @title 
 end 
 content 
 end 
  t('footer.powered_by') 
 link_to t('footer.churchio_onebody'), 'http://church.io/', rel: 'nofollow' 
 link_to t('footer.help'), page_for_public_path('help') 
 link_to t('footer.privacy_policy'), page_for_public_path('help/privacy_policy') 
 
 javascript_include_tag 'application' 
 yield(:js) 
 analytics_js 
 end

end

    end
  end

  private

    def check_setup_requirements
      if Person.count > 0
        render text: t('not_authorized'), layout: true
        return false
      end
    end

end

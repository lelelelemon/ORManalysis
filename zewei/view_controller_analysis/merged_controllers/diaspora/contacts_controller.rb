#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class ContactsController < ApplicationController
  before_action :authenticate_user!

  def index
    respond_to do |format|

      # Used for normal requests to contacts#index
      format.html { set_up_contacts }

      # Used by the mobile site
      format.mobile { set_up_contacts_mobile }

      # Used to populate mentions in the publisher
      format.json {
        aspect_ids = params[:aspect_ids] || current_user.aspects.map(&:id)
        @people = Person.all_from_aspects(aspect_ids, current_user).for_json
        render :json => @people.to_json
      }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 og_prefix 
 page_title yield(:page_title) 
 image_path('favicon.png') 
  if @post.present? 
 oembed_url(:url => post_url(@post)) 
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
 controller_name 
 action_name 
 yield :before_content 
 
 content_for :page_title do 
 t(".title") 
 end 
 t(".title") 
 if @contacts.size > 0 
 for contact in @contacts 
  person.id 
 person_image_link(person, size: :thumb_small, class: "media-object") 
 person_link(person, size: :thumb_small) 
 link_to person.diaspora_handle, local_or_remote_person_path(person), class: "black" 
 
 end 
 will_paginate @contacts, renderer: WillPaginate::ActionView::BootstrapLinkRenderer 
 else 
 t(".no_contacts") 
 end 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  def spotlight
    @spotlight = true
    @people = Person.community_spotlight
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 og_prefix 
 page_title yield(:page_title) 
 image_path('favicon.png') 
  if @post.present? 
 oembed_url(:url => post_url(@post)) 
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
 controller_name 
 action_name 
 yield :before_content 
 
 content_for :page_title do 
 t('contacts.spotlight.community_spotlight') 
 end 
  t("contacts.index.title") 
  
 if AppConfig.settings.community_spotlight.enable? 
 link_to t("contacts.spotlight.community_spotlight"), community_spotlight_path, class: "btn btn-link" 
 end 
 t("invitations.new.invite_someone_to_join") 
  id 
 path 
 id 
 id 
 title 
 
 
 if AppConfig.settings.community_spotlight.suggest_email.present? 
 link_to t('contacts.spotlight.suggest_member'), "mailto:#{AppConfig.settings.community_spotlight.suggest_email}", :class => "btn btn-default", :id => "suggest_member" 
 end 
 t('contacts.spotlight.community_spotlight') 
 unless @people.blank? 
 @people.each do |person| 
  person.id 
 person_image_link(person, size: :thumb_small, class: "media-object") 
 person_link(person, size: :thumb_small) 
 link_to person.diaspora_handle, local_or_remote_person_path(person), class: "black" 
 
 end 
 end 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  private

  def set_up_contacts
    type = params[:set].presence
    type ||= "by_aspect" if params[:a_id].present?
    type ||= "receiving"

    @contacts = contacts_by_type(type)
    @contacts_size = @contacts.length
    gon.preloads[:contacts] = @contacts.map{ |c| ContactPresenter.new(c, current_user).full_hash_with_person }
  end

  def contacts_by_type(type)
    case type
      when "all"
        current_user.contacts
      when "only_sharing"
        current_user.contacts.only_sharing
      when "receiving"
        current_user.contacts.receiving
      when "by_aspect"
        @aspect = current_user.aspects.find(params[:a_id])
        gon.preloads[:aspect] = AspectPresenter.new(@aspect).as_json
        current_user.contacts
      else
        raise ArgumentError, "unknown type #{type}"
      end
  end

  def set_up_contacts_mobile
    @contacts = case params[:set]
      when "only_sharing"
        current_user.contacts.only_sharing
      when "all"
        current_user.contacts
      else
        if params[:a_id]
          @aspect = current_user.aspects.find(params[:a_id])
          @aspect.contacts
        else
          current_user.contacts.receiving
        end
    end
    @contacts = @contacts.for_a_stream.paginate(:page => params[:page], :per_page => 25)
    @contacts_size = @contacts.length
  end
end

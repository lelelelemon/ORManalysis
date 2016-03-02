# encoding: utf-8
class Admin::EmailsController < ApplicationController

  before_filter :ensure_is_admin

  def new
    @selected_tribe_navi_tab = "admin"
    @selected_left_navi_link = "email_members"
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :javascript do 
 end 
 content_for :title_header do 
 t("layouts.admin.admin") 
 "-" 
 t("admin.emails.new.send_email_to_members") 
 end 
  
 t(".send_email_to_members_title") 
 form_for :email, :url => admin_community_emails_path(:community_id => @current_community.id), :html => { :id => "new_member_email" } do |form| 
 form.label :subject, t(".email_subject") 
 form.text_field :subject 
 form.label :content, t(".email_content") 
 form.text_area :content, :placeholder => t(".email_content_placeholder"), :class => "email_members_text_area" 
 if available_locales.size > 1 
 label_tag "email_language", t(".email_language") 
  text 
 
 options = [[t(".any_language"), "any"]] | available_locales 
 select_tag "email[locale]", options_for_select(options, "any") 
 else 
 form.hidden_field :locale, :value => "any" 
 end 
 button_tag t(".send_email"), :class => "send_button" 
 end 

end

  end

  def create
    content = params[:email][:content].gsub(/[”“]/, '"') if params[:email][:content] # Fix UTF-8 quotation marks
    Delayed::Job.enqueue(CreateMemberEmailBatchJob.new(@current_user.id, @current_community.id, params[:email][:subject], content, params[:email][:locale]))
    flash[:notice] = t("admin.emails.new.email_sent")
    redirect_to :action => :new
  end

end

class PrintableDirectoriesController < ApplicationController
  before_filter :check_access

  def new
 @title = t('printable_directories.heading') 
 #form_tag printable_directory_path, method: 'post' do 
 #t('printable_directories.click_to_have_custom_pdf_via_email') 
 #check_box_tag 'with_pictures', true, false 
 #t('printable_directories.include_family_pictures') 
 #t('printable_directories.will_take_longer') 
 #button_tag class: 'btn btn-success' do 
 #icon 'fa fa-envelope' 
 #t('printable_directories.email_custom_directory') 
 #end 
 #end 

  end

  def create
    PrintableDirectoryJob.perform_later(
      Site.current,
      @logged_in.id,
      params[:with_pictures].present?
    )
 @title = t('printable_directories.heading') 
 t('printable_directories.were_are_building_custom_pdf') 

  end

  def show
    redirect_to new_printable_directory_path
  end

  private

  def check_access
    return if @logged_in.active?
    render text: t('printable_directories.not_allowed'), layout: true, status: 401
    false
  end
end

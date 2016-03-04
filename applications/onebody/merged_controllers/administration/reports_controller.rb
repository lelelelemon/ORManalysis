class Administration::ReportsController < ApplicationController

  def index
    @reports = I18n.t('reports.reports')
    @custom_reports = CustomReport.order(:title)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('admin.report.title') 
 content_for :header do 
 breadcrumbs 
 @title 
 end 
 t('admin.report.list') 
 @reports.each do |id, report| 
 link_to report[:title], dossier_report_path(report: id) 
 link_to t('admin.report.launch'), dossier_report_path(report: id), class: 'label label-info' 
 end 
 t('reports.custom_reports.index.box_title') 
 @custom_reports.each do |report| 
 link_to report.title, custom_report_path(report) 
 link_to custom_report_path(report), class: 'btn btn-xs btn-info' do 
 icon 'fa fa-info' 
 t('reports.custom_reports.button.show') 
 end 
 if @logged_in.admin?(:manage_reports) 
 link_to edit_custom_report_path(report), class: 'btn btn-xs btn-primary' do 
 icon 'fa fa-pencil' 
 t('reports.custom_reports.button.edit') 
 end 
 link_to report, data: { method: 'delete', confirm: t('are_you_sure') }, class: 'btn btn-xs btn-danger' do 
 icon 'fa fa-trash-o' 
 t('reports.custom_reports.button.delete') 
 end 
 end 
 end 
 if @logged_in.admin?(:manage_reports) 
 link_to new_custom_report_path, class: 'btn btn-success' do 
 icon 'fa fa-plus-circle' 
 t('reports.custom_reports.button.add') 
 end 
 end 

end

  end

end

class CustomReportsController < ApplicationController
  before_action :set_custom_report, only: [:show, :edit, :update, :destroy]

  def index
    redirect_to admin_reports_url
  end

  def show
    if @logged_in.can_read?(@custom_report)
      @header = @custom_report.header
      @footer = @custom_report.footer
      @report_data = @custom_report.data_set(@custom_report.category)
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = @custom_report.title 
 @header.html_safe 
 @report_data.each do |param| 
 Mustache.render(@custom_report.body, param).html_safe 
 end 
 @footer.html_safe 

end

  end

  def new
    @custom_report = CustomReport.new

    if @logged_in.can_create?(@custom_report)
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('reports.custom_reports.new.title') 
  form_for @custom_report do |form| 
 error_messages_for(form) 
 form.label :title, t('reports.custom_reports.fields.title') 
 form.text_field :title, class: 'form-control' 
 form.label :category, t('reports.custom_reports.fields.category') 
 form.select :category, [['', nil], [t('reports.custom_reports.fields.category.people'), '1'], [t('reports.custom_reports.fields.category.family'), '2'], [t('reports.custom_reports.fields.category.groups'), '3']], {}, class: 'form-control' 
 form.label :header, t('reports.custom_reports.fields.header') 
 form.text_area :header, rows: 10, cols: 80, class: 'form-control' 
 form.label :body, t('reports.custom_reports.fields.body') 
 form.text_area :body, rows: 10, cols: 80, class: 'form-control' 
 form.label :footer, t('reports.custom_reports.fields.footer') 
 form.text_area :footer, rows: 5, cols: 80, class: 'form-control' 
 form.label :filters, t('reports.custom_reports.fields.filters') 
 form.text_field :filters, class: 'form-control' 
 form.button t('save'), class: 'btn btn-success' 
 end 
 content_for :css do 
 stylesheet_link_tag 'editor' 
 end 
 content_for :js do 
 javascript_include_tag 'editor' 
 end 
 

end

  end

  def create
    @custom_report = CustomReport.new(custom_report_params)
    if @logged_in.can_create?(@custom_report)
      if @custom_report.save
        redirect_to admin_reports_path,
                    notice: t('reports.custom_reports.create.notice')
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('reports.custom_reports.new.title') 
  form_for @custom_report do |form| 
 error_messages_for(form) 
 form.label :title, t('reports.custom_reports.fields.title') 
 form.text_field :title, class: 'form-control' 
 form.label :category, t('reports.custom_reports.fields.category') 
 form.select :category, [['', nil], [t('reports.custom_reports.fields.category.people'), '1'], [t('reports.custom_reports.fields.category.family'), '2'], [t('reports.custom_reports.fields.category.groups'), '3']], {}, class: 'form-control' 
 form.label :header, t('reports.custom_reports.fields.header') 
 form.text_area :header, rows: 10, cols: 80, class: 'form-control' 
 form.label :body, t('reports.custom_reports.fields.body') 
 form.text_area :body, rows: 10, cols: 80, class: 'form-control' 
 form.label :footer, t('reports.custom_reports.fields.footer') 
 form.text_area :footer, rows: 5, cols: 80, class: 'form-control' 
 form.label :filters, t('reports.custom_reports.fields.filters') 
 form.text_field :filters, class: 'form-control' 
 form.button t('save'), class: 'btn btn-success' 
 end 
 content_for :css do 
 stylesheet_link_tag 'editor' 
 end 
 content_for :js do 
 javascript_include_tag 'editor' 
 end 
 

end

      end
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
  end

  def edit
    unless @logged_in.can_update?(@custom_report)
      render text: t('not_authorized'), layout: true, status: 401
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('reports.custom_reports.edit.title') 
  form_for @custom_report do |form| 
 error_messages_for(form) 
 form.label :title, t('reports.custom_reports.fields.title') 
 form.text_field :title, class: 'form-control' 
 form.label :category, t('reports.custom_reports.fields.category') 
 form.select :category, [['', nil], [t('reports.custom_reports.fields.category.people'), '1'], [t('reports.custom_reports.fields.category.family'), '2'], [t('reports.custom_reports.fields.category.groups'), '3']], {}, class: 'form-control' 
 form.label :header, t('reports.custom_reports.fields.header') 
 form.text_area :header, rows: 10, cols: 80, class: 'form-control' 
 form.label :body, t('reports.custom_reports.fields.body') 
 form.text_area :body, rows: 10, cols: 80, class: 'form-control' 
 form.label :footer, t('reports.custom_reports.fields.footer') 
 form.text_area :footer, rows: 5, cols: 80, class: 'form-control' 
 form.label :filters, t('reports.custom_reports.fields.filters') 
 form.text_field :filters, class: 'form-control' 
 form.button t('save'), class: 'btn btn-success' 
 end 
 content_for :css do 
 stylesheet_link_tag 'editor' 
 end 
 content_for :js do 
 javascript_include_tag 'editor' 
 end 
 

end

  end

  def update
    if @logged_in.can_update?(@custom_report)
      if @custom_report.update(custom_report_params)
        redirect_to admin_reports_path,
                    notice: t('reports.custom_reports.update.notice')
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('reports.custom_reports.edit.title') 
  form_for @custom_report do |form| 
 error_messages_for(form) 
 form.label :title, t('reports.custom_reports.fields.title') 
 form.text_field :title, class: 'form-control' 
 form.label :category, t('reports.custom_reports.fields.category') 
 form.select :category, [['', nil], [t('reports.custom_reports.fields.category.people'), '1'], [t('reports.custom_reports.fields.category.family'), '2'], [t('reports.custom_reports.fields.category.groups'), '3']], {}, class: 'form-control' 
 form.label :header, t('reports.custom_reports.fields.header') 
 form.text_area :header, rows: 10, cols: 80, class: 'form-control' 
 form.label :body, t('reports.custom_reports.fields.body') 
 form.text_area :body, rows: 10, cols: 80, class: 'form-control' 
 form.label :footer, t('reports.custom_reports.fields.footer') 
 form.text_area :footer, rows: 5, cols: 80, class: 'form-control' 
 form.label :filters, t('reports.custom_reports.fields.filters') 
 form.text_field :filters, class: 'form-control' 
 form.button t('save'), class: 'btn btn-success' 
 end 
 content_for :css do 
 stylesheet_link_tag 'editor' 
 end 
 content_for :js do 
 javascript_include_tag 'editor' 
 end 
 

end

      end
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
  end

  def destroy
    if @logged_in.can_delete?(@custom_report)
      @custom_report.destroy
      redirect_to admin_reports_url,
                  notice: t('reports.custom_reports.destroy.notice')
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
  end

  private

  def set_custom_report
    @custom_report = CustomReport.find(params[:id])
  end

  def custom_report_params
    params.require(:custom_report)
      .permit(:title, :category, :header, :body, :footer, :filters)
  end
end

class Administration::ImportsController < ApplicationController
  before_filter :only_admins

  def index
    @imports = Import.order(created_at: :desc).includes(:rows, :person).page(params[:page])
 @title = 'Imports' 
 if @imports.any? 
 pagination @imports 
 t('.table.filename') 
 t('.table.created_at') 
 t('.table.person') 
 t('.table.status') 
 t('.table.rows') 
 t('.table.errored') 
 @imports.each do |import| 
 link_to import.filename, import 
 link_to import.created_at.to_s(:full), import 
 link_to import.person.try(:name), import.person 
 t(import.status, scope: 'administration.imports.status') # notest 
 import.rows.count 
 import.rows.errored.count 
 link_to import, class: 'btn btn-info btn-xs' do 
 icon 'fa fa-eye' 
 end 
 end 
 pagination @imports 
 else 
 end 
 link_to new_administration_import_path, class: 'btn btn-success' do 
 icon 'fa fa-upload' 
 end 

  end

  def show
    @import = Import.find(params[:id])
    @import.verify_working
    respond_to do |format|
      format.html do
        @rows = filter_rows(@import.rows).paginate(page: params[:page], per_page: 100)
        redirect_to(action: :edit) if @import.parsed?
        render :errored if @import.errored?
      end
      format.json do
        render json: @import
      end
    end
  end

  def new
 @title = t('.heading') 
 t('.people.heading') 
 form_tag administration_imports_path, multipart: true, id: 'import-form' do 
 hidden_field_tag :importable_type, 'Person' 
 file_field_tag :file, accept: 'text/csv,text/comma-separated-values' 
 icon 'fa fa-folder-open-o' 
 t('.browse.button') 
 button_tag t('.form.submit'), class: 'btn btn-success' 
 end 

  end

  def create
    return redirect_to(action: 'new') unless params[:file]
    @import = Import.create(
      person:                   @logged_in,
      filename:                 params[:file].original_filename,
      importable_type:          'Person',
      status:                   'pending',
      mappings:                 previous_import.try(:mappings) || {},
      match_strategy:           previous_import.try(:match_strategy),
      create_as_active:         previous_import.try(:create_as_active?),
      overwrite_changed_emails: previous_import.try(:overwrite_changed_emails?)
    )
    @import.parse_async(
      file:          params[:file],
      strategy_name: 'csv'
    )
    redirect_to administration_import_path(@import)
  end

  def edit
    @import = Import.find(params[:id])
    @import.update_attributes(status: 'parsed')
    @example = build_example
 render 'heading' 
 form_for @import do |form| 
 hidden_field_tag :status, 'matched' 
 form.label :match_strategy, t('.form.match_strategy') 
 form.select :match_strategy, import_match_strategies, {}, class: 'form-control' 
 form.check_box :create_as_active 
 form.label :create_as_active, t('.form.create_as_active') 
 form.check_box :overwrite_changed_emails 
 form.label :overwrite_changed_emails, t('.form.overwrite_changed_emails_html', url: administration_emails_path) 
 t('.table.column') 
 t('.table.attribute') 
 t('.table.example') 
 #@import.mappings.each do |from, to| 
 #from 
 #select_tag "import[mappings][#{from}]", | 
 #end 
 #@example[from] 
 #end 
 button_tag id: 'btn-preview', class: 'btn btn-success' do 
 t('.save.button') 
 icon 'fa fa-arrow-right' 
 end 
 button_tag id: 'btn-execute', class: 'btn btn-danger', data: { method: 'patch', confirm: t('are_you_sure') }, style: 'display:none' do 
 icon 'fa fa-bolt' 
 t('administration.imports.show.execute.button') 
 end 
 check_box_tag :dont_preview 
 label_tag :dont_preview, t('.form.dont_preview') 
 link_to @import, data: { method: :delete, confirm: t('are_you_sure') }, class: 'btn btn-delete pull-right' do 
 icon 'fa fa-trash-o' 
 t('.delete.button') 
 end 
 end 

  end

  def update
    @import = Import.find(params[:id])
    @import.attributes = import_params
    @import.mappings = params[:import][:mappings]
    @import.status = 'matched' if params[:status] == 'matched'
    if @import.save
      preview_or_execute
      redirect_to administration_import_path(@import)
    else
      @example = build_example
      render action :edit
    end
  end

  def destroy
    @import = Import.find(params[:id])
    @import.destroy
    redirect_to administration_imports_path
  end

  def execute
    @import = Import.find(params[:id])
    @import.reset_and_execute_async
    redirect_to administration_import_path(@import)
  end

  private

  FILTERS = %w(
    created_person
    created_family
    updated_person
    updated_family
    unchanged_people
    unchanged_families
    errored
  )

  def filter_rows(rows)
    FILTERS.each do |filter|
      rows = rows.send(filter) if params[filter]
    end
    rows
  end

  def preview_or_execute
    if @import.previewed? || params[:dont_preview] == '1'
      @import.reset_and_execute_async
    else
      @import.reset_and_preview_async
    end
  end

  def import_params
    params.require(:import).permit(:match_strategy, :create_as_active, :overwrite_changed_emails)
  end

  def build_example
    @import.rows.first.try(:import_attributes_as_hash, keep_invalid: true) || {}
  end

  def only_admins
    return if @logged_in.admin?(:import_data)
    render text: t('only_admins'), layout: true, status: 401
    false
  end

  def previous_import
    Import.order(:created_at).last
  end
end

class Administration::ImportsController < ApplicationController
  before_filter :only_admins

  def index
    @imports = Import.order(created_at: :desc).includes(:rows, :person).page(params[:page])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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

  end

  def show
    @import = Import.find(params[:id])
    @import.verify_working
    respond_to do |format|
      format.html do
        @rows = filter_rows(@import.rows).paginate(page: params[:page], per_page: 100)
        redirect_to(action: :edit) if @import.parsed?
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = 'There was a problem.' 
 icon 'fa fa-warning text-red' 
 t('.message') 
 @import.error_message 
 link_to @import, data: { method: :delete, confirm: t('are_you_sure') }, class: 'btn btn-delete pull-right' do 
 icon 'fa fa-trash-o' 
 t('administration.imports.show.delete.button') 
 end 
 link_to t('.new.button'), new_administration_import_path, class: 'btn btn-success' 

end

      end
      format.json do
        render json: @import
      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  status = t(@import.status, scope: 'administration.imports.status') # notest 
 @title = t('administration.imports.status_heading', status: status) 
 
 if @import.working? 
 end 
 t('.table.filename') 
 @import.filename 
 if @import.person 
 t('.table.person') 
 link_to @import.person.name, @import.person 
 end 
 t('.table.created_at') 
 @import.created_at.to_s(:full) 
 t('.table.completed_at') 
 if @import.completed_at 
 @import.completed_at.to_s(:full) 
 else 
 t('administration.imports.status.pending') 
 end 
 if @import.status_at_least?(:parsed) 
 t('.table.rows') 
 @import.rows.count 
 end 
 t('.table.match_strategy') 
 t(@import.match_strategy, scope: 'administration.imports.show.match_strategies', default: '') # notest 
 t('.table.create_as_active') 
 t(@import.create_as_active?.to_s, scope: 'administration.imports.show.create_as_active', default: '') # notest 
 if @import.status_at_least?('previewed') 
 t('.stats.heading') 
 unless @import.complete? 
 end 
 t('.table.people') 
 t('.table.families') 
 t('.table.creates') 
 icon 'fa fa-circle text-green' 
 link_to @import.rows.created_person.count, created_person: true 
 icon 'fa fa-circle text-green' 
 link_to @import.rows.created_family.count, created_family: true 
 t('.table.updates') 
 icon 'fa fa-circle text-yellow' 
 link_to @import.rows.updated_person.count, updated_person: true 
 icon 'fa fa-circle text-yellow' 
 link_to @import.rows.updated_family.count, updated_family: true 
 t('.table.no_change') 
 icon 'fa fa-circle text-gray' 
 link_to @import.rows.unchanged_people.count, unchanged_people: true 
 icon 'fa fa-circle text-gray' 
 link_to @import.rows.unchanged_families.count, unchanged_families: true 
 t('.table.errored') 
 icon 'fa fa-circle text-red' 
 link_to @import.rows.errored.count, errored: true 
 end 
 if @import.status_at_least?('previewed') 
 pagination @rows 
 t('.table.person_id') 
 t('.table.person_first_name') 
 t('.table.person_last_name') 
 t('.table.person_matched') 
 t('.table.person_status') 
 t('.table.family_id') 
 t('.table.family_name') 
 t('.table.family_matched') 
 t('.table.family_status') 
 @rows.each do |row| 
 attrs = row.import_attributes_as_hash(real_attributes: true) 
 import_link_to(row.person) 
 attrs['first_name'] 
 attrs['last_name'] 
 t(row.matched_person_by, scope: 'administration.imports.matched_by', default: '') # notest 
 import_row_record_status(row, :person) 
 import_link_to(row.family) 
 attrs['family_name'] 
 t(row.matched_family_by, scope: 'administration.imports.matched_by', default: '') # notest 
 import_row_record_status(row, :family) 
 if row.errored? 
 row.import_attributes.inspect 
 t('.errors_table.name') 
 t('.errors_table.value') 
 t('.errors_table.error') 
 import_row_errors(row).each do |error| 
 error[:name] 
 error[:value].presence || t('.errors_table.blank_value') 
 error[:message] 
 end 
 end 
 end 
 pagination @rows 
 end 
 if @import.previewed? 
 link_to edit_administration_import_path(@import), class: 'btn btn-warning' do 
 icon 'fa fa-arrow-left' 
 t('.edit.button') 
 end 
 link_to execute_administration_import_path(@import), class: 'btn btn-danger', data: { method: 'patch', confirm: t('are_you_sure') } do 
 icon 'fa fa-bolt' 
 t('.execute.button') 
 end 
 end 
 link_to @import, data: { method: :delete, confirm: t('are_you_sure') }, class: 'btn btn-delete pull-right' do 
 icon 'fa fa-trash-o' 
 t('.delete.button') 
 end 

end

  end

  def new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  status = t(@import.status, scope: 'administration.imports.status') # notest 
 @title = t('administration.imports.status_heading', status: status) 
 
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
 @import.mappings.each do |from, to| 
 from 
 select_tag "import[mappings][]",              import_mapping_option_tags(from, to),              include_blank: true,              class: 'form-control' 
 @example[from] 
 end 
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

class DocumentsController < ApplicationController
  before_action :find_parent_folder, only: %w(index show new)
  before_action :ensure_admin, except: %w(index show download)
  before_action :persist_prefs, only: %(index)

  def index
    @folders = (@parent_folder.try(:folders) || DocumentFolder.top).order(:name).includes(:groups)
    @folders = DocumentFolderAuthorizer.readable_by(@logged_in, @folders)
    if @logged_in.admin?(:manage_documents)
      @hidden_folder_count = @folders.hidden.count
      @restricted_folder_count = @folders.restricted.count('distinct document_folders.id')
    end
    @folders = @folders.open unless @show_restricted_folders
    @folders = @folders.active unless @show_hidden_folders
    @documents = (@parent_folder.try(:documents) || Document.top).order(:name)
    cookies[:document_view] = params[:view] if params[:view].present?
    @view = cookies[:document_view] || 'detail'
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = @parent_folder.try(:name) || t('.heading') 
 if @parent_folder && @parent_folder.all_groups.any? 
 icon('fa fa-lock') 
 t('documents.restricted_folder.alert_html',      groups: @parent_folder.all_groups.map { |g| link_to(g.name, g) }.join(', ').html_safe) 
 end 
 if @parent_folder 
 if @parent_folder.hidden? 
 icon('fa fa-eye-slash') 
 t('documents.hidden_folder.alert') 
 elsif @parent_folder.hidden_at_all? 
 icon('fa fa-eye-slash') 
 t('documents.hidden_folder_due_to_parent.alert') 
 end 
 end 
 @parent_folder.try(:description) || t('.intro') 
 link_to params.merge(view: 'detail'), class: @view == 'detail' ? 'btn btn-primary' : 'btn btn-default' do 
 icon 'fa fa-bars' 
 end 
 link_to params.merge(view: 'thumbnail'), class: @view == 'thumbnail' ? 'btn btn-primary' : 'btn btn-default' do 
 icon 'fa fa-th-large' 
 end 
 if @logged_in.admin?(:manage_documents) 
 form_tag nil, method: 'get', id: 'document-visibility' do 
 hidden_field_tag 'folder_id', params[:folder_id] 
 if @hidden_folder_count > 0 
 check_box_tag :hidden_folders, true, @show_hidden_folders, class: 'simple' 
 label_tag :hidden_folders, t('documents.index.hidden_folders.label', count: @hidden_folder_count) 
 end 
 if @restricted_folder_count > 0 
 check_box_tag :restricted_folders, true, @show_restricted_folders, class: 'simple' 
 label_tag :restricted_folders, t('documents.index.restricted_folders.label', count: @restricted_folder_count) 
 end 
 end 
 end 
 if @folders.any? or @documents.any? 
 if @view == 'detail' 
  
 else 
  @folders.each do |folder| 
 link_to documents_path(folder_id: folder.id) do 
 icon 'fa fa-folder-o' 
 end 
 link_to folder.name, documents_path(folder_id: folder.id) 
 end 
 @documents.each do |document| 
 link_to document_path(document.id) do 
 if document.preview.present? 
 image_tag document.preview.url(:medium), class: 'img-thumbnail' 
 else 
 icon document_icon_class(document) 
 end 
 end 
 link_to document.name, document_path(document.id) 
 end 
 
 end 
 else 
 t('none') 
 end 
 if @logged_in.admin?(:manage_documents) 
 if @logged_in.admin?(:manage_documents) && @parent_folder 
 link_to edit_document_path(@parent_folder, folder: true), class: 'btn btn-info' do 
 icon 'fa fa-pencil' 
 t('.edit_folder.button') 
 end 
 link_to document_path(@parent_folder, folder: true), data: { method: 'delete', confirm: t('documents.delete_folder.confirmation') }, class: 'btn btn-delete' do 
 icon 'fa fa-trash-o' 
 t('.delete_folder.button') 
 end 
 end 
 link_to new_document_path(folder: true, folder_id: @parent_folder), class: 'btn btn-success' do 
 icon 'fa fa-folder' 
 t('.new_folder.button') 
 end 
 link_to new_document_path(folder_id: @parent_folder), class: 'btn btn-success' do 
 icon 'fa fa-file' 
 t('.new_document.button') 
 end 
 end 

end

  end

  def show
    @document = Document.find(params[:id])
    fail ActiveRecord::RecordNotFound unless @logged_in.can_read?(@document)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = @document.name 
 if @document.parent_folder_groups.any? 
 icon('fa fa-lock') 
 t('documents.restricted_document.alert_html',      groups: @document.parent_folder_groups.map { |g| link_to(g.name, g) }.join(', ').html_safe) 
 end 
 if @document.hidden? 
 icon('fa fa-eye-slash') 
 t('documents.hidden_document.alert') 
 end 
 @document.description 
 link_to download_document_path(@document, inline: true) do 
 if @document.preview.present? 
 image_tag(@document.preview.url, class: 'thumbnail') 
 else 
 icon document_icon_class(@document) + ' icon-huge' 
 end 
 end 
 t('.table.filename') 
 @document.file_file_name 
 t('.table.content_type') 
 @document.file.content_type 
 t('.table.size') 
 number_to_human_size @document.file.size 
 t('.table.updated_at') 
 @document.updated_at.to_s(:full) 
 if @logged_in.admin?(:manage_documents) 
 link_to edit_document_path(@document), class: 'btn btn-info' do 
 icon 'fa fa-pencil' 
 t('.edit.button') 
 end 
 link_to @document, data: { method: :delete, confirm: t('are_you_sure') }, class: 'btn btn-delete' do 
 icon 'fa fa-trash-o' 
 t('.delete.button') 
 end 
 end 
 link_to download_document_path(@document), class: 'btn btn-success' do 
 icon 'fa fa-download' 
 t('.download.button') 
 end 

end

  end

  def new
    if params[:folder]
      @folder = (@parent_folder.try(:folders) || DocumentFolder).new
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('.heading') 
  

end

    else
      @document = (@parent_folder.try(:documents) || Document).new
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('.heading') 
  form_for @document, multipart: true, id: 'new-document-form' do |form| 
 error_messages_for(form) 
 form.hidden_field :folder_id 
 :file 
 :name 
 :description 
 form.label t('documents.index.no_file') 
 form.text_field :name, class: 'form-control' 
 form.text_field :description, class: 'form-control' 
 form.file_field :file, multiple: true, style: 'display:none' 
 icon 'fa fa-upload' 
 t('documents.new.select.button') 
 if parent_document_folder_options.any? 
 form.label :folder_id 
 form.select :folder_id, parent_document_folder_options, { include_blank: true }, class: 'form-control' 
 end 
 form.button t('save'), class: 'btn btn-success', style: 'display:none', id: 'document-form-submit-button' 
 end 
 

end

  end

  def create
    if params[:folder]
      create_folder
    else
      create_documents
    end
  end

  def edit
    if params[:folder]
      @folder = DocumentFolder.find(params[:id])
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('.heading', folder: @folder.name) 
  

end

    else
      @document = Document.find(params[:id])
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('.heading', document: @document.name) 
  form_for @document, multipart: true, id: 'new-document-form' do |form| 
 error_messages_for(form) 
 form.hidden_field :folder_id 
 :file 
 :name 
 :description 
 form.label t('documents.index.no_file') 
 form.text_field :name, class: 'form-control' 
 form.text_field :description, class: 'form-control' 
 form.file_field :file, multiple: true, style: 'display:none' 
 icon 'fa fa-upload' 
 t('documents.new.select.button') 
 if parent_document_folder_options.any? 
 form.label :folder_id 
 form.select :folder_id, parent_document_folder_options, { include_blank: true }, class: 'form-control' 
 end 
 form.button t('save'), class: 'btn btn-success', style: 'display:none', id: 'document-form-submit-button' 
 end 
 

end

  end

  def update
    if params[:folder]
      @folder = DocumentFolder.find(params[:id])
      if @folder.update_attributes(folder_params)
        redirect_to documents_path(folder_id: @folder.folder_id), notice: t('documents.update_folder.notice')
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('.heading', folder: @folder.name) 
  

end

      end
    else
      @document = Document.find(params[:id])
      if @document.update_attributes(document_params)
        redirect_to documents_path(folder_id: @document.folder_id), notice: t('documents.update.notice')
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('.heading', document: @document.name) 
  form_for @document, multipart: true, id: 'new-document-form' do |form| 
 error_messages_for(form) 
 form.hidden_field :folder_id 
 :file 
 :name 
 :description 
 form.label t('documents.index.no_file') 
 form.text_field :name, class: 'form-control' 
 form.text_field :description, class: 'form-control' 
 form.file_field :file, multiple: true, style: 'display:none' 
 icon 'fa fa-upload' 
 t('documents.new.select.button') 
 if parent_document_folder_options.any? 
 form.label :folder_id 
 form.select :folder_id, parent_document_folder_options, { include_blank: true }, class: 'form-control' 
 end 
 form.button t('save'), class: 'btn btn-success', style: 'display:none', id: 'document-form-submit-button' 
 end 
 

end

      end
    end
  end

  def destroy
    if params[:folder]
      @folder = DocumentFolder.find(params[:id])
      @folder.destroy
      redirect_to documents_path(folder_id: @folder.folder_id), notice: t('documents.delete_folder.notice')
    else
      @document = Document.find(params[:id])
      @document.destroy
      redirect_to documents_path(folder_id: @document.folder_id), notice: t('documents.delete.notice')
    end
  end

  def download
    @document = Document.find(params[:id])
    fail ActiveRecord::RecordNotFound unless @logged_in.can_read?(@document)
    send_file(
      @document.file.path,
      disposition: params[:inline] ? 'inline' : 'attachment',
      filename: @document.file_file_name,
      type: @document.file.content_type
    )
  end

  private

  def create_folder
    @folder = DocumentFolder.new(folder_params)
    if @folder.save
      redirect_to documents_path(folder_id: @folder), notice: t('documents.create_folder.notice')
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('.heading') 
  

end

    end
  end

  def create_documents
    @successes = []
    @errors = []
    params[:document][:file].each_with_index do |file, index|
      @document = Document.new(
        name: params[:document][:name][index],
        description: params[:document][:description][index],
        folder_id: params[:document][:folder_id],
        file: file
      )
      if @document.save
        @successes << @document.name
      else
        @errors << @document.name
      end
    end
    if @errors.any?
      flash[:error] = t('documents.create.failure', count: @errors.size, filenames: @errors.join(', '))
    else
      flash[:notice] = t('documents.create.notice', count: @successes.size)
    end
    redirect_to documents_path(folder_id: params[:document][:folder_id])
  end

  def find_parent_folder
    return if params[:folder_id].blank?
    @parent_folder = DocumentFolder.find(params[:folder_id])
    return if @logged_in.admin?(:manage_documents)
    fail ActiveRecord::RecordNotFound if @parent_folder && !@logged_in.can_read?(@parent_folder)
  end

  def folder_params
    params.require(:folder).permit(:name, :description, :hidden, :folder_id, group_ids: [])
  end

  def document_params
    params.require(:document).permit(:name, :description, :folder_id, :file)
  end

  def feature_enabled?
    return if Setting.get(:features, :documents)
    redirect_to people_path
    false
  end

  def ensure_admin
    return if @logged_in.admin?(:manage_documents)
    render text: t('not_authorized'), layout: true
    false
  end

  def persist_prefs
    cookies[:restricted_folders] = params[:restricted_folders] if params[:restricted_folders].present?
    @show_restricted_folders = !@logged_in.admin?(:manage_documents) || cookies[:restricted_folders] == 'true'
    cookies[:hidden_folders] = params[:hidden_folders] if params[:hidden_folders].present?
    @show_hidden_folders = cookies[:hidden_folders] == 'true'
  end
end

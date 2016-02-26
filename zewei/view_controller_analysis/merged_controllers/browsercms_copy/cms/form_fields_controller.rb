module Cms
  class FormFieldsController < Cms::BaseController

    layout false

    def new
      @field = Cms::FormField.new(label: 'Untitled', field_type: params[:field_type], form_id: params[:form_id])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 simple_form_for(@field, html: {id: 'ajax_form_field'}) do |f| 
 f.hidden_field :form_id 
 f.hidden_field :field_type 
 f.input :label, hint: @field.new_record? ? "" : "Will not change the database name (i.e. '#{@field.name}') for new or existing entries. ", autofocus: true 
 render partial: @field.field_type, locals: {f: f, field: @field} 
 f.button :submit, "Save", style: 'display: none' 
 end 

end

    end

    def preview
      @form = Cms::Form.find(params[:id])
      @field = Cms::FormField.new(label: 'Untitled', name: :untitled, field_type: params[:field_type], form: @form)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 simple_form_for(@form) do |f| 
 f.simple_fields_for :new_entry do |e| 

           locals = {f: e,
                     field: @field,
                     edit_path: new_form_field_path(form_id: @form.id, field_type: @field.field_type)
           }
           if @field.persisted?
             locals[:delete_path] = form_field_path(@field.id)
           else
             locals[:delete_path] = ""
           end
        
  f.input field.name,
            label: field.label,
            hint: field.instructions,
            wrapper: :append do 
 f.input_field field.name, field.options(disabled: true).merge({data: {id: field.id}}) 
 link_to("Edit", "#", data: {edit_path: edit_path}, class: "btn edit_form_button") 
 link_to("Delete", "#", data: {path: delete_path}, class: "btn delete_field_button") 
 end 
 
 end 
 end 

end

    end

    def create
      form = Cms::Form.find(params[:form_field].delete(:form_id))
      field = FormField.new(form_field_params)
      field.form = form
      if field.save
        include_edit_path_in_json(field)
        include_delete_path_in_json(field)
        render json: field
      else
        render json: {
            errors: field.errors.full_messages
        },
               success: false,
               status: :unprocessable_entity
      end
    end

    def edit
      @field = FormField.find(params[:id])
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 simple_form_for(@field, html: {id: 'ajax_form_field'}) do |f| 
 f.hidden_field :form_id 
 f.hidden_field :field_type 
 f.input :label, hint: @field.new_record? ? "" : "Will not change the database name (i.e. '#{@field.name}') for new or existing entries. ", autofocus: true 
 render partial: @field.field_type, locals: {f: f, field: @field} 
 f.button :submit, "Save", style: 'display: none' 
 end 

end

    end

    def update
      field = FormField.find(params[:id])
      if field.update form_field_params
        include_edit_path_in_json(field)
        render json: field
      else
        render text: "Fail", status: 500
      end
    end

    def destroy
      field = FormField.find(params[:id])
      field.destroy
      render json: field, success: true
    end

    def insert_at
      field = FormField.find(params[:id])
      field.insert_at(params[:position])
      render json: field
    end

    protected

    # For UI to update for subsequent editing.
    def include_edit_path_in_json(field)
      field.edit_path = cms.edit_form_field_path(field)
    end

    def include_delete_path_in_json(field)
      field.delete_path = cms.form_field_path(field)
    end

    def form_field_params()
      params.require(:form_field).permit(FormField.permitted_params)
    end
  end
end
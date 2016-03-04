class GeneratedFilesController < ApplicationController
  def show
    @file = @logged_in.generated_files.where(job_id: params[:id]).first
    respond_to do |format|
      format.html do
        if @file
          send_file(@file.file.path, type: @file.file.content_type, filename: @file.file_file_name)
        end
      end
      format.js
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title = t('generated_files.building') 
 content_for(:js) do 
 end 

end

  end
end

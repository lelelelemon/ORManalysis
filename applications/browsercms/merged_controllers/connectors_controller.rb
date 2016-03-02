class ConnectorsController < BaseController
  
  before_filter :load_page, :only => [:new, :create]
  
  def new    
    @block_type = ContentType.find_by_key(params[:block_type] || session[:last_block_type] || 'html_block')
    @container = params[:container]
    @connector = @page.connectors.build(:container => @container)
    @blocks = @block_type.model_class.where(["deleted = ?", false]).order("name")
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

   use_page_title"Reuse Content"

 render layout: 'page_title' do 
 link_to "Back to Page", page_path(@page), class: 'btn btn-small right' 
 end 
 form_tag new_connector_path, :method => :get do 
 hidden_field_tag :page_id, @page.to_param 
 hidden_field_tag :container, @container 
 select_tag "block_type", options_for_select(ContentType.connectable.to_a.map { |ct| [ct.display_name, ct.content_block_type] }, @block_type.content_block_type), :onchange => 'this.form.submit()' 
 end 
 render layout: 'main_content' do 
 @blocks.each do |block| 
 link_to "Add", connectors_path(page_id: @page.to_param, container: @container, :connectable_type => @block_type.content_block_type, connectable_id: block.id), class: "btn btn-mini btn-primary", method: :post 
 link_to block.name, engine_aware_path(block), target: '_blank' 
 block.updated_at.to_formatted_s(:date) 
 block.connected_pages.count 
 end 
 end 

end

  end

  def create
    @block_type = ContentType.find_by_key(params[:connectable_type])
    raise "Unknown block type" unless @block_type
    @block = @block_type.model_class.find(params[:connectable_id])
    if @page.create_connector(@block, params[:container])
      redirect_to @page.path
    else
      @blocks = @block_type.model_class.all(:order => "name")      
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|

   use_page_title"Reuse Content"

 render layout: 'page_title' do 
 link_to "Back to Page", page_path(@page), class: 'btn btn-small right' 
 end 
 form_tag new_connector_path, :method => :get do 
 hidden_field_tag :page_id, @page.to_param 
 hidden_field_tag :container, @container 
 select_tag "block_type", options_for_select(ContentType.connectable.to_a.map { |ct| [ct.display_name, ct.content_block_type] }, @block_type.content_block_type), :onchange => 'this.form.submit()' 
 end 
 render layout: 'main_content' do 
 @blocks.each do |block| 
 link_to "Add", connectors_path(page_id: @page.to_param, container: @container, :connectable_type => @block_type.content_block_type, connectable_id: block.id), class: "btn btn-mini btn-primary", method: :post 
 link_to block.name, engine_aware_path(block), target: '_blank' 
 block.updated_at.to_formatted_s(:date) 
 block.connected_pages.count 
 end 
 end 

end

    end
  end
  
  def destroy
    @connector = Connector.find(params[:id])
    @page = @connector.page
    @connectable = @connector.connectable
    if @page.remove_connector(@connector)
      flash[:notice] = "Removed '#{@connectable.name}' from the '#{@connector.container}' container"
    else
      flash[:error] = "Failed to remove '#{@connectable.name}' from the '#{@connector.container}' container"
    end
    respond_to do |format|
      format.html { redirect_to @page.path  }
      format.json { render :json => @connector }
    end
  end

  { #Define actions for moving connectors around
    :up => "up in",
    :down => "down in",
    :to_top => "to the top of",
    :to_bottom => "to the bottom of"    
  }.each do |move, where|
    define_method "move_#{move}" do
      @connector = Connector.find(params[:id])
      @page = @connector.page
      @connectable = @connector.connectable
      if @page.send("move_connector_#{move}", @connector)
        flash[:notice] = "Moved '#{@connectable.name}' #{where} the '#{@connector.container}' container"
      else
        flash[:error] = "Failed to move '#{@connectable.name}' #{where} the '#{@connector.container}' container"
      end

      respond_to do |format|
        format.html { redirect_to @page.path  }
        format.json { render :json => @connector }
      end

    end
  end

  private
    def load_page
      @page = Page.find(params[:page_id])
    end

end
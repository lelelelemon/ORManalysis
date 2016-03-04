class DirectoryMapsController < ApplicationController
  def index
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 directory_map_header 
 directory_map_div 

end

  end

  def family_locations
    render json: Family.mappable_details
  end
end

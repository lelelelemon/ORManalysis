class DirectoryMapsController < ApplicationController
  def index
 directory_map_header 
 directory_map_div 

  end

  def family_locations
    render json: Family.mappable_details
  end
end

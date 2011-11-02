require 'rgis/request'
require 'rgis/services/geometry_service'
require 'json'

module RGis
  class Point
    include RGis::Services::GeometryService

    attr_accessor :x, :y

    def initialize(x, y)
      @x = Float(x)
      @y = Float(y)
    end

    def == other
      @x == other.x && @y == other.y
    end

    def to_json
      JSON.unparse(to_hash)
    end
    
    def to_array
      [{:x => @x, :y => @y}]
    end

    private 

    def to_hash
      request = Request.new
      request.geometryType = RGis::Helper::GEOMETRY_TYPES[:point]
      request.geometries = to_array
      request
    end  
    
  end
end

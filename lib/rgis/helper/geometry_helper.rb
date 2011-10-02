module RGis
  module Helper
    
    # valid types for element arrays
    VALID_TYPES = [Fixnum, Bignum, Float, Array]

    # valid geometry types
    GEOMETRY_TYPES = {
      :point => 'esriGeometryPoint',
      :polygon => 'esriGeometryPolygon',
      :polyline => 'esriGeometryPolyline'
    }
    
    class GeometryHelper
    
      # parse a array or hash into a geometry in order to be serialized to JSON or another format
      #
      # geometry can be a Array or a Hash
      def self.parse(geometry)
        if geometry.is_a?(Array)
          self.parse_array(geometry)
        elsif geometry.is_a?(Hash)
          self.parse_hash(geometry)
        else
          raise ArgumentError, "argument geometry must be a Array or Hash"
        end
      end
    
      private 

      # parse an array into a geometry object
      def self.parse_array(array)
        if array.empty?
          raise ArgumentError, "geometry must have at least one element"
        end
        
        # should be a point
        if array.count == 1
          if !array[0].is_a?(Array)
            raise ArgumentError, "element of array geometry must have at least 2 numeric elements"
          end
          return self.parse_point(array[0])
        end
        
        # should be a point
        if array.count == 2 
          if array.count{|a| VALID_TYPES.include?(a.class)} == 2
            return self.parse_point(array)
          else
            raise ArgumentError, "elements of array geometry must have at only numeric elements"
          end
        end

        
        # polygon
        if array.first == array.last
          return self.parse_polygon(array)
        else
          return self.parse_polyline(array)
        end
        
        
      end

      # parse a hash into a geometry object
      def self.parse_hash(hash)
        if hash.empty?
          raise ArgumentError, "geometry must have at least one element"
        end
      end
      
      # parse a array of point to point object 
      def self.parse_point(array)
        return { :geometryType => GEOMETRY_TYPES[:point], :geometries => [{ :x => array[0], :y => array[1] }] }
      end
    
      # parse a array of point to polygon object 
      def self.parse_polygon(array)
        return { :geometryType => GEOMETRY_TYPES[:polygon], :rings => [array] }
      end
    
      # parse a array of point to polyline object 
      def self.parse_polyline(array)
        return { :geometryType => GEOMETRY_TYPES[:polyline], :paths => [array] }
      end
    
    end
  end
end
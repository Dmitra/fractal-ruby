class Shape
  attr_accessor :array  #this is array of array of coordinates
  def absolute
      unless @array.nil?
          temp=[]
          @array.each{|coor| coor[2]+=coor[0]; coor[3]+=coor[1];  #преобразование координат из относительных в абсолютные
          temp << coor} 
      @array = temp
      end
      return self
  end
  def zoom(times) #увеличивает и смещает на координаты начальной точки первой линии
    x = @array[0][0]*times/2 
    y = @array[0][1]*times/2
       for i in 0...@array.length
         @array[i][2] = @array[i][2] * times - x
         @array[i][3] = @array[i][3] * times - y
         @array[i][0] = @array[i][0] * times - x
         @array[i][1] = @array[i][1] * times - y
       end
       return self
  end 
end

class Triangle < Shape
  attr_reader :lines
  def initialize(line1, line2, line3)
    @array = [line1.coord, line2.coord, line3.coord]
    @lines = [line1, line2, line3]
  end
end

class Float
    def to_r
    self/180.0*(Math::PI)
  end  
  def to_deg
    self*180.0/(Math::PI)
  end
end
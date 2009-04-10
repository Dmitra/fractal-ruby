require 'Point.rb'

class Shape
  attr_accessor :array  #this is array of array of coordinates
  def absolute
      temp=[]
      array.each{|coor| coor[2]+=coor[0]; coor[3]+=coor[1];  #преобразование координат из относительных в абсолютные
      temp << coor} 
      array = temp
      return self
  end
  def relative
    temp=[]
    array.each{|coor| coor[2]-=coor[0]; coor[3]-=coor[1]
    temp << coor} 
    array = temp
    return self    
  end
  def midst #Point in the middle of the Shape
    for i in 0...self.array.length
      for j in [0,2]
        next1 = array[i][j]
        maxx = next1 if maxx.nil? or maxx < next1
        minx = next1 if minx.nil? or minx > next1
      end
      for j in [1,3]
        next1 = array[i][j]
        maxy = next1 if maxy.nil? or maxy < next1 
        miny = next1 if miny.nil? or miny > next1 
      end
    end
    return Point.new((maxx-minx)/2+minx,(maxy-miny)/2+miny)
  end
  def zoom(times, center)
    x = center.x; y = center.y
       for i in 0...array.length
         array[i][2] = (array[i][2]-x) * times + x
         array[i][3] = (array[i][3]-y) * times + y
         array[i][0] = (array[i][0]-x) * times + x
         array[i][1] = (array[i][1]-y) * times + y
       end
       return self
  end
  def move(point)
      temp=[]; x = point.x; y = point.y
      array.each{|coor| coor[0]+=x; coor[1]+=y; coor[2]+=x; coor[3]+=y
      temp << coor} 
      array = temp
      return self
  end 
  def rotate(fi_deg, center) 
    fi = -fi_deg.to_f.to_r; x = center.x; y = center.y
    temp=[]
    self.array.each{|coor|
      x1 = (coor[0]-x)*Math.cos(fi) + (coor[1]-y)*Math.sin(fi) + x
      y1 =-(coor[0]-x)*Math.sin(fi) + (coor[1]-y)*Math.cos(fi) + y
      x2 = (coor[2]-x)*Math.cos(fi) + (coor[3]-y)*Math.sin(fi) + x
      y2 =-(coor[2]-x)*Math.sin(fi) + (coor[3]-y)*Math.cos(fi) + y
    temp << [x1,y1,x2,y2]} 
    self.array = temp
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
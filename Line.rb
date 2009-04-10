require 'Shape.rb'

class Line < Shape
  attr_reader :coord, :starting, :ending
  def initialize(coor0, coor1, coor2, coor3) #by default Line should be created in absolute coordinates
    @coord = [coor0, coor1, coor2, coor3]
    @starting = Point.new(coor0, coor1)
    @ending = Point.new(coor2, coor3)
  end
  def self.create(arr)                        #array of absolute coordinates
      Line.new(arr[0],arr[1],arr[2],arr[3])
  end
  def self.createLine(point1, point2)         #starting and ending points
      Line.new(point1.x,point1.y,point2.x,point2.y)
  end
  def self.rel(coor0, coor1, coor2, coor3)    #create Line in relative coordinates
      Line.new(coor0, coor1, coor0+coor2, coor1+coor3)
  end
  def array #this is array of coordinates, required by parent Shape class
    [@coord]
  end
  def array=(item)
    @coord=item[0]
    @starting.x =item[0][0]; @starting.y = item[0][1]
    @ending.x = item[0][2]; @ending.y = item[0][3]
  end
  def x #lengh of Line by X axis
      ending.x - starting.x
  end
  def y #lengh of Line by Y axis
      ending.y - starting.y
  end
  def vector #this is a Point to which starting point of Line directed
      Point.new(x,y)
  end
  def tick(spin = "counterclockwise", angle=45) #галочка
     result = []
     x1=0
     y1=0
     alpha = Math.atan(y/x)+90.0.to_r    #вычисляем угол наклона отрезка к горизонтали в радианах; 90 - угол смещения координатной сетки приложения к декартовой
     #puts "alpha in degree: #{alpha.to_deg}"
     beta = angle.to_f.to_r + 90.0.to_r - alpha
     #puts "beta in degree: #{beta.to_deg}"
     alpha_deg = alpha.to_deg
     nano = 1e-10
     if (alpha_deg < nano and alpha_deg > -nano)
       alpha = 0.0   
       m = -y
     elsif (alpha_deg < 180+nano and alpha_deg > 180-nano)
          m = y
     else m = x/Math.sin(alpha)
     end
     c = m/(2*Math.sin(alpha + beta))
     a = Math.cos(beta)*c
     b = Math.sin(beta)*c
     if spin == "clockwise"
       x3 = b;  y3 = a
     else 
       x3 = a;  y3 = -b
     end
     [[x1,y1, x3,y3],[x3,y3, x, y]].each{|line| 
       result << Line.new(line[0]+=coord[0], line[1]+=coord[1], line[2]+=coord[0], line[3]+=coord[1])
     }
     return result
  end
  def divide(parts)
    result = []; xx = []; yy = []
    xx[0] = coord[0]
    yy[0] = coord[1]
    xx[parts] = coord[2]
    yy[parts] = coord[3]
    w = (xx[parts] - xx[0])/parts #длинна отрезка после деления по оси 'x'
    h = (yy[parts] - yy[0])/parts  #                            по оси 'y'
    for i in 1...parts
      xx[i] = xx[i-1] + w
      yy[i] = yy[i-1] + h
    end
    for i in 0...parts
      result << Line.new(xx[i],yy[i], xx[i+1],yy[i+1])
    end
    return result
  end
  def grow(direction, distance)
      Line.rel(@ending.x, @ending.y, distance.x, distance.y).rotate(direction, @ending)
  end
end
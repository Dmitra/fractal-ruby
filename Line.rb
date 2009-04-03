require 'Shape.rb'

class Line < Shape
  attr_accessor :coord
  def initialize(coor1, coor2, coor3, coor4)
    @coord = [coor1, coor2, coor3, coor4]
  end
  def array #this is array of coordinates, required by parent Shape class
    [@coord]
  end
  def array=(item)
    @coord=item[0]
  end
  def tick(spin = "counterclockwise") #галочка
     result = []
     x1=0
     y1=0
     x = coord[2].to_f - coord[0].to_f
     y = coord[3].to_f - coord[1].to_f
     alpha = Math.atan(y/x)+90.0.to_r    #вычисляем угол наклона отрезка к горизонтали в радианах; 90 - угол смещения координатной сетки приложения к декартовой
     #puts "alpha in degree: #{alpha.to_deg}"
     beta = 135.0.to_r - alpha
     #puts "beta in degree: #{beta.to_deg}"
     alpha_deg = alpha.to_deg
     if (alpha_deg < 0.1 and alpha_deg > -0.1)
       alpha = 0.0   
       m = -y
     elsif (alpha_deg < 180.1 and alpha_deg > 179.9)
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
       result << Line.new(line[0]+=coord[0], line[1]+=coord[1], line[2]+=coord[0], line[3]+=coord[1])}
       return result
  end
  def divide(parts)
    result = []; x = []; y = []
    x[0] = coord[0]
    y[0] = coord[1]
    x[parts] = coord[2]
    y[parts] = coord[3]
    w = (x[parts] - x[0])/parts #длинна отрезка после деления по оси 'x'
    h = (y[parts] - y[0])/parts  #                            по оси 'y'
    for i in 1...parts
      x[i] = x[i-1] + w
      y[i] = y[i-1] + h
    end
    for i in 0...parts
      result << Line.new(x[i],y[i], x[i+1],y[i+1])
    end
    return result
  end

end
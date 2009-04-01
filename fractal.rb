class Fractal
  attr_accessor :array, :shape
  def initialize(base, transformation, iterations) #creating Fractal object is only preparing for calculations
      @array = base
      @shape = transformation; @iter = iterations
  end
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
  def tick(coor, spin = "counterclockwise") #галочка
     result = []
     x1=0
     y1=0
     x = coor[2].to_f - coor[0].to_f
     y = coor[3].to_f - coor[1].to_f
     alpha = Math.atan(y/x)+90.0.to_r    #вычисляем угол наклона отрезка к горизонтали в радианах; 90 - угол смещения координатной сетки приложения к декартовой
     #puts "alpha in degree: #{alpha.to_deg}"
     beta = 135.0.to_r - alpha
     #puts "beta in degree: #{beta.to_deg}"
     if alpha.to_deg == 0.0 or alpha.to_deg == 180.0
          m = y.abs
     else m = x/Math.sin(alpha)
     end
     c = m/(2*Math.sin(alpha+beta))
     a = Math.cos(beta)*c
     b = Math.sin(beta)*c
     if spin == "clockwise"
       x3 = b;  y3 = a
     else 
       x3 = a;  y3 = -b
     end
     [[x1,y1, x3,y3],[x3,y3, x, y]].each{|line| line[0]+=coor[0]; line[1]+=coor[1]; line[2]+=coor[0]; line[3]+=coor[1]
      result << line}
    result
  end
  def divide(parts, line)
    result = []; x = []; y = []
    x[0] = line[0]
    y[0] = line[1]
    x[parts] = line[2]
    y[parts] = line[3]
    w = (x[parts] - x[0])/parts #длинна отрезка после деления по оси 'x'
    h = (y[parts] - y[0])/parts  #                                       -//- по оси 'y'
    for i in 1...parts
      x[i] = x[i-1] + w
      y[i] = y[i-1] + h
    end
    for i in 0...parts
      result << [x[i],y[i], x[i+1],y[i+1]]
    end
    return result
  end
  def draw
    result = @array
    case @shape
    when "tick" 
      @iter.times{
        @array.each{|line|
        @array += self.tick(line)                       #дописываем в конец массива линий две "из первой раздробленной"
        @array.shift                                        #удаление раздробленной линии
        } #end of ticking
      } #end of iterations
    when "snow"
      @iter.times{
        @array.each{|line|
         arr = self.divide(3, line)
         result += [arr[0]] + self.tick(arr[1]) + [arr[2]]
         result.shift
         }
         @array = result
      }
    when "tree1"
      half1 = @array
      half2 = @array 
      @iter.times{
        half1.each{|line|
          arr = self.divide(2, line)
          result += [arr[0]] + self.tick(arr[1], "clockwise")
          result.shift
        }
        half1 = result
      }
      result = @array #refresh result with initial value
      @iter.times{
        half2.each{|line|
          arr = self.divide(2, line)
          result += [arr[0]] + self.tick(arr[1], "counterclockwise")
          result.shift
        }
        half2 = result
      }
      @array = half1 + half2
    end
    return @array
  end
  
end
#Fractal.new([100,100,200,200], "tick", 1).tick
class Float
    def to_r
    self/180.0*(Math::PI)
  end  
  def to_deg
    self*180.0/(Math::PI)
  end
end
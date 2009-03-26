class Fractal
  attr_accessor :a, :shape
  def initialize(base, transformation, iterations)
    unless base.nil?
      temp=[]
      base.each{|coor| coor[2]+=coor[0]; coor[3]+=coor[1];  #преобразование координат из относительных в абсолютные
      temp << coor} 
      @a=temp
      @shape = transformation; @iter=iterations
    end
  end
  
  def tick(coor) #галочка
     result = []
     x1=0
     y1=0
     x = coor[2].to_f - coor[0].to_f
     y = coor[3].to_f - coor[1].to_f
     #puts "tangent of alpha: #{y/x}"
     alpha = Math.atan(y/x)+90.0.to_r    #вычисляем угол наклона отрезка к горизонтали в радианах; 90 - угол смещения координатной сетки приложения к декартовой
     #puts "alpha in degree: #{alpha.to_deg}"
     beta = 135.0.to_r - alpha
     #puts "beta in degree: #{beta.to_deg}"
     m = x/Math.sin(alpha)
     #puts "lenght of line: m = #{m}"
     c = m/(2*Math.sin(alpha+beta))
     a = Math.cos(beta)*c
     b = Math.sin(beta)*c
     x3 = a
     y3 = -b
     #original line: [x1,y1,x,y]
     [[x1, y1, x3, y3],[x3, y3, x, y]].each{|line| line[0]+=coor[0]; line[1]+=coor[1]; line[2]+=coor[0]; line[3]+=coor[1]
      result << line}
    result
   end
     
  def draw
    if @shape == "tick" 
      @iter.times{tick}
      @a
      elsif @shape == "base"
        @a
    end
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
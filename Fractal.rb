require 'Line.rb'

class Fractal
  attr_accessor :last
  def initialize(shape, transformation) #creating Fractal object is only preparing for calculations
      if shape.class == Line
           @shape = [shape]                     # this should be always array of Lines
      else @shape = shape.lines end
      @trans = transformation
#For accumulative fractals result of last iteration is needed for continuation
      @last = @shape
  end
  def self.sample
     @@fractals = [[],["tick", "snowflake", "tree_cutout", "pyramid", "branched_tree"],[15,5,6,15,12]]
     line1 = Line.rel(400,750,700,0)
     @@fractals[0] << Fractal.new(line1, @@fractals[1][0])
     triangle = Triangle.new(Line.rel(700,500, -200, 0),
       Line.rel(500,500,100,-(3**0.5)*100),
       Line.rel(600,500-(3**0.5)*100, 100,100*(3**0.5)))
     triangle.zoom(5, triangle.midst)
     @@fractals[0] << Fractal.new(triangle, @@fractals[1][1])
     
     line2 = Line.rel(800,1000,0,-800)
     @@fractals[0] << Fractal.new(line2, @@fractals[1][2])
     line3 = Line.rel(700,500,50,0)
     @@fractals[0] << Fractal.new(line3, @@fractals[1][3])
     line4= Line.rel(600,900,0,-100)
     @@fractals[0] << Fractal.new(line4, @@fractals[1][4])
     return @@fractals
  end
#Iterating function changes itSELF because it is a Fractal - "changing geometry of figure"
  def iter(iterations, continue)
    result = @shape
    case @trans
    when "tick" 
      iterations.times{
        @shape.each{|line|
        @shape += line.tick("counterclockwise", 45)  #дописываем в конец массива линий две "из первой раздробленной"
        @shape.shift                                 #удаление раздробленной линии
        } #end of ticking
      } #end of iterations
    when "pyramid" 
      iterations.times{
        @shape.each{|line|
        @shape += line.tick("counterclockwise", 60)  #дописываем в конец массива линий две "из первой раздробленной"
        @shape.shift                                 #удаление раздробленной линии
        } #end of ticking
      } #end of iterations
    when "snowflake"
      iterations.times{
        @shape.each{|line|
         arr = line.divide(3)
         result += [arr[0]] + arr[1].tick("counterclockwise", 45) + [arr[2]]
         result.shift
        }; @shape = result
      }
    when "tree_cutout"
      half1 = @shape
      half2 = @shape
      iterations.times{
        half1.each{|line|
          arr = line.divide(2)
          result += [arr[0]] + arr[1].tick("clockwise", 45)
          result.shift
        }
        half1 = result
      }
      result = @shape #refresh result with initial value
      iterations.times{
        half2.each{|line|
          arr = line.divide(2)
          result += [arr[0]] + arr[1].tick("counterclockwise")
          result.shift
        }
        half2 = result
      }
      @shape = half1 + half2
    when "branched_tree"
      if continue == true
        i = @last
      else i = @shape
      end
      iterations.times{
        result = []
        i.each{|line| 
          vector = line.vector*(0.7+0.2*rand)
          angle = 15+25*rand
          result << line.grow(-angle, vector) << line.grow(angle, vector)
        } 
        @last = i = result
        @shape += result
      }
    end
    return @shape
  end
end
    
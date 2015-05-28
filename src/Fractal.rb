require_relative 'Line.rb'

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
     @@samples = [[],["tick", "snowflake", "tree_cutout", "tree_1", "dragon", "pyramid", "branched_tree", "rounded_tree"],[15,5,6,6,16,15,12,0]]
     line1 = Line.rel(400,750,700,0)
     @@samples[0] << Fractal.new(line1, @@samples[1][0])
     triangle = Triangle.new(Line.rel(700,500, -200, 0),
       Line.rel(500,500,100,-(3**0.5)*100),
       Line.rel(600,500-(3**0.5)*100, 100,100*(3**0.5)))
     triangle.zoom(5, triangle.midst)
     @@samples[0] << Fractal.new(triangle, @@samples[1][1])
     line2 = Line.rel(800,1000,0,-800)
     @@samples[0] << Fractal.new(line2, @@samples[1][2])
     @@samples[0] << Fractal.new(line2, @@samples[1][3])
     line6 = Line.rel(1000,800, -600, 0)
     @@samples[0] << Fractal.new(line6, @@samples[1][4])
     line3 = Line.rel(700,500,50,0)
     @@samples[0] << Fractal.new(line3, @@samples[1][5])
     line4 = Line.rel(600,900,0,-100)
     @@samples[0] << Fractal.new(line4, @@samples[1][6])
     line5 = Line.rel(700,900,0,-1)
     @@samples[0] << Fractal.new(line5, @@samples[1][7])
     return @@samples
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
    when "snowflake" #на основе триадной кривой Коха
      iterations.times{
        @shape.each{|line|
         arr = line.divide(3)
         result += [arr[0]] + arr[1].tick("counterclockwise", 45) + [arr[2]]
         result.shift
        }; @shape = result
      }
    when "tree_1"
      iterations.times{
        @shape.each{|line|
          arr = line.divide(2)
          @shape += [arr[0]] + arr[1].tick("clockwise", 45) + arr[1].tick("counterclockwise", 45)
          @shape.shift
        }
     }
    when "tree_cutout"
      @shape = @shape*2
      iterations.times{
          length = @shape.length
          for i in 0 ... length
            arr = @shape.shift.divide(2)
            if i < length/2
                @shape += [arr[0]] + arr[1].tick("clockwise", 45)
            else
                @shape += [arr[0]] + arr[1].tick("counterclockwise", 45)
            end
          end
       }
    when "dragon" #дракон Хартера-Хейтуэя
      iterations.times{
        @shape.each_with_index{|line, index|
        if index%2 == 0
          @shape += line.tick("clockwise", 45)
         else  
          @shape += line.tick("counterclockwise", 45)
        end
        @shape.shift                                
        } #end of ticking
      } #end of iterations      
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
    when "rounded_tree"
         chit = @shape.dup #oтросток
         iterations.times{
          chit.each{|line|
              @shape << line.grow(rand*2-0.9, line.vector)
              chit = [@shape.last]
          }
         }
    end
    return @shape
  end
end
    

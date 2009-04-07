class Fractal
  def initialize(shape, transformation, iterations) #creating Fractal object is only preparing for calculations
      if shape.class == Line
           @shape = [shape]                     # this should be always array of Lines
      else @shape = shape.lines end
      @trans = transformation; @iter = iterations
  end
  def draw
    result = @shape
    case @trans
    when "tick" 
      @iter.times{
        @shape.each{|line|
        @shape += line.tick("counterclockwise", 45)  #дописываем в конец массива линий две "из первой раздробленной"
        @shape.shift                                 #удаление раздробленной линии
        } #end of ticking
      } #end of iterations
    when "pyramid" 
      @iter.times{
        @shape.each{|line|
        @shape += line.tick("counterclockwise", 60)  #дописываем в конец массива линий две "из первой раздробленной"
        @shape.shift                                 #удаление раздробленной линии
        } #end of ticking
      } #end of iterations
    when "snow"
      @iter.times{
        @shape.each{|line|
         arr = line.divide(3)
         result += [arr[0]] + arr[1].tick("counterclockwise", 45) + [arr[2]]
         result.shift
        }; @shape = result
      }
    when "tree_cutout"
      half1 = @shape
      half2 = @shape
      @iter.times{
        half1.each{|line|
          arr = line.divide(2)
          result += [arr[0]] + arr[1].tick("clockwise", 45)
          result.shift
        }
        half1 = result
      }
      result = @shape #refresh result with initial value
      @iter.times{
        half2.each{|line|
          arr = line.divide(2)
          result += [arr[0]] + arr[1].tick("counterclockwise")
          result.shift
        }
        half2 = result
      }
      @shape = half1 + half2
    when "branched_tree"
      i = [@shape[0]]
      @iter.times{
        result = []
        i.each{|line| 
          vector = line.vector*(0.7+0.2*rand)
          angle = 15+25*rand
          result << line.grow(-angle, vector) << line.grow(angle, vector)
        } 
        i = result
        @shape += result
      }
    end
    return @shape
  end
end
    
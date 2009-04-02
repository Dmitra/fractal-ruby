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
        @shape += line.tick                     #дописываем в конец массива линий две "из первой раздробленной"
        @shape.shift                            #удаление раздробленной линии
        } #end of ticking
      } #end of iterations
    when "snow"
      @iter.times{
        @shape.each{|line|
         arr = line.divide(3)
         result += [arr[0]] + arr[1].tick + [arr[2]]
         result.shift
         }
         @shape = result
      }
    when "tree1"
      half1 = @shape
      half2 = @shape
      @iter.times{
        half1.each{|line|
          arr = line.divide(2)
          result += [arr[0]] + arr[1].tick("clockwise")
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
    end
    return @shape
  end
  
end
#Fractal.new([100,100,200,200], "tick", 1).tick

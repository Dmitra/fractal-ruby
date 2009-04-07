class Point
  attr_accessor :x, :y
  def initialize(x,y)
    @x = x.to_f; @y = y.to_f #coordinates are always float for precise calculations
  end
  def +(value) #relative adding 
    if @x > 0 then @x += value elsif @x < 0 then @x -= value end
    if @y > 0 then @y += value elsif @y < 0 then @y -= value end
    return self
  end
  def -(value)
    self.+(-value)
  end
  def /(divisor)
    @x = @x/divisor; @y = @y/divisor
    return self
  end
  def *(multiplier)
    @x = @x*multiplier; @y = @y*multiplier
    return self
  end
  def -@
    @x = - @x; @y = - @y
    return self
  end
end
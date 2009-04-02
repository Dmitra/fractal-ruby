require 'rubygems'
require 'Line.rb'
require 'fractal.rb'
require 'wx'

class FractalApp < Wx::App

  def on_init
    width = 1600
    height = 1200
    #Containing frame.
    frame = Wx::Frame.new(nil, :size => [width, height])
    frame.show
    #Offscreen drawing buffer.
    buffer = Wx::Bitmap.new(width, height)
    #Displays drawing.
    window = Wx::Window.new(frame, :size => [width, height])
    window.evt_paint do |event|
      update_window(window, buffer)
    end

    #White background
    buffer.draw do |surface|
        surface.pen = Wx::Pen.new(Wx::Colour.new(0, 0, 0), 0)
        surface.brush = Wx::WHITE_BRUSH
        surface.draw_rectangle(0, 0, width, height)
    end
    start = Time.now    
    
    line1 = Line.new(400,750,700,0).absolute
    fractal1 = Fractal.new(line1, "tick", 6)
    
    triangle = Triangle.new(Line.new(600,400, -200, 0),
      Line.new(400,400,100,-(3**0.5)*100),
      Line.new(500,400-(3**0.5)*100, 100,100*(3**0.5)))
    
    fractal2 = Fractal.new(triangle, "snow", 5)
    line2 = Line.new(800,1000,800,100)
    triangle.absolute.zoom(5)
    fractal3 = Fractal.new(line2, "tree1", 6)
        
            #Draw line.
      buffer.draw do |surface|
        fractal3.draw.each_with_index{|a, index| 
          surface.pen = Wx::Pen.new(Wx::Colour.new(201, 0, 50),1)
          surface.pen.cap = Wx::CAP_ROUND
          surface.draw_line(a.coord[0].to_i, a.coord[1].to_i, a.coord[2].to_i, a.coord[3].to_i)
        } # конец прорисовки
      end #конец рисования в буфер
      
      #Update screen
        update_window(window, buffer)
        puts Time.now-start
        sleep 0.1
    end

    def update_window(window, buffer)
          window.paint do |dc|
          #Copy the buffer to the viewable window.
          dc.draw_bitmap(buffer, 0, 0, false)
    end
  end

end

app = FractalApp.new
app.main_loop
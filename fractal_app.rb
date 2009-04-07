require 'rubygems'
require 'Line.rb'
require 'fractal.rb'
require 'wx'

class FractalApp < Wx::App
  @@width = 1600
  @@height = 1200
  def visible(lines) #make lines from array of Lines a two dimensional array of coords
      lines.each_with_index{|line, i|
        lines[i] = []
        for j in 0..3
          if line.coord[j] < 0 then lines[i][j] = 0
          elsif line.coord[j] > @@width then lines[i][j] = @@width 
          else lines[i][j] = line.coord[j].to_i end
        end
      }
  end
  def on_init
    #Containing frame.
    frame = Wx::Frame.new(nil, :size => [@@width, @@height])
    frame.show
    #Offscreen drawing buffer.
    buffer = Wx::Bitmap.new(@@width, @@height)
    #Displays drawing.
    window = Wx::Window.new(frame, :size => [@@width, @@height])
    window.evt_paint do |event|
      update_window(window, buffer)
    end

    #White background
    buffer.draw do |surface|
        surface.pen = Wx::Pen.new(Wx::Colour.new(0, 0, 0), 0)
        surface.brush = Wx::WHITE_BRUSH
        surface.draw_rectangle(0, 0, @@width, @@height)
    end
    start = Time.now    
    
    line1 = Line.rel(400,750,700,0)
    staple = Fractal.new(line1, "tick", 15)
    triangle = Triangle.new(Line.rel(700,500, -200, 0),
      Line.rel(500,500,100,-(3**0.5)*100),
      Line.rel(600,500-(3**0.5)*100, 100,100*(3**0.5)))
    triangle.zoom(5, triangle.midst)
    snowflake = Fractal.new(triangle, "snow", 5)
    
    line2 = Line.rel(800,1000,0,-800)
    tree1 = Fractal.new(line2, "tree_cutout", 6)
    line3 = Line.rel(700,500,50,0)
    pyramid = Fractal.new(line3, "pyramid", 15)
    line4= Line.rel(600,900,0,-100)
    branch = Fractal.new(line4, "branched_tree", 9)
    
    buffer.draw do |surface|        
      surface.pen = Wx::Pen.new(Wx::Colour.new(201, 0, 50),1)
      surface.pen.cap = Wx::CAP_ROUND
      visible(branch.draw).each_with_index{|a, index| 
        surface.draw_line(a[0], a[1], a[2], a[3])
#        surface.draw_label("#{a[0]}, #{a[1]} -> #{a[2]}, #{a[3]}",Wx::Rect.new(a[0], a[1], a[0]+30, a[1]+30))
      } # конец прорисовки
    end #конец рисования в буфер
      
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
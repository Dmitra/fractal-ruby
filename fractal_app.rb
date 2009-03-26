require 'rubygems'
require 'fractal.rb'
require 'wx'

class MyApp < Wx::App

  def on_init
    width = 1000
    height = 1000
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
      
    #Draw line.
      buffer.draw do |surface|
        surface.pen = Wx::Pen.new(Wx::Colour.new(201, 0, 50),1)
        surface.pen.cap = Wx::CAP_ROUND
        start = Time.now
        #[400,400,300,10],[400,400,150,-150],[700,410,-150,-160]
#рисунок точками при 20 итерациях почти такой же как линиями
        #~ fractal = Fractal.new([[400,750,1100,760]], "tick", 20)
        #~ fractal.draw.each{|a|
        #~ surface.draw_point(a[0].to_i, a[1].to_i)
        #~ surface.draw_point(a[2].to_i, a[3].to_i)
        
        fractal = Fractal.new([[400,400,300,0]], "tick", 3)
        fractal.draw.each{|a|
        surface.draw_line(a[0].to_i, a[1].to_i, a[2].to_i, a[3].to_i)
        }
        puts Time.now-start
      end
      
    #Update screen.
    update_window(window, buffer)
    sleep 0.1
    end

    def update_window(window, buffer)
          window.paint do |dc|
          #Copy the buffer to the viewable window.
          dc.draw_bitmap(buffer, 0, 0, false)
    end
  end

end

app = MyApp.new
app.main_loop